import React, { useRef, useEffect } from "react";

export default function TextField({ value, onChange, onSend }) { // Add onSend as a prop
    const textareaRef = useRef(null);

    useEffect(() => {
        const textarea = textareaRef.current;
        textarea.style.height = "auto";
        textarea.style.height = `${textarea.scrollHeight}px`;
    }, [value]);

    const handleKeyPress = (event) => {
        if (event.key === "Enter" && !event.shiftKey) { // Check if Enter key is pressed without Shift
            event.preventDefault(); // Prevent new line
            onSend(); // Call the send function
        }
    };

    return (
        <textarea
            id="textField"
            ref={textareaRef}
            value={value}
            onChange={(e) => onChange(e.target.value)}  // Make sure to pass the new value
            placeholder="Pisz..."
            onKeyDown={handleKeyPress} // Add keydown event listener
        />
    );
}