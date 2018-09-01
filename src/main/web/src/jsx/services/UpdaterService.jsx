import axios from 'axios';
import {API} from './Endpoints.jsx';

export default class UpdaterService {


    info() {
        return axios.get(API.UPDATER.INFO);
    }
}
