package com.ftpix.sss.services;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ftpix.sss.models.DataExport;
import com.ftpix.sss.persistence.SettingsRepository;
import com.ftpix.sss.persistence.UserRepository;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.InvalidParameterException;
import java.util.Random;

import static com.ftpix.sss.Constants.ALLOW_IMPORT;


@Service
public class DataExportImportService {

    private final static int BACKUP_DELAY = 1000 * 60 * 60 * 24; // daily


    private final static Logger logger = LogManager.getLogger();


    private final UserRepository userRepository;
    private final SettingsRepository settingsRepository;


    private final String importPassword;
    private final ObjectMapper objectMapper;

    @Value("${DB_PATH:./SSS}")
    private String dbPath;


    @Autowired
    public DataExportImportService(UserRepository userRepository, SettingsRepository settingsRepository, ObjectMapper objectMapper) {
        this.userRepository = userRepository;
        this.settingsRepository = settingsRepository;
        this.objectMapper = objectMapper;

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
            return Path.of(dbPath).toAbsolutePath().getParent().toString() + "/";
        } else {
            return "./";
        }
    }

    @Scheduled(fixedRate = BACKUP_DELAY, initialDelay = 0)
    @Transactional(readOnly = true)
    public void exportData() throws IOException {
        logger.info("Starting daily backup");
        DataExport export = new DataExport();
        export.setUsers(userRepository.findAll());

        export.setSettings(settingsRepository.findAll());


        var json = objectMapper.writeValueAsString(export);

        String fileName = "SSS-backup.json";

        Files.writeString(Path.of(getBackupFolder() + fileName), json);
        logger.info("Backup completed to file: {} with {} users", fileName, export.getUsers()
                .size());

    }

    @Transactional
    public void importData(MultipartFile file, String importPassword) throws IOException {
        if (ALLOW_IMPORT) {

            if (importPassword.equalsIgnoreCase(this.importPassword)) {
                logger.info("Proceeding to import, all existing data will be deleted !!");

                var json = new String(file.getBytes());

                DataExport export = objectMapper.readValue(json, DataExport.class);

                System.out.println(export);

                logger.info("We can parse the file, deleting existing data");
/*
                dslContext.truncate(CATEGORY).execute();
                dslContext.truncate(EXPENSE).execute();
                dslContext.truncate(MONTHLY_HISTORY).execute();
                dslContext.truncate(RECURRING_EXPENSE).execute();
                dslContext.truncate(SETTINGS).execute();
                dslContext.truncate(USER).execute();
                dslContext.truncate(YEARLY_HISTORY).execute();
*/

                logger.info("Importing users...");
                userRepository.saveAll(export.getUsers());
                logger.info("Importing settings...");
                settingsRepository.saveAll(export.getSettings());

/*
                // since now we're using postgres, we need to set the auto increment properly
                long maxCategory = export.getCategories().stream().mapToLong(Category::getId).max().orElse(1L);
                long maxExpense = export.getExpenses().stream().mapToLong(Expense::getId).max().orElse(1L);
                long maxRecurring = export.getRecurringExpenses()
                        .stream()
                        .mapToLong(RecurringExpense::getId)
                        .max()
                        .orElse(1L);
                dslContext.alterSequence("category_id_seq").restartWith(maxCategory + 1).execute();
                dslContext.alterSequence("expense_id_seq").restartWith(maxExpense + 1).execute();
                dslContext.alterSequence("recurring_expense_id_seq").restartWith(maxRecurring + 1).execute();
*/

            } else {
                throw new InvalidParameterException("Invalid import password");
            }
        } else {
            throw new InvalidParameterException("Import not allowed");
        }
    }
}
