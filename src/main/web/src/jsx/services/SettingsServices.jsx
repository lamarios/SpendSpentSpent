import {API} from './Endpoints.jsx';
import Http from './Http';

export default class SettingsService {

    putSettings(setting) {
        return Http.put(API.SETTINGS.UPDATE, [setting]);
    }

    putSettingsList(settings) {
        return Http.put(API.SETTINGS.UPDATE, settings);
    }

    getAll() {
        return Http.get(API.SETTINGS.ALL);
    }

    get(name) {
        return Http.get(API.SETTINGS.GET.format(name));
    }
}

export const settingsService = new SettingsService();

