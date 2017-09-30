import React from 'react';


export default class Notification extends  React.Component{


    render(){
        return <div className={'Notification ' +(this.props.error?'error':'success')}>
            {this.props.children}
        </div>
    }
}