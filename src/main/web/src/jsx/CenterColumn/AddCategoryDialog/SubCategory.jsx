import React from 'react';


export default class SubCategory extends React.Component {
    constructor(props) {
        super(props);

        this.state = {
            expand:  !!props.expand
        };

        this.toggleExpand = this.toggleExpand.bind(this);
    }


    /**
     * Togle the display of the icons
     */
    toggleExpand() {
        this.setState({expand: !this.state.expand});
    }


    render() {
        return <div className={'SubCategory'}>
            <p onClick={this.toggleExpand}>
                {
                    this.state.expand ?
                        <i className={'fa fa-caret-down'} />
                        :
                        <i className={'fa fa-caret-right'}/>
                }
                &nbsp;
                &nbsp;
                {this.props.name}
            </p>
            <div className={'category-icons'}>
                {this.state.expand &&
                this.props.icons.map(
                    (icon) => <i key={icon}
                                 className={'cat ' + icon + (this.props.selected === icon ? ' selected' : '')}
                                 name="{icon}"
                                 onClick={() => this.props.onSelect(icon)}/>
                )}
            </div>
        </div>
    }
}