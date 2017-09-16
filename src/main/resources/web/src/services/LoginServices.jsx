import axios from 'axios';
import querystring from 'querystring';

export default class LoginService {

    login(username, password) {
        return axios.post(API.SESSION.LOGIN, querystring.stringify({
            username: username,
            password: password,
        }));
    }

}