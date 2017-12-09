import React from 'react';


export default class SubCategory extends React.Component {
    constructor(props) {
        super(props);

    }




    render() {
        return <div className={'SubCategory'}>
            <div className={'category-icons'}>
                {this.props.icons.map(
                    (icon) => <i key={icon}
                                 className={'cat ' + icon + (this.props.selected === icon ? ' selected' : '')}
                                 name={icon}
                                 onClick={() => this.props.onSelect(icon)}/>
                )}
            </div>
        </div>
    }
}