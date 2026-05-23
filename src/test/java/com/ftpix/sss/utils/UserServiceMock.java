package com.ftpix.sss.utils;

import com.ftpix.sss.models.User;
import com.ftpix.sss.persistence.CategoryRepository;
import com.ftpix.sss.persistence.UserRepository;
import com.ftpix.sss.services.EmailService;
import com.ftpix.sss.services.ExpenseService;
import com.ftpix.sss.services.SettingsService;
import com.ftpix.sss.services.UserService;


public class UserServiceMock extends UserService {

    private User currentUser;

    public UserServiceMock(ExpenseService recurringExpenseService, ExpenseService expenseService, ExpenseService categoryService, EmailService emailService, SettingsService settingsService, UserRepository userRepository, CategoryRepository categoryRepository) {
        super(recurringExpenseService, expenseService, categoryService, emailService, settingsService, userRepository, categoryRepository);
    }


    public User getCurrentUser() {
        return currentUser;
    }

    public void setCurrentUser(User currentUser) {
        this.currentUser = currentUser;
    }
}
