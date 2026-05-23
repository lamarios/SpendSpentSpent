package com.ftpix.sss.services;

import com.ftpix.sss.models.*;
import com.ftpix.sss.persistence.FilesRepository;
import org.apache.commons.io.FilenameUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.crypto.*;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.SecureRandom;
import java.security.spec.KeySpec;
import java.util.*;
import java.util.concurrent.ExecutionException;
import java.util.function.Function;

@Service
public class FileService {

    public static final int ONE_DAY = 24 * 60 * 60 * 1000;
    private static final int IV_SIZE = 12;
    private static final int SALT_SIZE = 16;     // 16 bytes salt// 12 bytes IV for GCM
    private static final int TAG_SIZE = 128;     // authentication tag length
    private final String filePath;
    private final AiFileProcessingService aiFileProcessingService;
    private final CategoryService categoryService;
    private final static Logger log = LogManager.getLogger();
    private final FilesRepository filesRepository;

    private static final byte[] MAGIC = "ENCv1".getBytes(); // identifier
    private static final int ITERATIONS = 65536; // PBKDF2 iterations
    private static final int KEY_SIZE = 256;
    private static final String ALGO = "AES/GCM/NoPadding";


    private final SecretKey encryptionKey;
    private final HouseholdService householdService;

    @Autowired
    public FileService(@Value("${FILES_PATH:./files}") String filePath, AiFileProcessingService aiFileProcessingService, CategoryService categoryService, FilesRepository filesRepository, @Value("${SALT}") String salt, HouseholdService householdService) throws Exception {
        this.aiFileProcessingService = aiFileProcessingService;
        this.categoryService = categoryService;
        this.filesRepository = filesRepository;
        this.householdService = householdService;
        File folder = new File(filePath);
        if (!folder.exists()) {
            folder.mkdir();
        }

        if (!folder.isDirectory()) {
            throw new RuntimeException("File folder not a directory! Please check the configuration!");
        }
        this.filePath = folder.getAbsolutePath();

        encryptionKey = deriveKey(salt.toCharArray(), new byte[SALT_SIZE]);
    }

/*
    @Transactional
    public boolean clearExpenseFiles(Long expenseId) {
        return filesDAO.clearExpenseFiles(expenseId);
    }
*/


    @Scheduled(fixedRate = ONE_DAY)
    @Transactional
    public void fileMaintenance() throws IOException {
        long oneDayFromNow = System.currentTimeMillis() - ONE_DAY;
        // we get all the pictures older than one day
        filesRepository.findByTimeCreatedBefore(oneDayFromNow).stream().filter(file -> {
                    boolean toDelete = file.getExpense() == null;

                    if (toDelete) {
                        deleteFile(file);
                    }

                    return !toDelete;
                })
                // then we remove anything that is already done
                .filter(file -> file.getStatus() != AiProcessingStatus.DONE && file.getStatus() != AiProcessingStatus.NO_PROCESSING)
                // with the remaining files, we reprocess them through our ai
                .forEach(file -> {
                    if (aiFileProcessingService.isAiEnabled()) {
                        file.setStatus(AiProcessingStatus.PENDING);
                        filesRepository.save(file);
                        processFileWithAi(file);
                    }
                });


        // we delete any physical file that has no sssFile linked to it
        Files.list(Path.of(filePath)).filter(
                path -> {
                    var name = FilenameUtils.getBaseName(path.toString());
                    var file = filesRepository.findFirstById(UUID.fromString(name));
                    return file == null;
//                    var file = filesDAO.getOneWhere(FILES.ID.eq(name));
//
//                    return file.isEmpty();
                }
        ).forEach(path -> {
            log.info("Deleting {}, it has no SssFile attached to it", path);
            path.toFile().delete();
        });


    }

    @Transactional
    public boolean deleteFile(SSSFile file) {
        File f = new File(filePath + "/" + file.getFileName());
        if (f.exists()) {
            try {
                f.delete();
            } catch (Exception e) {
                log.error("Couldn't delete file " + f.getAbsolutePath(), e);
            }
        }
        filesRepository.delete(file);
        return true;
    }


    @Transactional
    public SSSFile createFile(User currentUser, MultipartFile file) throws Exception {
        boolean aiEnabled = aiFileProcessingService.isAiEnabled();

        try {
            SSSFile sssFile = createFromUpload(currentUser, file);

            if (aiEnabled) {
                processFileWithAi(sssFile);
            }

            return sssFile;
        } catch (Exception e) {
            throw e;
        }
    }

