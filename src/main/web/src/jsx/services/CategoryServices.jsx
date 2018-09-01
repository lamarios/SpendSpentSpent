import axios from 'axios';
import querystring from 'querystring';
import { API } from './Endpoints.jsx';

export default class CategoryService{
    getAll(){
        return axios.get(API.CATEGORY.ALL);
    }

    deleteCategory(id){
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

    search(name){
        return axios.post(API.CATEGORY.SEARCH, querystring.stringify({
            name: name
        }));
    }
}