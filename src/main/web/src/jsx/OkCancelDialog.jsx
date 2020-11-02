import React from 'react';
import Dialog from "./Dialog.jsx";

export default class OkCancelDialog extends React.Component {

    render() {
        return <Dialog dismiss={this.props.dismiss} cancelText={'Cancel'} okText={'Ok'}
                       onOk={this.props.onOk}>
            <div style={{padding: '17px'}}> {this.props.children}</div>
        </Dialog>

    }
}