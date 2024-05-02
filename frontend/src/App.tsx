import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import Mainpage from './Mainpage/Mainpage';

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Mainpage />} />

      </Routes>
    </Router>
  );
}

export default App;

//path에는 "/"" 사용해줘야 한다.
