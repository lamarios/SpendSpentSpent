import axios from 'axios';
import querystring from 'querystring';

export default class ExpenseService{

    add(expense){
        return axios.post(API.EXPENSE.ADD, querystring.stringify(expense));
    }


}