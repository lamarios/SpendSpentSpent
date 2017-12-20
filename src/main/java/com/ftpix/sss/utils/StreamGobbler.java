package com.ftpix.sss.utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.function.Consumer;

/**
 * Takes an input stream and do something with each line of output using a consumer
 */
public class StreamGobbler implements Runnable {
    private final InputStream _inputStream;
    private Consumer<String> consumer;

    public StreamGobbler(InputStream is, Consumer<String> consumer) {
        _inputStream = is;
        this.consumer = consumer;
    }

    public void run() {
        try (
                InputStreamReader isr = new InputStreamReader(_inputStream);
                BufferedReader br = new BufferedReader(isr);
        ) {
            String line;
            while ((line = br.readLine()) != null) {
                consumer.accept(line);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
