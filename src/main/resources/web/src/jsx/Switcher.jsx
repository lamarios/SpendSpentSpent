import React from 'react';


export default class Switcher extends React.Component {
    constructor(props) {
        super(props);

        this.state = {selected: this.props.items[0].label}

        this.switchItem = this.switchItem.bind(this);
    }

    switchItem(item) {
        item.onClick();
        this.setState({selected: item.label});
    }

    render() {
        var style = {
            width: (100 / this.props.items.length) + '%'
        }
        return <div className={'Switcher slide-in-top'}>
            {this.props.items.map((item) => {
                return <div key={item.label} style={style}
                            className={'item ' + (this.state.selected === item.label?'selected':'')}
                            onClick={() => this.switchItem(item)}
                >
                    {item.label}
                </div>
            })}
        </div>
    }
}