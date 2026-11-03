package com.ftpix.sss.services;

import com.ftpix.sss.TestConfig;
import com.ftpix.sss.TestContainerTest;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.Expense;
import com.ftpix.sss.persistence.CategoryRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Import;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;

@Import(TestConfig.class)
public class ExpenseNotesTest extends TestContainerTest {

    @Autowired
    private ExpenseService expenseService;

    @Autowired
    private CategoryRepository categoryRepository;

    private Category category(String icon) {
        return categoryRepository.findAllByUser(currentUser)
                .stream()
                .filter(c -> c.getIcon().equals(icon))
                .findFirst()
                .orElseThrow();
    }

    private void expense(String icon, double amount, String note) throws Exception {
        Expense expense = new Expense();
        expense.setAmount(amount);
        expense.setCategory(category(icon));
        expense.setDate(LocalDate.of(2026, 1, 15));
        expense.setTimestamp(expense.getDate().atStartOfDay(ZoneId.systemDefault()).toInstant().toEpochMilli());
        expense.setType(Expense.TYPE_NORMAL);
        expense.setNote(note);
        expenseService.create(expense, currentUser);
    }

    @Test
    public void autoCompleteIgnoresTheCase() throws Exception {
        expense("house", 10, "Rent");

        assertEquals(Map.of("Rent", 1L), expenseService.autoCompleteNote(currentUser, "RE"));
        assertEquals(Map.of("Rent", 1L), expenseService.autoCompleteNote(currentUser, "re"));
    }
}
