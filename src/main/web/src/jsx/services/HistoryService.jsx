import {API} from './Endpoints.jsx';
import Http from './Http';

export default class HistoryService {

    getYearly() {
        return Http.get(API.HISTORY.OVERALL.YEAR);
    }

    getMonthly() {
        return Http.get(API.HISTORY.OVERALL.MONTH);
    }

    getMonthlyGraphData(categoryId, count) {
        return Http.get(API.HISTORY.MONTHLY.format(categoryId, count));
    }

    getYearlyGraphData(categoryId, count) {
        return Http.get(API.HISTORY.YEARLY.format(categoryId, count));
    }
}