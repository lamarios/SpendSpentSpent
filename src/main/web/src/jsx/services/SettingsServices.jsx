import axios from 'axios';
import {API} from './Endpoints.jsx';

export default class SettingsService {

    putSettings(setting) {
        return axios.put(API.SETTINGS.UPDATE, [setting]);
    }

    putSettingsList(settings){
        return axios.put(API.SETTINGS.UPDATE, settings);
    }

    getAll() {
        return axios.get(API.SETTINGS.ALL);
    }

    get(name){
        return axios.get(API.SETTINGS.GET.format(name));
    }
}