    @Transactional
    public SSSFile createFromUpload(User currentUser, MultipartFile file) throws Exception {
        SSSFile sssFile = new SSSFile();
        sssFile.setUser(currentUser);
        sssFile.setTimeCreated(System.currentTimeMillis());
        sssFile.setTimeUpdated(System.currentTimeMillis());
        sssFile.setStatus(aiFileProcessingService.isAiEnabled() ? AiProcessingStatus.PENDING : AiProcessingStatus.NO_PROCESSING);
        filesRepository.save(sssFile);
        String newfileName = sssFile.getId() + "." + FilenameUtils.getExtension(file.getOriginalFilename());
        File dest = File.createTempFile("sss-temp", "");


        try {
            file.transferTo(dest);

            encryptFile(sssFile, dest);

            sssFile.setFileName(newfileName);

            filesRepository.save(sssFile);
            return sssFile;
        } finally {
            dest.delete();
        }
    }


    @Transactional
    public CategorySuggestionResponse findFileCategory(User currentUser, MultipartFile file) throws ExecutionException, InterruptedException {
        var work = AiFileProcessingService.exec.submit(() -> {
            boolean aiEnabled = aiFileProcessingService.isAiEnabled();
            SSSFile sssFile = createFromUpload(currentUser, file);

            try {

                List<NewCategoryIcon> categories = categoryService.getUsed(currentUser)
                        .values()
                        .stream()
                        .flatMap(Collection::stream)
                        .toList();

                if (aiEnabled) {
                    return decryptAndDo(sssFile, dest -> {
                        // we refresh the file before saving it to avoid issues
                        CategorySuggestionResponse bestCategory = null;
                        try {
                            bestCategory = aiFileProcessingService.findBestCategory(dest, categories);
                            sssFile.setAiTags(bestCategory.file().getAiTags());
                            sssFile.setAmounts(bestCategory.file().getAmounts());
                            bestCategory = new CategorySuggestionResponse(bestCategory.categories(), sssFile);
                            bestCategory.file().setStatus(AiProcessingStatus.DONE);

                            filesRepository.save(bestCategory.file());

                            return bestCategory;
                        } catch (Exception e) {
                            throw new RuntimeException(e);
                        }
                    });
                } else {
                    return new CategorySuggestionResponse(categories, sssFile);
                }


            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        });

        return work.get();
    }


    public <T> T decryptAndDo(SSSFile sssFile, Function<File, T> consumer) throws Exception {
        File temp = File.createTempFile("sss-decrypt", "." + FilenameUtils.getExtension(sssFile.getFileName()));
        try {
            File f = new File(filePath + "/" + sssFile.getId().toString() + ".bin");
            if (f.exists()) {
                decrypt(sssFile, temp);
                return consumer.apply(temp);
            } else {
                // legacy non encrypted files
                f = new File(filePath + "/" + sssFile.getFileName());
                return consumer.apply(f);
            }
        } catch (Exception e) {
            throw e;
        } finally {
            temp.delete();
        }
    }

    // Decrypt file
    // Decrypt file
    private void decrypt(SSSFile sssFile, File outputFile) throws Exception {
        log.info("Decrypting file {}", sssFile.getId());
        long start = System.currentTimeMillis();

        File inputFile = new File(filePath + "/" + sssFile.getId() + ".bin");
        try (FileInputStream fis = new FileInputStream(inputFile)) {
            // 1. read and validate MAGIC
            byte[] magic = new byte[MAGIC.length];
            if (fis.read(magic) != MAGIC.length || !java.util.Arrays.equals(magic, MAGIC)) {
                throw new IllegalArgumentException("File is not encrypted with this scheme!");
            }

            // 2. read salt
            byte[] salt = new byte[SALT_SIZE];
            if (fis.read(salt) != SALT_SIZE) {
                throw new IOException("Failed to read salt");
            }

            // 3. read IV
            byte[] iv = new byte[IV_SIZE];
            if (fis.read(iv) != IV_SIZE) {
                throw new IOException("Failed to read IV");
            }


            // 5. init cipher
            Cipher cipher = Cipher.getInstance(ALGO);
            cipher.init(Cipher.DECRYPT_MODE, encryptionKey, new GCMParameterSpec(TAG_SIZE, iv));

            // 6. decrypt the rest of the file
            try (CipherInputStream cis = new CipherInputStream(fis, cipher);
                 FileOutputStream fos = new FileOutputStream(outputFile)) {
                cis.transferTo(fos);
            }
        }

        log.info("Decrypt done in {}ms", (System.currentTimeMillis() - start));
    }

    private File encryptFile(SSSFile sssFile, File f) throws Exception {
        long start = System.currentTimeMillis();
        byte[] iv = new byte[IV_SIZE];
        byte[] salt = new byte[SALT_SIZE];
        SecureRandom random = new SecureRandom();
        random.nextBytes(salt);
        random.nextBytes(iv);

        Cipher cipher = Cipher.getInstance(ALGO);
        cipher.init(Cipher.ENCRYPT_MODE, encryptionKey, new GCMParameterSpec(TAG_SIZE, iv));

        File outputFile = new File(filePath + "/" + sssFile.getId().toString() + ".bin");

        try (FileOutputStream fos = new FileOutputStream(outputFile); CipherOutputStream cos = new CipherOutputStream(fos, cipher)) {
            fos.write(MAGIC); // write header
            fos.write(salt);  // write salt
            fos.write(iv);    // write IV
            Files.copy(f.toPath(), cos);
        }

        log.info("Encrypt file done, encrypted file: {} in {}ms", outputFile.getAbsolutePath(), (System.currentTimeMillis() - start));

        return outputFile;
    }

    // Derive key from password + salt
    public static SecretKey deriveKey(char[] password, byte[] salt) throws Exception {
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
        KeySpec spec = new PBEKeySpec(password, salt, ITERATIONS, KEY_SIZE);
        byte[] keyBytes = factory.generateSecret(spec).getEncoded();
        return new SecretKeySpec(keyBytes, "AES");
    }


    private void processFileWithAi(SSSFile file) {
        AiFileProcessingService.exec.submit(() -> {
            User user = new User();
            user.setId(file.getId());
            try {
                decryptAndDo(file, f -> {
                    SSSFile toProcess;
                    try {
                        // we refresh the file before saving it to avoid issues
//                        filesDAO.updateField(file, FILES.STATUS, AiProcessingStatus.PROCESSING.name());
                        file.setStatus(AiProcessingStatus.PROCESSING);
                        var tags = aiFileProcessingService.getTagsForFile(f);


//                        toProcess = filesDAO.getOneWhere(FILES.ID.eq(file.getId().toString())).get();
                        toProcess = filesRepository.findFirstById(file.getId());
                        toProcess.setAiTags(tags.tags());
                        toProcess.setAmounts(tags.amounts());
                        toProcess.setStatus(AiProcessingStatus.DONE);

                        filesRepository.save(toProcess);
/*
                        filesDAO.updateField(file, FILES.STATUS, AiProcessingStatus.DONE.name());
                        filesDAO.updateField(file, FILES.AI_TAGS, record.getAiTags());
                        filesDAO.updateField(file, FILES.AMOUNTS, record.getAmounts());
*/

                    } catch (Exception e) {
                        log.error("Error while processing file " + file.getId(), e);
//                        filesDAO.updateField(file, FILES.STATUS, AiProcessingStatus.ERROR.name());
                        file.setStatus(AiProcessingStatus.ERROR);
                        filesRepository.save(file);
                        throw new RuntimeException(e);
                    }

                    return null;
                });
            } catch (Exception e) {
                throw new RuntimeException(e);
            }

        });
    }

    @Transactional(readOnly = true)
    public Optional<SSSFile> getfile(User user, String fileId) {

        // file from a household should be able to see each other files
        var household = householdService.getCurrentHousehold(user);
        List<User> users = new ArrayList<>();
        if (household.isPresent()) {
            users.addAll(household.get()
                    .getMembers()
                    .stream()
                    .map(HouseholdMember::getUser)
                    .toList());
        } else {
            users.add(user);
        }


        return Optional.ofNullable(filesRepository.findFirstByIdAndUserIn(UUID.fromString(fileId), users));
//        return filesDAO.getOneWhere(FILES.ID.eq(fileId).and(FILES.USER_ID.in(users)));
    }

    @Transactional(readOnly = true)
    public void updateFile(SSSFile file) {
        filesRepository.save(file);
    }

    @Transactional(readOnly = true)
    public List<SSSFile> getFiles(List<Expense> expenses) {
        return filesRepository.findAllByExpenseIn(expenses);
//        return filesDAO.getWhere(FILES.EXPENSE_ID.in(expenses.stream().map(Expense::getId).toList()));
    }

    @Transactional(readOnly = true)
    public File getFileAsFile(User currentUser, String fileId) throws FileNotFoundException {
        var sssFile = filesRepository.findFirstByIdAndUser(UUID.fromString(fileId), currentUser);
        if (sssFile == null) {
            throw new FileNotFoundException();
        }
        return new File(filePath + "/" + sssFile.getFileName());
    }
}
