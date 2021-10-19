package com.ftpix.sss.services;


import com.ftpix.sss.Constants;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.PaginatedResults;
import com.ftpix.sss.models.Settings;
import com.ftpix.sss.models.User;
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.stmt.QueryBuilder;
import com.j256.ormlite.stmt.Where;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;


@Service
public class UserService {
    public final static String EMAIL_REGEX = "[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
    private final static Logger logger = LogManager.getLogger();
    private final ExpenseService recurringExpenseService;
    private final ExpenseService expenseService;
    private final ExpenseService categoryService;
    private final Dao<Category, Long> categoryDao;
    private final Dao<User, UUID> userDao;
    private final EmailService emailService;
    private final PaginationService paginationService;
    private final SettingsService settingsService;
    @Value("${SALT}")
    private String SALT;

    @Autowired
    public UserService(ExpenseService recurringExpenseService, ExpenseService expenseService, ExpenseService categoryService, Dao<Category, Long> categoryDao, Dao<User, UUID> userDao, EmailService emailService, PaginationService paginationService, SettingsService settingsService) {
        this.recurringExpenseService = recurringExpenseService;
        this.expenseService = expenseService;
        this.categoryService = categoryService;
        this.categoryDao = categoryDao;
        this.userDao = userDao;
        this.emailService = emailService;
        this.paginationService = paginationService;
        this.settingsService = settingsService;
    }

    /**
     * String hash for passowrds
     *
     * @param str the string to hash
     * @return the new string
     * @throws NoSuchAlgorithmException
     */
    public String hashString(String str) throws NoSuchAlgorithmException {
        MessageDigest md5;
        md5 = MessageDigest.getInstance("MD5");
        str += SALT;

        md5.update(str.getBytes());

        byte[] byteData = md5.digest();
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < byteData.length; i++) {
            sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
        }

