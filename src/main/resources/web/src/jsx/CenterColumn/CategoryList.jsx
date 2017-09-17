import React from 'react';
import CategoryService from '../services/CategoryServices.jsx';
import CategoryGridIcon from './CategoryGridIcon.jsx';
import AddCategoryDialog from './AddCategoryDialog/AddCategoryDialog.jsx';
import OkDialog from "../OkDialog.jsx";


export default class CategoryList extends React.Component {

    constructor() {
        super();
        this.categoryService = new CategoryService();
        this.state = {
            categories: [],
            overlay: false,
            showAddCategory: false,
            error:'',
        }

        this.showOverlay = this.showOverlay.bind(this);
        this.deleteCategory = this.deleteCategory.bind(this);
        this.toggleAddCategoryDialog = this.toggleAddCategoryDialog.bind(this);
        this.refreshList = this.refreshList.bind(this);
        this.dismissError = this.dismissError.bind(this);
    }

    /**
     * When the component is mounted
     */
    componentDidMount() {
        this.refreshList();
    }

    /**
     * Show the settings overlay
     */
    showOverlay() {
        this.setState({overlay: !this.state.overlay});
    }

    /**
     * Refresh the list of categories
     */
    refreshList() {
        this.categoryService.getAll()
            .then(res => {
                this.setState({categories: res.data});
                console.log(res.data);
            })
            .catch(err => {
                this.setState({error: 'Couldn\'t retrieve category list: '+err})
                console.log('Hello', err)
            })

    }

    /**
     * Hides or display the category dialog
     */
    toggleAddCategoryDialog() {
        console.log(this.state.showAddCategory)
        this.setState({showAddCategory: !this.state.showAddCategory});
    }


    /**
     * Deletes a category
     * @param id
     */
    deleteCategory(id) {
        if (confirm('Are you sure to delete this category and all the related expenses ?')) {
            this.categoryService.delete(id)
                .then(res => this.refreshList())
        }
    }

    dismissError(e){
        this.setState({error:''});
    }

    render() {
        return (
            <div className="CategoryList">
                {this.state.showAddCategory &&
                <AddCategoryDialog
                    dismiss={this.toggleAddCategoryDialog}
                    refresh={this.refreshList}
                />
                }

                {this.state.error.length > 0 &&
                    <OkDialog dismiss={this.dismissError}>
                        {this.state.error}
                    </OkDialog>
                }

                <ul>
                    {this.state.categories.map(
                        (category) => <CategoryGridIcon
                            key={category.id}
                            category={category}
                            overlay={this.state.overlay}
                            delete={this.deleteCategory}
                        />
                    )}
                </ul>
                <div className="list-settings">
                    <i className="fa fa-plus" onClick={this.toggleAddCategoryDialog}></i>
                    <i className="fa fa-cog" onClick={this.showOverlay}></i>
                </div>
            </div>
        );
    }
}

