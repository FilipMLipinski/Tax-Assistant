import React from "react";

export default function SendButton({ onClick }) {
    return (
        <button id="sendButton" onClick={onClick}>
            Wyślij
        </button>
    );
}