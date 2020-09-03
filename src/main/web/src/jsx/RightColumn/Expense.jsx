import React from 'react';
import Amount from "../Amount.jsx";
import ExpenseLocation from "./ExpenseLocation.jsx";
import OkCancelDialog from "../OkCancelDialog.jsx";

export default class Expense extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            flipped: false,
            showDeleteDialog: false
        };
    }

    render() {
        return <div className={'Expense'}>
            <div className={'card ' + (this.state.flipped === true ? 'flip' : '')}
                 onClick={() => this.setState({flipped: !this.state.flipped})}>
                {this.state.flipped === false &&
                <div className={'front fade-in'}>
                    <i className={'cat ' + this.props.expense.category.icon}/>
                    <span className={'amount'}>
                         <Amount>{this.props.expense.amount}</Amount>
                    </span>
                    <div className={'modifiers'}>
                        {(this.props.expense.latitude !== 0 || this.props.expense.longitude !== 0) &&
                        <i className={'fa fa-location-arrow'}/>}
                        {this.props.expense.type === 2 &&
                        <i className={'fa fa-refresh'}/>}
                        {this.props.expense.note !== undefined && this.props.expense.note.length > 0 &&
                        <i className={'fa fa-pencil-square-o'}/>}
                    </div>
                </div>
                }
                {this.state.flipped === true &&
                <div className={'back fade-in'}>
                    {this.props.expense.note !== undefined && this.props.expense.note.length > 0 &&
                    <div className={"note"}>
                        <i className={"fa fa-pencil-square-o"}/>
                        <span>{this.props.expense.note}</span>
                    </div>
                    }
                    {(this.props.expense.latitude !== 0 || this.props.expense.longitude !== 0) &&
                    <ExpenseLocation icon={this.props.expense.category.icon} longitude={this.props.expense.longitude}
                                     latitude={this.props.expense.latitude}/>}

                    <p className={'actions'}>
                        <a>Close</a>
                        <a className={'delete'} onClick={(e) => {
                            this.setState({showDeleteDialog: true});
                            e.stopPropagation()
                        }}>Delete</a>
                    </p>
                </div>
                }
            </div>

            {this.state.showDeleteDialog === true &&
            <OkCancelDialog
                dismiss={() => this.setState({showDeleteDialog: false})}
                onOk={() => {
                    this.props.onDelete(this.props.expense.id);
                    this.setState({showDeleteDialog: false});
                }}
            >
                Delete this expense ?
            </OkCancelDialog>}
        </div>
    }
}