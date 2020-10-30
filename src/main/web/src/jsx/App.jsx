import React, {useState} from 'react';
import {BrowserRouter, Route} from "react-router-dom";
import CenterColumn from "./CenterColumn/CenterColumn";
import LeftColumn from "./LeftColumn/LeftColumn";
import RightColumn from "./RightColumn/RightColumn";
import Login from "./Login";
import SignUp from "./SignUp";
import Settings from "./Settings";
import EditProfile from "./EditProfile";
import BottomBar from "./BottomBar";
import {loginService} from "./services/LoginServices";
import ResetPassword from "./ResetPassword";

export const UserDispatch = React.createContext(null);

const App = (props) => {
    const [currentUser, dispatch] = useState(loginService.getCurrentUser());

    return <BrowserRouter>
        <div>
            <UserDispatch.Provider value={dispatch}>
                <Route exact path="/" component={CenterColumn}/>
                <Route path="/graphs" component={LeftColumn}/>
                <Route path="/history" component={RightColumn}/>
                <Route path="/login-screen" component={Login}/>
                <Route path="/signup-screen" component={SignUp}/>
                <Route path="/reset-password" component={ResetPassword}/>
                <Route path="/settings" component={Settings}/>
                <Route path="/edit-profile" component={EditProfile}/>

                {!window.location.pathname.includes('login') &&
                !window.location.pathname.includes('signup') &&
                !window.location.pathname.includes('reset-password') &&
                <BottomBar user={currentUser}/>}
            </UserDispatch.Provider>
        </div>
    </BrowserRouter>
}

export default App;