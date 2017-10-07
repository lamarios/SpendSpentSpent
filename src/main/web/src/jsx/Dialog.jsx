import React from 'react';
import Overlay from "./Overlay.jsx";

export default class Dialog extends React.Component {

    constructor(props) {
        super(props);

        this.stopPropagation = this.stopPropagation.bind(this);
        this.dismiss = this.dismiss.bind(this);
    }

    dismiss(e){
        e.stopPropagation();
        this.props.dismiss(e);
    }

    stopPropagation(e) {
        e.stopPropagation();
    }

    render() {
        return <Overlay dismiss={this.dismiss}>
            <div className={'Dialog'} onClick={this.stopPropagation}>
                <div className={'content'}>
                    {this.props.children}
                </div>
                <div className={"actions"}>
                    <a onClick={this.dismiss}>{this.props.cancelText}</a>
                    {this.props.onOk && this.props.okText &&
                    <a className={'ok'} onClick={this.props.onOk}>{this.props.okText}</a>
                    }
                </div>
            </div>
        </Overlay>
    }
}