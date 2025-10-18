package com.ftpix.sss.services;


import com.ftpix.sss.Constants;
import com.ftpix.sss.dao.CategoryDao;
import com.ftpix.sss.dao.UserDao;
import com.ftpix.sss.models.PaginatedResults;
import com.ftpix.sss.models.Settings;
import com.ftpix.sss.models.User;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

import static com.ftpix.sss.dsl.Tables.*;


@Service
public class UserService {
    public final static String EMAIL_REGEX = "[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
    private final static Logger logger = LogManager.getLogger();
    private final ExpenseService recurringExpenseService;
    private final ExpenseService expenseService;
    private final ExpenseService categoryService;
    private final CategoryDao categoryDaoJooq;
    private final EmailService emailService;
    private final SettingsService settingsService;
    @Value("${SALT}")
    private String SALT;
    private final UserDao userDaoJooq;

    @Autowired
    public UserService(ExpenseService recurringExpenseService, ExpenseService expenseService, ExpenseService categoryService, CategoryDao categoryDaoJooq, EmailService emailService, SettingsService settingsService, UserDao userDaoJooq) {
        this.recurringExpenseService = recurringExpenseService;
        this.expenseService = expenseService;
        this.categoryService = categoryService;
        this.categoryDaoJooq = categoryDaoJooq;
        this.emailService = emailService;
        this.settingsService = settingsService;
        this.userDaoJooq = userDaoJooq;
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

    @Transactional(readOnly = true)
    public User getByEmail(String email) throws SQLException {
        return userDaoJooq.getOneWhere(USER.EMAIL.eq(email)).orElse(null);
    }

    @Transactional(readOnly = true)
    public User getByOidcSub(String sub) {
        return userDaoJooq.getOneWhere(USER.OIDCSUB.eq(sub)).orElse(null);
    }

    @Transactional(readOnly = true)
    public User getCurrentUser() throws SQLException {
        final Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        org.springframework.security.core.userdetails.User user = (org.springframework.security.core.userdetails.User) authentication.getPrincipal();

        return getByEmail(user.getUsername());
    }

    @Transactional(readOnly = true)
    public PaginatedResults<User> getAll(String search, int page, int pageSize) throws SQLException {

        if (search.trim().length() > 0) {
            String searchQuery = "%" + search.trim() + "%";

            return userDaoJooq.getPaginatedWhere(page, pageSize, USER.EMAIL.like(searchQuery)
                    .or(USER.FIRSTNAME.like(searchQuery))
                    .or(USER.LASTNAME.like(searchQuery)));
        } else {
            return userDaoJooq.getPaginatedWhere(page, pageSize);
        }
    }

    @Transactional(readOnly = true)
    public PaginatedResults<User> getAll() throws SQLException {
        return getAll("", 0, Integer.MAX_VALUE);
    }

    @Transactional(readOnly = true)
    public User getById(UUID id) throws SQLException {
        return userDaoJooq.getOneWhere(USER.ID.eq(id.toString())).orElse(null);
    }

    @Transactional
    public User createUser(User user) throws Exception {
        if (user.getFirstName() == null || user.getFirstName()
                .isEmpty() || user.getLastName() == null || user.getLastName()
                .isEmpty() || user.getEmail() == null || user.getEmail()
                .isEmpty() || ((user.getPassword() == null || user.getPassword()
                .isEmpty()) && user.getOidcSub() == null)) {
            throw new Exception("All fields must be filled.");
        }

        final long count = userDaoJooq.countUsers();

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
        final long emailCheck = userDaoJooq.countUsers(USER.EMAIL.eq(user.getEmail()));

        if (emailCheck > 0) {
            throw new Exception("Email already in use");
        }

        // order is important here as the clear password gets updated after the bcrypt
        user.setPasswordBcrypt(new BCryptPasswordEncoder().encode(user.getPassword()));
        user.setPassword(hashUserCredentials(user.getEmail(), user.getPassword()));
        User toReturn = userDaoJooq.insert(user);


        Map<String, Object> templateData = new HashMap<>();
        templateData.put("firstName", user.getFirstName());

        emailService.sendTemplate(user.getEmail(), "Welcome to SpendSpentSpent !", "email/user-registered.ftl", templateData);

        // Migration code
        // migrating all existing categories to new user as it's the first one
        if (count == 0) {
            categoryDaoJooq.queryForAll().forEach(c -> {
                c.setUser(toReturn);
                categoryDaoJooq.update(toReturn, c);
            });
        }

        return toReturn;
    }

    @Transactional
    public boolean deleteUser(String userId, User currentUser) throws Exception {
        if (currentUser.getId().toString().equalsIgnoreCase(userId)) {
            throw new Exception("You can't delete yourself");
        }

        return Optional.ofNullable(getById(UUID.fromString(userId))).map(user -> {
            try {
                // deleting recurring expenses
                recurringExpenseService.getAll(user).forEach(e -> {
                    try {
                        recurringExpenseService.delete(e.getId(), user);
                    } catch (Exception throwables) {
                        throw new RuntimeException(throwables);
                    }
                });

                // all expenses
                expenseService.getAll(user).forEach(e -> {
                    try {
                        expenseService.delete(e.getId(), user);
                    } catch (Exception throwables) {
                        throw new RuntimeException(throwables);
                    }
                });
                // all categories
                categoryService.getAll(user).forEach(c -> {
                    try {
                        categoryService.delete(c.getId(), user);
                    } catch (Exception throwables) {
                        throw new RuntimeException(throwables);
                    }
                });

                userDaoJooq.delete(user);
                return true;
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        }).orElse(false);
    }

    @Transactional
    public boolean setUserPassword(String userId, String newPassword) throws SQLException {
        return Optional.ofNullable(getById(UUID.fromString(userId))).map(u -> {
            try {
                u.setPassword(hashUserCredentials(u.getEmail(), newPassword));
                userDaoJooq.update(u);
                return true;
            } catch (NoSuchAlgorithmException e) {
                throw new RuntimeException(e);
            }
        }).orElse(false);
    }

    @Transactional
    public boolean setUserAdmin(String userId, boolean isAdmin, User requester) throws Exception {
        if (requester.getId().toString().equals(userId) && !isAdmin) {
            throw new Exception("You can't remove admin rights to yourself");
        }

        return Optional.ofNullable(getById(UUID.fromString(userId))).map(u -> {
            u.setAdmin(isAdmin);
            userDaoJooq.update(u);
            return true;
        }).orElse(false);
    }

    @Transactional
    public User updateUserProfile(User user, User newUserData) throws Exception {
        if (newUserData.getFirstName() == null || newUserData.getFirstName()
                .length() == 0 || newUserData.getLastName() == null || newUserData.getLastName().length() == 0) {
            throw new Exception("first name and lat name can't be empty");
        }

        user.setFirstName(newUserData.getFirstName());
        user.setLastName(newUserData.getLastName());

        final String value = settingsService.getByName(Settings.DEMO_MODE).getValue();
        boolean demo = value.equalsIgnoreCase("1");

        if ((!demo || demo && user.isAdmin()) && newUserData.getPassword() != null && !newUserData.getPassword()
                .isEmpty()) {
            user.setPassword(hashUserCredentials(user.getEmail(), newUserData.getPassword()));
        }

        userDaoJooq.update(user);
        return user;
    }

    @Transactional
    public User updateUser(User user) {
        var updated = userDaoJooq.update(user);
        return user;
    }
}
