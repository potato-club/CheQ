import React from "react";
import Mainpage from "./page/Mainpage";
import Mypage from "./page/Mypage";
import Attendance from "./page/Attendance";
import Admin from "./page/Admin";
import Login from "./page/Login";
import ReactDOM from "react-dom";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/main" element={<Mainpage />} />
        <Route path="/Mypage" element={<Mypage />} />
        <Route path="/" element={<Login />} />
        <Route path="/attendance" element={<Attendance />} />
        <Route path="/admin" element={<Admin />} />
      </Routes>
    </Router>
  );
}

export default App;
