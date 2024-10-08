import React, { useState, useEffect, useRef } from 'react';
import Conversation from './Conversation';
import UserInput from './UserInput';

export default function ChatWindow() {
    const [messages, setMessages] = useState([]);
    const hasGreeted = useRef(false);  // Ref to track if greeting has been sent

    const addMessage = (message) => {
        setMessages((prevMessages) => [
            ...prevMessages,
            { sender: "user", text: message },
        ]);

        // Wyślij zapytanie do backendu Flask
        fetch('http://localhost:5000/api/chat_assistant', {
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

    // Add initial greeting message when the component mounts
    useEffect(() => {
        if (!hasGreeted.current) {
            const greetingMessage = "Witam! w czym mogę pomóc?"
            const userMessage = "Mam taką sprawę... <użytkownik podaje kontekst>";
            const botMessage = "Rozumiem, że potrzebuje Pan/Pani wypełnić formularz PCC-3. Już go pokazuję, po prawej stronie. Z chęcią go wypełnię, ale potrzebuję więcej informacji. Proszę podać swój PESEL, imię i nazwisko.";
            
            // Set both messages in the state
            setMessages((prevMessages) => [
                ...prevMessages,
                { sender: "bot", text: botMessage },
            ]);
            hasGreeted.current = true;  // Mark greeting as sent
        }
    }, []); // Empty array ensures the effect runs only once

    return (
        <div id="chatWindow">
            <Conversation messages={messages} />
            <UserInput onSend={addMessage} />
        </div>
    );
}
