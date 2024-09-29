import React, { useEffect, useState } from "react";
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

    useEffect(() => {
        const loadAndTransformXml = async () => {
            try {
                // Load the XML file
                const xmlResponse = await fetch("/jacht.xml");
                const xmlText = await xmlResponse.text();

                // Load the XSL file
                const xslResponse = await fetch("/xsd/styl.xsl");
                const xslText = await xslResponse.text();

                // Transform XML using XSL
                const transformedHtml = transformXml(xmlText, xslText);
                setHtmlContent(transformedHtml);
                console.log(transformedHtml);
            } catch (err) {
                console.log(err);
                setError("Error loading XML or XSL file.");
            }
        };

        loadAndTransformXml();
    }, []);

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

    return (
        <div id="documentRenderer">
            {error && <p style={{ color: "red" }}>{error}</p>}
            {htmlContent ? (
                <div className="scrollable-content" dangerouslySetInnerHTML={{ __html: htmlContent }} />
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