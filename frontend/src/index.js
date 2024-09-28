import React from "react";
import ReactDom from "react-dom";

import App from "./App";
import './styles.css';

const root = ReactDom.createRoot(document.getElementById("root"));
root.render(
  <React.StrictMode>
  <link rel="stylesheet" href="styles.css"></link>
    <App />
  </React.StrictMode>
);