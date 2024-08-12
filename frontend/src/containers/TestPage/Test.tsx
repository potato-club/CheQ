import React from "react";
import styled from "styled-components";

function TestPage() {
  return (
    <div>
      <BigBox>
          <AttendanceTitle>
            <MainTitle>CheQ</MainTitle>
            <SubTitle>기기등록</SubTitle>
          </AttendanceTitle>
        
          <Box1>
          <Box1IdBox>
            <Box1IdBoxText>
              <Box1IdBoxTextTag>등록</Box1IdBoxTextTag>
            </Box1IdBoxText>
            <Box1IdLineText>
              <Box1IdLineTag>
                <input
                  type="text"
                  // placeholder="학교의 학번을 입력하세요"
                  maxLength={25}
                />
              </Box1IdLineTag>
            </Box1IdLineText>
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
