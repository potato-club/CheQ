import React, { useState } from 'react';
import styled from 'styled-components';
import RegisterBar from '../../components/Register';

function ChangeInformationPage () {
  const [thirdChecked, setThirdChecked] = useState(false);
  const [seventhChecked, setSeventhChecked] = useState(false);

  const handleThirdCheckboxChange = () => {
    if (!thirdChecked) {
      setThirdChecked(true);
      setSeventhChecked(false);
    }
  };

  const handleSeventhCheckboxChange = () => {
    if (!seventhChecked) {
      setSeventhChecked(true);
      setThirdChecked(false);
    }
  };
    
    return(
    <div>
        <BigBox>
            <AttendanceTitle>
                <MainTitle>CheQ</MainTitle>
                <SubTitle>정보 수정</SubTitle>
            </AttendanceTitle>    
            <Box1>
                <Box1IdBox>
                    <Box1IdBoxText>
                        <Box1IdBoxTextTag>아이디</Box1IdBoxTextTag>
                    </Box1IdBoxText>
                    <Box1IdLineText>
                        <Box1IdLineTag> 
                            <input type="text" placeholder="학교의 학번을 입력하세요"  maxLength={25} />
                        </Box1IdLineTag>
                    </Box1IdLineText>
                </Box1IdBox>
            </Box1>
            <Box2>
                <Box2PasswordBox>
                    <Box2PasswordText>
                        <Box2PasswordTextTag>비밀번호</Box2PasswordTextTag>
                    </Box2PasswordText>
                    <Box2PasswordLineText>
                        <Box2PasswordLineTag>
                            <input type="text" placeholder="영문+숫자 조합 8자 이상 입력해주세요"  maxLength={25} />
                        </Box2PasswordLineTag>
                    </Box2PasswordLineText>
                </Box2PasswordBox>
            </Box2>
            <Box3>
                <Box3ChapelChairBox>
                    <Box3ChapelChairBoxText>
                        <Box3ChapelChairBoxTextTag>채플좌석</Box3ChapelChairBoxTextTag>
                    </Box3ChapelChairBoxText>
                    <Box3LineText>
                     <Box3LineTextSelectA>
                        {['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'].map((letter) => (
                          <Box3LineTextOption key={letter} value={letter}>
                            {letter}
                          </Box3LineTextOption>
                        ))}
                      </Box3LineTextSelectA>
                      <Box3LineTextSelectB>
                        {Array.from({ length:100 }, (_, index) => index + 1).map((number) => (
                          <Box3LineTextOption key={number} value={number}>
                            {number}
                          </Box3LineTextOption>
                        ))}
                      </Box3LineTextSelectB>
                    </Box3LineText>
                </Box3ChapelChairBox>
            </Box3>
            <Box4>
                <Box4ChapelNumberBox>
                  <Box4ChapelNumberBoxText>
                    <Box4ChapelNumberBoxTextTag>채플종류</Box4ChapelNumberBoxTextTag>
                  </Box4ChapelNumberBoxText>
                  <Box4LineText>
                    <Box4LineTextSelectA>
                      <CheckboxLabel>
                        <CustomCheckbox checked={thirdChecked} onChange={handleThirdCheckboxChange} />
                          3교시
                      </CheckboxLabel>
                    </Box4LineTextSelectA>
                    <Box4LineTextSelectB>
                      <CheckboxLabel>
                        <CustomCheckbox checked={seventhChecked} onChange={handleSeventhCheckboxChange} />
                          7교시
                      </CheckboxLabel>
                    </Box4LineTextSelectB>
                  </Box4LineText>
                </Box4ChapelNumberBox>
            </Box4>
            {/* <Box5>

            </Box5> */}
        </BigBox>
        <RegisterBar/>
    </div>    
    )
}

export default ChangeInformationPage;


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
const SubTitle = styled.h2`
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
    content: '';
    display: block;
    width: 85%;
    height: 2px;
    background-color:#375cde;
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

const Box2 = styled.div`
 display: flex;
 padding: 5px;
 align-items: center;
 justify-content: center;
`;

const Box2PasswordBox = styled.div`
  display: flex;
  width: 100%;
  height: 150px;
  //margin-top: 5px;
  flex-direction: column;
