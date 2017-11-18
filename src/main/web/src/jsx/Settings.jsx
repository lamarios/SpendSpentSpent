import React from 'react';
import SettingsService from './services/SettingsServices.jsx';
import OkDialog from "./OkDialog.jsx";
import Notification from './Notification.jsx';
export default class Settings extends React.Component {
    constructor(props) {
        super(props);

        this.settingsService = new SettingsService();
        this.state = {
            settings: {},
            tab: 'authentication',
            showErrorDialog: false,
            errorMessage: '',
            newPassword: '',
            notificationTimeout: null,
            showNotification: false,
            notificationMessage: '',
        };


        this.authenticationChanged = this.authenticationChanged.bind(this);
        this.usernameChanged = this.usernameChanged.bind(this);
        this.passwordChanged = this.passwordChanged.bind(this);
        this.pushbulletChanged = this.pushbulletChanged.bind(this);
        this.pushbulletApiChanged = this.pushbulletApiChanged.bind(this);
        this.pushalotChanged = this.pushalotChanged.bind(this);
        this.pushalotApiChanged = this.pushalotApiChanged.bind(this);
        this.pushoverChanged = this.pushoverChanged.bind(this);
        this.pushoverAppTokenChanged = this.pushoverAppTokenChanged.bind(this);
        this.pushoverUserTokenChanged = this.pushoverUserTokenChanged.bind(this);
        this.googlemapChanged = this.googlemapChanged.bind(this);

        this.getSettings = this.getSettings.bind(this);
        this.saveAuthentication = this.saveAuthentication.bind(this);
        this.saveNotifications = this.saveNotifications.bind(this);
        this.saveGoogleMap = this.saveGoogleMap.bind(this);
        this.showNotification = this.showNotification.bind(this);
    }


    getSettings() {
        this.settingsService.getAll()
            .then(res => this.setState({settings: res.data}));
    }


    saveAuthentication() {
        if (this.state.settings.authentication.value === 'true'
            && (
                this.state.settings.username.value.length === 0
                || this.state.newPassword.length === 0
            )) {

            this.setState({
                showErrorDialog: true,
                errorMessage: 'To use authentication, you must specify a username and a password'
            });
            return;
        }


        let password = {
            name: 'password',
            value: this.state.newPassword,
        };


        let toSave = [this.state.settings.authentication];

        if (this.state.settings.authentication.value === 'true') {
            toSave.push(this.state.settings.username);
            toSave.push(password);
        }

        this.settingsService.putSettingsList(toSave).then(res => this.showNotification('Authentication settings saved !'));

    }

    showNotification(message) {
        clearTimeout(this.state.notificationTimeout);


        this.setState({
            notificationTimeout: setTimeout(() => this.setState({showNotification: false}), 3000),
            showNotification: true,
            notificationMessage: message
        })
    }

    saveNotifications() {
        this.settingsService.putSettingsList([
                this.state.settings.pushbullet,
                this.state.settings.pushbulletApi,
                this.state.settings.pushalot,
                this.state.settings.pushalotApi,
                this.state.settings.pushover,
                this.state.settings.pushoverAppToken,
                this.state.settings.pushoverUserToken,
            ]
        ).then(res => this.showNotification('Notification settings saved !'));
    }

    saveGoogleMap() {
        this.settingsService.putSettingsList([
                this.state.settings.googlemap,
            ]
        ).then(res => this.showNotification('Google Map settings saved !'));
    }

    authenticationChanged(e) {
         let setting = {
            name: 'authentication',
            value: e.target.checked.toString(),
        };

        let settings = this.state.settings;
        settings.authentication = setting;

        this.setState({settings: settings});
    }


    googlemapChanged(e) {
        let setting = {
            name: 'googlemap',
            value: e.target.value,
        };

        let settings = this.state.settings;
        settings.googlemap = setting;

        this.setState({settings: settings});


    }

    pushoverUserTokenChanged(e) {
         let setting = {
            name: 'pushoverUserToken',
            value: e.target.value,
        };

        let settings = this.state.settings;
        settings.pushoverUserToken = setting;

        this.setState({settings: settings});

    }

    pushoverAppTokenChanged(e) {
        let setting = {
            name: 'pushoverAppToken',
            value: e.target.value,
        };

        let settings = this.state.settings;
        settings.pushoverAppToken = setting;

        this.setState({settings: settings});

    }

    pushoverChanged(e) {
        let setting = {
            name: 'pushover',
            value: e.target.checked.toString(),
        };

        let settings = this.state.settings;
        settings.pushover = setting;

        this.setState({settings: settings});

    }

    pushalotApiChanged(e) {
        let setting = {
            name: 'pushalotApi',
            value: e.target.value,
        };

        let settings = this.state.settings;
        settings.pushalotApi = setting;

        this.setState({settings: settings});

    }

    pushalotChanged(e) {
        let setting = {
            name: 'pushalot',
            value: e.target.checked.toString(),
        };

        let settings = this.state.settings;
        settings.pushalot = setting;

        this.setState({settings: settings});

    }

