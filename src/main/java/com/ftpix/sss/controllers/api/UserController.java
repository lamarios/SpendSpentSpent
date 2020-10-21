package com.ftpix.sss.controllers.api;

import com.ftpix.sparknnotation.Sparknotation;
import com.ftpix.sparknnotation.annotations.*;
import com.ftpix.sss.Constants;
import com.ftpix.sss.db.DB;
import com.ftpix.sss.models.User;
import com.ftpix.sss.transformer.GsonTransformer;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import spark.Spark;

import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.*;

import static com.ftpix.sss.controllers.api.ApiController.TOKEN;
import static com.ftpix.sss.controllers.api.UserSessionController.*;

@SparkController("/API/User")
public class UserController {
    private final static Logger logger = LogManager.getLogger();


    public Optional<User> getByEmail(String email) throws SQLException {
        Map<String, Object> values = new HashMap<>();
        values.put("email", email);

        return DB.USER_DAO.queryForFieldValues(values)
                .stream()
                .findFirst();
    }

    @SparkPost(transformer = GsonTransformer.class)
    public String updateUser(@SparkBody User user, @SparkHeader(TOKEN) String token) throws Exception {
        User currentUser = getCurrentUser(token).orElseThrow(UNAUTHORIZED_SUPPLIER);

        if (user.getFirstName() == null || user.getFirstName().length() == 0 || user.getLastName() == null || user.getLastName().length() == 0) {
            Spark.halt(400, "First name and last name can't be empty");
        }

        currentUser.setFirstName(user.getFirstName());
        currentUser.setLastName(user.getLastName());

        if (user.getPassword() != null && user.getPassword().length() > 0) {
            currentUser.setPassword(Sparknotation.getController(SettingsController.class).hashUserCredentials(currentUser.getEmail(), user.getPassword()));
        }

        currentUser.update();

        return Sparknotation.getController(UserSessionController.class).createTokenForUser(user);
    }

    @SparkGet(transformer = GsonTransformer.class)
    public List<User> getUsers(@SparkHeader(TOKEN) String token) throws Exception {
        getCurrentUser(token).filter(User::isAdmin).orElseThrow(UNAUTHORIZED_SUPPLIER);
        return DB.USER_DAO.queryForAll();
    }

    @SparkGet(value = "/:userId/setAdmin/:isAdmin", transformer = GsonTransformer.class)
    public boolean setAdmin(@SparkParam("userId") String userId, @SparkParam("isAdmin") boolean isAdmin, @SparkHeader(TOKEN) String token) throws Exception {
        User user = getCurrentUser(token).filter(User::isAdmin).orElseThrow(UNAUTHORIZED_SUPPLIER);

        if (user.getId().toString().equals(userId) && !isAdmin) {
            Spark.halt(400, "You can't remove admin rights to yourself");
        }

        return Optional.ofNullable(DB.USER_DAO.queryForId(UUID.fromString(userId)))
                .map(u -> {
                    u.setAdmin(isAdmin);
                    try {
                        u.update();
                        return true;
                    } catch (SQLException e) {
                        throw new RuntimeException(e);
                    }
                }).orElse(false);

    }

    @SparkPost(value = "/:userId/setPassword", transformer = GsonTransformer.class)
    public boolean setPassword(@SparkParam("userId") String userId, @SparkBody String newPassword, @SparkHeader(TOKEN) String token) throws Exception {
        getCurrentUser(token).filter(User::isAdmin).orElseThrow(UNAUTHORIZED_SUPPLIER);

        return Optional.ofNullable(DB.USER_DAO.queryForId(UUID.fromString(userId)))
                .map(u -> {
                    try {
                        u.setPassword(Sparknotation.getController(SettingsController.class).hashUserCredentials(u.getEmail(), newPassword));
                        u.update();
                        return true;
                    } catch (NoSuchAlgorithmException | SQLException e) {
                        throw new RuntimeException(e);
                    }
                }).orElse(false);
    }

    @SparkPut(transformer = GsonTransformer.class)
    public User addUser(@SparkBody User user, @SparkHeader(TOKEN) String token) throws Exception {
        getCurrentUser(token).filter(User::isAdmin).orElseThrow(UNAUTHORIZED_SUPPLIER);

        return createUser(user);
    }


    @SparkDelete(value = "/:userId", transformer = GsonTransformer.class)
    public boolean deleteUser(@SparkParam("userId") String userId, @SparkHeader(TOKEN) String token) throws Exception {

        User currentUser = getCurrentUser(token).filter(User::isAdmin).orElseThrow(UNAUTHORIZED_SUPPLIER);

        if (currentUser.getId().toString().equalsIgnoreCase(userId)) {
            Spark.halt(400, "You can't delete yourself");
        }

        return Optional.ofNullable(DB.USER_DAO.queryForId(UUID.fromString(userId)))
                .map(user -> {
                    try {
                        // deleting recurring expenses
                        Sparknotation.getController(RecurringExpenseController.class).get(user)
                                .forEach(e -> {
                                    try {
                                        e.delete();
                                    } catch (SQLException throwables) {
                                        throw new RuntimeException(throwables);
                                    }
                                });

                        // all expenses
                        Sparknotation.getController(ExpenseController.class).getAll(user)
                                .forEach(e -> {
                                    try {
                                        e.delete();
                                    } catch (SQLException throwables) {
                                        throw new RuntimeException(throwables);
                                    }
                                });
                        // all categories
                        Sparknotation.getController(CategoryController.class).getAll(user)
                                .forEach(c -> {
                                    try {
                                        c.delete();
                                    } catch (SQLException throwables) {
                                        throw new RuntimeException(throwables);
                                    }
                                });

                        user.delete();
                        return true;
                    } catch (Exception e) {
                        throw new RuntimeException(e);
                    }
                })
                .orElse(false);
        // deleting all the data

    }

    public User createUser(User user) throws SQLException, NoSuchAlgorithmException {
        if (user.getFirstName() == null || user.getFirstName().length() == 0
                || user.getLastName() == null || user.getLastName().length() == 0
                || user.getEmail() == null || user.getEmail().length() == 0
                || user.getPassword() == null || user.getPassword().length() == 0
        ) {
            Spark.halt(400, "All fields must be filled.");
        }

        final long count = DB.USER_DAO.countOf();

        if (count == 0) {
            user.setAdmin(true);
        }

        if (!user.getEmail().matches(EMAIL_REGEX)) {
            Spark.halt(400, "Invalid email");
        }

        if (Constants.HAS_SUBSCRIPTIONS && !user.isAdmin()) {
            // give one month subscription to new users
            final LocalDateTime expiry = LocalDateTime.now().plusMonths(1);
            user.setSubscriptionExpiryDate(Timestamp.valueOf(expiry).getTime());
        } else {
            user.setSubscriptionExpiryDate(User.NEVER);
        }

        // checking if user already exists
        final long emailCheck = DB.USER_DAO.queryBuilder()
                .where()
                .eq("email", user.getEmail())
                .countOf();

        if (emailCheck > 0) {
            Spark.halt(400, "Email already in use");
        }

        user.setPassword(Sparknotation.getController(SettingsController.class).hashUserCredentials(user.getEmail(), user.getPassword()));
        DB.USER_DAO.create(user);

        // Migration code
        // migrating all existing categories to new user as it's the first one
        if (count == 0) {
            DB.CATEGORY_DAO.queryForAll().forEach(c -> {
                try {
                    c.setUser(user);
                    c.update();
                } catch (SQLException e) {
                    logger.error("Couldn't migrate categories", e);
                    throw new RuntimeException(e);
                }
            });
        }

        return user;
    }
}
