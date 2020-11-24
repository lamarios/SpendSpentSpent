import React from 'react';
import Amount from "../Amount.jsx";
import ExpenseChart from './ExpenseChart.jsx';

export default class ExpenseBar extends React.Component {

    constructor(props) {
        super(props);
        this.state = {showChart: false};

        this.toggleChart = this.toggleChart.bind(this);
    }

    /**
     * Toggles the display of the chart
     */
    toggleChart() {
        this.setState({showChart: !this.state.showChart});
    }

    render() {
        let percentage = (this.props.expense.amount / this.props.expense.total) * 100;
        let style = {width: percentage + "%"};
        return <div className={'ExpenseBar scale-fade-in'}>
            <div className={'bar'} onClick={this.toggleChart}>
                <div className={'text'}>
                    <i className={this.props.expense.category.icon.categoryIcon()}/>
                    <p className={'amount'}>
                        <Amount>{this.props.expense.amount}</Amount>
                    </p>
                </div>
                {percentage > 5 && <div className={'percentage'} style={style}></div>}
            </div>

            {this.state.showChart === true &&
            <ExpenseChart category={this.props.expense.category} showMonthly={this.props.showMonthly}/>}
        </div>
    }
}