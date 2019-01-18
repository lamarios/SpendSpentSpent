import React from 'react';
import {NavLink} from 'react-router-dom';
import MiscService from './services/MiscService';

export default class BottomBar extends React.Component {
    constructor(props) {
        super(props);
        this.state = {expanded: false, versions: {local: '', latest: ''}};

        this.miscService = new MiscService();
        this.hideSubLinks = this.hideSubLinks.bind(this);
        this.logout = this.logout.bind(this);
    }

    componentDidMount() {
        this.miscService.getVersion()
            .then(res => {
                this.setState({versions: res.data})
            });
    }

    hideSubLinks() {
        this.setState({expanded: false});
    }

    logout() {
        if (typeof window.localStorage !== undefined) {
            window.localStorage.removeItem('token');
        }

        location.href = window.origin;
    }


    render() {
        return (
            <div className={"BottomBar " + (this.state.expanded ? 'expanded' : '')}>
                <i onClick={() => this.setState({expanded: !this.state.expanded})}
                   className={'expand-button fa fa-chevron-down ' + (this.state.expanded ? 'expanded' : '')}/>
                <div className={'main-links'}>
                    <NavLink to="/graphs" onClick={this.hideSubLinks}>
                        <i className="fa fa-bar-chart" aria-hidden="true"/>
                    </NavLink>
                    <NavLink exact to="/" onClick={this.hideSubLinks}>
                        <i className="fa fa-square" aria-hidden="true"/>
                    </NavLink>
                    <NavLink to="/history" onClick={this.hideSubLinks}>
                        <i className="fa fa-bars" aria-hidden="true"/>
                    </NavLink>
                </div>
                <div className={'sub-links'}>
                    <NavLink to="/settings" onClick={this.hideSubLinks}>
                        <i className="fa fa-cog" aria-hidden="true"/>&nbsp; Settings
                    </NavLink>
                    <a onClick={this.logout}><i className={'fa fa-sign-out'}/> Logout</a>
                </div>
                <div className={'info'}>
                    SpendSpentSpent v{this.state.versions.local}
                    &nbsp;-&nbsp;
                    <a href="https://github.com/lamarios/SpendSpentSpent">Github</a> (v{this.state.versions.latest})
                </div>
            </div>
        );
    }
}

