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

// catering for both new and old icons
// TODO: remove when old icons are removed
String.prototype.categoryIcon = function () {
    return this.startsWith("icon-") ? "cat " + this : "cat-" + this;
}

render(<App></App>, document.getElementById('app'));