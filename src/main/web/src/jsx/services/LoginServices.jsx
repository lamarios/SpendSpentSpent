import {API} from './Endpoints.jsx';
import Http from './Http';

export default class LoginService {

    login(username, password) {
        return Http.post(API.SESSION.LOGIN, {
            username: username,
            password: password,
        });
    }

}