    pushbulletApiChanged(e) {
        let setting = {
            name: 'pushbulletApi',
            value: e.target.value,
        };

        let settings = this.state.settings;
        settings.pushbulletApi = setting;

        this.setState({settings: settings});

    }

    pushbulletChanged(e) {
        let setting = {
            name: 'pushbullet',
            value: e.target.checked.toString(),
        };

        let settings = this.state.settings;
        settings.pushbullet = setting;

        this.setState({settings: settings});

    }

    passwordChanged(e) {

        this.setState({newPassword: e.target.value});
    }

    usernameChanged(e) {
        let setting = {
            name: 'username',
            value: e.target.value,
        };

        let settings = this.state.settings;
        settings.username = setting;

        this.setState({settings: settings});
    }


    componentDidMount() {
        this.getSettings();
    }


    render() {
        let settings = this.state.settings;
        let authentication = settings.authentication !== undefined && settings.authentication.value === 'true';
        let pushbullet = settings.pushbullet !== undefined && settings.pushbullet.value === 'true';
        let pushalot = settings.pushalot !== undefined && settings.pushalot.value === 'true';
        let pushover = settings.pushover !== undefined && settings.pushover.value === 'true';


        let username = settings.username !== undefined ? settings.username.value : '';
        let pushalotApi = settings.pushalotApi !== undefined ? settings.pushalotApi.value : '';
        let pushbulletApi = settings.pushbulletApi !== undefined ? settings.pushbulletApi.value : '';
        let pushoverAppToken = settings.pushoverAppToken !== undefined ? settings.pushoverAppToken.value : '';
        let pushoverUserToken = settings.pushoverUserToken !== undefined ? settings.pushoverUserToken.value : '';
        let googlemap = settings.googlemap !== undefined ? settings.googlemap.value : '';

        return <div className={'Settings scale-fade-in'}>
            <h1> Settings </h1>
            <ul className={'tabs'}>
                <li onClick={() => this.setState({tab: 'authentication'})}
                    className={this.state.tab === 'authentication' ? 'active' : ''}>Authentication
                </li>
                <li onClick={() => this.setState({tab: 'notifications'})}
                    className={this.state.tab === 'notifications' ? 'active' : ''}>Notifications
                </li>
                <li onClick={() => this.setState({tab: 'google'})}
                    className={this.state.tab === 'google' ? 'active' : ''}>Google Map
                </li>
            </ul>

            {this.state.tab === 'authentication' && <div className={'tab-content scale-fade-in'}>
                <p><label><input type={"checkbox"} checked={authentication} value={'true'}
                                 onChange={this.authenticationChanged}/> Authentication</label></p>
                <div className={'setting-input'}>
                    <label> Username </label>
                    <input value={username} onChange={this.usernameChanged}/>
                </div>
                <div className={'setting-input'}>
                    <label>Password</label>
                    <input type={'password'} onChange={this.passwordChanged}/>
                </div>
                <button onClick={this.saveAuthentication}>Save</button>
            </div>
            }


            {this.state.tab === 'notifications' && <div className={'tab-content scale-fade-in'}>
                <p><label><input type={"checkbox"} checked={pushbullet} value={'true'}
                                 onChange={this.pushbulletChanged}/>
                    Use PushBullet
                    notifications</label>
                </p>
                < div className={'setting-input'}>
                    <label> PushBullet API key </label>
                    <input value={pushbulletApi} onChange={this.pushbulletApiChanged}/>
                </div>

                <p><label><input type={"checkbox"} checked={pushalot} value={'true'}
                                 onChange={this.pushalotChanged}/> Use
                    Pushalot notifications</label>
                </p>
                <div className={'setting-input'}>
                    <label> Pushalot API key </label>
                    <input value={pushalotApi} onChange={this.pushalotApiChanged}/>
                </div>

                <p><label><input type={"checkbox"} checked={pushover} value={'true'}
                                 onChange={this.pushoverChanged}/> Use
                    Pushover notifications</label>
                </p>
                <div className={'setting-input'}>
                    <label> Pushover API key </label>
                    <input value={pushoverAppToken} onChange={this.pushoverAppTokenChanged}/>
                </div>
                <div className={'setting-input'}>
                    <label> Pushover User token </label>
                    <input value={pushoverUserToken} onChange={this.pushoverUserTokenChanged}/>
                </div>
                <button onClick={this.saveNotifications}>Save</button>
            </div>
            }

            {this.state.tab === 'google' && <div className={'tab-content scale-fade-in'}>
                <div className={'setting-input'}>
                    <label>Google Mapi API key </label>
                    <input value={googlemap} onChange={this.googlemapChanged}/>
                </div>
                <button onClick={this.saveGoogleMap}>Save</button>
            </div>
            }

            {this.state.showErrorDialog === true &&
            <OkDialog dismiss={() => this.setState({showErrorDialog: false})}>{this.state.errorMessage}</OkDialog>}

            {this.state.showNotification === true && <Notification>
                {this.state.notificationMessage}
            </Notification>}
        </div>
    }
}