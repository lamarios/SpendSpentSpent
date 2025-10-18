package com.ftpix.sss.controllers.api;

import com.ftpix.sss.models.ApiKey;
import com.ftpix.sss.services.ApiKeyService;
import com.ftpix.sss.services.UserService;
import io.swagger.annotations.Api;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.security.InvalidParameterException;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/API/ApiKey")
@Api(tags = {"Api Key"})
public class ApiKeyController {

    private final UserService userService;
    private final ApiKeyService apiKeyService;


    @Autowired
    public ApiKeyController(UserService userService, ApiKeyService apiKeyService) {
        this.userService = userService;
        this.apiKeyService = apiKeyService;
    }

    @PostMapping
    public ApiKey create(@RequestBody ApiKey apiKey) throws SQLException {
        if (apiKey.getKeyName() == null || apiKey.getKeyName().trim().isEmpty()) {
            throw new InvalidParameterException("Key name is required");
        }
        return apiKeyService.createApiKey(userService.getCurrentUser(), apiKey);
    }

    @GetMapping
    public List<ApiKey> getApiKeys() throws SQLException {
        return apiKeyService.getKeys(userService.getCurrentUser());
    }

    @DeleteMapping("/{id}")
    public boolean deleteKey(@PathVariable String id) throws SQLException {
        return apiKeyService.deleteKey(userService.getCurrentUser(), UUID.fromString(id));
    }
}
