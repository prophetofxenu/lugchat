import React, { useRef } from 'react';
import Button from '@material-ui/core/Button';
import TextField from '@material-ui/core/TextField';

function MessageInput(props) {
    
    let inputRef = useRef(null);

    let label;
    if (props.room !== '')
        label = 'Send a message to ' + props.room;
    else
        label = 'Join a room first';

    let sendMessage = function() {
        let message = inputRef.current.value; 
        inputRef.current.value = null;
        props.sendMessage(message);
    };

    return (
        <div className="message-input">
            <div className="message-input-field">
                <TextField id="message-input-field" label={label} fullWidth variant="outlined"
                    disabled={props.room === ''} inputRef={inputRef} />
            </div>
            <Button variant="outlined" id="send-message" color="primary"
                disabled={props.room === ''} onClick={sendMessage} >
                Send Message
            </Button>
        </div>
    );

}

export default MessageInput;

