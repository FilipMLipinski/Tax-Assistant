import React, { useEffect, useState } from "react";
import { io } from "socket.io-client";
import "./DocumentWindow.css"; // Link to the CSS file

export default function DocumentWindow() {
    return (
        <div id="documentWindow">
            <DocumentRenderer />
            <div id="buttonContainer"> {/* New div to contain the button */}
                <DownloadXMLButton />
            </div>
        </div>
    );
}

function DocumentRenderer() {
    const [htmlContent, setHtmlContent] = useState(null);
    const [error, setError] = useState(null);

    // Initialize socket connection
    const socket = io("http://localhost:5000"); // Adjust if necessary

    useEffect(() => {
        const loadAndTransformXml = async () => {
            try {
                // Load the XML file
                const xmlDefaultResponse = await fetch("/pusty.xml");
                const xmlDefaultText = await xmlDefaultResponse.text();

                const xmlResponse = await fetch("http://localhost:5000/api/get_xml");
                const xmlResponseJson = await xmlResponse.json();
                const xmlText = xmlResponseJson['response'];

                // Load the XSL file
                const xslResponse = await fetch("/xsd/styl.xsl");
                const xslText = await xslResponse.text();

                let transformedHtml = "";
                if (xmlText === "none") {
                    transformedHtml = transformXml(xmlDefaultText, xslText);
                } else {
                    transformedHtml = transformXml(xmlText, xslText);
                }
                setHtmlContent(transformedHtml);
            } catch (err) {
                console.error("Error loading XML:", err);
                setError("Error loading XML or XSL file.");
            }
        };

        // Load initial XML data
        loadAndTransformXml();

        // Listen for 'xml_ready' event
        socket.on('xml_ready', () => {
            console.log("Received xml_ready event, reloading XML...");
            loadAndTransformXml(); // Reload XML when notified
        });

        // Cleanup the socket on component unmount
        return () => {
            socket.off('xml_ready'); // Remove the listener
            socket.disconnect(); // Optionally disconnect when the component unmounts
        };
    }, [socket]);

    const transformXml = (xmlText, xslText) => {
        const parser = new DOMParser();
        const xmlDoc = parser.parseFromString(xmlText, "application/xml");
        const xslDoc = parser.parseFromString(xslText, "application/xml");

        if (xmlDoc.getElementsByTagName("parsererror").length > 0 ||
            xslDoc.getElementsByTagName("parsererror").length > 0) {
            throw new Error("Error parsing XML or XSL.");
        }

        const xsltProcessor = new XSLTProcessor();
        xsltProcessor.importStylesheet(xslDoc);
        const resultDocument = xsltProcessor.transformToFragment(xmlDoc, document);

        const wrapper = document.createElement("div");
        wrapper.appendChild(resultDocument);
        return wrapper.innerHTML;
    };

    // Reset the body styles after setting the content
    useEffect(() => {
        if (htmlContent) {
            console.log("Transformed HTML content: ", htmlContent);
            
            // Reset body styles after the content is loaded
            document.body.style.margin = "0";
            document.body.style.padding = "0";
            document.body.style.overflowX = "hidden"; // Prevent horizontal scrolling
        }
    }, [htmlContent]);

    return (
        <div id="documentRenderer">
            {error && <p style={{ color: "red" }}>{error}</p>}
            {htmlContent ? (
                <div className="scrollableContent" dangerouslySetInnerHTML={{ __html: htmlContent }} />
            ) : (
                <p>Loading XML data...</p>
            )}
        </div>
    );
}

function DownloadXMLButton() {
    const handleDownload = async () => {
        try {
            const response = await fetch("/jacht.xml"); // Adjust path if necessary
            const blob = await response.blob(); // Get the XML as a blob
            const url = window.URL.createObjectURL(blob); // Create a URL for the blob
            const a = document.createElement('a'); // Create a temporary anchor element
            a.href = url;
            a.download = 'jacht.xml'; // Set the desired file name
            document.body.appendChild(a); // Append the anchor to the body
            a.click(); // Simulate a click on the anchor to trigger download
            a.remove(); // Remove the anchor from the document
            window.URL.revokeObjectURL(url); // Cleanup the URL object
        } catch (error) {
            console.error("Error downloading XML:", error);
        }
    };

    return (
        <button id="xmlButton" onClick={handleDownload}>
            Pobierz XML
        </button>
    );
}
