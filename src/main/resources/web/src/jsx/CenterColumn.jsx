import React from 'react';
import CategoryService from '../services/CategoryServices.jsx';

class CenterColumn extends React.Component {

    constructor(){
        super();
        this.categoryService= new CategoryService();
    }

    componentDidMount() {
        this.categoryService.getAll()
            .then(res =>  console.log(res))
            .catch(err => console.log('Hello', err))

        this.categoryService.get(321);

    }

    render() {
        return <p> cent @#!@#!#!@#er</p>;
    }
}

export default CenterColumn;