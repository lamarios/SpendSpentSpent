import axios from 'axios';

export default class CategoryService{
    refresh(){
        return axios.get('/API/Category');
    }
}