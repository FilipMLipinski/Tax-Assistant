import React, { useState } from "react";
import Conversation from "./Conversation";
import UserInput from "./UserInput";

export default function ChatWindow() {
    const [messages, setMessages] = useState([]);

    const addMessage = (message) => {
        // Add user's message
        setMessages((prevMessages) => [
            ...prevMessages,
            { sender: "user", text: message },
        ]);

        // Simulate bot's response
        setTimeout(() => {
            const botResponse = getResponse();
            setMessages((prevMessages) => [
                ...prevMessages,
                { sender: "bot", text: botResponse },
            ]);
        }, 1000); // Simulate delay for bot's response
    };

    const getResponse = () => {
        return "bot's response";
    };

    return (
        <div id="chatWindow">
            <Conversation messages={messages} />
            <UserInput onSend={addMessage} />
        </div>
    );
}