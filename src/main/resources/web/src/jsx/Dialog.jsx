import React from 'react';
import Overlay from "./Overlay.jsx";

export default class Dialog extends React.Component {

    constructor(props){
        super(props);

        this.stopPropagation= this.stopPropagation.bind(this);
    }


    stopPropagation(e){
        e.stopPropagation();
    }

    render() {
        return <Overlay dismiss={this.props.dismiss}>
            <div className={'Dialog'} onClick={this.stopPropagation}>
                {this.props.children}
                <div className={"actions"}>
                    <a onClick={this.props.dismiss}>{this.props.cancelText}</a>
                    <a className={'ok'} onClick={this.props.onOk}>{this.props.okText}</a>
                </div>
            </div>
        </Overlay>
    }
}