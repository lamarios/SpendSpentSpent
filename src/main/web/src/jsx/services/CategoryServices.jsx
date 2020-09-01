import axios from 'axios';
import querystring from 'querystring';
import {API} from './Endpoints.jsx';

export default class CategoryService {
    getAll() {
        return axios.get(API.CATEGORY.ALL);
    }

    deleteCategory(id) {
        return axios.delete(API.CATEGORY.DELETE.format(id));
    }

    add(icon) {
        return axios.post(API.CATEGORY.ADD, querystring.stringify({
            icon: icon,
            order: 0,
        }));
    }

    updateMany(categories) {
        return fetch(API.CATEGORY.UPDATE_ALL, {
            method: 'PUT',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(categories)
        }).then(res => res.json());
    }

    getAvailable() {
        return axios.get(API.CATEGORY.AVAILABLE);
    }

    search(name) {
        return axios.post(API.CATEGORY.SEARCH, querystring.stringify({
            name: name
        }));
    }
}