import React, { useState, useEffect } from 'react';
import axios from 'axios';
import styled from "styled-components";

function TestPage() {
  const [inputValue, setInputValue] = useState("");
  const [token, setToken] = useState<string | null>(null); 
  const [primaryKey, setPrimaryKey] = useState<string | null>(null); 

  // 컴포넌트가 마운트될 때 localStorage에서 토큰과 Primary Key를 불러옴
  useEffect(() => {
    const savedToken = localStorage.getItem("at");
    const savedPrimaryKey = localStorage.getItem("primaryKey");

    if (savedToken) {
      setToken(savedToken);
      console.log("Loaded token from localStorage:", savedToken);
    }

    if (savedPrimaryKey) {
      setPrimaryKey(savedPrimaryKey);
      console.log("Loaded primaryKey from localStorage:", savedPrimaryKey);
    }
  }, []);

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setInputValue(e.target.value);
  };

  const handleUpdate = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    // 토큰 또는 Primary Key가 없을 경우 경고 메시지 표시
    if (!token) {
      alert("유효한 토큰이 없습니다. 다시 로그인해주세요.");
      return;
    }

    // if (!primaryKey) {
    //   alert("Primary Key를 찾을 수 없습니다. 다시 시도해주세요.");
    //   return;
    // }

    try {
      // Primary Key를 URL의 마지막에 추가하여 PUT 요청
      const response = await axios.put(
        `http://dual-kayla-gamza-9d3cdf9c.koyeb.app/user/device/}`, 
        { uuid: inputValue }, 
        { headers: { AT: token } }
      );

      console.log("Update successful:", response.data);
      alert("기기 등록이 완료되었습니다!");
    } catch (error) {
      console.error("기기 업데이트 중 오류가 발생했습니다:", error);
      alert("기기 등록 중 오류가 발생했습니다.");
    }
  };
  
  return (
    <div>
      <BigBox>
        <AttendanceTitle>
          <MainTitle>CheQ</MainTitle>
          <SubTitle>기기등록</SubTitle>
        </AttendanceTitle>

        <Box1>
          <Box1IdBox>
            <form onSubmit={handleUpdate}>
              <Box1IdBoxText>
                <Box1IdBoxTextTag>등록</Box1IdBoxTextTag>
              </Box1IdBoxText>
              <Box1IdLineText>
                <Box1IdLineTag>
                <input 
                  type="text" 
                  value={inputValue} 
                  onChange={handleInputChange} 
                  placeholder="Device UUID 입력" 
                />
                <button type="submit" className="submit-button">등록</button>
                </Box1IdLineTag>
              </Box1IdLineText>
            </form>
          </Box1IdBox>
        </Box1>
      </BigBox>
    </div>
  );
}
export default TestPage;

const BigBox = styled.div`
  display: flex;
  flex-direction: column;
  margin: auto;
  width: 100vw;
  min-width: 200px;
  max-width: 580px;
  padding: 0px 20px 73px 20px;
`;

const AttendanceTitle = styled.div`
  display: flex;
  align-items: center;
`;
const MainTitle = styled.h1`
  color: #375cde;
  margin-right: 28px;
`;
const SubTitle = styled.h3`
  color: #375cde;
`;

const Box1 = styled.div`
  display: flex;
  padding: 5px;
  align-items: center;
  justify-content: center;
`;

const Box1IdBox = styled.div`
  display: flex;
  width: 100%;
  height: 150px;
  //margin-top: 5px;
  flex-direction: column;
`;

const Box1IdBoxText = styled.div`
  display: flex;
  height: 75px;
  justify-content: flex-start;
  align-items: center;
`;

const Box1IdBoxTextTag = styled.h1`
  color: #b5c2ed;
  font-weight: bold;
  font-size: 30px;
  margin-left: 20px;
  margin-top: 25px;
`;

const Box1IdLineText = styled.div`
  display: flex;
  height: 75px;
  justify-content: flex-start;
  align-items: center;
  position: relative;
  width: 100%;
`;

const Box1IdLineTag = styled.div`
  position: relative;
  width: 100%;
  margin-left: 20px;
  margin-bottom: 25px;

  &::after {
    content: "";
    display: block;
    width: 85%;
    height: 2px;
    background-color: #375cde;
    bottom: 0;
    left: 0;
  }

  input {
    width: calc(100% - 100px); /* Adjust for padding/margin */
    border: 0; //테두리 없애기
    background: transparent; //입력 필드의 배경을 투명하게
    color: #375cde; //내부 입력 글씨 색상 검은색
    font-size: 16px;
    font-weight: bold;
    padding: 3px;
    outline: none;
    z-index: 1; //입력 필드가 맨 위에 오도록 의사 요소 위에 입력 필드의 스택 순서 설정
  }

  input::placeholder {
    color: #375cde;
    font-weight: bold;
  }

  .submit-button {
  background-color: #007bff; /* 버튼 배경색 */
  color: white; /* 텍스트 색상 */
  border: none; /* 테두리 없음 */
  padding: 5px; /* 여백 */
  font-size: 16px; /* 폰트 크기 */
  cursor: pointer; /* 커서 모양 */
  border-radius: 5px; /* 모서리 둥글기 */
  background-color: #007bff;
}

.submit-button:hover {
  background-color: #0056b3; /* 호버 시 배경색 */
}
`;
