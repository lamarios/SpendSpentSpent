import React from 'react';
import HistoryService from "../services/HistoryService.jsx";
import Chartist from 'chartist';
import ChartistGraph from 'react-chartist';

export default class ExpenseChart extends React.Component {

    constructor(props) {
        super(props);


        this.state = {data: {}, count: 5};
        this.historyService = new HistoryService();

        this.refreshChart = this.refreshChart.bind(this);
        this.increaseCount = this.increaseCount.bind(this);
        this.decreaseCount = this.decreaseCount.bind(this);
    }

    componentDidMount() {
        this.refreshChart();
    }

    refreshChart() {
        let promise;

        if (this.props.showMonthly === true) {
            promise = this.historyService.getMonthlyGraphData(this.props.category.id, this.state.count);
        } else {
            promise = this.historyService.getYearlyGraphData(this.props.category.id, this.state.count);
        }

        promise.then(res => {
            let resData = res.data;
            let labels = [];
            let values = [];
            resData.forEach(d => {
                labels.unshift(d.date);
                values.unshift(d.amount);
            });

            this.setState({
                data: {
                    labels: labels,
                    series: [values],
                }
            });


        });

    }

    decreaseCount() {
        if (this.state.count > 2) {
            this.setState({count: this.state.count - 1}, () => this.refreshChart());
        }
    }

    increaseCount() {
        this.setState({count: this.state.count + 1}, ()=> this.refreshChart());
    }


    render() {
        let options = {
            width: '100%',
            height: '200px',
            low: 0,
            showArea: true,
            lineSmooth: Chartist.Interpolation.none(),
        };
        return <div className={'ExpenseChart fade-in'}>
            <ChartistGraph className={'ct-chart'} data={this.state.data} type={'Line'} options={options}/>
            <div className={'chart-controls'}>
                <button onClick={this.decreaseCount}><i className={'fa fa-minus'}/> </button>
                {this.state.count}
                {this.props.showMonthly?' Months': ' Years'}
                <button onClick={this.increaseCount}><i className={'fa fa-plus'} /></button>
            </div>
        </div>;
    }
}