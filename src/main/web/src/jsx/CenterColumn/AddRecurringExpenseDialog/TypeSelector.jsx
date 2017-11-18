import React from 'react';
import ButtonGroup from "../../ButtonGroup.jsx";

export default class TypeSelector extends React.Component {
    constructor(props) {
        super(props);

        this.state = {
            type: 0,
            typeParam: 0,
        };

        this.onTypeChange = this.onTypeChange.bind(this);
    }


    onTypeChange(type) {
        this.props.onTypeChange(type);
    }


    onTypeParamChange(param) {
        this.props.onTypeParamChange(param);
    }

    render() {

        let list = [
            {label: 'Daily', value: 0},
            {label: 'Weekly', value: 1},
            {label: 'Monthly', value: 2},
            {label: 'Yearly', value: 3},
        ];

        let weekDays = [
            {label: 'Monday', value: 2},
            {label: 'Tuesday', value: 3},
            {label: 'Wednesday', value: 4},
            {label: 'Thursday', value: 5},
            {label: 'Friday', value: 6},
            {label: 'Saturday', value: 7},
            {label: 'Sunday', value: 1},
        ];

        let days = [];

        for (let i = 1; i <= 28; i++) {
            days.push({label: i, value: i});
        }


        let month = [
            {label: 'January', value: 0},
            {label: 'February', value: 1},
            {label: 'March', value: 2},
            {label: 'April', value: 3},
            {label: 'May', value: 4},
            {label: 'June', value: 5},
            {label: 'July', value: 6},
            {label: 'August', value: 7},
            {label: 'September', value: 8},
            {label: 'October', value: 9},
            {label: 'November', value: 10},
            {label: 'December', value: 11},

        ];

        return <div>
            <ButtonGroup list={list} onSelect={(item) => {
                this.setState({type: item.value});
                this.onTypeChange(item.value)
            }}/>
            {this.state.type === 1 && <ButtonGroup list={weekDays} onSelect={(item) => {
                this.setState({typeParam: item.value});
                this.onTypeParamChange(item.value)
            }}/>}
            {this.state.type === 2 && <ButtonGroup list={days} onSelect={(item) => {
                this.setState({typeParam: item.value});
                this.onTypeParamChange(item.value)
            }}/>}
            {this.state.type === 3 && <ButtonGroup list={month} onSelect={(item) => {
                this.setState({typeParam: item.value});
                this.onTypeParamChange(item.value)
            }}/>}

        </div>
    }
}