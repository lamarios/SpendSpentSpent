package com.ftpix.sss.services;

import com.ftpix.sss.dao.*;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.DataExport;
import com.google.gson.*;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.jooq.impl.DefaultDSLContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.lang.reflect.Type;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.InvalidParameterException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;

import static com.ftpix.sss.Constants.ALLOW_IMPORT;
import static com.ftpix.sss.dsl.Tables.*;


@Service
public class DataExportImportService {

    private final static int BACKUP_DELAY = 1000 * 60 * 60 * 24; // daily


    private final static Logger logger = LogManager.getLogger();

    private final UserDao userDaoJooq;
    private final ExpenseDao expenseDaoJooq;
    private final CategoryDao categoryDaoJooq;
    private final SettingsDao settingsDaoJooq;
    private final RecurringExpenseDao recurringExpenseDaoJooq;
    private final YearlyHistoryDao yearlyHistoryDaoJooq;
    private final MonthlyHistoryDao monthlyHistoryDaoJooq;
    private final DefaultDSLContext dslContext;

    private final Gson gson;

    private final String importPassword;

    @Value("${DB_PATH:./SSS}")
    private String dbPath;


    @Autowired
    public DataExportImportService(DefaultDSLContext dslContext, UserDao userDaoJooq, ExpenseDao expenseDaoJooq, CategoryDao categoryDaoJooq, SettingsDao settingsDaoJooq, RecurringExpenseDao recurringExpenseDaoJooq, YearlyHistoryDao yearlyHistoryDaoJooq, MonthlyHistoryDao monthlyHistoryDaoJooq) {
        this.userDaoJooq = userDaoJooq;
        this.expenseDaoJooq = expenseDaoJooq;
        this.categoryDaoJooq = categoryDaoJooq;
        this.settingsDaoJooq = settingsDaoJooq;
        this.recurringExpenseDaoJooq = recurringExpenseDaoJooq;
        this.yearlyHistoryDaoJooq = yearlyHistoryDaoJooq;
        this.monthlyHistoryDaoJooq = monthlyHistoryDaoJooq;
        this.dslContext = dslContext;


        GsonBuilder builder = new GsonBuilder();
        builder.serializeSpecialFloatingPointValues();
        builder.registerTypeAdapter(Date.class, (JsonSerializer<Date>) (date, type, jsonSerializationContext) -> {

            final DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            return new JsonPrimitive(df.format(date));
        });
        builder.registerTypeAdapter(Date.class, new JsonDeserializer<Date>() {
            final DateFormat df = new SimpleDateFormat("yyyy-MM-dd");

            @Override
            public Date deserialize(final JsonElement json, final Type typeOfT, final JsonDeserializationContext context)
                    throws JsonParseException {
                try {
                    return df.parse(json.getAsString());
                } catch (ParseException e) {
                    return null;
                }
            }
        });

        this.gson = builder.create();

        // we generate a random password at every restart to allow import
        int leftLimit = 48; // numeral '0'
        int rightLimit = 122; // letter 'z'
        int targetStringLength = 128;
        Random random = new Random();


        importPassword = random.ints(leftLimit, rightLimit + 1)
                .filter(i -> (i <= 57 || i >= 65) && (i <= 90 || i >= 97))
                .limit(targetStringLength)
                .collect(StringBuilder::new, StringBuilder::appendCodePoint, StringBuilder::append)
                .toString();
        if (ALLOW_IMPORT) {
            logger.info("Import password is {}", importPassword);
        } else {
            logger.info("Import not allowed");
        }
    }


    private String getBackupFolder() {

        // if we have a h2 db file path, we save it in the same folder
        if (dbPath != null && !dbPath.startsWith("jdbc:")) {
            return Path.of(dbPath).toAbsolutePath().getParent().toString()+"/";
        } else {
            return "./";
        }
    }

    @Scheduled(fixedRate = BACKUP_DELAY, initialDelay = 0)
    public void exportData() throws IOException {
        logger.info("Starting daily backup");
        DataExport export = new DataExport();
        export.setUsers(userDaoJooq.getWhere());

        List<Category> categories = new ArrayList<>();
        export.getUsers().forEach(user -> categories.addAll(categoryDaoJooq.getWhere(user)));
        export.setCategories(categories);

        export.setExpenses(expenseDaoJooq.queryForAll(export.getCategories()));
        export.setSettings(settingsDaoJooq.getWhere());
        export.setRecurringExpenses(recurringExpenseDaoJooq.queryForAll(export.getCategories()));
        export.setYearlyHistories(yearlyHistoryDaoJooq.getWhere());
        export.setMonthlyHistories(monthlyHistoryDaoJooq.getWhere());


        var json = gson.toJson(export);

        String fileName = "SSS-backup.json";

        Files.writeString(Path.of(getBackupFolder() + fileName), json);
        logger.info("Backup completed to file: {} with {} users, {} categories, {} expenses", fileName, export.getUsers()
                .size(), export.getCategories().size(), export.getExpenses().size());

    }

    public void importData(MultipartFile file, String importPassword) throws IOException {
        if (ALLOW_IMPORT) {

            if (importPassword.equalsIgnoreCase(this.importPassword)) {
                logger.info("Proceeding to import, all existing data will be deleted !!");

                var json = new String(file.getBytes());

                DataExport export = gson.fromJson(json, DataExport.class);

                System.out.println(export);

                logger.info("We can parse the file, deleting existing data");
                dslContext.truncate(CATEGORY).execute();
                dslContext.truncate(EXPENSE).execute();
                dslContext.truncate(MONTHLY_HISTORY).execute();
                dslContext.truncate(RECURRING_EXPENSE).execute();
                dslContext.truncate(SETTINGS).execute();
                dslContext.truncate(USER).execute();
                dslContext.truncate(YEARLY_HISTORY).execute();

                logger.info("Importing users...");
                userDaoJooq.importMany(export.getUsers());
                logger.info("Importing settings...");
                settingsDaoJooq.importMany(export.getSettings());
                logger.info("Importing categories...");
                categoryDaoJooq.importManyForUsers(export.getCategories());
                logger.info("Importing expenses...");
                expenseDaoJooq.importManyForUsers(export.getExpenses());
                logger.info("Importing recurring expenses...");
                recurringExpenseDaoJooq.importManyForUsers(export.getRecurringExpenses());
                logger.info("Importing monthly history...");
                monthlyHistoryDaoJooq.importMany(export.getMonthlyHistories());
                logger.info("Importing yearly history...");
                yearlyHistoryDaoJooq.importMany(export.getYearlyHistories());
            } else {
                throw new InvalidParameterException("Invalid import password");
            }
        } else {
            throw new InvalidParameterException("Import not allowed");
        }
    }
}
