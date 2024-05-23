import React from 'react';
import styled from 'styled-components';
import Nav from '../UnderNavBar/NaverBar';
import QRImage from '../Image/qr -1004.png';

const BigBox = styled.div`
  display: flex;
  flex-direction: column;
  width: 100vw;
  height: 100vh;
  min-width: 200px;
  max-width: 600px;
  margin: 0 auto;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
`;
//BigBox를 2개의 박스로 만들어서 AttendanceTitle부분 박스와 SquareA B C 박스가 들어갈 박스 총
const AttendanceTitle = styled.div`
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 260px;
  margin-right: 250px;
  margin-top: 35px;
`;

const MainTitle = styled.h1`
    color: #375cde;
`;
const SubTitle = styled.h3`
    color: #375cde;
`;

const SquareA = styled.div`
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 30%;
  /* box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
     2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1); */
`;

const SquareAboxA = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  width:100%;
  height:15%;
  margin-bottom: 15px;
  /* box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1); */
`
const SquareAboxB = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  width:100%;
  height:85%;
  
  /* box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1); */
`;

const SquareAboxBinformationbox = styled.div`
  display:flex;
  justify-content: center;
  flex-direction: row;
  align-items: center;
  width:80%;
  height:70%;
  border-radius: 20px;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
`;

const ProfilBox = styled.div`
  width:20%;;
  height:80%; 
  display: flex;
  justify-content: center;
  align-items: center;
  margin-right: 50px;
  border-radius: 20px;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
`;

const ProfilContentBox = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
  gap: 5px;
  width:40%;
  height:80%;
  margin-right: 50px;
  /* box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1); */
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

const ProfilContentBoxA = styled.div`
  display: flex;
  align-items: center;
  width:100%;
  height:100%;
  font-size:12px;
  font-weight: bold;
  white-space: nowrap; /* 텍스트가 공간을 벗어나지 않도록 설정 */
`;

const ProfilContentBoxB = styled.div`
  display: flex;
  align-items: center;
  width:100%;
  height:100%;
  font-size:12px;
  font-weight: bold;
  white-space: nowrap; /* 텍스트가 공간을 벗어나지 않도록 설정 */
`;

const ProfilContentBoxC = styled.div`
  display: flex;
  align-items: center;
  width:100%;
  height:100%;
  font-size:12px;
  font-weight: bold;
  white-space: nowrap; /* 텍스트가 공간을 벗어나지 않도록 설정 */
`;

const ProfilContentBoxD = styled.div`
  display: flex;
  align-items: center;
  width:100%;
  height:100%;
  font-size:12px;
  font-weight:bold;
  white-space: nowrap; /* 텍스트가 공간을 벗어나지 않도록 설정 */
  `;

const SquareB = styled.div`
  display:flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 70%;
  flex-direction: column;
` ; 
const SquareBboxA = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 65%;
  flex-direction: column;
`;

const SquareBboxAQRBox = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  width:80%;
  aspect-ratio: 1 / 1; //1대1비율 쓰기위해서는 width를 지정해주면 그거에 맞게 1대1비율로 높이가 지정된다.
  flex-direction: column;
  border-radius: 20px; 
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
`;

const SquareBboxAQRBoxA = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  width:100%;
  height:20%;
  border-radius: 20px;
  /* box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1); */
`;

const SquareBboxAQRBoxAtext = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  width: auto;
  font-weight: bold;
  font-size: 12px;
  height: 100%;
  position: relative; //정적위치시킬때
  left: -150px;
  /* box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);  */
`;

const SquareBboxAQRBoxB = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  width:100%;
  height:80%;
  border-radius: 20px;
  /* box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1); */
`;

const SquareBboxAQRBoxBqr = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  width: 45%;
  aspect-ratio: 1 / 1; //1대1 비율
  overflow: hidden;
  border-radius: 20px;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1); 
    &:hover {
    cursor: pointer;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.4);
    transform: scale(1);
  }  
`;

const Divider = styled.div`
  width: 95%;
  height: 2px; /* 두께 조정 */
  background-color: #e8e5e5; /* 색상 조정 */
`;

const QRImageStyled = styled.img`
  width: 100%;
  height: 100%;
  object-fit: cover; /* 이미지를 컨테이너에 꽉 차도록 함 */
`;

const SquareBboxB = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 35%;
  flex-direction: column;
  /* box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);  */
`;

const SquareBboxBsetting = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  width: 80%;
  height: 80%;
  border-radius: 20px;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1); 
`;

const SquareBboxBsettingA = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
  width: 90%;
  height: 80%;
  border-radius: 20px;
  /* box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);  */
 `;

const SquareBboxBsettingA1 = styled.div`
  display: flex;
  justify-content: flex-start;
  align-items: center;
  width: 100%;
  height: 50%;
  margin-left: 25px;
  /* box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);    */
`;

const SquareBboxsettingA1text = styled.div`
  display: flex;
  justify-content:center;
  align-items: center;
  width: auto;
  height: 100%;
  font-size: 12px;
  font-weight: bold;
  /* box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);    */
`;

const SquareBboxBsettingA2 = styled.div`
  display: flex;
  justify-content: flex-start;
  align-items: center;
  width: 100%;
  height: 50%;
  margin-left: 35px;
  /* box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);  */
`;

const SquareBboxsettingA2text = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  width: auto;
  height: 100%;
  font-size: 12px;
  font-weight: bold;
  /* box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);    */
`;

const SquareBboxBsettingA3= styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 50%;
  /* box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);  */
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

           <SquareA>
             <SquareAboxA>
                <AttendanceTitle>
                  <MainTitle>CheQ</MainTitle>
                  <SubTitle>마이 페이지</SubTitle>
                </AttendanceTitle>
             </SquareAboxA> 
             <SquareAboxB> 
             <SquareAboxBinformationbox>      
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
            </SquareAboxBinformationbox>  
            </SquareAboxB>   
         </SquareA> 
         <SquareB>
            <SquareBboxA>
              <SquareBboxAQRBox>
                <SquareBboxAQRBoxA>
                  <SquareBboxAQRBoxAtext>내 QR코드</SquareBboxAQRBoxAtext>
                </SquareBboxAQRBoxA>
                  <Divider />
                <SquareBboxAQRBoxB>
                  <SquareBboxAQRBoxBqr> 
                    <QRImageStyled src={QRImage} alt="QR Code" />
                  </SquareBboxAQRBoxBqr>
                </SquareBboxAQRBoxB>
              </SquareBboxAQRBox>
            </SquareBboxA>
            <SquareBboxB> 
              <SquareBboxBsetting>
                <SquareBboxBsettingA>
                  <SquareBboxBsettingA1>
                    <SquareBboxsettingA1text>푸시 알림 설정</SquareBboxsettingA1text>
                  </SquareBboxBsettingA1>
                  <Divider />
                  <SquareBboxBsettingA2>
                   <SquareBboxsettingA2text>앱 설정</SquareBboxsettingA2text>
                  </SquareBboxBsettingA2>
                  <Divider />
                  <SquareBboxBsettingA3> </SquareBboxBsettingA3>
                </SquareBboxBsettingA>
              </SquareBboxBsetting>
            </SquareBboxB>
         </SquareB>
         
         
         <Nav /> 
      </BigBox>
  );
}

export default Mypage;