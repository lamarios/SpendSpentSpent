import React from 'react';
import GoogleMapReact from 'google-map-react';

const MapIcon = ({ icon }) => <i className={'cat '+icon }/>;

export default class ExpenseLocation extends React.Component{

    render(){
        return <div className={'ExpenseLocation'} onClick={(e)=> e.stopPropagation()}>
            <GoogleMapReact defaultZoom={16} defaultCenter={{lat: this.props.latitude, lng:this.props.longitude}}>

                <MapIcon icon={this.props.icon} lat={this.props.latitude} lng={this.props.longitude} />

            </GoogleMapReact>
        </div>
    }
}