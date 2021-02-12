import React from 'react';
import AddExpenseDialog from "./AddExpenseDialog/AddExpenseDialog.jsx";
import OkCancelDialog from "../OkCancelDialog.jsx";
import {SortableHandle} from "react-sortable-hoc";
import AddCategoryDialog from "./AddCategoryDialog/AddCategoryDialog";

const DragHandle = SortableHandle(() => <i className='drag-icon fa fa-arrows'/>);
export default class CategoryGridIcon extends React.Component {

    constructor(props) {
        super(props);

        this.state = {
            showDialog: false,
            showDeleteDialog: false,
            showChangeCategoryDialog: false,
        };

        this.deleteCategory = this.deleteCategory.bind(this);
        this.toggleAddExpenseDialog = this.toggleAddExpenseDialog.bind(this);
        this.dismissCategoryChange = this.dismissCategoryChange.bind(this);
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

    dismissCategoryChange() {
        this.setState({showChangeCategoryDialog: false});
    }

    render() {
        let style = {
            animationDuration: ((Math.random()) * (0.5 - 0.20) + 0.20) + 's',
        };
        let percentageStyle = {
            backgroundColor: "rgb(3,57,102," + this.props.category.percentageOfMonthly + ")"
        }

        return <li className={'CategoryGridIcon ' + (this.props.overlay ? ' editting' : '')} style={style}
                   onClick={this.toggleAddExpenseDialog}>
            {this.state.showDialog &&
            <AddExpenseDialog refresh={this.props.refresh} dismiss={this.toggleAddExpenseDialog}
                              category={this.props.category}/>
            }

            {this.state.showDeleteDialog &&
            <OkCancelDialog dismiss={() => this.setState({showDeleteDialog: false})}
                            onOk={this.deleteCategory}>
                Are you sure to delete this category and all the related expenses ?
            </OkCancelDialog>
            }
            <div className="shading" style={percentageStyle}>
                <i className={this.props.category.icon.categoryIcon()}/>
                {this.props.category.icon.startsWith("icon-") &&
                <i className="legacy fa fa-exclamation" aria-hidden="true"></i>}

                <div className={'grid-overlay ' + (this.props.overlay ? 'showing fade-in' : '')}
                     onClick={(e) => e.stopPropagation()}>
                    <div className="delete-button" onClick={(e) => {
                        this.setState({showDeleteDialog: true});
                        e.stopPropagation();
                    }}>
                        <i className="fa fa-times"/>
                    </div>
                    <i onClick={() => this.setState({showChangeCategoryDialog: true})} title="Change category icon"
                       className={this.props.category.icon.categoryIcon()}/>
                    <DragHandle/>
                    {this.props.category.icon.startsWith("icon-") &&
                    <i onClick={() => this.setState({showChangeCategoryDialog: true})}
                       className="legacy fa fa-exclamation" aria-hidden="true"></i>}
                </div>
            </div>

            {this.state.showChangeCategoryDialog &&
            <AddCategoryDialog refresh={this.props.refresh} updateCategory={this.props.category.id}
                               dismiss={this.dismissCategoryChange}/>}
        </li>
    }
}
