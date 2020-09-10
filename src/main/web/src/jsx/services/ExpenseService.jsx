import Http from './Http';
import {API} from './Endpoints.jsx';

export default class ExpenseService {

    add(expense) {
        return Http.post(API.EXPENSE.ADD, expense);
    }

    getMonths() {
        return Http.get(API.EXPENSE.GET_MONTHS);
    }

    getByDay(month) {
        return Http.get(API.EXPENSE.BY_MONTH.format(month));
    }

    delete(id) {
        return Http.delete(API.EXPENSE.DELETE.format(id));
    }

}