import axios from 'axios';
import {API} from './Endpoints.jsx';


export default class HistoryService {

    getYearly() {
        return axios.get(API.HISTORY.OVERALL.YEAR);
    }

    getMonthly() {
        return axios.get(API.HISTORY.OVERALL.MONTH);
    }

    getMonthlyGraphData(categoryId, count){
        return axios.get(API.HISTORY.MONTHLY.format(categoryId, count));
    }

    getYearlyGraphData(categoryId, count) {
        return axios.get(API.HISTORY.YEARLY.format(categoryId, count));
    }
}