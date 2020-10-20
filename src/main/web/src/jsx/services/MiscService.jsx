import {API} from './Endpoints.jsx';
import Http from './Http'

export default class MiscService {

    getVersion(){
        return Http.get(API.MISC.VERSION);
    }

    getConfig(){
        return Http.get(API.MISC.GET_CONFIG);
    }
}

export const miscService = new MiscService();
