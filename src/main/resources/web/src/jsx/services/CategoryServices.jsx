import axios from 'axios';
import querystring from 'querystring';

export default class CategoryService{
    getAll(){
        return axios.get(API.CATEGORY.ALL);
    }

    delete(id){
        return axios.delete(API.CATEGORY.DELETE.format(id));
    }

    add(icon){
        return axios.post(API.CATEGORY.ADD, querystring.stringify({
            icon: icon,
            order: 0,
        }));
    }


    getAvailable(){
        return axios.get(API.CATEGORY.AVAILABLE);
    }
}