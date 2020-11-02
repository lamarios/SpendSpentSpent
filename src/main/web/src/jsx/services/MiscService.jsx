import {API} from './Endpoints.jsx';
import Http from './Http'

export default class MiscService {

    getVersion() {
        return Http.get(API.MISC.VERSION);
    }

    getConfig() {
        return Http.get(API.MISC.GET_CONFIG);
    }

    resetPasswordRequest(email) {
        return Http.post(API.SESSION.RESET_PASSWORD_REQUEST, email);
    }

    resetPassword(request) {
        return Http.post(API.SESSION.RESET_PASSWORD, request);
    }

}

export const miscService = new MiscService();
