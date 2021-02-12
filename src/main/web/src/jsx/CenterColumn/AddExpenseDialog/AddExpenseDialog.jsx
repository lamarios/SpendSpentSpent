import React from 'react';
import DatePicker from 'react-datepicker';

// copied to vendor less folder as it somehow stopped working
// import 'react-datepicker/dist/react-datepicker.css';
import AmountKeyBoard from "./AmountKeyBoard.jsx";
import ExpenseService from "../../services/ExpenseService.jsx";
import Dialog from "../../Dialog.jsx";
import LoadingOverlay from "../../LoadingOverlay.jsx";
import CurrencySelector from './CurrencySelector.jsx';

export default class AddExpenseDialog extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            isCalendarOpen: false,
            date: Date.now(),
            amount: '',
            note: '',
            showNotes: false,
            showCurrencies: false,
            fromCurrency: undefined,
            toCurrency: undefined,
            currencyRate: 1,
            currencyOriginalAmount: '',
            location: null,
            refreshingLocation: false,
            loading: false,
            useLocation: (typeof localStorage !== undefined ? localStorage.useLocation === 'true' : false)
        };

        this.expenseService = new ExpenseService();

        this.toggleCalendar = this.toggleCalendar.bind(this);
        this.handleDateChange = this.handleDateChange.bind(this);
        this.addDigit = this.addDigit.bind(this);
        this.removeDigit = this.removeDigit.bind(this);
        this.refreshLocation = this.refreshLocation.bind(this);
        this.toggleLocation = this.toggleLocation.bind(this);
        this.addExpense = this.addExpense.bind(this);
        this.formatDate = this.formatDate.bind(this);
        this.currencyChanged = this.currencyChanged.bind(this);
        this.convertValue = this.convertValue.bind(this);
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
        if (typeof localStorage !== undefined) {
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
        e && e.preventDefault();
        this.setState({isCalendarOpen: !this.state.isCalendarOpen})
    }

    /**
     * Whenever the user selects a date
     * @param date
     */
    handleDateChange(date) {
        this.setState({date: date});
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
                }, (error) => {//Error
                    console.log('error', error);
                    this.setState({
                        location: null,
                        refreshingLocation: false
                    });
                });
            });
        }

    };

    convertValue(value) {
        let newAmount = value * this.state.currencyRate;
        return newAmount.toFixed(2);
    }

    /**
     * Adds a digit to the amount
     * @param digit
     */
    addDigit(digit) {
        let patt = new RegExp(/^[0-9]+(\.[0-9]{0,2})?$/);
        let convert = this.state.fromCurrency !== undefined && this.state.toCurrency !== undefined;

        if (convert) {
            let originAmount = this.state.currencyOriginalAmount + digit;
            let newAmount = this.convertValue(originAmount);
            if (patt.test(originAmount) && patt.test(newAmount)) {
                this.setState({amount: newAmount, currencyOriginalAmount: originAmount})
            }
        } else {
            let newAmount = this.state.amount + digit;
            if (patt.test(newAmount)) {
                this.setState({amount: newAmount})
            }
        }
    }

    /**
     * Removes a digit from the amount
     */
    removeDigit() {
        let convert = this.state.fromCurrency !== undefined && this.state.toCurrency !== undefined;
        if (convert) {
            let originAmount = this.state.currencyOriginalAmount.substring(0, this.state.currencyOriginalAmount.length - 1);
            let newAmount = this.convertValue(originAmount);
            if (newAmount == 0) {
                newAmount = '';
            }
            this.setState({amount: newAmount, currencyOriginalAmount: originAmount})
        } else {
            this.setState({amount: this.state.amount.substring(0, this.state.amount.length - 1)});
        }
    }

    /**
     * Format a javascript Date object t oyyyy-mm-dd
     * @param date
     * @return {string}
     */
    formatDate(date) {
        var d = new Date(date),
            month = '' + (d.getMonth() + 1),
            day = '' + d.getDate(),
            year = d.getFullYear();

        if (month.length < 2) month = '0' + month;
        if (day.length < 2) day = '0' + day;

        return [year, month, day].join('-');
    }

    /**
     * Creates the expense in the backend
     */
    addExpense() {
        if (this.state.amount.length > 0) {
            this.setState({loading: true});

            let expense = {
                amount: this.state.amount,
                category: {
                    id: this.props.category.id
                },
                income: false,
                type: 1,
                date: this.formatDate(this.state.date),
                note: this.state.note,
            };

            // adding currency conversion to note
            if (this.state.fromCurrency && this.state.fromCurrency !== '') {
                expense.note += ' (' + this.state.fromCurrency + ' ' + this.state.currencyOriginalAmount + ' -> ' + this.state.toCurrency + ')';
            }

            if (this.state.useLocation && this.state.location !== null) {
                expense.latitude = this.state.location.latitude;
                expense.longitude = this.state.location.longitude;
            }

            this.expenseService.add(expense)
                .then(res => {
                    this.props.refresh();
                    this.props.dismiss();

                })
                .catch(err => {
                    alert('Failed to add new expense: ' + err);
                    console.error(err);
                    this.setState({loading: false});
                })

        }
    }

    currencyChanged(from, to, rate) {
        this.setState({fromCurrency: from, toCurrency: to, currencyRate: rate}, () => {
            //if we already have value, we need to redo the convertion
            if (this.state.currencyOriginalAmount.length > 0) {
                this.addDigit('');
            }
        });
    }

    render() {
        return <Dialog dismiss={this.props.dismiss} cancelText={"Cancel"} okText={"Ok"} onOk={this.addExpense}>
            <div className={'AddExpenseDialog'}>
                {this.state.loading && <LoadingOverlay/>}

                <div className={'header'}>
                    <i className={this.props.category.icon.categoryIcon()}/>
                </div>
                <div className={'amount'}>
                    {this.state.fromCurrency !== undefined && this.state.toCurrency !== undefined &&
                    <span>{this.state.fromCurrency}</span>
                    }
                    {this.state.fromCurrency !== undefined && this.state.toCurrency !== undefined &&
                    <input value={this.state.currencyOriginalAmount} placeholder={'Amount'}
                           readOnly={true}/>
                    }
                    {this.state.fromCurrency !== undefined && this.state.toCurrency !== undefined &&
                    <span>{this.state.toCurrency}</span>
                    }
                    <input value={this.state.amount} placeholder={'Amount'}
                           readOnly={true}/>
                </div>
                <div className={'keypad'}>
                    <AmountKeyBoard onDigitClick={this.addDigit} onEraseDigitClick={this.removeDigit}/>
                </div>
                <div className={'options'}>
                    <div className={'option'}>
                        <button
                            className="date-button"
                            onClick={this.toggleCalendar}>
                            {this.formatDate(this.state.date)}
                        </button>
                    </div>
                    <div className={'option'}>
                        <i className={"fa fa-location-arrow "
                        + (this.state.useLocation ? 'enabled' : '')
                        + (this.state.refreshingLocation ? ' refreshing' : '')
                        + (this.state.location !== null ? ' active' : '')
                        }
                           aria-hidden="true"
                           onClick={this.toggleLocation}
                        />
                    </div>
                    <div className={'option'}>
                        <i className={"fa fa fa-pencil-square-o "
                        + (this.state.note.length > 0 ? 'enabled' : '')
                        } aria-hidden="true"
                           onClick={() => this.setState({showNotes: !this.state.showNotes, showCurrencies: false})}
                        />
                    </div>
                    <div className="option">
                        <div className={
                            (this.state.fromCurrency !== undefined && this.state.toCurrency !== undefined ? 'enabled' : '')
                        }>
                            <i className={"fa fa-usd "
                            }
                               onClick={() => this.setState({
                                   showNotes: false,
                                   showCurrencies: !this.state.showCurrencies
                               })}
                            />
                            {this.state.fromCurrency !== undefined && this.state.toCurrency !== undefined
                            && <span>{' '}{this.state.fromCurrency} <i
                                className={'fa fa-long-arrow-right'}/> {this.state.toCurrency}
                                <i className={'fa fa-times'}
                                   onClick={() => this.setState({
                                       fromCurrency: undefined,
                                       toCurrency: undefined,
                                       currencyRate: 1,
                                       showCurrencies: false
                                   })}/> </span>
                            }
                        </div>
                    </div>
                    {
                        this.state.isCalendarOpen && <div onClick={e => e.stopPropagation()}>
                            <DatePicker
                                selected={this.state.date}
                                onChange={this.handleDateChange}
                                withPortal
                                inline/>
                        </div>

                    }
                </div>
                {this.state.showCurrencies &&
                <CurrencySelector onChange={this.currencyChanged}/>}
                {this.state.showNotes && <div className={"notes"}>
                <textarea placeholder={"Something about this expense"}
                          value={this.state.note}
                          onChange={(e) => this.setState({note: e.target.value})}>
                </textarea>
                </div>}
            </div>
        </Dialog>
    }
}