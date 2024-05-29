import React, { useState, useEffect } from 'react';
import styled from 'styled-components';
import Nav from '../UnderNavBar/NaverBar';
// import Slider from 'react-slick';
//import Nav from '../UnderNavBar/NaverBar';
// import 'slick-carousel/slick/slick.css';
// import 'slick-carousel/slick/slick-theme.css';

const images = [
  'https://pimg.hackers.com/land/main/land_default.jpg',
  'https://i.ytimg.com/vi/zvTgwgams-Q/maxresdefault.jpg',
  'https://cdn.autotribune.co.kr/news/photo/202312/11209_56884_5312.png',
  'https://cdn.bosa.co.kr/news/photo/202206/2174709_206247_5859.png'
];

function Mainpage() {
  const [currentImageIndex, setCurrentImageIndex] = useState(0);

  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentImageIndex((prevIndex) => (prevIndex === images.length - 1 ? 0 : prevIndex + 1));
    }, 5000);

    return () => clearInterval(interval); // 정리 함수 추가
  }, []);
  
  return(
    <div>
      <BigBox>
        <Box1>
          <AttendanceTitle>
           <MainTitle>CheQ</MainTitle> 
          </AttendanceTitle>
        </Box1>
        <Box2>
          <Box2Advertisement>
            <AdvertisementImage src={images[currentImageIndex]} alt="Advertisement" />
          </Box2Advertisement>
        </Box2>
        <Box3A>
          <Box3Atext>
            <Box3AtextTitle>현재 출결 현황</Box3AtextTitle>
          </Box3Atext>
        </Box3A>
        <Line />
        <Box3B>
          <Box3BCircle>
            <Box3BCircleA></Box3BCircleA>
            <Box3BCircleB></Box3BCircleB>
            <Box3BCircleC></Box3BCircleC>
            <Box3BCircleD></Box3BCircleD>
            <Box3BCircleE></Box3BCircleE>
          </Box3BCircle>
        </Box3B>
        <Box4>
          <Box4MainA>
            <Box4MainAButton1>

            </Box4MainAButton1>
            <Box4MainAButton2>

            </Box4MainAButton2>
            <Box4MainAButton3>

            </Box4MainAButton3>
          </Box4MainA>
          <Box4MainA>
            <Box4MainAButton1>

            </Box4MainAButton1>
            <Box4MainAButton2>

            </Box4MainAButton2>
            <Box4MainAButton3>

            </Box4MainAButton3>
          </Box4MainA>
        </Box4>
      </BigBox>
        <Nav />
    </div>
  
  );
}

export default Mainpage;

const BigBox = styled.div`
  display: flex;
  width: 100vw;
  min-width: 200px;
  max-width: 600px;
  margin: auto;
  flex-direction: column;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
`;

const Box1 = styled.div`
  display: flex;
  justify-content: flex-start;
  padding: 5px;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
  background-color: #375cde;
`;

const AttendanceTitle = styled.div`
  display: flex;
  width: auto;
  align-items: center;
  margin-left: 55px;
`;

const MainTitle = styled.h1`
  color: white;
`;

const Box2 = styled.div`
display: flex;
justify-content: center;
align-items: center;
height: 250px;
flex-direction: column;
box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1); 
`;

const Box2Advertisement = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
  overflow: cover;
`;

const AdvertisementImage = styled.img`
  width: 100%;
  height: 100%;
`;

const Box3A = styled.div`
display: flex;
//justify-content: flex-start;
align-items: center;
padding: 5px;
/* box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1); */
`;

const Box3Atext = styled.div`
 display: flex;
 justify-content: center;
 align-items: center;
 font-size: 8px;
 margin-left: 50px;
 /* box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
 border-radius: 10px; */
`;

const Box3AtextTitle = styled.h2`
 color: black;
`;

const Box3B = styled.div`
display: flex;
justify-content: center;
align-items: center;
padding:5px;
/* box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1); */
`; 
 
const Box3BCircle = styled.div`
  display: flex;
  align-items: center;
  justify-content: space-around; //요소 주위를 동일하게 나누기
  flex-direction: row;
  padding: 3px;
  width: 70%;
`;

const Box3BCircleA = styled.div`
  display: flex;
  background-color: red;
  width: 15px;
  height: 15px;
  border-radius: 50px;
`;

const Box3BCircleB = styled.div`
  display: flex;
  background-color: green;
  width: 15px;
  height: 15px;
  border-radius: 50px;
 
`;

const Box3BCircleC = styled.div`
  display: flex;
  background-color: green;
  width: 15px;
  height: 15px;
  border-radius: 50px;
 
`;

const Box3BCircleD = styled.div`
  display: flex;
  background-color: green;
  width: 15px;
  height: 15px;
  border-radius: 50px;
 
`;

const Box3BCircleE = styled.div`
  display: flex;
  background-color: green;
  width: 15px;
  height: 15px;
  border-radius: 50px;
  
`;

const Box4 = styled.div`
display: flex;
justify-content: center;
flex-direction: column;
align-items: center; //컨테이너 박스를 꼭대기에 옮기기
padding: 30px 10px 30px 10px;
box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
`;

const Box4MainA = styled.div`
  display: flex;
  justify-content: space-around; //요소 주의 간격을 동일하게
  align-items: center;
  flex-direction: row;
  width: 100%;
  height: 130px;
  margin-bottom: 40px;
`; 

const Box4MainAButton1 = styled.div`
  display: flex;
  align-items: center;
  width: 150px;
  aspect-ratio: 1/ 1;
  margin-left: 5px;
  margin-right: 5px; 
  border-radius: 20px;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
`;

const Box4MainAButton2 = styled.div`
  display: flex;
  align-items: center;
  width: 150px;
  aspect-ratio: 1/ 1;
  margin-left: 5px;
  margin-right: 5px;
  border-radius: 20px;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
`;

const Box4MainAButton3 = styled.div`
  display: flex;
  align-items: center;
  width: 150px;
  aspect-ratio: 1/ 1;
  margin-left: 5px;
  margin-right: 5px;
  border-radius: 20px;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
`;

const Line = styled.div`
  width: 100%;
  height: 2px; //선 두께
  background-color: #E3E3E3;
`;