        return sb.toString();
    }

    public String hashUserCredentials(String email, String password) throws NoSuchAlgorithmException {
        return hashString(email + password);
    }

    public User getByEmail(String email) throws SQLException {
        return userDao.queryBuilder().where().eq("email", email).queryForFirst();
    }

    public User getCurrentUser() throws SQLException {
        final Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        org.springframework.security.core.userdetails.User user = (org.springframework.security.core.userdetails.User) authentication.getPrincipal();

        return getByEmail(user.getUsername());
    }

    public PaginatedResults<User> getAll(String search, long page, long pageSize) throws SQLException {

        final QueryBuilder<User, UUID> builder = userDao.queryBuilder();

        if (search.trim().length() > 0) {
            Where<User, UUID> where = builder.where();
            where = where.like("email", "%" + search + "%")
                    .or().like("firstName", "%" + search + "%")
                    .or().like("lastName", "%" + search + "%");

            final String[] split = search.split("\\s");
            if (split.length > 0) {
                for (String s : split) {
                    where = where.or().like("firstName", "%" + s + "%")
                            .or().like("lastName", "%" + s + "%");
                }

            }
            builder.setWhere(where);
        }


        return paginationService.getPaginatedResults(builder, page, pageSize);
    }

    public PaginatedResults<User> getAll() throws SQLException {
        return getAll("", 0, Integer.MAX_VALUE);
    }

    public User getById(UUID id) throws SQLException {
        return userDao.queryForId(id);
    }

    public User createUser(User user) throws Exception {
        if (user.getFirstName() == null || user.getFirstName().length() == 0
                || user.getLastName() == null || user.getLastName().length() == 0
                || user.getEmail() == null || user.getEmail().length() == 0
                || user.getPassword() == null || user.getPassword().length() == 0
        ) {
            throw new Exception("All fields must be filled.");
        }

        final long count = userDao.countOf();

        if (count == 0) {
            user.setAdmin(true);
        }

        if (!user.getEmail().matches(EMAIL_REGEX)) {
            throw new Exception("Invalid email");
        }

        if (Constants.HAS_SUBSCRIPTIONS && !user.isAdmin()) {
            // give one month subscription to new users
            final LocalDateTime expiry = LocalDateTime.now().plusMonths(1);
            user.setSubscriptionExpiryDate(Timestamp.valueOf(expiry).getTime());
        } else {
            user.setSubscriptionExpiryDate(User.NEVER);
        }

        // checking if user already exists
        final long emailCheck = userDao.queryBuilder()
                .where()
                .eq("email", user.getEmail())
                .countOf();

        if (emailCheck > 0) {
            throw new Exception("Email already in use");
        }

        user.setPassword(hashUserCredentials(user.getEmail(), user.getPassword()));
        userDao.create(user);


        Map<String, Object> templateData = new HashMap<>();
        templateData.put("firstName", user.getFirstName());

        emailService.sendTemplate(user.getEmail(), "Welcome to SpendSpentSpent !", "email/user-registered.ftl", templateData);

        // Migration code
        // migrating all existing categories to new user as it's the first one
        if (count == 0) {
            categoryDao.queryForAll().forEach(c -> {
                try {
                    c.setUser(user);
                    categoryDao.update(c);
                } catch (SQLException e) {
                    logger.error("Couldn't migrate categories", e);
                    throw new RuntimeException(e);
                }
            });
        }

        return user;
    }

    public boolean deleteUser(String userId, User currentUser) throws Exception {
        if (currentUser.getId().toString().equalsIgnoreCase(userId)) {
            throw new Exception("You can't delete yourself");
        }

        return Optional.ofNullable(getById(UUID.fromString(userId)))
                .map(user -> {
                    try {
                        // deleting recurring expenses
                        recurringExpenseService.getAll(user)
                                .forEach(e -> {
                                    try {
                                        recurringExpenseService.delete(e.getId(), user);
                                    } catch (Exception throwables) {
                                        throw new RuntimeException(throwables);
                                    }
                                });

                        // all expenses
                        expenseService.getAll(user)
                                .forEach(e -> {
                                    try {
                                        expenseService.delete(e.getId(), user);
                                    } catch (Exception throwables) {
                                        throw new RuntimeException(throwables);
                                    }
                                });
                        // all categories
                        categoryService.getAll(user)
                                .forEach(c -> {
                                    try {
                                        categoryService.delete(c.getId(), user);
                                    } catch (Exception throwables) {
                                        throw new RuntimeException(throwables);
                                    }
                                });

                        userDao.delete(user);
                        return true;
                    } catch (Exception e) {
                        throw new RuntimeException(e);
                    }
                })
                .orElse(false);
    }

    public boolean setUserPassword(String userId, String newPassword) throws SQLException {
        return Optional.ofNullable(getById(UUID.fromString(userId)))
                .map(u -> {
                    try {
                        u.setPassword(hashUserCredentials(u.getEmail(), newPassword));
                        userDao.update(u);
                        return true;
                    } catch (NoSuchAlgorithmException | SQLException e) {
                        throw new RuntimeException(e);
                    }
                }).orElse(false);
    }

    public boolean setUserAdmin(String userId, boolean isAdmin, User requester) throws Exception {
        if (requester.getId().toString().equals(userId) && !isAdmin) {
            throw new Exception("You can't remove admin rights to yourself");
        }

        return Optional.ofNullable(getById(UUID.fromString(userId)))
                .map(u -> {
                    u.setAdmin(isAdmin);
                    try {
                        userDao.update(u);
                        return true;
                    } catch (SQLException e) {
                        throw new RuntimeException(e);
                    }
                }).orElse(false);
    }

    public User updateUserProfile(User user, User newUserData) throws Exception {
        if (newUserData.getFirstName() == null || newUserData.getFirstName().length() == 0 || newUserData.getLastName() == null || newUserData.getLastName().length() == 0) {
            throw new Exception("first name and lat name can't be empty");
        }

        user.setFirstName(newUserData.getFirstName());
        user.setLastName(newUserData.getLastName());

        final String value = settingsService.getByName(Settings.DEMO_MODE).getValue();
        boolean demo = value.equalsIgnoreCase("1");

        if ((!demo || demo && user.isAdmin()) && newUserData.getPassword() != null && newUserData.getPassword().length() > 0) {
            user.setPassword(hashUserCredentials(user.getEmail(), newUserData.getPassword()));
        }

        userDao.update(user);


        return user;

    }
}
