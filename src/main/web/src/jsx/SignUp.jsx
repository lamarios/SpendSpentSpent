import React, {useState} from 'react';
import {FormContainer} from "./components/containers";
import {loginService} from "./services/LoginServices";

export const EMAIL_PATTERN = /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/g;

const SignUp = (props) => {
    const [user, setUser] = useState({
        firstName: '',
        lastName: '',
        email: '',
        password: '',
        repeatPassword: '',
    });

    const [error, setError] = useState('');

    const setField = (field, event) => {
        const userMod = user;
        userMod[field] = event.target.value;
        setError('');

        if (field === 'password' || field === 'repeatPassword') {
            if (userMod.password !== userMod.repeatPassword) {
                setError('Passwords don\'t match');
            } else {
                setError('');
            }
        }

        if (field === 'email') {
            if (!userMod.email.match(EMAIL_PATTERN)) {
                setError('Not a valid email');
            } else {
                setError('');
            }
        }

        setUser(userMod);
    }

    const signUp = async (e) => {
        e.preventDefault();
        console.log(user);

        if (user.email.length === 0
            || user.password.length === 0
            || user.repeatPassword.length === 0
            || user.firstName.length === 0
            || user.lastName.length === 0) {
            setError("Please fill all the fields");
            return false;
        }

        if (user.password !== user.repeatPassword) {
            setError('Passwords don\'t match');
            return false;
        }

        if (!user.email.match(EMAIL_PATTERN)) {
            setError('Not a valid email');
            return false;
        }
        try {
            const token = await loginService.signUp(user);
            localStorage.token = token;
            location.href = window.origin;
        } catch (e) {
            const error = JSON.parse(e.message);
            setError(error.text);
        }

        return false;
    }

    return (<div className="SignUp scale-fade-in">
            <FormContainer>
                <h1>Sign up</h1>
                <div>
                    <form onSubmit={signUp}>
                        {error.length > 0 &&
                        <p className="error">{error}</p>
                        }
                        <p>
                            <label htmlFor="email">Email</label>
                            <input type="text" id="email" onChange={e => setField('email', e)} autoComplete="off"
                                   autoCorrect="off" autoCapitalize="off" spellCheck="false"/>
                        </p>
                        <p>
                            <label htmlFor="password">Password</label>
                            <input type="password" id="password" onChange={e => setField('password', e)}/>
                        </p>
                        <p>
                            <label htmlFor="repeatPassword">Repeat password</label>
                            <input type="password" id="repeatPassword" onChange={e => setField('repeatPassword', e)}/>
                        </p>
                        <p>
                            <label htmlFor="firstName">First Name</label>
                            <input type="text" id="firstName" onChange={e => setField('firstName', e)}
                                   autoComplete="off"
                                   autoCorrect="off" autoCapitalize="off" spellCheck="false"/>
                        </p>
                        <p>
                            <label htmlFor="lastName">Last Name</label>
                            <input type="text" id="lastName" onChange={e => setField('lastName', e)} autoComplete="off"
                                   autoCorrect="off" autoCapitalize="off" spellCheck="false"/>
                        </p>
                        <button disabled={(error.length > 0)}>Submit</button>
                    </form>
                </div>
            </FormContainer>
        </div>
    );
}

export default SignUp;