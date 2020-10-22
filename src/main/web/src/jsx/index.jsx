import React from 'react';
import {render} from 'react-dom';
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