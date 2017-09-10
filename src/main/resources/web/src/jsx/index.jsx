import React from 'react';
import {render} from 'react-dom';
import {BrowserRouter, Route, Link} from 'react-router-dom';
import CenterColumn from './CenterColumn.jsx';
import RightColumn from './RightColumn.jsx';
import LeftColumn from './LeftColumn.jsx';
import BottomBar from './BottomBar.jsx';

String.prototype.format = function() {
    var s = this,
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

            <BottomBar/>
        </div>
    </BrowserRouter>
), document.getElementById('app'));