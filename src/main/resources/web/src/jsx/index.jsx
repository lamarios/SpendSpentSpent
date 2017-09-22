import React from 'react';
import {render} from 'react-dom';
import {BrowserRouter, Route} from 'react-router-dom';
import CenterColumn from './CenterColumn/CenterColumn.jsx';
import RightColumn from './RightColumn/RightColumn.jsx';
import LeftColumn from './LeftColumn.jsx';
import Login from './Login.jsx';
import BottomBar from './BottomBar.jsx';
import axios from 'axios';

String.prototype.format = function () {
    var s = this,
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
        if (typeof localStorage !== undefined && localStorage.token) {
            config.headers['Authorization'] = localStorage.token;
        } else {
            location.href = window.origin + '/login';
        }
    }
    return config;
}, function (error) {
    // Do something with request error
    return Promise.reject(error);
});


render((
    <BrowserRouter>
        <div>
            <Route exact path="/" component={CenterColumn}/>
            <Route path="/graphs" component={LeftColumn}/>
            <Route path="/history" component={RightColumn}/>
            <Route path="/Login" component={Login}/>

            {!window.location.pathname.includes('login') && <BottomBar/>}
        </div>
    </BrowserRouter>
), document.getElementById('app'));