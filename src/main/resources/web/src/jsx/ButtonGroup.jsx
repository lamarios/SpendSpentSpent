import React from 'react';


export default class ButtonGroup extends React.Component {

    constructor(props) {
        super(props);
        this.onSelect = this.onSelect.bind(this);
        this.state = {selected: ''}
    }


    onSelect(item) {
        this.setState({selected: item.value});
        this.props.onSelect(item);
    }


    render() {
        return <ul className={'ButtonGroup'}>
            {this.props.list.map(
                item => <li key={item.value}
                            className={(this.state.selected === item.value ? 'selected' : '')}
                            onClick={()=> this.onSelect(item)}
                >
                    {item.label}
                </li>
            )}
        </ul>
    }
}