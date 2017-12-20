import React from 'react';
import {render} from 'react-dom';
import {BrowserRouter, Route} from 'react-router-dom';
import CenterColumn from './CenterColumn/CenterColumn.jsx';
import RightColumn from './RightColumn/RightColumn.jsx';
import LeftColumn from './LeftColumn/LeftColumn.jsx';
import Login from './Login.jsx';
import Settings from './Settings.jsx';
import BottomBar from './BottomBar.jsx';
import axios from 'axios';
import UpdaterService from './services/UpdaterService.jsx';

//shitty trick to get webpack to actually copy the images
let images =   require.context("../images/", true, /^\.\/.*\.png/);

String.prototype.format = function () {
    let s = this,
        i = arguments.length;

    while (i--) {
        s = s.replace(new RegExp('\\{' + i + '\\}', 'gm'), arguments[i]);
    }
    return s;
};

//Defining the interceptors
console.log('creating interceptor');
axios.interceptors.request.use(function (config) {

    if (config.url.indexOf('/Login') === -1) {
        if (typeof window.localStorage !== undefined && window.localStorage.token) {
            config.headers['Authorization'] = localStorage.token;
        }
    }
    return config;
}, function (error) {
    return Promise.reject(error);
});

// Add a response interceptor
axios.interceptors.response.use(function (response) {
    return response;
}, function (error) {

    console.log(error.request);
    console.log(error.response);
    if(error.request.responseURL.indexOf('/Login') === -1 && error.response.status === 401){
        location.href = window.origin + '/login-screen';
    }
    return Promise.reject(error);
});

//Will cause infinite log in loops
// let updaterService = new UpdaterService();
// updaterService.info().then((info) => console.log(info));

render((
    <BrowserRouter>
        <div>
            <Route exact path="/" component={CenterColumn}/>
            <Route path="/graphs" component={LeftColumn}/>
            <Route path="/history" component={RightColumn}/>
            <Route path="/login-screen" component={Login}/>
            <Route path="/settings" component={Settings}/>

            {!window.location.pathname.includes('login') && <BottomBar/>}
        </div>
    </BrowserRouter>
), document.getElementById('app'));