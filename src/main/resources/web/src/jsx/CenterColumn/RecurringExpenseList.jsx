import React from 'react';
import RecurringExpense from "./RecurringExpense.jsx";
import RecurringExpenseServices from "../services/RecurringExpenseServices.jsx";


export default class RecurringExpenseList extends React.Component {

    constructor(props) {
        super(props);

        this.state = {expenses: []};

        this.recurringExpenseServices = new RecurringExpenseServices();
    }

    componentDidMount() {
        this.recurringExpenseServices.getAll()
            .then(res => {
                this.setState({expenses: res.data});
            })
            .catch(err => {
                    alert('Error while retriving recurrent expenses: ' + err);
                    console.err(err);
                }
            );
    }

    render() {
        var animationLength = 0.5;
        var step = 0.5 / (this.state.expenses.length-1);
        return <div className={'RecurringServices'}>
            {this.state.expenses.map(
                (expense) => {
                    var style = {animationDuration: animationLength+'s'};
                    console.log(style);
                    animationLength += step;
                    return <RecurringExpense key={expense.id} style={style} expense={expense}/>
                }
            )}
        </div>
    }
}