import React from 'react';
import styled from 'styled-components';
import Slider from 'react-slick';
import Nav from '../UnderNavBar/NaverBar';
import 'slick-carousel/slick/slick.css';
import 'slick-carousel/slick/slick-theme.css';

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
  border-radius: 5px;
`;
const AttendanceTitle = styled.div`
    display: flex;
    align-items: center;
    width: 200px;
    margin-left: 20px;
    justify-content: space-between;
    margin-bottom: 20px;
`;
const MainTitle = styled.h1`
    color: white;
`;

const SmallBox = styled.div`
  width: 100px;
  height: 100px;
  background-color: white;
  border-radius: 5px;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
  &:hover {
    cursor: pointer;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.4);
    transform: scale(1);
  }
`;

const SquareA = styled.div`
  width: 100%;
  height: 500px;
  background-color: #375cde;
  display: flex;
  flex-direction: column;
  justify-content: center; 
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
`;
//SquareB 부분 column 써서 현재 출결현황 박스와 점 찍힐 박스 2개를 만든다.
const SquareB = styled.div`
  width: 100%;
  height: 200px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  border-radius: 2px;
  position: relative; /* 부모 요소에 position: relative 추가 */
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
  &:hover {
    cursor: pointer;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.4);
    transform: scale(1);
  }
`;

//SquareC 부분도 위쪽 라인에 박스 3개 넣을 박스와 밑에 라인에 박스 3개 넣을 박스 이렇게 총 2개로 나눠야해
const SquareC = styled.div`
  display: flex;
  justify-content: space-around;
  background-color: white;
  height: 100%;
  padding: 40px 0px;
`;

const AdvertisementBox = styled(Slider)`
  height: 200px;
  top: 30%;
  left: 50%;
  transform: translate(-50%, -50%);
  overflow: hidden;
  margin-bottom: 20px;
`;

const TextB = styled.div`
  color: black;
  font-size: 10px;
  font-weight: bold;
  position: absolute;
  top: 15px;
  left: 25px;
`;
const Image = styled.img`
  width: 100%;
  height: 100%;
  object-fit: contain;
`;

const CirclesContainer = styled.div`
  display: flex;
  gap: 60px; /* 동그라미 사이 간격 설정 */
  height: 0px;
`;

const CircleA = styled.div`
  background-color: red;
  width: 10px;
  height: 10px;
  border-radius: 50%;
`;

const CircleB = styled.div`
  background-color: green;
  width: 10px;
  height: 10px;
  border-radius: 50%;
`;

const images = [
  'https://pimg.hackers.com/land/main/land_default.jpg',
  'https://img.seoul.co.kr/img/upload/2023/06/27/SSC_20230627135839_O2.jpg',

]

function Mainpage() {
  const settings = {
    dots: true,
    infinite: true,
    speed: 300,
    slidesToShow: 1,
    slidesToScroll: 1,
    arrows: true,
    autoplay: true,
    autoplaySpeed: 3000,
  };

  //settings.dots = images.length <= settings.slidesToShow;

  return (
    <BigBox>
    <SquareA>
      <AttendanceTitle>
        <MainTitle>CheQ</MainTitle>
      </AttendanceTitle>
      <AdvertisementBox {...settings}>
        {images.map((image, index) => (
          <Image key={index} src={image} alt={`AdvertisementBox ${index}`} />
        ))}
      </AdvertisementBox>
    </SquareA>
    <SquareB>
      <TextB>현재 출결 현황</TextB>
      <CirclesContainer>
        <CircleA />
        <CircleB />
        <CircleB />
        <CircleB />
        <CircleB />
      </CirclesContainer>
    </SquareB>
    <SquareC>
      <SmallBox />
      <SmallBox />
      <SmallBox />
    </SquareC>
     <Nav /> {/* NaverBar 컴포넌트 사용 */}
 
  </BigBox>
  

  );
}

export default Mainpage;
