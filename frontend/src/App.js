import Header from './Header';
import MessageBox from './MessageBox';
import MessageInput from './MessageInput';

import React, { useEffect, useState } from 'react';
import './App.css';

const axios = require('axios');

function App() {

    let [ messages, setMessages ] = useState([]);
    let [ username, setUsername ] = useState('');
    let [ roomName, setRoomName ] = useState('');

    let sendMessage = function(msg) {
        console.log(msg);
    };

    return (
        <div className="lugchat-app">
            <Header setUsername={setUsername} setRoom={setRoomName} />
            <MessageBox messages={messages} />
            <MessageInput room={roomName} sendMessage={sendMessage} />
        </div>
    );
}

export default App;

