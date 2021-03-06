import React, {Fragment, useEffect, useState} from 'react';
import {v4 as uuidv4} from 'uuid';
import {settingsService} from "../services/SettingsServices";

const SingleSetting = (props) => {
    const [settings, setSettings] = useState({});
    const [newValue, setNewValue] = useState('');
    const uuid = uuidv4();
    const [saveTimeout, setSaveTimeout] = useState();
    const [showSuccess, setShowSuccess] = useState(false);

    useEffect(() => {
        getSettings();
    }, []);

    const saveSettings = (newValue) => {
        clearTimeout(saveTimeout);
        setSaveTimeout(setTimeout(async () => {
                const response = await settingsService.putSettings({
                    name: props.name,
                    value: newValue,
                    secret: props.secret
                });

                setShowSuccess(true);
                setTimeout(() => {
                    setShowSuccess(false);
                }, 2000);
            }, 500)
        );
    }

    const valueChanged = newValue => {
        setNewValue(newValue);
        const set = settings;
        set.value = newValue;
        setSettings(set);
        saveSettings(newValue);
    };

    const getSettings = async () => {
        const response = await settingsService.get(props.name);
        setSettings(response);
        setNewValue(response.value);
    }

    return <div className="SingleSetting">
        {settings && <Fragment>
            <label htmlFor={uuid}>{props.title}</label>
            <div className="description">
                {props.children}
            </div>
            <div className="input-container">
                <input type={props.secret ? "password" : "text"} id={uuid} value={newValue}
                       onChange={e => valueChanged(e.target.value)}/>
                {showSuccess && <div className="done">
                    <i className="fa fa-check"/>
                </div>}
            </div>
        </Fragment>}
    </div>
}

export default SingleSetting;