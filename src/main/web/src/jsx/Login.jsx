import React from 'react';
import LoginService from './services/LoginServices.jsx'

export default class Login extends React.Component {

    constructor(props) {
        super(props);
        this.loginService = new LoginService();
        this.state = {username: '', password: '', error: ''}

        this.usernameChange = this.usernameChange.bind(this);
        this.passwordChange = this.passwordChange.bind(this);
        this.login = this.login.bind(this);
    }

    usernameChange(e) {
        this.setState({username: e.target.value});
    }

    passwordChange(e) {
        this.setState({password: e.target.value});
    }

    login(e) {
        e.preventDefault();
        this.setState({error: ''});
        this.loginService.login(this.state.username, this.state.password)
            .then(function (res) {
                console.log('login res', res);
                localStorage.token = res.data.token;
                location.href = window.origin;
            }.bind(this))
            .catch(function (error) {
                this.setState({error: 'Invalid username or password'});
            }.bind(this));
        return false;
    }

    render() {
        return (
            <div className="Login scale-fade-in">
                <h1>SpendSpentSpent</h1>
                <div>
                    <form onSubmit={this.login}>
                        {this.state.error.length > 0 &&
                        <p className="error">{this.state.error}</p>
                        }
                        <p>
                            <label htmlFor="#login">Username</label>
                            <input type="text" id="username" onChange={this.usernameChange}/>
                        </p>
                        <p>
                            <label htmlFor="#password">password</label>
                            <input type="password" id="password" onChange={this.passwordChange}/>
                        </p>
                        <button>Login</button>
                    </form>
                </div>
            </div>
        );
    }
}