`;

const Box2PasswordText = styled.div`
  display: flex;
  height: 75px;
  justify-content: flex-start;
  align-items: center;  
`;

const Box2PasswordTextTag = styled.h1`
  color: #b5c2ed;
  font-weight: bold;
  font-size: 30px;
  margin-left: 20px;
  margin-top: 25px;
`;

const Box2PasswordLineText = styled.div`
  display: flex;
  height: 75px;
  justify-content: flex-start;
  align-items: center;
  position: relative;
  width: 100%;
`;

const Box2PasswordLineTag = styled.div`
  position: relative;
  width: 100%;
  margin-left: 20px;
  margin-bottom: 25px;
  
  &::after {
    content: '';
    display: block;
    width: 85%;
    height: 2px;
    background-color:#375cde;
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

const Box3 = styled.div`
 display: flex;
 padding: 5px;
 align-items: center;
 justify-content: center;
`;

const Box3ChapelChairBox = styled.div`
  display: flex;
  width: 100%;
  height: 150px;
  //margin-top: 10px;
  flex-direction: column;
`;

const Box3ChapelChairBoxText = styled.div`
  display: flex;
  height: 75px;
  justify-content: flex-start;
  align-items: center;
`;

const Box3ChapelChairBoxTextTag = styled.h1`
  color: #b5c2ed;
  font-weight: bold;
  font-size: 30px;
  margin-left: 20px;
  margin-top: 25px;
`;

const Box3LineText = styled.div`
  display: flex;
  height: 75px;
  justify-content: flex-start;
  align-items: center;
  position: relative;
  flex-direction: row;
  width: 100%;
`;

const Box3LineTextSelectA = styled.select`
  display: flex;
  align-items: center;
  width: 100px; /* Increase width to accommodate the dropdown */
  height: 50px;
  background-color: #375cde;
  border: none;
  border-radius: 20px;
  color: white;
  margin-left: 20px;
  padding: 0 10px;
  font-size: 16px;
  overflow: hidden;
  &::-webkit-scrollbar {
    display: none;
  }
`;

const Box3LineTextSelectB = styled.select`
  display: flex;
  align-items: center;
  width: 100px; /* Increase width to accommodate the dropdown */
  height: 50px;
  background-color: #375cde;
  border: none;
  border-radius: 20px;
  color: white;
  margin-left: 20px;
  padding: 0 10px;
  font-size: 16px;
  overflow: hidden; //스크롤 가리기
  &::-webkit-scrollbar { //Chrome에서 필수
    display: none;
  }
`
const Box3LineTextOption = styled.option`
  background-color: #375cde;
  color: white;
`;


const Box4 = styled.div`
 display: flex;
 padding: 5px;
 align-items: center;
 justify-content: center; 
`;

const Box4ChapelNumberBox = styled.div`
  display: flex;
  width: 100%;
  height: 150px;
  margin-top: 20px;
  flex-direction: column;
`;

const Box4ChapelNumberBoxText = styled.div`
  display: flex;
  height: 75px;
  justify-content: flex-start;
  align-items: center;
`;

const Box4ChapelNumberBoxTextTag = styled.h1`
  color: #b5c2ed;
  font-weight: bold;
  font-size: 30px;
  margin-left: 20px;
  margin-top: 25px;
`;

const Box4LineText = styled.div`
  display: flex;
  height: 75px;
  align-items: center;
  justify-content: flex-start;
  flex-direction: row;
  width: 100%;
  margin-bottom: 10px;
`;

const Box4LineTextSelectA = styled.div`
  display: flex;
  flex-direction: row;
  align-items: center;
  width: 100px;
  height: 50px;
  margin-left: 20px;
  padding: 10px;
  color: white;
`;

const Box4LineTextSelectB = styled.div`
  display: flex;
  flex-direction: row;
  align-items: center;
  width: 100px;
  height: 50px;
  margin-left: 20px;
  padding: 10px;
  color: black;
`;

const CheckboxLabel = styled.label`
  display: flex;
  align-items: center;
  color: #375cde;
  font-size: 20px;
`;

const CustomCheckbox = styled.input.attrs({ type: 'checkbox' })`
  margin-right: 20px;
  width:20px;
  height:20px;
`;


