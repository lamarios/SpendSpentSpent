import React from 'react';
import Dialog from "./Dialog.jsx";

export default class OkDialog extends React.Component {

    render() {
        return <Dialog dismiss={this.props.dismiss} cancelText={'Ok'}>
            <div style={{padding: '17px'}}> {this.props.children}</div>
        </Dialog>

    }
}