import React from 'react';
import GoogleMapReact from 'google-map-react';
import SettingsService from '../services/SettingsServices.jsx';
import LoadingOverlay from "../LoadingOverlay.jsx";

const MapIcon = ({icon}) => <i className={'cat ' + icon}/>;

export default class ExpenseLocation extends React.Component {
    constructor(props) {
        super(props);

        this.state = {apiKey: ''};
        this.settingsService = new SettingsService();
    }


    componentDidMount() {
        console.log('hello');
        this.settingsService.get('googlemap')
            .then(res => this.setState({apiKey: res.data}, () => console.log(this.state)));
    }

    render() {
        return <div className={'ExpenseLocation'} onClick={(e) => e.stopPropagation()}>
            {this.state.apiKey.length > 0 &&
            <GoogleMapReact bootstrapURLKeys={{key: this.state.apiKey}} defaultZoom={16}
                            defaultCenter={{lat: this.props.latitude, lng: this.props.longitude}}>
                <MapIcon icon={this.props.icon} lat={this.props.latitude} lng={this.props.longitude}/>
            </GoogleMapReact>}
            {this.state.apiKey.length === 0 && <LoadingOverlay/>}
        </div>
    }
}