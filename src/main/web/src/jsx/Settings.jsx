import React, {useEffect, useState} from 'react';
import {userService} from "./services/UserService";
import {loginService} from "./services/LoginServices";
import {EMAIL_PATTERN} from "./SignUp";
import OkCancelDialog from "./OkCancelDialog";
import OkDialog from "./OkDialog";
import Notification from "./Notification";
import moment from 'moment';
import {miscService} from "./services/MiscService";
import Pagination from "./components/Pagination";
import SingleSetting from "./components/SingleSetting";

const LONG_MAX = 9223372036854776000;

const Settings = (props) => {
    const [tab, setTab] = useState('users');
    const [showErrorDialog, setShowErrorDialog] = useState(false);
    const [errorMessage, setErrorMessage] = useState('');
    const [notificationTimeout, setNotificationTimeout] = useState(null);
    const [showNotification, setShowNotification] = useState(false);
    const [notificationMessage, setNotificationMessage] = useState('');
    const [users, setUsers] = useState();
    const [editPasswordOf, setEditPasswordOf] = useState(null);
    const [newPassword, setNewPassword] = useState('');
    const [newUser, setNewUser] = useState(null);
    const [newUserError, setNewUserError] = useState(null);
    const [hasSubscription, setHasSubscription] = useState(false);
    const [userPage, setUserPage] = useState(0);
    const [userPageSize, setUserPageSize] = useState(20);
    const [userSearch, setUserSearch] = useState("");
    const [searchDebounce, setSearchDebounce] = useState();

    const refreshUsers = () => {
        console.log("searching users");
        userService.getUsers(userSearch, userPage, userPageSize)
            .then(u => setUsers(u));
    }

    useEffect(() => {
        miscService.getConfig()
            .then(r => setHasSubscription(r.hasSubscription));
    }, []);

    useEffect(() => {
        if (searchDebounce) {
            clearTimeout(searchDebounce);
        }
        let timeout = setTimeout(refreshUsers, 300);
        setSearchDebounce(timeout);
    }, [userSearch, userPage]);

    const showNotificationPopUp = (message) => {
        clearTimeout(notificationTimeout);

        setNotificationMessage(message);
        setNotificationTimeout(setTimeout(() => setShowNotification(false), 3000))
        setShowNotification(true);
    }

    const toggleAdmin = (user) => {
        userService.setAdmin(user.id, !user.isAdmin)
            .then(r => {
                showNotificationPopUp(user.firstName + " " + user.lastName + " updated");
                refreshUsers();
            })
    }

    const randomPassword = (length) => {
        var result = '';
        var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        var charactersLength = characters.length;
        for (var i = 0; i < length; i++) {
            result += characters.charAt(Math.floor(Math.random() * charactersLength));
        }
        return result;
    }

    const updateUserPassword = () => {
        if (newPassword.trim().length === 0) {
            return false;
        }

        userService.setPassword(editPasswordOf.id, newPassword)
            .then(r => {
                showNotificationPopUp(editPasswordOf.firstName + " " + editPasswordOf.lastName + " updated");
                setNewPassword("");
                setEditPasswordOf(null);
            })
    }

    const setNewUserField = (field, value) => {
        const user = {};
        user[field] = value;
        setNewUserError(null);

        if (field === 'email' && !value.match(EMAIL_PATTERN)) {
            setNewUserError("Invalid email");
        }

        setNewUser({...newUser, ...user});
    }

    const saveNewUser = () => {
        if (!newUser.password || newUser.password.length === 0
            || !newUser.email || newUser.email.length === 0
            || !newUser.firstName || newUser.firstName.length === 0
            || !newUser.lastName || newUser.lastName.length === 0
        ) {
            setNewUserError("Please fill all the fields")
            return false;
        }

        if (!newUser.email.match(EMAIL_PATTERN)) {
            setNewUserError("Invalid email");
            return false;
        }

        userService.createUser(newUser)
            .then(res => {
                setNewUser(null);
                showNotificationPopUp("New user added !");
                refreshUsers();
            }).catch(e => {
            console.log('Error while creating new user', e);
            const error = JSON.parse(e.message);
            setNewUserError(error.text);
        });

        return true;
    }

    const deleteUser = (user) => {
        if (confirm("Delete user ? This will delete all his/her categories  and expenses ?")) {
            userService.deleteUser(user.id)
                .then(res => {
                    refreshUsers();
                    showNotificationPopUp(user.firstName + " " + user.lastName + " delete.");
                }).catch(e => {
                const error = JSON.parse(e.message);
                setErrorMessage(error.text);
                setShowErrorDialog(true);

            })
        }
    }

    const searchUsers = (e) => {
        setUserPage(0);
        setUserSearch(e.target.value);
    }

    return <div className={'Settings scale-fade-in'}>
        <h1> Settings </h1>
        <ul className={'tabs'}>
            <li onClick={() => setTab('users')}
                className={tab === 'users' ? 'active' : ''}>Users
            </li>
            <li onClick={() => setTab('settings')}
                className={tab === 'settings' ? 'active' : ''}>Settings
            </li>
            {/*
            <li onClick={() => setTab('settings')}
                className={tab === 'settings' ? 'active' : ''}>Other settings
            </li>
*/}
        </ul>

        {tab === 'users' && <div className={'tab-content scale-fade-in'}>
            <input type="text" placeholder="Search" value={userSearch} onChange={searchUsers}/>
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Email</th>
                    <th>Name</th>
                    {hasSubscription && <th>Account expiry</th>}
                    <th>Admin</th>
                    <th>Change password</th>
                    <th>Delete user</th>
                </tr>
                </thead>
                <tbody>
                {users && users.data && users.data.map(u => <tr key={u.id}>
                    <td>{u.id}</td>
                    <td>{u.email}</td>
                    <td>{u.firstName + " " + u.lastName}</td>
                    {hasSubscription &&
                    <td>{u.subscriptionExpiryDate === LONG_MAX || u.subscriptionExpiryDate === 0 ? 'Never' : moment(u.subscriptionExpiryDate).format('MMMM Do YYYY')}</td>}
                    <td className="action"><input type="checkbox" checked={u.isAdmin}
                                                  disabled={u.id === loginService.getCurrentUser().id}
                                                  onChange={() => toggleAdmin(u)}/></td>
                    <td className="action"><i className="fa fa-key" onClick={e => setEditPasswordOf(u)}/></td>
                    <td className="action">{u.id !== loginService.getCurrentUser().id &&
                    <i className="fa fa-times" onClick={e => deleteUser(u)}/>}</td>
                </tr>)}
                {!users || !users.data || users.data.length === 0 &&
                <tr>
                    <td colSpan={hasSubscription ? 7 : 6}>No users matching criteria</td>
                </tr>}
                </tbody>
            </table>
            {users && users.pagination &&
            <Pagination pagination={users.pagination} setPage={(i) => setUserPage(i)}></Pagination>}
            <div>
                <button onClick={e => setNewUser({})}>
                    <i className="fa fa-plus"/> Add new user
                </button>
            </div>
        </div>
        }

        {tab === 'settings' && <div className={'tab-content scale-fade-in'}>
            <SingleSetting name="currencyApiKey" title="Currency converter API key" secret={true}>
                API key from <a href="https://freecurrencyapi.net" target="_blank">freecurrencyapi</a>.
            </SingleSetting>
        </div>
        }

        {showErrorDialog === true &&
        <OkDialog dismiss={() => setShowErrorDialog(false)}>{errorMessage}</OkDialog>}

        {showNotification === true && <Notification>
            {notificationMessage}
        </Notification>}

        {editPasswordOf && <OkCancelDialog onOk={updateUserPassword} dismiss={() => {
            setEditPasswordOf(null);
            setNewPassword("")
        }}>
            <h2>Change {editPasswordOf.firstName + " " + editPasswordOf.lastName}'s password</h2>
            <div className="setting-input">
                <label htmlFor="newPassword">New Password</label>
                <input id="newPassword" type="text" value={newPassword}
                       onChange={e => setNewPassword(e.target.value)}/>
            </div>
            <button className="random-password" onClick={() => setNewPassword(randomPassword(16))}>
                <i className="fa fa-refresh"/> Generate random password
            </button>
            <p><em>After saving you won't be able to see the password anymore.</em></p>
        </OkCancelDialog>}

        {newUser && <OkCancelDialog dismiss={() => setNewUser(null)} onOk={saveNewUser}>
            <h2>Add new user</h2>
            {newUserError && <p className="error">{newUserError}</p>}
            <div className="setting-input">
                <label htmlFor="email">Email</label>
                <input id="email" type="text" value={newUser.email}
                       onChange={e => setNewUserField('email', e.target.value)}/>
            </div>
            <div className="setting-input">
                <label htmlFor="firstName">First Name</label>
                <input id="firstName" type="text" value={newUser.firstName}
                       onChange={e => setNewUserField('firstName', e.target.value)}/>
            </div>
            <div className="setting-input">
                <label htmlFor="lastName">Last Name</label>
                <input id="lastName" type="text" value={newUser.lastName}
                       onChange={e => setNewUserField('lastName', e.target.value)}/>
            </div>
            <div className="setting-input">
                <label htmlFor="password">Password</label>
                <input id="password" type="text" value={newUser.password}
                       onChange={e => setNewUserField('password', e.target.value)}/>
            </div>
            <button className="random-password" onClick={() => setNewUserField('password', randomPassword(16))}>
                <i className="fa fa-refresh"/> Generate random password
            </button>
        </OkCancelDialog>}
    </div>

}

export default Settings;