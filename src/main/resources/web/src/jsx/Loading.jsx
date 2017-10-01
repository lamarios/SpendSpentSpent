import React from 'react';

export default class Loading extends React.Component{


    render(){
       return <div className="sk-folding-cube loading-indicator Loading">
            <div className="sk-cube1 sk-cube"></div>
            <div className="sk-cube2 sk-cube"></div>
            <div className="sk-cube4 sk-cube"></div>
            <div className="sk-cube3 sk-cube"></div>
        </div>
    }
}