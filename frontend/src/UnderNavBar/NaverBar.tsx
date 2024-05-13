import React from 'react';
import styled from 'styled-components';


const NavBarContainer = styled.div`
  display: flex;
  justify-content: space-around;
  background-color: #375cde;
  height: 80px;
  border-radius: 14px;
  width: 390px;
  margin: auto;
`;

const NavBtn = styled.button`
  border: none;
  outline: none;
  background-color: transparent;
  color: white;
  font-size: 16px;
  &:hover {
    cursor: pointer;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.4);
    transform: scale(1);
  }
`;

function NaverBar() {
  return (
    <NavBarContainer>
      <NavBtn>HOME</NavBtn>
      <NavBtn>내 출결</NavBtn>
      <NavBtn>MY</NavBtn>
    </NavBarContainer>
  );
}

export default NaverBar;
