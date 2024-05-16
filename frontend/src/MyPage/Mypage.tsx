import React from 'react';
import styled from 'styled-components';
import Nav from '../UnderNavBar/NaverBar';
import QRImage from '../Image/qr -1004.png';

const BigBox = styled.div`
  display: flex;
  flex-direction: column;
  width: 390px;
  height: 100vh;
  min-width: 200px;
  max-width: 600px;
  margin: 0 auto;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
`;

const AttendanceTitle = styled.div`
    display: flex;
    align-items: center;
    width: 200px;
    margin-left: 20px;
    margin-top: 3px;
    justify-content: space-between;
    margin-bottom: 15px;
`;
const MainTitle = styled.h1`
    color: #375cde;
`;
const SubTitle = styled.h3`
    color: #375cde;
`;

const SquareA = styled.div`
  width: 80%;
  height: 10px; /* SquareA의 높이를 고정 */
  display: flex;
  border-radius: 20px;
  flex-direction: row;
  justify-content: center;
  //align-items: center;
  padding-bottom: 120px;
  margin-left: 38px;
  margin-right: 38px;
  margin-bottom: 20px; //SquareA 와 SquareB 부분 여백주기
  position: relative;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
  &:hover {
    cursor: pointer;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.4);
    transform: scale(1);
  }
`;

const SquareB = styled.div`
  width: 80%;
  height: 500px;
  display: flex;
  flex-direction: column; //세로로 네모 나누기
  margin-left: 38px;
  margin-right: 38px;
  margin-bottom: 20px; //SquareB와 SquareC 여백주기
  justify-content: center;
  border-radius: 20px;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
    &:hover {
    cursor: pointer;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.4);
    transform: scale(1);
  }
`;

const SquareC = styled.div`
  width: 80%;
  height: 150px;
  border-radius: 20px;
  margin-left: 38px;
  margin-right: 38px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
    &:hover {
    cursor: pointer;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.4);
    transform: scale(1);
  }
`;

const ProfilBox = styled.div`
  width:45%;
  height:100%; /* SquareA의 높이에 맞추기 위해 100%로 설정 */
  margin-right: 15px;
  margin-left: 85px;
  margin-top: 20px;
  margin-bottom: 20px;
  padding: 40px;
  display: flex;
  justify-content: center;
  align-items: center;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
    &:hover {
    cursor: pointer;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.4);
    transform: scale(1);
  }  
`;

const ProfilContentBox = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
  width:30%;
  height:100%; /* SquareA의 높이에 맞추기 위해 100%로 설정 */
  margin-right: 80px;
  margin-top: 20px;
  padding: 40px;
  /* box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1); */
`;

const ProfilContentBoxA = styled.div`
  display: flex;
  align-items: center;
  width:100%;
  height:100%;
  margin-top: 10px;
  margin-bottom: 13px;
  margin-right: 30px;
  font-size:12px;
  font-weight: bold;
  white-space: nowrap; /* 텍스트가 공간을 벗어나지 않도록 설정 */
`;

const ProfilContentBoxB = styled.div`
  display: flex;
  align-items: center;
  width:100%;
  height:100%;
  margin-bottom: 13px;
  margin-right: 30px;
  white-space: nowrap; /* 텍스트가 공간을 벗어나지 않도록 설정 */
  font-size:12px;
  font-weight: bold;
`;

const ProfilContentBoxC = styled.div`
  display: flex;
  align-items: center;
  width:100%;
  height:100%;
  white-space: nowrap; /* 텍스트가 공간을 벗어나지 않도록 설정 */
  font-size:12px;
  font-weight: bold;
  margin-bottom: 13px;
  margin-right: 30px;
`;

const ProfilContentBoxD = styled.div`
  display: flex;
  align-items: center;
  width:100%;
  height:100%;
  margin-bottom: 13px;
  margin-right: 30px;
  white-space: nowrap; /* 텍스트가 공간을 벗어나지 않도록 설정 */
  font-size:12px;
  font-weight: bold;
`;

const ProfilContentNameTag = styled.div`
  display: flex;
  justify-content: flex-end; /* 왼쪽에 글씨를 고정하기 위해 flex-end로 설정 */
  align-items: center;
  width:auto;
  height:100%;
  margin-right: 20px;
  font-weight: bold;
  /* box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1); */
