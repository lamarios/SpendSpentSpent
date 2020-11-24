import {API} from './Endpoints.jsx';
import Http from './Http';

export default class CategoryService {
    getAll() {
        return Http.get(API.CATEGORY.ALL);
    }

    deleteCategory(id) {
        return Http.delete(API.CATEGORY.DELETE.format(id));
    }

    add(icon) {
        return Http.post(API.CATEGORY.ADD, {
            icon: icon,
            order: 0,
        });
    }

    updateMany(categories) {
        return Http.put(API.CATEGORY.UPDATE_ALL, categories);
    }

    getAvailable() {
        return Http.get(API.CATEGORY.AVAILABLE);
    }

    search(name) {
        return Http.post(API.CATEGORY.SEARCH, name);
    }

    mergeCategory(id, cat) {
        return Http.put(API.CATEGORY.MERGE_CATEGORY.format(id), cat);
    }

    isUsingLegacy(){
        return Http.get(API.CATEGORY.IS_USING_LEGACY);
    }
}

export const categoryService = new CategoryService();