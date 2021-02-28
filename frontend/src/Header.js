import React, { useState } from 'react';
import Button from '@material-ui/core/Button';
import TextField from '@material-ui/core/TextField';
import './App.css';


function Header(props) {

    let [ roomName, setRoomName ] = useState('');
    let [ username, setUsername ] = useState('');

    let updateUsername = function(event) {
        setUsername(event.target.value);
    };
    
    let updateRoomName = function(event) {
        setRoomName(event.target.value);
    };

    let setParams = function() {
        props.setUsername(username);
        props.setRoom(roomName);
    };

    let buttonEnabled = roomName != '' && username != '';

    return (
        <div className="header">
            <h1 className="header-item">LUGChat</h1>
            <div className="header-mui">
                <TextField className="header-item" id="username-field" label="Username"
                    variant="outlined" onChange={updateUsername} />
                <TextField className="header-item" id="chatroom-field" label="Chatroom"
                    variant="outlined" onChange={updateRoomName} />
                <Button variant="outlined" id="enter-room" color="primary"
                    onClick={setParams} disabled={!buttonEnabled} >Enter Room</Button>
            </div>
        </div>
    );
}

export default Header;

