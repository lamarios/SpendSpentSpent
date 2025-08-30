package com.ftpix.sss.services;

import com.ftpix.sss.dao.FileDAO;
import com.ftpix.sss.models.AiProcessingStatus;
import com.ftpix.sss.models.Expense;
import com.ftpix.sss.models.SSSFile;
import com.ftpix.sss.models.User;
import org.apache.commons.io.FilenameUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.jooq.Condition;
import org.jooq.Fields;
import org.jooq.Files;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.Collectors;

import static com.ftpix.sss.dsl.Tables.FILES;

@Service
public class FileService {

    private final String filePath;
    private final FileDAO filesDAO;
    private final AiFileProcessingService aiFileProcessingService;
    private final static Logger log = LogManager.getLogger();

    private final ExecutorService exec = Executors.newSingleThreadExecutor();

    @Autowired
    public FileService(@Value("${FILE_PATH:./files}") String filePath, FileDAO filesDAO, AiFileProcessingService aiFileProcessingService) {
        this.filesDAO = filesDAO;
        this.aiFileProcessingService = aiFileProcessingService;
        File folder = new File(filePath);
        if (!folder.exists()) {
            folder.mkdir();
        }

        if (!folder.isDirectory()) {
            throw new RuntimeException("File folder not a directory! Please check the configuration!");
        }
        this.filePath = folder.getAbsolutePath();
    }


    public SSSFile createFile(User currentUser, MultipartFile file) throws IOException {
        SSSFile sssFile = new SSSFile();
        sssFile.setUserId(currentUser.getId());
        sssFile.setTimeCreated(System.currentTimeMillis());
        sssFile.setTimeUpdated(System.currentTimeMillis());
        sssFile.setStatus(AiProcessingStatus.PENDING);

        String newfileName = sssFile.getId() + "." + FilenameUtils.getExtension(file.getOriginalFilename());
        File dest = new File(filePath + "/" + newfileName);
        file.transferTo(dest);

        sssFile.setFileName(newfileName);

        filesDAO.insert(sssFile);

        processFileWithAi(sssFile);

        return sssFile;
    }

    private void processFileWithAi(SSSFile file) {
        exec.submit(() -> {
            File f = new File(filePath + "/" + file.getFileName());
            SSSFile toProcess = file;
            try {
                // we refresh the file before saving it to avoid issues
                toProcess = filesDAO.getOneWhere(FILES.ID.eq(file.getId().toString())).get();
                toProcess.setStatus(AiProcessingStatus.PROCESSING);
                filesDAO.update(toProcess);
                List<String> tags = aiFileProcessingService.getTagsForFile(f);
                toProcess = filesDAO.getOneWhere(FILES.ID.eq(file.getId().toString())).get();
                toProcess.setAiTags(tags);
                toProcess.setStatus(AiProcessingStatus.DONE);
                filesDAO.update(toProcess);
            } catch (Exception e) {
                log.error("Error while processing file " + file.getId(), e);
                toProcess = filesDAO.getOneWhere(FILES.ID.eq(file.getId().toString())).get();
                toProcess.setStatus(AiProcessingStatus.ERROR);
                filesDAO.update(toProcess);
                throw new RuntimeException(e);
            }
        });
    }

    public Optional<SSSFile> getfile(User user, String fileId) {
        return filesDAO.getOneWhere(FILES.ID.eq(fileId).and(FILES.USER_ID.eq(user.getId().toString())));
    }

    public void updateFile(SSSFile file) {
        filesDAO.update(file);
    }

    public List<SSSFile> getFiles(List<Expense> expenses) {
        return filesDAO.getWhere(FILES.EXPENSE_ID.in(expenses.stream().map(Expense::getId).toList()));
    }

    public File getFileAsFile(User currentUser, String fileId) throws FileNotFoundException {
        var sssFile = filesDAO.getOneWhere(FILES.USER_ID.eq(currentUser.getId().toString()).and(FILES.ID.eq(fileId)));
        if (sssFile.isEmpty()) {
            throw new FileNotFoundException();
        }
        return new File(filePath + "/" + sssFile.get().getFileName());
    }
}
