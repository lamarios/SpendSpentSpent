import React from 'react';
import ExpenseService from "../services/ExpenseService.jsx";
import DayExpenses from "./DayExpenses.jsx";
import Amount from "../Amount.jsx";
import moment from 'moment';

export default class RightColumn extends React.Component {

    constructor(props) {
        super(props);
        this.expenseService = new ExpenseService();

        this.state = {
            months: [],
            total: 0,
            selectedMonth: '',
            expenses: {},
            apiMonthOver: false,
            apiExpenseOver: false,
        };

        this.refreshMonths = this.refreshMonths.bind(this);
        this.refreshExpenses = this.refreshExpenses.bind(this);
        this.getMonthTotal = this.getMonthTotal.bind(this);
        this.handleMonthChange = this.handleMonthChange.bind(this);
        this.deleteExpense = this.deleteExpense.bind(this);
    }

    componentDidMount() {
        this.refreshMonths();
    }

    /**
     * Get the list of available months
     */
    refreshMonths() {
        this.expenseService.getMonths()
            .then(res => {
                let selectedMonth = res.length > 0 ? res[res.length - 1] : '';
                this.setState({
                        months: res,
                        apiMonthOver: true,
                        selectedMonth: selectedMonth,
                    },
                    () => {
                        this.refreshExpenses();
                    }
                );
            });
    }

    /**
     * Refresh the list of expenses for the selected month
     */
    refreshExpenses() {
        if (this.state.selectedMonth !== '') {
            this.expenseService.getByDay(this.state.selectedMonth)
                .then(expenses => {
                    this.setState({expenses: expenses, apiExpenseOver: true}, () => {
                        this.getMonthTotal(expenses);
                    });
                });
        }
    }

    /**
     * Calculate the selected month total expenses
     */
    getMonthTotal() {
        let total = 0;
        Object.keys(this.state.expenses).map(day => {
            total += this.state.expenses[day].total;
        });

        this.setState({total: total});
    }

    /**
     * Handles month change from the select drop down
     */
    handleMonthChange(e) {
        this.setState({selectedMonth: e.target.value, expenses: {}}, () => {
            this.refreshExpenses();
        });
    }

    deleteExpense(id) {
        this.expenseService.delete(id)
            .then(res => this.refreshExpenses());
    }

    render() {

        return <div className={'RightColumn column'}>
            {(this.state.apiMonthOver === true && this.state.months.length === 0) &&
            <p>Nothing to show, go back to the <i className={'fa fa-square'}/> screen to add expenses, then it will
                appear here. </p>
            }

            {this.state.months.length > 0 &&
            <div className={'month-select slide-in-top'}>
                <select value={this.state.selectedMonth} onChange={this.handleMonthChange}>
                    {this.state.months.map(month => <option key={month}
                                                            value={month}>{moment(month, 'YYYY-MM').format('MMMM YYYY')}</option>)}
                </select>
            </div>
            }

            {this.state.months.length > 0 &&
            <p className={'total fade-in'}>Total: <span className={'amount'}>
                    <Amount>{this.state.total}</Amount>
                </span>
            </p>
            }


            {this.state.apiExpenseOver === true && Object.keys(this.state.expenses).length === 0 &&
            <p>Nothing to show, go back to the <i className={'fa fa-square'}/> screen to add expenses, then it will
                appear here. </p>
            }

            {Object.keys(this.state.expenses).length > 0 &&
            Object.keys(this.state.expenses).map((day, index) => {
                let style = {animationDuration: '0.5s'};
                return <div className={'scale-fade-in'} style={style} key={day}><DayExpenses
                    onDelete={this.deleteExpense}
                    day={this.state.expenses[day]}/></div>
            })}


        </div>;
    }
}
