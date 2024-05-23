import React, { useState, useEffect } from 'react';
import styled from 'styled-components';
// import Slider from 'react-slick';
import Nav from '../UnderNavBar/NaverBar';
// import 'slick-carousel/slick/slick.css';
// import 'slick-carousel/slick/slick-theme.css';

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

const AttendanceTitle = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  width: auto;
  margin-right: 450px;
`;

const MainTitle = styled.h1`
  color: white;
`;

const SquareA = styled.div`
  width: 100%;
  height: 350px;
  background-color: #375cde;
  display: flex;
  flex-direction: column;
  justify-content: center;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
`;

const SquareAboxA = styled.div`
  display: flex;
  width: 100%;
  height: 30%;
  justify-content: center;
  align-items: center;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
`;

const SquareAboxB = styled.div`
  display: flex;
  width: 100%;
  height: 70%;
  justify-content: center;
  align-items: center;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
`;

const SquareAboxBAdvertisement = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%; /* Set explicit height to maintain the size */
  overflow: cover; /* Hide overflow to ensure the image fits within the div */
`;

const AdvertisementImage = styled.img`
  width: 100%;
  height: 100%;
  /* overflow: hidden;  */
`;

const SquareB = styled.div`
  width: 100%;
  height: 150px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  position: relative;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
`;

const SquareBboxA = styled.div`
  display: flex;
  width: 100%;
  height: 50%;
  justify-content: center;
  align-items: center;
`;

const SquareBboxAtext = styled.div`
  display: flex;
  width: auto;
  height: 100%;
  font-size: 12px;
  font-weight: bold;
  justify-content: center;
  align-items: center;
  margin-right: 400px;
`;

const SquareBboxB = styled.div`
  display: flex;
  width: 100%;
  height: 50%;
  justify-content: center;
  align-items: center;
`;

const SquareBboxBcircle = styled.div`
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  gap: 80px;
  height: 100%;
  width: 100%;
  margin-bottom: 20px;
`;

const SquareC = styled.div`
  display: flex;
  flex-direction: column;
  background-color: white;
  height: 100vh;
  overflow-y: auto; /* 스크롤이 필요한 경우만 표시 */
  &::-webkit-scrollbar {
    width: 0; /* 수평 스크롤바 너비를 0으로 설정하여 숨김 */
  }
  &::-webkit-scrollbar-thumb {
    background-color: transparent; /* 스크롤바 썸 색상을 투명으로 설정하여 숨김 */
  }
`;
const SquareCboxA = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 50%;
  gap: 80px;
`;

const SquareCboxASquare = styled.div`
  display: flex;
  width: 100px;
  height: 100px;
  background-color: white;
  border-radius: 5px;
  margin-top: 20px;
  margin-bottom: 20px;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
  &:hover {
    cursor: pointer;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.4);
    transform: scale(1);
  }
`;

const CircleA = styled.div`
  display: flex;
  background-color: red;
  width: 15px;
  height: 15px;
  border-radius: 50px;
`;

const CircleB = styled.div`
  background-color: green;
  width: 15px;
  height: 15px;
  border-radius: 50px;
`;

const CircleC = styled.div`
  background-color: green;
  width: 15px;
  height: 15px;
  border-radius: 50px;
`;

const CircleD = styled.div`
  background-color: green;
  width: 15px;
  height: 15px;
  border-radius: 50px;
`;

const CircleE = styled.div`
  background-color: green;
  width: 15px;
  height: 15px;
  border-radius: 50px;
`;

const images = [
  'https://pimg.hackers.com/land/main/land_default.jpg',
  'https://i.ytimg.com/vi/zvTgwgams-Q/maxresdefault.jpg',
  'https://cdn.autotribune.co.kr/news/photo/202312/11209_56884_5312.png',
  'https://cdn.bosa.co.kr/news/photo/202206/2174709_206247_5859.png'
];

function Mainpage() {
  const [numberOfBoxes, setNumberOfBoxes] = useState(1); // 숫자 값을 상태로 관리
  const [currentImageIndex, setCurrentImageIndex] = useState(0);

  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentImageIndex((prevIndex) => (prevIndex === images.length - 1 ? 0 : prevIndex + 1));
    }, 5000);

    return () => clearInterval(interval);
  }, []);
  // const settings = {
  //   dots: true,
  //   infinite: true,
  //   speed: 300,
  //   slidesToShow: 1,
  //   slidesToScroll: 1,
  //   arrows: true,
  //   autoplay: true,
  //   autoplaySpeed: 3000,
  // };

  // SquareCboxA를 numberOfBoxes 수만큼 반복해서 렌더링
  const renderSquareCboxA = () => {
    const boxes = [];
    for (let i = 0; i < numberOfBoxes; i++) {
      boxes.push(
        <SquareCboxA key={i}>
          <SquareCboxASquare />
          <SquareCboxASquare />
          <SquareCboxASquare />
        </SquareCboxA>
      );
    }
    return boxes;
  };

  return (
    <BigBox>
      <SquareA>
        <SquareAboxA>
          <AttendanceTitle>
            <MainTitle>CheQ</MainTitle>
          </AttendanceTitle>
        </SquareAboxA>
        <SquareAboxB>
          <SquareAboxBAdvertisement>
            <AdvertisementImage src={images[currentImageIndex]} alt="Advertisement" />
          </SquareAboxBAdvertisement>
        </SquareAboxB>
      </SquareA>
      <SquareB>
        <SquareBboxA>
          <SquareBboxAtext>현재 출결사항</SquareBboxAtext>
        </SquareBboxA>
        <SquareBboxB>
          <SquareBboxBcircle>
            <CircleA />
            <CircleB />
            <CircleC />
            <CircleD />
            <CircleE />
          </SquareBboxBcircle>
        </SquareBboxB>
      </SquareB>
      <SquareC>
        {renderSquareCboxA()} {/* 동적으로 SquareCboxA 렌더링 */}
      </SquareC>
      <Nav /> {/* NaverBar 컴포넌트 사용 */}
    </BigBox>
  );
}

export default Mainpage;
