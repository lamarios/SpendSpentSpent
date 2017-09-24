import axios from 'axios';


export default class HistoryService {

    getYearly() {
        return axios.get(API.HISTORY.OVERALL.YEAR);
    }

    getMonthly() {
        return axios.get(API.HISTORY.OVERALL.MONTH);
    }

}