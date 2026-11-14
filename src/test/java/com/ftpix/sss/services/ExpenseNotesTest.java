package com.ftpix.sss.services;

import static org.junit.jupiter.api.Assertions.assertEquals;

import com.ftpix.sss.TestConfig;
import com.ftpix.sss.TestContainerTest;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.Expense;
import com.ftpix.sss.persistence.CategoryRepository;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;
import java.util.Map;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Import;

@Import(TestConfig.class)
public class ExpenseNotesTest extends TestContainerTest {

  @Autowired private ExpenseService expenseService;

  @Autowired private CategoryRepository categoryRepository;

  private Category category(String icon) {
    return categoryRepository.findAllByUser(currentUser).stream()
        .filter(c -> c.getIcon().equals(icon))
        .findFirst()
        .orElseThrow();
  }

  private void expense(String icon, double amount, String note) throws Exception {
    Expense expense = new Expense();
    expense.setAmount(amount);
    expense.setCategory(category(icon));
    expense.setDate(LocalDate.of(2026, 1, 15));
    expense.setTimestamp(
        expense.getDate().atStartOfDay(ZoneId.systemDefault()).toInstant().toEpochMilli());
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

  private List<String> suggestRanked(String icon, double amount) {
    Expense expense = new Expense();
    expense.setCategory(category(icon));
    expense.setAmount(amount);
    return expenseService.suggestNotesRanked(currentUser, expense);
  }

  @Test
  public void suggestionsOnlyContainNotesOfCloseAmounts() throws Exception {
    expense("house", 400, "Deposit");
    expense("house", 600, "Deposit");
    expense("house", 399, "Plumber");
    expense("house", 1000, "Rent");
    expense("cloth", 500, "Shoes");

    assertEquals(Map.of("Deposit", 2L), suggest("house", 500));
  }

  @Test
  public void rankedSuggestionsPutTheCloseAmountsFirst() throws Exception {
    for (int i = 0; i < 10; i++) {
      expense("house", 200, "Far");
    }
    for (int i = 0; i < 5; i++) {
      expense("house", 130, "Middle");
    }
    expense("house", 110, "Close");
    expense("cloth", 100, "Shoes");

    assertEquals(List.of("Close", "Middle", "Far"), suggestRanked("house", 100));
  }

  @Test
  public void rankedSuggestionsUseBracketsOf20And40Percent() throws Exception {
    expense("house", 80, "a 80");
    expense("house", 120, "b 120");
    expense("house", 60, "c 60");
    expense("house", 140, "d 140");
    expense("house", 59, "e 59");
    expense("house", 141, "f 141");

    // within a bracket, as often used: alphabetical order
    assertEquals(
        List.of("a 80", "b 120", "c 60", "d 140", "e 59", "f 141"), suggestRanked("house", 100));
  }

  @Test
  public void centAmountsAtTheBracketLimitsAreInTheBracket() throws Exception {
    expense("house", 1.74, "20% away");
    expense("house", 2.03, "40% away");
    expense("house", 3, "Far");
    expense("house", 3, "Far");

    assertEquals(Map.of("20% away", 1L), suggest("house", 1.45));
    assertEquals(List.of("20% away", "40% away", "Far"), suggestRanked("house", 1.45));
  }

  @Test
  public void aNoteIsRankedByItsClosestAmountAndHowOftenItWasUsedForIt() throws Exception {
    for (int i = 0; i < 5; i++) {
      expense("house", 300, "Lidl");
    }
    expense("house", 105, "Lidl");
    expense("house", 95, "Bakery");
    expense("house", 98, "Bakery");

    assertEquals(List.of("Bakery", "Lidl"), suggestRanked("house", 100));
    assertEquals(Map.of("Bakery", 2L, "Lidl", 1L), suggest("house", 100));
  }

  @Test
  public void rankedSuggestionsMergeSpellingsUnderTheMostUsedOne() throws Exception {
    expense("house", 10, "Rent");
    expense("house", 10, "rent");
    expense("house", 500, " rent ");

    assertEquals(List.of("rent"), suggestRanked("house", 10));
  }

  @Test
  public void emptyNotesAreNotSuggested() throws Exception {
    expense("house", 10, null);
    expense("house", 10, "");
    expense("house", 10, "  ");
    expense("house", 10, "\t");
    expense("house", 10, " \r\n ");
    expense("house", 10, "\u2003");
    expense("house", 10, "Rent");

    assertEquals(Map.of("Rent", 1L), suggest("house", 10));
    assertEquals(List.of("Rent"), suggestRanked("house", 10));
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
  public void onlyTheMostRelevantNotesAreSuggestedRanked() throws Exception {
    for (int i = 0; i < 25; i++) {
      expense("house", 10, "Note " + i);
    }
    expense("house", 10, "Rent");
    expense("house", 10, "Rent");

    List<String> suggestions = suggestRanked("house", 10);

    assertEquals(20, suggestions.size());
    assertEquals("Rent", suggestions.getFirst());
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

    assertEquals(
        Map.of("Bakery #visa", 3L, "Bakery #VIP", 1L),
        expenseService.autoCompleteNote(currentUser, "Bakery #vi"));

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

    assertEquals(
        Map.of("Lidl #visa", 2L, "Lidl #bank", 1L),
        expenseService.autoCompleteNote(currentUser, "Lidl #"));
  }

  @Test
  public void aCompletedTagMatchingANoteInAnotherCaseIsSuggestedOnce() throws Exception {
    expense("house", 10, "Lidl #visa");

    // as often used: the saved note wins over the typed text
    assertEquals(
        Map.of("Lidl #visa", 1L), expenseService.autoCompleteNote(currentUser, "lidl #vi"));
  }

  @Test
  public void aCompletedTagMatchingANoteWithAnotherSpellingOfTheTagIsSuggestedOnce()
      throws Exception {
    expense("house", 10, "Bakery #Visa");
    expense("house", 10, "Lidl #visa");
    expense("house", 10, "Aldi #visa");

    // the most used spelling of the tag wins
    assertEquals(
        Map.of("Bakery #visa", 3L), expenseService.autoCompleteNote(currentUser, "Bakery #vi"));
  }

  @Test
  public void completedTagsKeepTheirCombiningMarks() throws Exception {
    expense("house", 10, "Rent #किराया");
    expense("house", 10, "Bakery #café");

    assertEquals(
        Map.of("Deposit #किराया", 1L), expenseService.autoCompleteNote(currentUser, "Deposit #कि"));
    assertEquals(
        Map.of("Lidl #café", 1L), expenseService.autoCompleteNote(currentUser, "Lidl #caf"));
  }

  @Test
  public void typedTagsAreCompletedWhateverTheCaseOfTheirLetters() throws Exception {
    expense("house", 10, "Flight #İstanbul");
    expense("house", 10, "Paint #ασπρο");

    // lower casing in Java turns İ into two characters and a final Σ into ς, which don't match
    // these tags
    assertEquals(
        Map.of("Hotel #İstanbul", 1L), expenseService.autoCompleteNote(currentUser, "Hotel #İ"));
    assertEquals(
        Map.of("Wall #ασπρο", 1L), expenseService.autoCompleteNote(currentUser, "Wall #ΑΣ"));
  }

  @Test
  public void tagsAreOnlyCompletedAtTheEnd() throws Exception {
    expense("house", 10, "Lidl #visa");

    assertEquals(Map.of(), expenseService.autoCompleteNote(currentUser, "Aldi #vi groceries"));
    assertEquals(Map.of(), expenseService.autoCompleteNote(currentUser, "Aldi#vi"));
  }
}
