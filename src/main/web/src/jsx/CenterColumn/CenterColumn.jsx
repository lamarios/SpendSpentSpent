import React from 'react';
import CategoryList from './CategoryList.jsx';
import Switcher from "../Switcher.jsx";
import RecurringExpenseList from "./RecurringExpenseList.jsx";
import {categoryService} from "../services/CategoryServices";

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
        categoryService.isUsingLegacy()
            .then(r => {
                this.setState({isUsingLegacy: r})
            });
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
                {this.state.isUsingLegacy && <div className="legacy-alert">
                    You are currently using legacy category icons, those icons will be removed from the software on the
                    <b>June 1st 2021</b>.<br/>Please make sure to migrate the icons marked with an exclamation mark to the
                    new ones
                    by clicking on the <i className="fa fa-cog"/> icon then click on the category icon to update it.
                    <br/><br/>
                    You can request for new icons by <a target="_blank"
                                                        href="https://github.com/lamarios/SpendSpentSpent/issues">creating
                    a new issue on github</a>.
                </div>}
            </div>
        );
    }
}
