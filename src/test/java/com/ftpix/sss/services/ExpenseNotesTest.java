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

    private Map<String, Long> suggest(String icon, double amount) {
        Expense expense = new Expense();
        expense.setCategory(category(icon));
        expense.setAmount(amount);
        return expenseService.suggestNotes(currentUser, expense);
    }

    @Test
    public void suggestionsDontDependOnTheAmount() throws Exception {
        expense("house", 10, "Plumber");
        expense("house", 1000, "Rent");
        expense("cloth", 500, "Shoes");

        assertEquals(Map.of("Plumber", 1L, "Rent", 1L), suggest("house", 500));
    }

    @Test
    public void emptyNotesAreNotSuggested() throws Exception {
        expense("house", 10, null);
        expense("house", 10, "");
        expense("house", 10, "  ");
        expense("house", 10, "Rent");

        assertEquals(Map.of("Rent", 1L), suggest("house", 10));
    }

    @Test
    public void suggestionsMergeSpellingsUnderTheMostUsedOne() throws Exception {
        expense("house", 10, "Rent");
        expense("house", 10, "rent");
        expense("house", 10, " rent ");
        expense("house", 10, "Plumber");
        expense("house", 10, "plumber");

        // a tie goes to the first spelling in alphabetical order
        assertEquals(Map.of("rent", 3L, "Plumber", 2L), suggest("house", 10));
    }

    @Test
    public void onlyTheMostUsedNotesAreSuggested() throws Exception {
        for (int i = 0; i < 25; i++) {
            expense("house", 10, "Note " + i);
        }
        expense("house", 10, "Rent");
        expense("house", 10, "Rent");

        Map<String, Long> suggestions = suggest("house", 10);

        assertEquals(20, suggestions.size());
        assertEquals(2L, suggestions.get("Rent"));
    }

    @Test
    public void autoCompleteMergesSpellings() throws Exception {
        expense("house", 10, "Rent");
        expense("house", 10, "rent");
        expense("house", 10, "Rent");

        assertEquals(Map.of("Rent", 3L), expenseService.autoCompleteNote(currentUser, "ren"));
    }

    @Test
    public void typedTagsAreCompletedWithTheKnownTags() throws Exception {
        expense("house", 10, "Lidl #visa");
        expense("house", 10, "Aldi #Visa #shared");
        expense("cloth", 10, "Shoes #visa");
        expense("house", 10, "Rent #bank");
        expense("house", 10, "Plumber #VIP");

        assertEquals(Map.of("Bakery #visa", 3L, "Bakery #VIP", 1L), expenseService.autoCompleteNote(currentUser, "Bakery #vi"));

        Map<String, Long> onlyTag = expenseService.autoCompleteNote(currentUser, "#VI");
        assertEquals(3L, onlyTag.get("#visa"));
        assertEquals(1L, onlyTag.get("#VIP"));
        // and the notes containing the text, as before
        assertEquals(1L, onlyTag.get("Plumber #VIP"));
    }

    @Test
    public void notesMatchingACompletedTagArentCountedTwice() throws Exception {
        expense("house", 10, "Lidl #visa");
        expense("house", 10, "Aldi #visa");
        expense("house", 10, "Lidl #bank");

        assertEquals(Map.of("Lidl #visa", 2L, "Lidl #bank", 1L), expenseService.autoCompleteNote(currentUser, "Lidl #"));
    }

    @Test
    public void aCompletedTagMatchingANoteInAnotherCaseIsSuggestedOnce() throws Exception {
        expense("house", 10, "Lidl #visa");

        // as often used: the saved note wins over the typed text
        assertEquals(Map.of("Lidl #visa", 1L), expenseService.autoCompleteNote(currentUser, "lidl #vi"));
    }

    @Test
    public void aCompletedTagMatchingANoteWithAnotherSpellingOfTheTagIsSuggestedOnce() throws Exception {
        expense("house", 10, "Bakery #Visa");
        expense("house", 10, "Lidl #visa");
        expense("house", 10, "Aldi #visa");

        // the most used spelling of the tag wins
        assertEquals(Map.of("Bakery #visa", 3L), expenseService.autoCompleteNote(currentUser, "Bakery #vi"));
    }

    @Test
    public void completedTagsKeepTheirCombiningMarks() throws Exception {
        expense("house", 10, "Rent #किराया");
        expense("house", 10, "Bakery #café");

        assertEquals(Map.of("Deposit #किराया", 1L), expenseService.autoCompleteNote(currentUser, "Deposit #कि"));
        assertEquals(Map.of("Lidl #café", 1L), expenseService.autoCompleteNote(currentUser, "Lidl #caf"));
    }

    @Test
    public void typedTagsAreCompletedWhateverTheCaseOfTheirLetters() throws Exception {
        expense("house", 10, "Flight #İstanbul");
        expense("house", 10, "Paint #ασπρο");

        // lower casing in Java turns İ into two characters and a final Σ into ς, which don't match these tags
        assertEquals(Map.of("Hotel #İstanbul", 1L), expenseService.autoCompleteNote(currentUser, "Hotel #İ"));
        assertEquals(Map.of("Wall #ασπρο", 1L), expenseService.autoCompleteNote(currentUser, "Wall #ΑΣ"));
    }

    @Test
    public void tagsAreOnlyCompletedAtTheEnd() throws Exception {
        expense("house", 10, "Lidl #visa");

        assertEquals(Map.of(), expenseService.autoCompleteNote(currentUser, "Aldi #vi groceries"));
        assertEquals(Map.of(), expenseService.autoCompleteNote(currentUser, "Aldi#vi"));
    }
}
