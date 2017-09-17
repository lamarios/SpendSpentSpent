import React from 'react';
import RecurringExpense from "./RecurringExpense.jsx";
import RecurringExpenseServices from "../services/RecurringExpenseServices.jsx";
import OkDialog from "../OkDialog.jsx";


export default class RecurringExpenseList extends React.Component {

    constructor(props) {
        super(props);

        this.state = {expenses: [], error: ''};

        this.recurringExpenseServices = new RecurringExpenseServices();
        this.deleteExpense = this.deleteExpense.bind(this);
        this.refreshList = this.refreshList.bind(this);
        this.dismissError = this.dismissError.bind(this);
    }

    componentDidMount() {
        this.refreshList();
    }

    refreshList() {
        this.recurringExpenseServices.getAll()
            .then(res => {
                this.setState({expenses: res.data});
            })
            .catch(err => {
                    this.setState({error: 'Error while retrieving recurrent expenses: ' + err});
                    console.error(err);
                }
            );
    }

    /**
     * Deletes a recurring expense
     * @param id
     */
    deleteExpense(id) {
        this.recurringExpenseServices.delete(id)
            .then(() => this.refreshList())
            .catch(err => {
                    this.setState({error: 'Error while deleting recurrent expense: ' + err});
                    console.error(err);
                }
            );

    }

    dismissError(e) {
        this.setState({error: ''});
    }


    render() {
        var animationLength = 0.5;
        var step = 0.5 / (this.state.expenses.length - 1);
        return <div className={'RecurringServices'}>
            {this.state.error.length > 0 &&
            <OkDialog dismiss={this.dismissError}>
                {this.state.error}
            </OkDialog>
            }
            {this.state.expenses.map(
                (expense) => {
                    var style = {animationDuration: animationLength + 's'};
                    console.log(style);
                    animationLength += step;
                    return <RecurringExpense
                        key={expense.id}
                        style={style}
                        expense={expense}
                        delete={this.deleteExpense}/>
                }
            )}
        </div>
    }
}