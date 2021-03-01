function MessageBox(props) {

    let messages = [];
    for (let msg of props.messages) {
        messages.push(
            <div className="message">
                <h6>{msg.user} - {msg.timestamp}</h6>
                <h5>{msg.message}</h5>
            </div>
        );
    }

    return (
        <div className="message-box" ref={props.mref}>
        {messages}
        </div>
    );
}

export default MessageBox;

