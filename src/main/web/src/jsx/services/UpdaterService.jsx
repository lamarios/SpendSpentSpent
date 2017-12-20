import axios from 'axios';

export default class UpdaterService {


    info() {
        return axios.get(API.UPDATER.INFO);
    }
}
