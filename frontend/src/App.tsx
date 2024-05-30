import React from 'react';
import Mainpage from './page/Mainpage';
import Mypage from './page/Mypage';
import Attendance from "./page/Attendance";
import Login from "./page/Login";
import Change from "./page/ChangeInformation";
import ReactDOM from "react-dom";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Mainpage />} />
        <Route path="/Mypage" element={<Mypage />}/>
        <Route path="/login" element={<Login />} />
        <Route path="/attendance" element={<Attendance />} />
        <Route path="/change" element={<Change/>} />
      </Routes>
    </Router>
  );
}

export default App;


