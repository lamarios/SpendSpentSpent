package com.ftpix.sss.services;

import com.ftpix.sss.models.*;
import com.ftpix.sss.persistence.CategoryRepository;
import com.ftpix.sss.persistence.ExpenseRepository;
import com.ftpix.sss.persistence.utils.Specifications;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.SQLException;
import java.time.Instant;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.*;
import java.util.stream.Collectors;

import static com.ftpix.sss.Constants.dateFormatter;

@Service
public class SearchService {
    private final CategoryService categoryService;
    private final FileService fileService;
    private final ZoneId zoneId;
    private final ExpenseRepository expenseRepository;
    private final CategoryRepository categoryRepository;

    @Autowired
    public SearchService(CategoryService categoryService, FileService fileService, ZoneId zoneId, ExpenseRepository expenseRepository, CategoryRepository categoryRepository) {
        this.categoryService = categoryService;
        this.fileService = fileService;

        this.zoneId = zoneId;
        this.expenseRepository = expenseRepository;
        this.categoryRepository = categoryRepository;
    }

    @Transactional(readOnly = true)
    public SearchParameters getSearchParameters(User currentUser, Long categoryId) throws SQLException {


//        List<Category> categories = expenseDao.getHouseholdCategories(currentUser).values().stream().toList();
        List<Category> categories = categoryRepository.getHouseholdCategories(currentUser);

        Specification<Expense> categorySpec = Specification.where(Specifications.<Expense>in("category", categories));

        if (categoryId != null) {
            categorySpec = categorySpec.and(Specifications.<Expense>equal("category.id", categoryId));
        }

//        Condition[] categoryCondition = categoryId != null ? new Condition[]{EXPENSE.CATEGORY_ID.eq(categoryId)} : new Condition[0];

        Pageable minPageable = PageRequest.of(0, 1, Sort.by("amount").ascending());

//        int minAmount = expenseDao.getFromHouseholdPaginatedWhere(currentUser, 0, 1, new OrderField[]{EXPENSE.AMOUNT.asc()}, categoryCondition)
        int minAmount = expenseRepository.findAll(categorySpec, minPageable)
                .getContent()
                .stream()
                .map(Expense::getAmount)
                .map(Double::intValue)
                .findFirst()
                .orElse(0);

        Pageable maxPageable = PageRequest.of(0, 1, Sort.by("amount").descending());
//        int maxAmount = expenseDao.getFromHouseholdPaginatedWhere(currentUser, 0, 1, new OrderField[]{EXPENSE.AMOUNT.desc()}, categoryCondition)
        int maxAmount = expenseRepository.findAll(categorySpec, maxPageable)
                .getContent()
                .stream()
                .map(Expense::getAmount)
                .map(Double::intValue)
                .map(i -> i + 1)
                .findFirst()
                .orElse(0);

        Pageable minDatePageable = PageRequest.of(0, 1, Sort.by("timestamp").ascending());
//        long minDate = expenseDao.getFromHouseholdPaginatedWhere(currentUser, 0, 1, new OrderField[]{EXPENSE.TIMESTAMP.asc()}, categoryCondition)
        long minDate = expenseRepository.findAll(categorySpec, minDatePageable)
                .getContent()
                .stream()
                .map(Expense::getTimestamp)
                .findFirst()
                .orElse(System.currentTimeMillis() - 1000 * 60 * 60 * 24);

        Pageable maxDatePageable = PageRequest.of(0, 1, Sort.by("timestamp").descending());
//        long maxDate = expenseDao.getFromHouseholdPaginatedWhere(currentUser, 0, 1, new OrderField[]{EXPENSE.TIMESTAMP.desc()}, categoryCondition)
        long maxDate = expenseRepository.findAll(categorySpec, maxDatePageable)
                .getContent()
                .stream()
                .map(Expense::getTimestamp)
                .findFirst()
                .orElse(System.currentTimeMillis());

        return new SearchParameters(categories, minAmount, maxAmount, minDate, maxDate, "");
    }

    @Transactional(readOnly = true)
    public Map<String, DailyExpense> search(User currentUser, SearchParameters parameters, ZoneId zone) {
        List<Category> categories = categoryRepository.getHouseholdCategories(currentUser);

        Specification<Expense> spec = Specification.where(Specifications.<Expense>in("category", categories));

//        List<Condition> conditions = new ArrayList<>();

        if (parameters.maxAmount() >= 0) {
            spec = spec.and(Specifications.lessThanOrEqual("amount", parameters.maxAmount()));
//            conditions.add(EXPENSE.AMOUNT.le((double) parameters.maxAmount()));
        }

        if (parameters.minAmount() >= 0) {
            spec = spec.and(Specifications.greaterThanOrEqual("amount", parameters.minAmount()));
//            conditions.add(EXPENSE.AMOUNT.ge((double) parameters.minAmount()));
        }

        if (parameters.categories() != null && !parameters.categories().isEmpty()) {
//            conditions.add(EXPENSE.CATEGORY_ID.in(parameters.categories().stream().map(Category::getId).toList()));
            spec = spec.and(Specifications.in("category", parameters.categories()));
        }

        if (parameters.searchQuery() != null && !parameters.searchQuery().trim().isEmpty()) {
            String upperCase = parameters.searchQuery().toUpperCase();
//            conditions.add(upper(EXPENSE.NOTE).like("%" + upperCase + "%")
//                    .or(upper(FILES.AI_TAGS).like("%" + upperCase + "%")));
            spec = spec.and(Specifications.<Expense>like("note", upperCase)
                    .or(Specifications.joinLike("files", "aiTags", upperCase)));
        }

        if (parameters.minDate() != null) {
//            conditions.add(EXPENSE.TIMESTAMP.ge(parameters.minDate()));
            spec = spec.and(Specifications.greaterThanOrEqual("timestamp", parameters.minDate()));
        }

        if (parameters.maxDate() != null) {
//            conditions.add(EXPENSE.TIMESTAMP.le(parameters.maxDate()));
            spec = spec.and(Specifications.lessThanOrEqual("timestamp", parameters.maxDate()));
        }

//        List<Expense> searchResult = expenseDao.searchInHousehold(currentUser, new OrderField[]{EXPENSE.DATE.desc()}, conditions.toArray(new Condition[0]));
        List<Expense> searchResult = expenseRepository.findAll(spec);
//        List<SSSFile> files = fileService.getFiles(searchResult);
//
//        files.forEach(file -> searchResult.stream().filter(e -> Objects.equals(e.getId(), file.getExpenseId()))
//                .forEach(expense -> expense.getFiles().add(file)));

        Map<String, List<Expense>> grouped = searchResult
                .stream()
                .collect(Collectors.groupingBy(expense -> dateFormatter.format(ZonedDateTime.ofInstant(Instant.ofEpochMilli(expense.getTimestamp()), Optional.ofNullable(zone)
                        .orElse(zoneId)))));

        Map<String, DailyExpense> result = new TreeMap<>(Collections.reverseOrder());

        grouped.forEach((s, expenses) -> {
            DailyExpense exp = new DailyExpense();
            exp.setDate(s);
            exp.setExpenses(expenses);
            exp.setTotal(expenses.stream().mapToDouble(Expense::getAmount).sum());
            result.put(s, exp);
        });


        return result;
    }
}
