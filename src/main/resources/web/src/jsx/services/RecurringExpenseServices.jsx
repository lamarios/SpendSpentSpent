import axios from 'axios';


export default class RecurringExpenseServices {

    getAll() {
        return axios.get(API.RECURRING.GET);
    }

    delete(id){
        return axios.delete(API.RECURRING.DELETE.format(id));
    }

}