import Http from "./Http";
import {API} from "./Endpoints";

class UserService {

    editProfile(user) {
        return Http.post(API.USER.EDIT_PROFILE, user);
    }

    getUsers(search, page, pageSize) {
        const queryString = "?search=" + encodeURIComponent(search) + "&page=" + page + "&pageSize=" + pageSize;

        return Http.get(API.USER.GET+queryString);
    }

    setAdmin(userId, isAdmin) {
        return Http.get(API.USER.SET_ADMIN.format(userId, isAdmin));
    }

    setPassword(userId, password) {
        return Http.post(API.USER.UPDATE_PASSWORD.format(userId), password);
    }

    createUser(user) {
        return Http.put(API.USER.ADD_USER, user);
    }

    deleteUser(userId) {
        return Http.delete(API.USER.DELETE_USER.format(userId));
    }
}

export const userService = new UserService();