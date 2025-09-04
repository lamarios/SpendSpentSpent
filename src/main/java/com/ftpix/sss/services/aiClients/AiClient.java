package com.ftpix.sss.services.aiClients;

import java.io.File;
import java.util.List;
import java.util.Map;

public interface AiClient {

    String processImage(String model, String prompt, File f) throws Exception;

    <T> List<T> generateFormatted(String model, String prompt, Class<T> format) throws Exception;
}
