import {API} from './Endpoints.jsx';
import Http from './Http';

export default class LoginService {

    login(username, password) {
        return Http.post(API.SESSION.LOGIN, {
            email: username,
            password: password,
        });
    }

    signUp(user) {
        return Http.post(API.SESSION.SIGNUP, user);
    }

    getCurrentUser() {
        if (localStorage && localStorage.getItem("token")) {
            const token = localStorage.getItem("token");
            var base64Url = token.split('.')[1];
            var base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
            var jsonPayload = decodeURIComponent(atob(base64).split('').map(function (c) {
                return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
            }).join(''));

            const payload = JSON.parse(jsonPayload);
            return payload.user
        } else {
            return null;
        }
    }

}

export const loginService = new LoginService();