import React from 'react';
import CategoryService from '../../services/CategoryServices.jsx';
import SubCategory from './SubCategory.jsx'
import Dialog from "../../Dialog.jsx";

export default class AddCategoryDialog extends React.Component {

    constructor(props) {
        super(props);
        this.categoryService = new CategoryService();
        this.state = {
            categories: [],
            searchResults: [],
            searchTerms: '',
            selected: '',
            loading: false,
        };

        this.addCategory = this.addCategory.bind(this);
        this.select = this.select.bind(this);
        this.searchCategory = this.searchCategory.bind(this);
    }

    searchCategory(event) {
        clearTimeout(this.searchTimeout);
        let value = event.target.value;

        this.searchTimeout = setTimeout(() => {
            this.setState({searchTerms: value, loading: true}, () => {
                this.categoryService.search(value)
                    .then(res => {
                        if (res.query === value) {
                            this.setState({searchResults: res.results, loading: false});
                        }
                    });
            });
        }, 200);
    }

    /**
     * When the component is showing
     */
    componentDidMount() {
        this.setState({loading: true}, () => {
            this.categoryService.getAvailable()
                .then(res => {
                    this.setState({categories: res, loading: false});
                    console.log(Object.getOwnPropertyNames(this.state.categories), this.state.categories);
                })
                .catch(err => alert('unable to get cattegories' + err));

        });
    }

    /**
     * Do the backend call to add the category
     */
    addCategory() {
        if (this.props.updateCategory) {
            this.setState({loading: true}, () => {
                this.categoryService.mergeCategory(this.props.updateCategory, {icon: this.state.selected})
                    .then(() => {
                        this.props.refresh();
                        this.props.dismiss();
                    })
                    .catch(err => {
                        alert('Error while updating category ' + err);
                        console.error(err);
                        this.setState({loading: false});
                    });
            });
        } else {
            this.setState({loading: true}, () => {
                if (this.state.selected.length > 0) {
                    console.log('Adding category', this.state.selected);
                    this.categoryService.add(this.state.selected)
                        .then(() => {
                            this.props.refresh();
                            this.props.dismiss();
                        })
                        .catch(err => {
                            alert('Error while adding category ' + err);
                            console.error(err);
                            this.setState({loading: false});
                        });

                }
            });
        }
    }

    /**
     * Selects an icon
     * @param icon
     */
    select(icon) {
        this.setState({selected: icon});
    }

    render() {
        let keys = Object.keys(this.state.categories);

        return <Dialog dismiss={this.props.dismiss}
                       cancelText={'Cancel'}
                       okText={this.props.updateCategory ? 'Update Icon' : 'Add Category'}
                       onOk={this.addCategory}>

            <div className={'AddCategoryDialog'}>
                <div className={"categories"}>
                    <div className={'search'}>
                        <input placeholder={'search'} onKeyUp={this.searchCategory}/>
                    </div>
                    {this.state.searchTerms.length > 0 && <SubCategory
                        icons={this.state.searchResults}
                        onSelect={this.select}
                        selected={this.state.selected}
                    />}

                    {keys.length > 0 && this.state.searchTerms.length === 0 &&
                    <SubCategory
                        icons={this.state.categories}
                        onSelect={this.select}
                        selected={this.state.selected}
                    />
                    }
                </div>
            </div>
        </Dialog>
    }
}