package com.ftpix.sss.controllers.api;

import com.ftpix.sss.models.CategorySuggestionResponse;
import com.ftpix.sss.models.SSSFile;
import com.ftpix.sss.models.User;
import com.ftpix.sss.services.FileService;
import com.ftpix.sss.services.UserService;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.SQLException;
import java.util.concurrent.ExecutionException;

@RestController
@RequestMapping("/API/Files")
@Tag(name = "Files")
@SecurityRequirement(name = "bearerAuth")
public class FileController {


    private final FileService fileService;
    private final UserService userService;

    @Autowired
    public FileController(FileService fileService, UserService userService) {
        this.fileService = fileService;
        this.userService = userService;
    }

    @GetMapping("/{id}/download")
    public ResponseEntity<byte[]> downloadFile(@PathVariable("id") String fileId) throws Exception {

        var sssFile = fileService.getfile(userService.getCurrentUser(), fileId);

        if (sssFile.isPresent()) {

            return fileService.decryptAndDo(sssFile.get(), f -> {

                Path p = Path.of(f.getAbsolutePath());

                String mimeType = null;
                try {
                    mimeType = Files.probeContentType(p);

                    return ResponseEntity.ok()
                            .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + p.getFileName() + "\"")
                            .contentType(MediaType.valueOf(mimeType))
                            .contentLength(Files.size(p))
                            .body(Files.readAllBytes(f.toPath()));
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
            });
        } else {
            return ResponseEntity.status(404).build();
        }
    }

    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public SSSFile uploadFile(@RequestParam("file") MultipartFile file) throws Exception {
        final User currentUser = userService.getCurrentUser();
        return fileService.createFile(currentUser, file);
    }

    @PostMapping(value = "/find-category", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public CategorySuggestionResponse findFileCategory(@RequestParam("file") MultipartFile file) throws SQLException, IOException, ExecutionException, InterruptedException {
        final User currentUser = userService.getCurrentUser();
        return fileService.findFileCategory(currentUser, file);
    }

}
