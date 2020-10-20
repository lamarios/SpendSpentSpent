import React, {useContext, useState} from 'react';
import {FormContainer} from "./components/containers";
import {loginService} from "./services/LoginServices";
import {userService} from "./services/UserService";
import {UserDispatch} from "./App";

const EditProfile = (props) => {

    const [user, setUser] = useState(loginService.getCurrentUser());
    const [error, setError] = useState("");
    const [success, setSuccess] = useState(false);
    const dispatch = useContext(UserDispatch);

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

        setSuccess(false);

        setUser(userMod);
    }

    const submitForm = (event) => {
        event.preventDefault();
        if (!user.firstName || user.firstName.length === 0 || !user.lastName || user.lastName.length === 0) {
            setError("First name and last name can't be empty");
            return false;
        }
        try {
            userService.editProfile(user).then(res => {
                // we should get a new user token
                localStorage.setItem("token", res);
                // window.location.href = window.location.href + "?success=true";
                dispatch(loginService.getCurrentUser());
                setSuccess(true);
            })
        } catch (e) {
            const error = JSON.parse(e.message);
            setError(error.text);
        }
        return false;

    }


    return <div className="EditProfile scale-fade-in">
        <FormContainer>
            <form onSubmit={submitForm}>
                <h1>Edit profile</h1>
                {error.length > 0 &&
                <p className="error">{error}</p>
                }

                {success && <p className="success">Profile saved successfully !</p>}
                <p>
                    <label htmlFor="firstName">First Name</label>
                    <input type="text" id="firstName" onChange={e => setField('firstName', e)}
                           defaultValue={user.firstName}
                           autoComplete="off"
                           autoCorrect="off" autoCapitalize="off" spellCheck="false"/>
                </p>
                <p>
                    <label htmlFor="lastName">Last Name</label>
                    <input type="text" id="lastName" onChange={e => setField('lastName', e)} autoComplete="off"
                           defaultValue={user.lastName}
                           autoCorrect="off" autoCapitalize="off" spellCheck="false"/>
                </p>

                <p>
                    To update your password fill up the fields, to keep your current password leave them empty.
                </p>
                <p>
                    <label htmlFor="password">Password</label>
                    <input type="password" id="password" onChange={e => setField('password', e)}/>
                </p>
                <p>
                    <label htmlFor="repeatPassword">Repeat password</label>
                    <input type="password" id="repeatPassword" onChange={e => setField('repeatPassword', e)}/>
                </p>
                <button disabled={(error.length > 0)}>Submit</button>
            </form>
        </FormContainer>
    </div>
}

export default EditProfile;