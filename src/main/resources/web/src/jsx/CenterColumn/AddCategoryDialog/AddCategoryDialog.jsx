import React from 'react';
import CategoryService from '../../services/CategoryServices.jsx';
import SubCategory from './SubCategory.jsx'
import Loading from "../../Loading.jsx";
import Dialog from "../../Dialog.jsx";
import LoadingOverlay from "../../LoadingOverlay.jsx";

export default class AddCategoryDialog extends React.Component {

    constructor(props) {
        super(props);
        this.categoryService = new CategoryService();
        this.state = {
            categories: [],
            selected: '',
            loading: false,
        }

        this.addCategory = this.addCategory.bind(this);
        this.select = this.select.bind(this);
    }

    /**
     * When the component is showing
     */
    componentDidMount() {
        this.categoryService.getAvailable()
            .then(res => {
                this.setState({categories: res.data})
                console.log(Object.getOwnPropertyNames(this.state.categories), this.state.categories);
            })
            .catch(err => alert('unable to get cattegories' + err));
    }

    /**
     * Do the backend call to add the category
     */
    addCategory() {
        this.setState({loading: true}, () => {
            if (this.state.selected.length > 0) {
                console.log('Adding category', this.state.selected);
                this.categoryService.add(this.state.selected)
                    .then(res => {
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

    /**
     * Selects an icon
     * @param icon
     */
    select(icon) {
        this.setState({selected: icon});
    }


    render() {
        var keys = Object.keys(this.state.categories);

        return <Dialog dismiss={this.props.dismiss}
                       cancelText={'Cancel'}
                       okText={'Add Category'}
                       onOk={this.addCategory}>

            <div className={'AddCategoryDialog'}>
                {this.state.loading && <LoadingOverlay/>}
                <div className={"categories"}>
                    {keys.length > 0 && keys.map(
                        (subCategory) => <SubCategory
                            key={subCategory}
                            name={subCategory}
                            selected={this.state.selected}
                            icons={this.state.categories[subCategory]}
                            onSelect={this.select}

                        />
                    )}
                    {keys.length === 0 && <Loading/>}
                </div>
            </div>
        </Dialog>
    }
}