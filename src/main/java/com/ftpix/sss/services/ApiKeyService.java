package com.ftpix.sss.services;

import com.ftpix.sss.models.ApiKey;
import com.ftpix.sss.models.User;
import com.ftpix.sss.persistence.ApiKeyRepository;
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
    //    private final ApiKeyDao apiKeyDao;
    private final ApiKeyRepository apiKeyRepository;


    @Autowired
    public ApiKeyService(ApiKeyRepository apiKeyRepository) {
        this.apiKeyRepository = apiKeyRepository;
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


        apiKeyRepository.save(key);
        // when creating a key, we return the clear one so the user can see it once
        // return a detached copy with the clear key, don't mutate the managed entity
        ApiKey response = new ApiKey();
        response.setId(key.getId());
        response.setApiKey(clearKey); // clear key for one-time display
        response.setKeyName(key.getKeyName());
        response.setExpiryDate(key.getExpiryDate());
        response.setTimeCreated(key.getTimeCreated());
        return response;
    }

    @Transactional(readOnly = true)
    public List<ApiKey> getKeys(User currentUser) {
        return apiKeyRepository.findByUser(currentUser).stream().map(k -> {
            k.setApiKey(null);
            return k;
        }).toList();
    }

    @Transactional()
    public Optional<User> getUserForKey(String clearKey) {
        BCryptPasswordEncoder bCryptPasswordEncoder = new BCryptPasswordEncoder();
//        return apiKeyDao.getOneWhere(Tables.API_KEYS.APIKEYHASH.eq(DigestUtils.sha256Hex(clearKey)))
        String hashedKey = DigestUtils.sha256Hex(clearKey);
        List<ApiKey> possibleMatches = apiKeyRepository.findByApiKeyHash(hashedKey);
        return possibleMatches
                .stream()
                .filter(apiKey -> {
                    return apiKey.getExpiryDate() == null || apiKey.getExpiryDate() > System.currentTimeMillis();
                })
                .filter(apiKey -> {
                    return bCryptPasswordEncoder.matches(clearKey, apiKey.getApiKey());
                })
                .map(apiKey1 -> {
                    apiKey1.setLastUsed(System.currentTimeMillis());
                    apiKeyRepository.save(apiKey1);
                    return apiKey1.getUser();
                }).findFirst();

    }

    @Transactional
    public boolean deleteKey(User user, UUID id) {

        apiKeyRepository.deleteApiKeyByIdAndUser(id, user);
//        return apiKeyDao.deleteWhere(Tables.API_KEYS.ID.eq(id.toString()), Tables.API_KEYS.USER_ID.eq(user.getId()
//                .toString())) == 1;
        return true;
    }
}
