import React from 'react';
import Map from 'pigeon-maps'
import Marker from 'pigeon-marker'

export default class ExpenseLocation extends React.Component {
    constructor(props) {
        super(props);
    }

    componentDidMount() {
    }

    render() {
        const position = [this.props.latitude, this.props.longitude];
        return <div className={'ExpenseLocation'} onClick={(e) => e.stopPropagation()}>

            <Map center={position} zoom={13}>
                <Marker anchor={position} payload={1}/>
            </Map>
        </div>
    }
}