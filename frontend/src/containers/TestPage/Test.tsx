import React, { useState, useEffect } from 'react';
import axios from 'axios';
import styled from "styled-components";

function TestPage() {
  const [inputValue, setInputValue] = useState("");
  const [token, setToken] = useState<string | null>(null); // 토큰 값을 저장할 상태 (토큰이 존재하면 setToken을 통해 상태를 저장하고 토큰이 없다면 로그인 요청메세지나오게하기)

  // 컴포넌트가 마운트될 때 localStorage에서 토큰을 불러옴
  useEffect(() => {
    const savedToken = localStorage.getItem("token");
    console.log("Loaded token from localStorage:", savedToken); // 저장된 토큰을 확인하기 위한 로그
    if (savedToken) {
      setToken(savedToken);
    } else {
      alert("로그인 후 기기 등록을 진행해주세요.");
    }
  }, []);

  // 입력 값 변경 시 호출되는 핸들러
  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setInputValue(e.target.value);
  };

  // 폼 제출 시 호출되는 핸들러
  const handleUpdate = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault(); // 페이지 새로고침 방지

    // 토큰이 없는 경우, 처리 중단
    if (!token) {
      alert("유효한 토큰이 없습니다. 다시 로그인해주세요.");
      return;
    }

    // PUT 요청을 통해 기기 ID 업데이트
    axios
      .put(
        `http://dual-kayla-gamza-9d3cdf9c.koyeb.app/user/device`, 
        { uuId: inputValue },
        {
          headers: {
            Authorization: `Bearer ${token}`, // 토큰을 Authorization 헤더에 포함
          }
        }
      )
      .then(response => {
        console.log("Update successful:", response.data);
        alert("기기 등록이 완료되었습니다!");
      })
      .catch(error => {
        console.error("기기 업데이트 중 오류가 발생했습니다:", error);
        alert("기기 등록 중 오류가 발생했습니다.");
      })
      .finally(() => {
        console.log("Update request completed.");
      });
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
                  placeholder="기기 ID 입력" 
                />
                  <button type="submit">Update</button>
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
`;
