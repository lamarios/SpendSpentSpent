import React from 'react';

export const FormContainer = (props) => {
    return <div className="FormContainer" {...props}>
        {props.children}
    </div>
}