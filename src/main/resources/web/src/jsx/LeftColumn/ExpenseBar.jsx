import React from 'react';
import Amount from "../Amount.jsx";


export default class ExpenseBar extends React.Component{



    render(){
        let percentage = (this.props.expense.amount / this.props.expense.total) * 100;
        let style = {width: percentage+"%"};
        return <div className={'ExpenseBar scale-fade-in'}>
            <div className={'percentage'} style={style}></div>
            <i className={'cat '+this.props.expense.category}/>
            <p className={'amount'}>
                <Amount>{this.props.expense.amount}</Amount>
            </p>
        </div>
    }
}