import React from 'react';
import Loading from "./Loading.jsx";

export default class LoadingOverlay extends React.Component {

    render() {
        return <div className={'LoadingOverlay'}>
            <Loading/>
        </div>
    }
}