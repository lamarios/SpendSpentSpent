import React from 'react';

const UserIcon = (props) => {

    const hashCode = (str) => { // java String#hashCode
        var hash = 0;
        for (var i = 0; i < str.length; i++) {
            hash = str.charCodeAt(i) + ((hash << 5) - hash);
        }
        return hash;
    }

    const intToRGB = (i) => {
        var c = (i & 0x00FFFFFF)
            .toString(16)
            .toUpperCase();

        return "00000".substring(0, 6 - c.length) + c;
    }

    const generateInitials = () =>{
        if(props.user) {
            return props.user.firstName.substr(0, 1) + props.user.lastName.substr(0, 1);
        }else{
            return "A";
        }
    }


    const style = {
        backgroundColor: props.user?'#'+intToRGB(hashCode(props.user.id)):"#fff",
    }



    return <div className="UserIcon" style={style}>
        {generateInitials()}
    </div>
}

export default UserIcon;