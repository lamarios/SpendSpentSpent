import React from 'react';
import DatePicker from 'react-datepicker';
import moment from 'moment';

import 'react-datepicker/dist/react-datepicker.css';
import AmountKeyBoard from "./AmountKeyBoard.jsx";
import ExpenseService from "../../services/ExpenseService.jsx";
import Dialog from "../../Dialog.jsx";
import LoadingOverlay from "../../LoadingOverlay.jsx";


export default class AddExpenseDialog extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            isCalendarOpen: false,
            date: moment(),
            amount: '',
            location: null,
            refreshingLocation: false,
            loading: false,
            useLocation: (typeof localStorage !== undefined ? localStorage.useLocation === 'true' : false)
        }

        this.expenseService = new ExpenseService();

        this.toggleCalendar = this.toggleCalendar.bind(this);
        this.handleDateChange = this.handleDateChange.bind(this);
        this.addDigit = this.addDigit.bind(this);
        this.removeDigit = this.removeDigit.bind(this);
        this.refreshLocation = this.refreshLocation.bind(this);
        this.toggleLocation = this.toggleLocation.bind(this);
        this.addExpense = this.addExpense.bind(this);
    }


    componentDidMount() {
        if (this.state.useLocation) {
            this.refreshLocation();
        }
    }

    /**
     * toggle the use of location.
     */
    toggleLocation() {
        if (typeof  localStorage !== undefined) {
            this.setState({useLocation: !this.state.useLocation}, () => {
                localStorage.useLocation = this.state.useLocation;
                if (this.state.useLocation) {
                    this.refreshLocation();
                } else {
                    this.setState({location: null});
                }
            });
        }
    }

    /**
     * Shows the calendar date selector
     * @param e
     */
    toggleCalendar(e) {
        e && e.preventDefault()
        this.setState({isCalendarOpen: !this.state.isCalendarOpen})
    }

    /**
     * Whenever the user selects a date
     * @param date
     */
    handleDateChange(date) {
        this.setState({date: date})
        this.toggleCalendar()
    }

    /**
     * Refreshes the location if necessary
     */
    refreshLocation() {

        if (navigator.geolocation) {
            this.setState({refreshingLocation: true}, () => {
                navigator.geolocation.getCurrentPosition((position) => {
                    this.setState({
                        location: position.coords,
                        refreshingLocation: false
                    });
                }, () => {//Error
                    this.setState({
                        location: null,
                        refreshingLocation: false
                    });
                });
            });
        }

    };

    /**
     * Adds a digit to the amount
     * @param digit
     */
    addDigit(digit) {
        var newAmount = this.state.amount + digit;

        var patt = new RegExp(/^[0-9]+(\.[0-9]{0,2})?$/);

        if (patt.test(newAmount)) {
            this.setState({amount: newAmount})
        }
    }

    /**
     * Removes a digit from the amount
     */
    removeDigit() {
        this.setState({amount: this.state.amount.substring(0, this.state.amount.length - 1)});
    }


    /**
     * Creates the expense in the backend
     */
    addExpense() {
        if (this.state.amount.length > 0) {
            this.setState({loading: true});

            var expense = {
                amount: this.state.amount,
                category: this.props.category.id,
                income: false,
                type: 1,
            }

            if (this.state.useLocation && this.state.location !== null) {
                expense.latitude = this.state.location.latitude;
                expense.longitude = this.state.location.longitude;
            }

            console.log('New expense', expense);
            this.expenseService.add(expense)
                .then(res => {
                    this.props.dismiss();

                })
                .catch(err => {
                    alert('Failed to add new expense: ' + err);
                    console.error(err);
                    this.setState({loading: false});
                })

        }
    }

    render() {
        return <Dialog dismiss={this.props.dismiss} cancelText={"Cancel"} okText={"Ok"} onOk={this.addExpense}>
            <div className={'AddExpenseDialog'}>
                {this.state.loading && <LoadingOverlay/>}

                <div className={'header'}>
                    <i className={'cat ' + this.props.category.icon}/>
                </div>
                <div className={'amount'}>
                    <input value={this.state.amount} placeholder={'Amount'}
                           readOnly={"true"}/>
                </div>
                <div className={'keypad'}>
                    <AmountKeyBoard onDigitClick={this.addDigit} onEraseDigitClick={this.removeDigit}/>
                </div>
                <div className={'options'}>
                    <button
                        className="date-button"
                        onClick={this.toggleCalendar}>
                        {this.state.date.format("DD/MM/YYYY")}
                    </button>
                    <i className={"fa fa-location-arrow "
                    + (this.state.useLocation ? 'enabled' : '')
                    + (this.state.refreshingLocation ? ' refreshing' : '')
                    + (this.state.location !== null ? ' active' : '')
                    }
                       aria-hidden="true"
                       onClick={this.toggleLocation}
                    />
                    {
                        this.state.isCalendarOpen && (
                            <DatePicker
                                selected={this.state.date}
                                onChange={this.handleDateChange}
                                withPortal
                                inline/>
                        )
                    }
                </div>
            </div>
        </Dialog>
    }
}