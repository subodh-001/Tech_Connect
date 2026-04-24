// SmartTech Connect v2.1.0 - full project update April 2025
// Performance optimized | April 24, 2025
import React from "react";
import { AuthProvider } from "./contexts/NewAuthContext";
import Routes from "./Routes";

function App() {
  return (
    <AuthProvider>
      <Routes />
    </AuthProvider>
  );
}

export default App;