import React, { useRef, useEffect } from "react";

export default function TextField({ value, onChange }) {
    const textareaRef = useRef(null);

    useEffect(() => {
        const textarea = textareaRef.current;
        textarea.style.height = "auto";
        textarea.style.height = `${textarea.scrollHeight}px`;
    }, [value]);

    return (
        <textarea
            id="textField"
            ref={textareaRef}
            value={value}
            onChange={(e) => onChange(e.target.value)}  // Make sure to pass the new value
            placeholder="Type your message..."
        />
    );
}