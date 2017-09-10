import React from 'react';
import {Link} from 'react-router-dom';

export default class BottomBar extends React.Component {
    render() {
        return (
            <div className="BottomBar">
                <div>
                    <ul>
                        <li><Link to="/graphs"><i className="fa fa-bar-chart" aria-hidden="true"></i></Link></li>
                        <li><Link to="/"><i className="fa fa-square" aria-hidden="true"></i></Link></li>
                        <li><Link to="/history"><i className="fa fa-bars" aria-hidden="true"></i></Link></li>
                    </ul>
                </div>
            </div>
        );
    }
}