`;

const SquareBboxA = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 25%; /* 반반으로 나누기 */
  margin-bottom: 20px;
  /* box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);  */
`;

const SquareBboxAText = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  width: auto;
  font-weight: bold;
  font-size: 12px;
  height: 100%;
  margin-top: 5px;
  margin-right: 220px;
  /* box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);  */
`;

const SquareBboxB = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 75%; /* 반반으로 나누기 */
  border-radius: 20px;
  /* box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);  */
`;

const SquareBboxBQr = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  width: 60%;
  height: 80%;
  margin-bottom: 15px;
  border-radius: 20px;
  overflow: hidden;
  position: relative;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1); 
    &:hover {
    cursor: pointer;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.4);
    transform: scale(1);
  }  
`;

const QRImageStyled = styled.img`
  width: 100%;
  height: 100%;
  object-fit: cover; /* 이미지를 컨테이너에 꽉 차도록 함 */
`;

const SquareCboxA = styled.div`
  display: flex;
  flex-direction: center;
  align-items: center;
  width:100%;
  height:60px;
  margin-top: 15px;
  margin-bottom: 10px;
`;
const SquareCboxB = styled.div`
  display: flex;
  flex-direction: center;
  align-items: center;
  width:100%;
  height:60px;
  margin-top: 10px;
  margin-bottom: 10px;
`;

const SquareCboxC = styled.div`
  display: flex;
  flex-direction: center;
  align-items: center;
  width:100%;
  height:60px;
  margin-bottom: 15px;
`; 

const SquareCboxText = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  width: auto;
  font-weight: bold;
  font-size: 12px;
  height: 100%;
  margin-top: 5px;
  margin-left: 15px;
  margin-bottom: 5px;
`;


const LineA = styled.div`
  width: auto; /* Same width as SquareB */
  height: 1px;
  background-color: #ccc; /* Color of the line */
  margin-left: 10px; /* Same left position as SquareB */
  margin-right: 10px;
  position: relative;
  top: -15px/* Move the line above by 5 pixels */
`;

const LineB = styled.div`
  width: 100%;
  height: 1px;
  background-color: #ccc;
  top: -5px;
`;

function Mypage(){
  // 텍스트 길이를 10으로 제한하는 함수
  const limitText = (text: string) => {
      if (text.length > 10) {
          return text.substring(0, 10) + '...';
      }
      return text;
  };

  return(
      <BigBox>
         <AttendanceTitle>
              <MainTitle>CheQ</MainTitle>
              <SubTitle>마이 페이지</SubTitle>
         </AttendanceTitle>
         <SquareA>
              <ProfilBox>
                 {/* <사진 넣을예정> */}
              </ProfilBox>
              <ProfilContentBox>
                    <ProfilContentBoxA>
                      <ProfilContentNameTag>학번| </ProfilContentNameTag>
                      {limitText('202110034')}
                    </ProfilContentBoxA>
                    <ProfilContentBoxB>
                      <ProfilContentNameTag>전공| </ProfilContentNameTag>
                      {limitText('컴퓨터공학과')}
                    </ProfilContentBoxB>
                    <ProfilContentBoxC>
                      <ProfilContentNameTag>채플| </ProfilContentNameTag>
                      {limitText('3교시')}
                    </ProfilContentBoxC>
                    <ProfilContentBoxD>
                      <ProfilContentNameTag>좌석| </ProfilContentNameTag>
                      {limitText('H32')}
                    </ProfilContentBoxD>
              </ProfilContentBox>
         </SquareA>
         <SquareB>
              <SquareBboxA>
                <SquareBboxAText>내 QR코드</SquareBboxAText>
              </SquareBboxA>
              <LineA />
              <SquareBboxB>
                <SquareBboxBQr> 
                  <QRImageStyled src={QRImage} alt="QR Code" />
                </SquareBboxBQr>
              </SquareBboxB>   
         </SquareB>
         <SquareC>
             <SquareCboxA>
               <SquareCboxText >푸시 알람설정</SquareCboxText>
             </SquareCboxA>
                <LineB />
             <SquareCboxB>
               <SquareCboxText >앱 설정</SquareCboxText>
             </SquareCboxB>
                <LineB />
             <SquareCboxC>
              
             </SquareCboxC>
        </SquareC>
         
         <Nav /> 
      </BigBox>
  );
}

export default Mypage;