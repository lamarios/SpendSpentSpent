package com.ftpix.sss.utils;

import com.ftpix.sss.dao.CategoryDao;
import com.ftpix.sss.dao.UserDao;
import com.ftpix.sss.models.User;
import com.ftpix.sss.services.EmailService;
import com.ftpix.sss.services.ExpenseService;
import com.ftpix.sss.services.SettingsService;
import com.ftpix.sss.services.UserService;


public class UserServiceMock extends UserService {

    private User currentUser;

    public UserServiceMock(ExpenseService recurringExpenseService, ExpenseService expenseService, ExpenseService categoryService, CategoryDao categoryDaoJooq, EmailService emailService, SettingsService settingsService, UserDao userDaoJooq) {
        super(recurringExpenseService, expenseService, categoryService, categoryDaoJooq, emailService, settingsService, userDaoJooq);
    }

    public User getCurrentUser() {
        return currentUser;
    }

    public void setCurrentUser(User currentUser) {
        this.currentUser = currentUser;
    }
}
