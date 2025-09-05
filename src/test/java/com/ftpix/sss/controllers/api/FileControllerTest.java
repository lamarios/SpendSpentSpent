package com.ftpix.sss.controllers.api;

import com.ftpix.sss.TestConfig;
import com.ftpix.sss.TestContainerTest;
import com.ftpix.sss.models.User;
import com.ftpix.sss.services.FileService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Import;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.web.multipart.MultipartFile;
import org.testcontainers.shaded.org.apache.commons.io.FileUtils;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.util.Arrays;

import static java.nio.file.Files.readAllBytes;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

@Import(TestConfig.class)
public class FileControllerTest extends TestContainerTest {
    @Autowired
    private FileController fileController;

    @Autowired
    private FileService fileService;

    @Autowired
    private User currentUser;

    @Value("${FILES_PATH:./files}")
    private String filePath;

    @Test
    public void testFileUpload() throws Exception {
        File testFile = loadTestFile("test.png");
        MultipartFile file = new MockMultipartFile("test.png", "test.png", Files.probeContentType(testFile.toPath()), readAllBytes(testFile.toPath()));

        var sssFile = fileController.uploadFile(file);

        // we make sure the file exists and that it is not empty
        File f = new File(filePath + "/" + sssFile.getId() + ".bin");
        assertTrue(f.exists());
        assertTrue(f.length() > 0);

        // check that we can decrypt and use the file
        fileService.decryptAndDo(sssFile, decrypted -> {
            assertEquals(testFile.length(), decrypted.length());
            try {
                assertEquals(Files.probeContentType(testFile.toPath()), Files.probeContentType(decrypted.toPath()));
                assertEquals(testFile.length(), decrypted.length());
                assertEquals(getFileMd5(testFile), getFileMd5(decrypted));
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

            return null;
        });
    }

    @Test
    public void testFileDownload() throws Exception {

        File testFile = loadTestFile("test.png");
        MultipartFile file = new MockMultipartFile("test.png", "test.png", Files.probeContentType(testFile.toPath()), readAllBytes(testFile.toPath()));

        var sssFile = fileController.uploadFile(file);

        var download = fileController.downloadFile(sssFile.getId().toString());

        assertTrue(Arrays.equals(readAllBytes(testFile.toPath()), download.getBody()));

    }

    private File loadTestFile(String resourceName) throws IOException {
        try (InputStream in = FileUtils.class.getClassLoader().getResourceAsStream(resourceName)) {
            if (in == null) {
                throw new IllegalArgumentException("Resource not found: " + resourceName);
            }
            File temp = File.createTempFile("resource-", "-" + resourceName);
            temp.deleteOnExit();
            Files.copy(in, temp.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
            return temp;
        }
    }

    private String getFileMd5(File f) throws IOException {
        try (InputStream is = Files.newInputStream(f.toPath())) {
            return org.apache.commons.codec.digest.DigestUtils.md5Hex(is);
        }
    }

}
