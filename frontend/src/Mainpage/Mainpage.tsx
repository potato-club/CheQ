import React from 'react';
import styled from 'styled-components';

const BigBox = styled.div`
  display: flex;
  height: 100vh;
  max-width: 30%; /* 최대 너비를 설정합니다. */
  margin: 0 auto; /* 가운데 정렬을 위해 좌우 마진을 자동으로 설정합니다. */
  background-color: #e0dbdb;
`;

const Square = styled.div`
  width: 100%;
  height: 35%; 
  background-color: #5959eb;
  display: flex;
`;

const Text = styled.div`
  color: white; 
  font-size: 30px; 
  font-weight: bold; 
  margin-left: 20px;
  margin-right: 20px; 
  margin-top: 20px;
`;

function Mainpage() {
  return (
    <BigBox>
      <Square>
        <Text>CheQ</Text>
      </Square>
    </BigBox>
  );
}

export default Mainpage;




