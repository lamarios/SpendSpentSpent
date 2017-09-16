import React from 'react';
import AddExpenseDialog from "./AddExpenseDialog/AddExpenseDialog.jsx";

export default class CategoryGridIcon extends React.Component {

    constructor(props) {
        super(props);

        this.state = {
            showDialog: false,
        };

        this.deleteCategory = this.deleteCategory.bind(this);
        this.toggleAddExpenseDialog = this.toggleAddExpenseDialog.bind(this);
    }

    /**
     * Deletes a category
     */
    deleteCategory() {
        this.props.delete(this.props.category.id);
    }


    /**
     * Toggles the expense dialog
     */
    toggleAddExpenseDialog() {
        this.setState({showDialog: !this.state.showDialog})
    }

    render() {
        var style = {
            animationDuration: ((Math.random())+0.5) + 's'
        }


        return <li className={'CategoryGridIcon '} style={style} onClick={this.toggleAddExpenseDialog}>

            {this.state.showDialog &&
            <AddExpenseDialog dismiss={this.toggleAddExpenseDialog} category={this.props.category}/>
            }

            <i className={'cat ' + this.props.category.icon}></i>
            <div className={'grid-overlay ' + (this.props.overlay ? 'showing' : '')}>
                <i className="fa fa-times" onClick={this.deleteCategory}></i>
            </div>
        </li>
    }
}
