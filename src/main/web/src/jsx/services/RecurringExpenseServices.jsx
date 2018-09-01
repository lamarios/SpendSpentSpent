import axios from 'axios';
import {API} from './Endpoints.jsx';
import qs from 'querystring';

export default class RecurringExpenseServices {

    getAll() {
        return axios.get(API.RECURRING.GET);
    }

    delete(id){
        return axios.delete(API.RECURRING.DELETE.format(id));
    }

    add(recurirngExpense){
        return axios.post(API.RECURRING.ADD, qs.stringify(recurirngExpense));
    }



}