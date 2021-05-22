import {API} from './Endpoints.jsx';
import Http from './Http';

export default class SettingsService {

    putSettings(settings) {
        return Http.post(API.SETTINGS.UPDATE, settings);
    }

    get(name) {
        return Http.get(API.SETTINGS.GET.format(name));
    }
}

export const settingsService = new SettingsService();

