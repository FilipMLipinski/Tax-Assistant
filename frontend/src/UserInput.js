import React, { useState } from "react";
import TextField from "./TextField";
import SendButton from "./SendButton";

export default function UserInput({ onSend }) {
    const [inputValue, setInputValue] = useState("");

    const handleSend = () => {
        if (inputValue.trim()) {
            onSend(inputValue);
            setInputValue(""); // Clear the input after sending the message
        }
    };

    return (
        <div id="userInput">
            <TextField value={inputValue} onChange={setInputValue} />
            <SendButton onClick={handleSend} />
        </div>
    );
}