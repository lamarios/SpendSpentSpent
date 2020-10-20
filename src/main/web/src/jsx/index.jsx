import React,{createContext, useState}  from 'react';
import {render} from 'react-dom';
import {BrowserRouter, Route} from 'react-router-dom';
import CenterColumn from './CenterColumn/CenterColumn.jsx';
import RightColumn from './RightColumn/RightColumn.jsx';
import LeftColumn from './LeftColumn/LeftColumn.jsx';
import Login from './Login.jsx';
import Settings from './Settings.jsx';
import BottomBar from './BottomBar.jsx';
import SignUp from "./SignUp";
import EditProfile from "./EditProfile";
import {loginService} from "./services/LoginServices";
import App from "./App";

String.prototype.format = function () {
    let s = this,
        i = arguments.length;

    while (i--) {
        s = s.replace(new RegExp('\\{' + i + '\\}', 'gm'), arguments[i]);
    }
    return s;
};


render(<App></App>, document.getElementById('app'));