package com.ftpix.sss.services;

import com.ftpix.sss.TestConfig;
import com.ftpix.sss.TestContainerTest;
import com.ftpix.sss.models.ApiKey;
import com.ftpix.sss.models.User;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Import;
import springfox.documentation.spring.web.plugins.Docket;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@Import(TestConfig.class)
public class ApiKeyServiceTest extends TestContainerTest {


    @Autowired
    private ApiKeyService apiKeyService;
    @Autowired
    private User currentUser;
    @Autowired
    private Docket api;


    @Test
    public void testApiKeyCrud() throws InterruptedException {
        var baseKey = new ApiKey();
        baseKey.setKeyName("test");
        baseKey.setExpiryDate(System.currentTimeMillis() + 5000);
        var newKey = apiKeyService.createApiKey(currentUser, baseKey);
        assertNotNull(newKey);
        assertEquals(baseKey.getKeyName(), newKey.getKeyName());
        assertEquals(baseKey.getExpiryDate(), newKey.getExpiryDate());

        var keys = apiKeyService.getKeys(currentUser);
        assertEquals(1, keys.size());
        assertNotEquals(newKey.getApiKey(), keys.get(0).getApiKey());
        assertNull(keys.get(0).getApiKey());

        // testing getting back our user through the api key
        // will be used by the security filter
        Optional<User> userOpt = apiKeyService.getUserForKey(newKey.getApiKey());
        assertTrue(userOpt.isPresent());
        var user = userOpt.get();
        assertEquals(currentUser.getId(), user.getId());

        keys = apiKeyService.getKeys(currentUser);
        assertEquals(1, keys.size());
        assertNotNull(keys.get(0).getLastUsed());


        // now we sleep for 5 seconds and the key should be expired
        Thread.sleep(5000);

        userOpt = apiKeyService.getUserForKey(newKey.getApiKey());
        assertFalse(userOpt.isPresent());

        // we delete the key
        var deleted = apiKeyService.deleteKey(currentUser, newKey.getId());
        assertTrue(deleted);
        keys = apiKeyService.getKeys(currentUser);
        assertEquals(0, keys.size());

    }
}
