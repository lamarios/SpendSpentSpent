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
            apiOver:false,
        };

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
                this.setState({categories: res.data, apiOver:true});
            })
            .catch(err => {
                this.setState({error: 'Couldn\'t retrieve category list: '+err, apiOver: true});
                console.log('Hello', err)
            })

    }

    /**
     * Hides or display the category dialog
     */
    toggleAddCategoryDialog() {
        this.setState({showAddCategory: !this.state.showAddCategory});
    }


    /**
     * Deletes a category
     * @param id
     */
    deleteCategory(id) {
            this.categoryService.deleteCategory(id)
                .then(res => this.refreshList())
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

                { this.state.categories.length > 0 &&
                <ul>
                    {this.state.categories.map(
                        (category) => <CategoryGridIcon
                            key={category.id}
                            category={category}
                            overlay={this.state.overlay}
                            delete={this.deleteCategory}
                        />
                    )}
                </ul>}


                {(this.state.apiOver === true && this.state.categories.length === 0)  && <p>Nothing to show, add expense categories by click the <i className={'fa fa-plus'}/> icon  below.</p>}

                <div className="list-settings fade-in">
                    <i className="fa fa-plus" onClick={this.toggleAddCategoryDialog}></i>
                    <i className="fa fa-cog" onClick={this.showOverlay}></i>
                </div>
            </div>
        );
    }
}

