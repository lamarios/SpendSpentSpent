import React, {useEffect, useState} from 'react';
import {FormContainer} from "./components/containers";
import {miscService} from "./services/MiscService";

const ResetPassword = (props) => {

    const [resetId, setResetId] = useState(null);
    const [requestSent, setRequestSent] = useState(false);
    const [email, setEmail] = useState('');
    const [user, setUser] = useState({
        password: '',
        repeatPassword: '',
    });
    const [error, setError] = useState('');

    useEffect(() => {
        const urlParams = new URLSearchParams(window.location.search);
        setResetId(urlParams.get('reset-id'));
    }, [])

    const sendRequest = async (e) => {
        e.preventDefault();
        await miscService.resetPasswordRequest(email);

        setRequestSent(true);
        return false;
    }

    const resetPassword = async (e) => {
        e.preventDefault();

        if (!user.password || user.password.trim().length === 0) {
            setError("Password is empty");
            return false;
        }
        try {
            const result = await miscService.resetPassword({
                resetId: resetId,
                newPassword: user.password,
            });

            if (result) {
                setRequestSent(true);
                setTimeout(() => location.href = location.href.replace('/reset-password', '/login-screen'), 3000);
            }
        } catch (e) {
            const error = JSON.parse(e.message);
            setError(error.text);
        }
        return false;
    }
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

        setUser(userMod);
    }
    return <div className="ResetPassword scale-fade-in">
        <FormContainer>
            <h1>Reset password</h1>
            {!resetId && <form onSubmit={sendRequest}>
                {requestSent &&
                <p className="success">Request sent successfully, you'll receive an email with the
                    instructions shortly.</p>}
                <p>
                    <label htmlFor="login">Email</label>
                    <input type="text" id="email" onChange={e => setEmail(e.target.value)} autoComplete="off"
                           autoCorrect="off" autoCapitalize="off" spellCheck="false"/>
                </p>
                <button>Send request</button>
            </form>}
            {resetId && <form onSubmit={resetPassword}>
                {error.length > 0 &&
                <p className="error">{error}</p>
                }
                {requestSent &&
                <p className="success">Password reset successfully, you'll be redirected to the login page</p>}
                <p>
                    <label htmlFor="password">Password</label>
                    <input type="password" id="password" onChange={e => setField('password', e)}/>
                </p>
                <p>
                    <label htmlFor="repeatPassword">Repeat password</label>
                    <input type="password" id="repeatPassword" onChange={e => setField('repeatPassword', e)}/>
                </p>
                <button>Reset password</button>
            </form>}
        </FormContainer>
    </div>
}

export default ResetPassword;