import axios from 'axios';

export default class CategoryService{
    getAll(){
        return axios.get(API.CATEGORY.ALL);
    }

    get(id){
        console.log(API.CATEGORY.GET.format(id));
    }
}