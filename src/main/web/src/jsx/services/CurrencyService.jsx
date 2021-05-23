import {API} from './Endpoints.jsx';
import Http from './Http';

export default class CurrencyService {

    get(from, to) {
        return Http.get(API.CURRENCY.GET.format(from, to));
    }

}

export const currencyService = new CurrencyService();

