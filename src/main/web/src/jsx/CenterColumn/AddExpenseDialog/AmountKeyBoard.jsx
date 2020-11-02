import React from 'react';

export default class AmountKeyBoard extends React.Component {

    constructor(props) {
        super(props);
    }

    render() {
        return <div className={'AmountKeyBoard'}>
            <div className={'digit'}>
                <div onClick={() => this.props.onDigitClick(1)}>1</div>
                <div onClick={() => this.props.onDigitClick(2)}>2</div>
                <div onClick={() => this.props.onDigitClick(3)}>3</div>
            </div>
            <div className={'digit'}>
                <div onClick={() => this.props.onDigitClick(4)}>4</div>
                <div onClick={() => this.props.onDigitClick(5)}>5</div>
                <div onClick={() => this.props.onDigitClick(6)}>6</div>
            </div>
            <div className={'digit'}>
                <div onClick={() => this.props.onDigitClick(7)}>7</div>
                <div onClick={() => this.props.onDigitClick(8)}>8</div>
                <div onClick={() => this.props.onDigitClick(9)}>9</div>
            </div>
            <div className={'digit'}>
                <div onClick={() => this.props.onDigitClick('.')}>.</div>
                <div onClick={() => this.props.onDigitClick(0)}>0</div>
                <div onClick={() => this.props.onEraseDigitClick()}>
                    <i className="fa fa-arrow-left" aria-hidden="true"/>
                </div>
            </div>

        </div>
    }
}