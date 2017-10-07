import React from 'react';
import Expense from "./Expense.jsx";
import moment from 'moment';
import Amount from "../Amount.jsx";

export default class DayExpenses extends React.Component {
    constructor(props) {
        super(props);
        this.state= {date: moment()};
    }

    componentDidMount() {
        this.setState({date: moment(this.props.day.date, 'YYYY-MM-DD')});
    }

    render() {
        return <div className={'DayExpense'}>
            <p className={'date'}>{this.state.date.format('MMMM Do YYYY')}</p>
            <div className={'expenses'}>
                {this.props.day.expenses.map(expense => <Expense onDelete={this.props.onDelete} key={expense.id} expense={expense}/>)}
            </div>
            <p className={'total'}>Total: <span className={'amount'}><Amount>{this.props.day.outcome}</Amount></span></p>
        </div>
    }
}