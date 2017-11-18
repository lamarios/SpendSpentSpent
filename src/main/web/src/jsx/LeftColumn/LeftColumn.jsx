import React from 'react';
import Switcher from "../Switcher.jsx";
import HistoryService from "../services/HistoryService.jsx";
import ExpenseBar from "./ExpenseBar.jsx";

class LeftColumn extends React.Component {

    constructor(props) {
        super(props);

        this.state = {showMonthly: true, data: []};

        this.showMonthly = this.showMonthly.bind(this);
        this.showYearly = this.showYearly.bind(this);
        this.historyService = new HistoryService();
    }

    componentDidMount() {
        this.showMonthly();
    }


    showMonthly() {
        this.setState({showMonthly: true, data:[]}, () => {
            this.historyService.getMonthly()
                .then(res => this.setState({data: res.data}));
        });

    }

    showYearly() {
        this.setState({showMonthly: false, data:[]}, () => {
            this.historyService.getYearly()
                .then(res => this.setState({data: res.data}));
        });

    }

    render() {
        let items = [
            {label: 'Monthly', onClick: this.showMonthly},
            {label: 'Yearly', onClick: this.showYearly}
        ];
        return <div className={'LeftColumn column'}>
            <Switcher items={items}/>

            {this.state.data.map((expense, index) => {

                return <ExpenseBar expense={expense} showMonthly={this.state.showMonthly}
                                   key={expense.category.id + '' + expense.total + this.state.showMonthly}/>
            })}

        </div>
    }
}

export default LeftColumn;
