import React from 'react';
import {NavLink} from 'react-router-dom';

export default class BottomBar extends React.Component {
    render() {
        return (
            <div className="BottomBar">
                <div>
                    <NavLink to="/graphs"><i className="fa fa-bar-chart" aria-hidden="true"></i></NavLink>
                    <NavLink exact to="/"><i className="fa fa-square" aria-hidden="true"></i></NavLink>
                    <NavLink to="/history"><i className="fa fa-bars" aria-hidden="true"></i></NavLink>
                </div>
            </div>
        );
    }
}

