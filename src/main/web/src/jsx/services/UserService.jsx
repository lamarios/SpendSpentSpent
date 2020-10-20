import Http from "./Http";
import {API} from "./Endpoints";

class UserService {

    editProfile(user) {
        return Http.post(API.USER.EDIT_PROFILE, user);
    }
}

export const userService = new UserService();