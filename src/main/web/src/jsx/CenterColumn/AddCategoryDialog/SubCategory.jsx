import React from 'react';

export default class SubCategory extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        const categories = Object.keys(this.props.icons);
        return <div className={'SubCategory'}>
            <div className={'category-icons'}>
                {categories.map(
                    (category) => <div key={category}>
                        <h2>{category}</h2>
                        <div className="icons">
                            {this.props.icons[category].map((icon) => <i key={icon}
                                                                         className={'cat-' + icon + (this.props.selected === icon ? ' selected' : '')}
                                                                         name={icon}
                                                                         onClick={() => this.props.onSelect(icon)}/>)}
                        </div>
                    </div>
                )}
            </div>
        </div>
    }
}