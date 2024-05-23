import React from 'react';
import styled from 'styled-components';


const NavBar = styled.div`
  display: flex;
  justify-content: space-around;
  background-color: #375cde;
  height: 50px;
  border-radius: 14px;
  width: 100vw;
  min-width: 200px;
  max-width: 600px; 
  margin: auto;
  position: fixed;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
`;
const NavBtn = styled.button`
  border: none;
  outline: none;
  background-color: transparent;
  color: white;
  font-size: 16px;
  cursor: pointer;
`;

function NaverBar() {
  return (
    <NavBar>
      <NavBtn>HOME</NavBtn>
      <NavBtn>내 출결</NavBtn>
      <NavBtn>MY</NavBtn>
    </NavBar>
  );
}

export default NaverBar;
