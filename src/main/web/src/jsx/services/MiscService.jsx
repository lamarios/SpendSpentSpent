import axios from 'axios';
import {API} from './Endpoints.jsx';
import qs from 'querystring';

export default class MiscService {

    getVersion(){
        return axios.get(API.MISC.VERSION);
    }
}
