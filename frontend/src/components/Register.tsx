import React, { useState, useEffect } from "react";
import styled from "styled-components";

function Register() {
  const [alertMessage, setAlertMessage] = useState("");

  const handleRegisterClick = () => {
    setAlertMessage("수정이 완료되었습니다");
  };

  useEffect(() => {
    if (alertMessage) {
      alert(alertMessage);
      setAlertMessage(""); // 알람을 표시한 후 메시지 초기화
    }
  }, [alertMessage]);

  return (
    <div>
      <RegisterBar>
        <RegisterBtn onClick={handleRegisterClick}>수정</RegisterBtn>
      </RegisterBar>
    </div>
  );
}

export default Register;

const RegisterBar = styled.div`
  display: flex;
  justify-content: center;
  background-color: #375cde;
  height: 80px;
  border-radius: 14px;
  width: 100vw;
  min-width: 200px;
  max-width: 620px;
  padding: 0px 20px 0px 20px;
  margin: auto;
  position: fixed;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
`;

const RegisterBtn = styled.button`
  border: none;
  outline: none;
  background-color: transparent;
  color: white;
  font-size: 20px;
  cursor: pointer;
`;
