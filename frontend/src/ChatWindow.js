import React, { useState } from 'react';
import Conversation from './Conversation';
import UserInput from './UserInput';

export default function ChatWindow() {
    const [messages, setMessages] = useState([]);

    const addMessage = (message) => {
        setMessages((prevMessages) => [
            ...prevMessages,
            { sender: "user", text: message },
        ]);

        // Wyślij zapytanie do backendu Flask
        fetch('http://localhost:5000/api/openai', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ input: message }),
        })
        .then(response => response.json())
        .then(data => {
            setMessages((prevMessages) => [
                ...prevMessages,
                { sender: "bot", text: data.response },
            ]);
        })
        .catch(error => {
            console.error('Error:', error);
        });
    };

    return (
        <div id="chatWindow">
            <Conversation messages={messages} />
            <UserInput onSend={addMessage} />
        </div>
    );
}
