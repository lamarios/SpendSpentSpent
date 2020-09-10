import {API} from './Endpoints.jsx';
import Http from './Http';

export default class RecurringExpenseServices {

    getAll() {
        return Http.get(API.RECURRING.GET);
    }

    delete(id) {
        return Http.delete(API.RECURRING.DELETE.format(id));
    }

    add(recurirngExpense) {
        return Http.post(API.RECURRING.ADD, recurirngExpense);
    }

}