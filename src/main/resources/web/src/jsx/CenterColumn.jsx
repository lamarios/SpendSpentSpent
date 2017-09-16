import React from 'react';
import CategoryList from './CategoryList.jsx';

export default class CenterColumn extends React.Component {

    constructor(){
        super();
    }

    componentDidMount() {
    }

    render() {
        return (
            <div className="CenterColumn">
                <CategoryList/>
            </div>
        );
    }
}
