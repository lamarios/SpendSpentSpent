import React from 'react';
import CategoryList from './CategoryList.jsx';
import Switcher from "../Switcher.jsx";
import RecurringExpenseList from "./RecurringExpenseList.jsx";

export default class CenterColumn extends React.Component {

    constructor() {
        super();

        this.state = {
            displayLeft: true
        };

        this.showNormal = this.showNormal.bind(this);
        this.showRecurring = this.showRecurring.bind(this);
    }

    componentDidMount() {
    }

    /**
     * Show normal expenses
     */
    showNormal() {
        this.setState({displayLeft: true});
    }

    /**
     * Show recurring expenses
     */
    showRecurring() {
        this.setState({displayLeft: false});
    }

    render() {

        let items = [
            {label: 'Normal', onClick: this.showNormal},
            {label: 'Recurring', onClick: this.showRecurring}
        ];
        return (
            <div className="CenterColumn column">
                <Switcher items={items}/>
                {this.state.displayLeft ?
                    <CategoryList/>
                    :
                    <RecurringExpenseList/>
                }
            </div>
        );
    }
}
