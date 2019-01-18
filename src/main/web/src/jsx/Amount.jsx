import React from 'react';
import NumberFormat from 'react-number-format';

export default class Amount extends React.Component {

    render() {
        return <NumberFormat value={this.props.children}
                             thousandSeparator={true}
                             displayType={'text'}
                             fixedDecimalScale={true}
                             decimalScale={2}
        />
    }
}