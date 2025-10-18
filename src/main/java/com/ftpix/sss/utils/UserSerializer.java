package com.ftpix.sss.utils;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.ftpix.sss.models.User;

import java.io.IOException;

public class UserSerializer extends JsonSerializer<User> {

    @Override
    public void serialize(User user, JsonGenerator gen, SerializerProvider serializers) throws IOException {
        ObjectMapper mapper = (ObjectMapper) gen.getCodec();

        // Convert user to a mutable JSON tree
        ObjectNode node = mapper.valueToTree(user);

        // Remove sensitive field
        node.remove("password");

        // Write the final JSON object
        mapper.writeTree(gen, node);
    }
}

