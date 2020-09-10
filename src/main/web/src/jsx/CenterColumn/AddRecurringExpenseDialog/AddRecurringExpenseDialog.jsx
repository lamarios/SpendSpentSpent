import React from 'react';
import Dialog from "../../../jsx/Dialog.jsx";
import CategoryServices from "../../services/CategoryServices.jsx";
import TypeSelector from "./TypeSelector.jsx";
import AmountKeyBoard from "../AddExpenseDialog/AmountKeyBoard.jsx";
import RecurringExpenseServices from "../../services/RecurringExpenseServices.jsx";
import LoadingOverlay from "../../LoadingOverlay.jsx";

export default class AddRecurringExpenseDialog extends React.Component {

    constructor(props) {
        super(props);

        this.state = {
            step: 1,
            nextText: 'Next',
            previousText: 'Cancel',
            categories: [],
            category: -1,
            type: -1,
            typeParam: -1,
            amount: '',
            loading: true,
            apiOver: false,
        };

        this.recurringService = new RecurringExpenseServices();
        this.categoryService = new CategoryServices();
        this.nextStep = this.nextStep.bind(this);
        this.previousStep = this.previousStep.bind(this);
        this.addDigit = this.addDigit.bind(this);
        this.removeDigit = this.removeDigit.bind(this);
    }

    componentDidMount() {
        this.categoryService.getAll()
            .then(res => this.setState({categories: res, loading: false, apiOver: true}));
    }

    /**
     * Brings the wizard to the following step
     * @param e
     */
    nextStep(e) {
        if (this.state.step === 3) {
            let recurringExpense = {
                amount: this.state.amount,
                category: {id: this.state.category},
                income: false,
                type: this.state.type,
                typeParam: this.state.type === 0 ? 0 : this.state.typeParam,
                name: '',
            };

            let valid = recurringExpense.amount.length > 0
                && recurringExpense.category.id > -1
                && recurringExpense.type > -1
                && recurringExpense.typeParam > -1;

            if (valid) {
                this.setState({loading: true});
                this.recurringService.add(recurringExpense)
                    .then(() => this.props.dismiss())
                    .catch(err => {
                        console.error(err);
                        alert('Error while creating recurring expense');
                    });
            } else {
                alert('Category, frequency and amount are required.');
            }

        } else {
            let newStep = this.state.step + 1;
            console.log(newStep);
            this.setState({
                step: newStep,
                nextText: newStep === 3 ? 'Add' : 'Next',
                previousText: newStep === 1 ? 'Cancel' : 'Back',
            });
        }
    }

    /**
     * Brings the wizard one step back
     * @param e
     */
    previousStep(e) {
        if (this.state.step === 1) {
            this.props.dismiss(e);
        } else {
            let newStep = this.state.step - 1;
            console.log(newStep);
            this.setState({
                step: newStep,
                previousText: newStep === 1 ? 'Cancel' : 'Back',
                nextText: newStep === 3 ? 'Add' : 'Next',
            });

        }
    }

    /**
     * Adds a digit to the amount
     * @param digit
     */
    addDigit(digit) {
        console.log('Adding digit', digit);
        let newAmount = this.state.amount + digit;

        let patt = new RegExp(/^[0-9]+(\.[0-9]{0,2})?$/);

        if (patt.test(newAmount)) {
            this.setState({amount: newAmount})
        }
    }

    /**
     * Removes a digit from the amount
     */
    removeDigit() {
        console.log('removing digit');
        this.setState({amount: this.state.amount.substring(0, this.state.amount.length - 1)});
    }

    render() {
        return <Dialog cancelText={this.state.previousText} okText={this.state.nextText} dismiss={this.previousStep}
                       onOk={this.nextStep}>
            {this.state.loading && <LoadingOverlay/>}

            <div className={'AddRecurringExpenseDialog'}>
                {this.state.step === 1 && <div>
                    <div className={'categories'}>
                        <h3>Which category ?</h3>

                        {(this.state.apiOver && this.state.categories.length === 0) &&
                        <p>Nothing to show here, close this dialog and add categories first.</p>}

                        {this.state.categories.length > 0 &&
                        <ul>
                            {this.state.categories.map(cat =>
                                <li key={cat.id}
                                    onClick={() => this.setState({category: cat.id})}
                                    className={(this.state.category === cat.id ? 'selected' : '')}
                                >
                                    <i className={'cat ' + cat.icon}/>
                                </li>
                            )}
                        </ul>
                        }
                    </div>
                </div>}

                {this.state.step === 2 && <div className={'select-type'}>
                    <h3>How often ?</h3>
                    <TypeSelector type={this.state.type} typeParam={this.state.typeParam}
                                  onTypeChange={(type) => this.setState({type: type})}
                                  onTypeParamChange={(typeParam) => this.setState({typeParam: typeParam})}
                    />
                </div>}

                {this.state.step === 3 && <div className={'amount'}>
                    <h3>How much ?</h3>
                    <div>
                        <input value={this.state.amount} placeholder={'Amount'} readOnly={"true"}/>
                    </div>
                    <AmountKeyBoard onDigitClick={this.addDigit} onEraseDigitClick={this.removeDigit}/>
                </div>}
            </div>
        </Dialog>
    }
}