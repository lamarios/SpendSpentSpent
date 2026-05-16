package com.ftpix.sss.persistence.listeners;

import com.ftpix.sss.models.SSSFile;
import com.ftpix.sss.websockets.WebSocketSessionManager;
import jakarta.persistence.PostUpdate;
import org.springframework.stereotype.Component;

@Component
public class FileListener {

    @PostUpdate
    public void onChanged(Object object){
        var file = (SSSFile) object;
        WebSocketSessionManager.sendToUser(file.getUser().getId().toString(), file);

    }
}
