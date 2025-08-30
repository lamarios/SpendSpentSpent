package com.ftpix.sss.controllers.api;

import com.ftpix.sss.models.SSSFile;
import com.ftpix.sss.models.User;
import com.ftpix.sss.services.FileService;
import com.ftpix.sss.services.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.SQLException;

@RestController
@RequestMapping("/API/Files")
public class FileController {


    private final FileService fileService;
    private final UserService userService;

    @Autowired
    public FileController(FileService fileService, UserService userService) {
        this.fileService = fileService;
        this.userService = userService;
    }

    @GetMapping("/{id}/download")
    public ResponseEntity<Resource> downloadFile(@PathVariable("id") String fileId) throws SQLException, IOException {

        File f = fileService.getFileAsFile(userService.getCurrentUser(), fileId);

        Path p = Path.of(f.getAbsolutePath());

        Resource resource = new FileSystemResource(f.getAbsolutePath());

        String mimeType = Files.probeContentType(p);

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + p.getFileName() + "\"")
                .contentType(MediaType.valueOf(mimeType))
                .contentLength(Files.size(p))
                .body(resource);
    }

    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public SSSFile uploadFile(@RequestParam("file") MultipartFile file) throws SQLException, IOException {
        final User currentUser = userService.getCurrentUser();
        return fileService.createFile(currentUser, file);

    }

}
