import React from 'react';
import LoginService from './services/LoginServices.jsx'
import {NavLink} from "react-router-dom";
import {FormContainer} from "./components/containers";
import {miscService} from "./services/MiscService";

export default class Login extends React.Component {

    constructor(props) {
        super(props);
        this.loginService = new LoginService();
        this.state = {email: '', password: '', error: '', allowSignup: false, announcement: ''};

        this.emailChange = this.emailChange.bind(this);
        this.passwordChange = this.passwordChange.bind(this);
        this.login = this.login.bind(this);
    }

    componentDidMount() {
        miscService.getConfig()
            .then(res => {
                console.log('config:', res);
                this.setState({allowSignup: res.allowSignup, announcement: res.announcement});
            })
    }

    emailChange(e) {
        this.setState({email: e.target.value});
    }

    passwordChange(e) {
        this.setState({password: e.target.value});
    }

    login(e) {
        e.preventDefault();
        this.setState({error: ''});
        this.loginService.login(this.state.email, this.state.password)
            .then(function (res) {
                if (typeof res === 'string') {
                    localStorage.token = res;
                    location.href = window.origin;
                } else {
                    this.setState({error: 'Invalid email or password'});
                }
            }.bind(this))
            .catch(function (error) {
                this.setState({error: 'Invalid email or password'});
            }.bind(this));
        return false;
    }

    render() {
        return (<div className="Login scale-fade-in">
                <FormContainer>
                    <h1>SpendSpentSpent</h1>
                    <div>
                        <form onSubmit={this.login}>
                            {this.state.error.length > 0 &&
                            <p className="error">{this.state.error}</p>
                            }
                            <p>
                                <label htmlFor="login">Email</label>
                                <input type="text" id="email" onChange={this.emailChange} autoComplete="off"
                                       autoCorrect="off" autoCapitalize="off" spellCheck="false"/>
                            </p>
                            <p>
                                <label htmlFor="password">Password</label>
                                <input type="password" id="password" onChange={this.passwordChange}/>
                            </p>
                            <button>Login</button>
                        </form>
                        {this.state.allowSignup && <div className="signup-link">
                            or <NavLink to="/signup-screen">
                            Sign up
                        </NavLink>
                        </div>}
                    </div>
                </FormContainer>

                {this.state.announcement && this.state.announcement.length > 0 && <div className="announcement">
                    {this.state.announcement}
                </div>}
            </div>
        );
    }
}

