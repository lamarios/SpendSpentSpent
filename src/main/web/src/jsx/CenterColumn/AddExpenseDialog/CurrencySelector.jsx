import React from 'react';
import {currencyService} from "../../services/CurrencyService";

const CURRENCIES = [
    "AUD",
    "BGN",
    "BRL",
    "CAD",
    "CHF",
    "CNY",
    "CZK",
    "DKK",
    "EUR",
    "GBP",
    "HKD",
    "HRK",
    "HUF",
    "IDR",
    "ILS",
    "INR",
    "ISK",
    "JPY",
    "KRW",
    "MXN",
    "MYR",
    "NOK",
    "NZD",
    "PHP",
    "PLN",
    "RON",
    "RUB",
    "SEK",
    "SGD",
    "THB",
    "TRY",
    "USD",
    "ZAR"
]

export default class CurrencySelector extends React.Component {

    constructor(props) {
        super(props);

        this.state = {
            from: localStorage.getItem('fromCurrency') !== null ? localStorage.getItem("fromCurrency") : CURRENCIES[0],
            to: localStorage.getItem('toCurrency') !== null ? localStorage.getItem("toCurrency") : CURRENCIES[0],
            rate: 1,
            fetching: false
        }

        this.fromChanged = this.fromChanged.bind(this);
        this.toChanged = this.toChanged.bind(this);
        this.getRate = this.getRate.bind(this);

    }

    componentDidMount() {
        if (this.state.from.length > 0 && this.state.to.length > 0) {
            this.getRate();
        }
    }

    fromChanged(event) {
        let self = this;
        this.setState({from: event.target.value}, () => {
            localStorage.setItem("fromCurrency", this.state.from);
            self.getRate();
        });
    }

    toChanged(event) {
        let self = this;
        this.setState({to: event.target.value}, () => {
            localStorage.setItem("toCurrency", this.state.to);
            self.getRate();
        });
    }

    getRate() {
        this.setState({fetching: true}, () => {
            let self = this;
            /*
                        fetch('https://api.exchangeratesapi.io/latest?symbols=' + this.state.to + '&base=' + this.state.from)
                            .then((response) => response.json())
                            .then(json => {
                                let rate = json.rates[self.state.to];
                                self.setState({rate: rate, fetching: false}, () =>
                                    self.props.onChange(self.state.from, self.state.to, self.state.rate));
                            });
            */

            currencyService.get(this.state.from, this.state.to)
                .then(res => {
                    self.setState({rate: res, fetching: false}, () =>
                        self.props.onChange(self.state.from, self.state.to, self.state.rate));
                })

        });
    }

    render() {
        return (<div className={"CurrencySelector"}>
            <div className={'item'}>From:</div>
            <select className={'item'} value={this.state.from} onChange={this.fromChanged}>
                {CURRENCIES.map(c => (
                    <option key={c}>{c}</option>
                ))
                })
            </select>
            <div className={'item'}>To:</div>
            <select className={'item'} value={this.state.to} onChange={this.toChanged}>
                {CURRENCIES.map(c => (
                    <option key={c}> {c}</option>
                ))
                })
            </select>
            {this.state.fetching && <i className={'fa fa-refresh fa-spin'}/>}
        </div>);
    }
}