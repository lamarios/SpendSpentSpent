import axios from 'axios';
import querystring from 'querystring';

export default class ExpenseService{

    add(expense){
        return axios.post(API.EXPENSE.ADD, querystring.stringify(expense));
    }


    getMonths(){
        return axios.get(API.EXPENSE.GET_MONTHS);
    }


    getByDay(month){
        return axios.get(API.EXPENSE.BY_MONTH.format(month));
    }

    delete(id){
        return axios.delete(API.EXPENSE.DELETE.format(id));
    }

}