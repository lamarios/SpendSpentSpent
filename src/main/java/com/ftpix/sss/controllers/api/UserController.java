package com.ftpix.sss.controllers.api;

import com.ftpix.sparknnotation.Sparknotation;
import com.ftpix.sparknnotation.annotations.SparkBody;
import com.ftpix.sparknnotation.annotations.SparkController;
import com.ftpix.sparknnotation.annotations.SparkHeader;
import com.ftpix.sparknnotation.annotations.SparkPost;
import com.ftpix.sss.db.DB;
import com.ftpix.sss.models.User;
import com.ftpix.sss.transformer.GsonTransformer;
import spark.Spark;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import static com.ftpix.sss.controllers.api.ApiController.TOKEN;
import static com.ftpix.sss.controllers.api.UserSessionController.UNAUTHORIZED_SUPPLIER;
import static com.ftpix.sss.controllers.api.UserSessionController.getCurrentUser;

@SparkController("/API/User")
public class UserController {


    public Optional<User> getByEmail(String email) throws SQLException {
        Map<String, Object> values = new HashMap<>();
        values.put("email", email);

        return DB.USER_DAO.queryForFieldValues(values)
                .stream()
                .findFirst();
    }

    @SparkPost(transformer = GsonTransformer.class)
    public String updateUser(@SparkBody User user, @SparkHeader(TOKEN) String token) throws Exception {
        User currentUser = getCurrentUser(token).orElseThrow(UNAUTHORIZED_SUPPLIER);

        if(user.getFirstName() == null || user.getFirstName().length() == 0 || user.getLastName() == null || user.getLastName().length() == 0){
            Spark.halt(400,"First name and last name can't be empty");
        }

        currentUser.setFirstName(user.getFirstName());
        currentUser.setLastName(user.getLastName());

        if (user.getPassword() != null && user.getPassword().length() > 0) {
            currentUser.setPassword(Sparknotation.getController(SettingsController.class).hashUserCredentials(currentUser.getEmail(), user.getPassword()));
        }

        currentUser.update();

        return Sparknotation.getController(UserSessionController.class).createTokenForUser(user);
    }
}
