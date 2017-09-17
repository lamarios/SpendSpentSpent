import React from 'react';
import AddExpenseDialog from "./AddExpenseDialog/AddExpenseDialog.jsx";
import OkCancelDialog from "../OkCancelDialog.jsx";

export default class CategoryGridIcon extends React.Component {

    constructor(props) {
        super(props);

        this.state = {
            showDialog: false,
            showDeleteDialog: false,
        };

        this.deleteCategory = this.deleteCategory.bind(this);
        this.toggleAddExpenseDialog = this.toggleAddExpenseDialog.bind(this);
    }

    /**
     * Deletes a category
     */
    deleteCategory(e) {
        this.props.delete(this.props.category.id);
        e.stopPropagation();
        this.setState({showDeleteDialog: false});
    }


    /**
     * Toggles the expense dialog
     */
    toggleAddExpenseDialog() {
        this.setState({showDialog: !this.state.showDialog})
    }

    render() {
        var style = {
            animationDuration: ((Math.random()) + 0.5) + 's'
        }


        return <li className={'CategoryGridIcon '} style={style} onClick={this.toggleAddExpenseDialog}>

            {this.state.showDialog &&
            <AddExpenseDialog dismiss={this.toggleAddExpenseDialog} category={this.props.category}/>
            }

            {this.state.showDeleteDialog &&
            <OkCancelDialog dismiss={() => this.setState({showDeleteDialog: false})}
                            onOk={this.deleteCategory}>
                Are you sure to delete this category and all the related expenses ?
            </OkCancelDialog>
            }

            <i className={'cat ' + this.props.category.icon}></i>
            <div className={'grid-overlay ' + (this.props.overlay ? 'showing' : '')}
                 onClick={(e) => e.stopPropagation()}>
                <i className="fa fa-times" onClick={(e) => {
                    this.setState({showDeleteDialog: true});
                    e.stopPropagation();
                }}/>
            </div>
        </li>
    }
}
