package com.ftpix.sss.services;

import com.ftpix.sss.models.Settings;
import org.springframework.stereotype.Service;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

@Service
public class Encryption {
    private static final String characterEncoding = "UTF-8";
    private static final String cipherTransformation = "AES/CBC/PKCS5PADDING";
    private static final String aesEncryptionAlgorithm = "AES";

    public static String SALT;

    /**
     * Method for Encrypt Plain String Data
     *
     * @param plainText
     * @return encryptedText
     */
    public static String encrypt(String plainText) {
        try {
            String encryptedText = "";
            Cipher cipher = Cipher.getInstance(cipherTransformation);
            byte[] key = SALT.getBytes(characterEncoding);
            SecretKeySpec secretKey = new SecretKeySpec(key, aesEncryptionAlgorithm);
            IvParameterSpec ivparameterspec = new IvParameterSpec(key);
            cipher.init(Cipher.ENCRYPT_MODE, secretKey, ivparameterspec);
            byte[] cipherText = cipher.doFinal(plainText.getBytes(StandardCharsets.UTF_8));
            Base64.Encoder encoder = Base64.getEncoder();
            encryptedText = encoder.encodeToString(cipherText);

            return encryptedText;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * Method For Get encryptedText and Decrypted provided String
     *
     * @param encryptedText
     * @return decryptedText
     */
    public static String decrypt(String encryptedText) {
        try {
            String decryptedText = "";
            Cipher cipher = Cipher.getInstance(cipherTransformation);
            byte[] key = SALT.getBytes(characterEncoding);
            SecretKeySpec secretKey = new SecretKeySpec(key, aesEncryptionAlgorithm);
            IvParameterSpec ivparameterspec = new IvParameterSpec(key);
            cipher.init(Cipher.DECRYPT_MODE, secretKey, ivparameterspec);
            Base64.Decoder decoder = Base64.getDecoder();
            byte[] cipherText = decoder.decode(encryptedText.getBytes(StandardCharsets.UTF_8));
            decryptedText = new String(cipher.doFinal(cipherText), StandardCharsets.UTF_8);

            return decryptedText;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static String decrypt(Settings settings) {
        return decrypt(settings.getValue());
    }
}
