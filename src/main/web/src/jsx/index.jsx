import React from 'react';
import {render} from 'react-dom';
import {BrowserRouter, Route} from 'react-router-dom';
import CenterColumn from './CenterColumn/CenterColumn.jsx';
import RightColumn from './RightColumn/RightColumn.jsx';
import LeftColumn from './LeftColumn/LeftColumn.jsx';
import Login from './Login.jsx';
import Settings from './Settings.jsx';
import BottomBar from './BottomBar.jsx';

String.prototype.format = function () {
    let s = this,
        i = arguments.length;

    while (i--) {
        s = s.replace(new RegExp('\\{' + i + '\\}', 'gm'), arguments[i]);
    }
    return s;
};



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