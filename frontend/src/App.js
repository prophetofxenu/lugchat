import Header from './Header';
import MessageBox from './MessageBox';
import MessageInput from './MessageInput';

import React from 'react';
import './App.css';

const axios = require('axios');

const API_URL = 'https://rgh5xv7fmh.execute-api.us-east-1.amazonaws.com/lugchat-stage';

class App extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            messages: [],
            username: '',
            roomName: '',
            msgIDs: null,
            fetchInterval: null,
        };
        this.messagesRef = React.createRef();
    }

    login = async (username, roomName) => {
        let url = API_URL + `/messages/${roomName}?all=y`;
        let results = await axios.get(url);
        let msgIDs = new Set();
        this.state.messages = [];
        for (let msg of results.data.result) {
            msgIDs.add(msg.ID.S);
            this.state.messages.push({
                user: msg.User.S,
                timestamp: msg.Timestamp.S,
                message: msg.Message.S
            });
        }
        if (this.state.fetchInterval)
            clearInterval(this.state.fetchInterval);
        let interval = setInterval(async function() {
            let url = API_URL + `/messages/${roomName}`;
            let results = await axios.get(url);
            let newMsg = false;
            for (let msg of results.data.result) {
                if (!msgIDs.has(msg.ID.S)) {
                    newMsg = true;
                    msgIDs.add(msg.ID.S);
                    this.state.messages.push({
                        user: msg.User.S,
                        timestamp: msg.Timestamp.S,
                        message: msg.Message.S
                    });
                }
            }
            this.setState({
                messages: this.state.messages
            });
            if (newMsg) {
                this.messagesRef.current.scrollTop = this.messagesRef.current.scrollHeight;
            }
        }.bind(this), 500);
        this.setState({
            username: username,
            roomName: roomName,
            messages: this.state.messages,
            fetchInterval: interval
        });
        this.messagesRef.current.scrollTop = this.messagesRef.current.scrollHeight;
    };

    sendMessage = async (msg) => {
        let result = await axios({
            method: 'post',
            url: API_URL + `/messages/${this.state.roomName}`,
            data: {
                'user': this.state.username,
                'message': msg
            },
            headers: { 'Content-Type': 'text/plain' }
        });
        console.log(result);
    };

    render() {
        return (
            <div className="lugchat-app">
                <Header login={this.login} />
                <MessageBox messages={this.state.messages} mref={this.messagesRef} />
                <MessageInput room={this.state.roomName} sendMessage={this.sendMessage} />
            </div>
        );
    }
}

export default App;

