import React from 'react';


export default class RecurringExpense extends React.Component {

    constructor(props) {
        super(props);


        this.getFrequence = this.getFrequence.bind(this);
    }

    getFrequence(type) {
        switch(type){
            case 0:
                return 'Daily'
            case 1:
                return 'Weekly';
            case 2:
                return 'Monthly';
            case 3:
                return 'Yearly';
        }
    }

    render() {
        return <div className={'RecurringExpense'}>
            <div className={'bar'} style={this.props.style}>
                <div className={'frequence'}>
                    {this.getFrequence(this.props.expense.type)}
                </div>
                <div className={'icon'}>
                    <i className={'cat ' + this.props.expense.category.icon}></i>
                </div>
                <div className={'amount'}>
                    {this.props.expense.amount}
                </div>
            </div>
        </div>
    }
}