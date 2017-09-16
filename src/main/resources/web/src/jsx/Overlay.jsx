import React from 'react';

export default class Overlay extends React.Component{


    render(){
        return <div className="Overlay" onClick={this.props.dismiss}>
            {this.props.children}
        </div>
    }
}