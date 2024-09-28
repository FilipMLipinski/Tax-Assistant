import React, { useEffect, useRef } from "react";

export default function Conversation({ messages }) {
    const conversationRef = useRef(null);

    // Scroll to the bottom of the conversation when a new message is added
    useEffect(() => {
        if (conversationRef.current) {
            conversationRef.current.scrollTop = conversationRef.current.scrollHeight;
        }
    }, [messages]);

    return (
        <div id="conversation" ref={conversationRef}>
            {messages.map((message, index) => (
                <div
                    key={index}
                    className={`message ${message.sender === "user" ? "user" : "bot"}`}
                >
                    {message.text}
                </div>
            ))}
        </div>
    );
}