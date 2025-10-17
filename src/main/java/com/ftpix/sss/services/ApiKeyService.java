package com.ftpix.sss.services;

import com.ftpix.sss.dao.ApiKeyDao;
import com.ftpix.sss.dsl.Tables;
import com.ftpix.sss.models.ApiKey;
import com.ftpix.sss.models.User;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class ApiKeyService {
    private final ApiKeyDao apiKeyDao;


    @Autowired
    public ApiKeyService(ApiKeyDao apiKeyDao) {
        this.apiKeyDao = apiKeyDao;
    }

    @Transactional
    public ApiKey createApiKey(User user, ApiKey keyBaseData) {
        ApiKey key = new ApiKey();
        var clearKey = RandomStringUtils.secure().next(64, true, false);

        key.setApiKey(new BCryptPasswordEncoder().encode(clearKey));
        key.setApiKeyHash(DigestUtils.sha256Hex(clearKey));
        key.setTimeCreated(System.currentTimeMillis());
        key.setUser(user);
        key.setKeyName(keyBaseData.getKeyName());
        key.setExpiryDate(keyBaseData.getExpiryDate());


        apiKeyDao.insert(key);
        // when creating a key, we return the clear one so the user can see it once
        key.setApiKey(clearKey);
        return key;
    }

    @Transactional(readOnly = true)
    public List<ApiKey> getKeys(User currentUser) {
        return apiKeyDao.getWhere(Tables.API_KEYS.USER_ID.eq(currentUser.getId().toString())).stream().map(k -> {
            k.setApiKey(null);
            return k;
        }).toList();
    }

    @Transactional()
    public Optional<User> getUserForKey(String clearKey) {
        BCryptPasswordEncoder bCryptPasswordEncoder = new BCryptPasswordEncoder();
        return apiKeyDao.getOneWhere(Tables.API_KEYS.APIKEYHASH.eq(DigestUtils.sha256Hex(clearKey)))
                .filter(apiKey -> apiKey.getExpiryDate() == null || apiKey.getExpiryDate() > System.currentTimeMillis())
                .filter(apiKey -> bCryptPasswordEncoder.matches(clearKey, apiKey.getApiKey()))
                .map(apiKey1 -> {
                    apiKey1.setLastUsed(System.currentTimeMillis());
                    apiKeyDao.update(apiKey1);
                    return apiKey1.getUser();
                });

    }

    public boolean deleteKey(User user, UUID id) {
        return apiKeyDao.deleteWhere(Tables.API_KEYS.ID.eq(id.toString()), Tables.API_KEYS.USER_ID.eq(user.getId()
                .toString())) == 1;
    }
}
