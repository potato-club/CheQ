import React from 'react';
import styled from 'styled-components';
import Slider from 'react-slick';
import 'slick-carousel/slick/slick.css';
import 'slick-carousel/slick/slick-theme.css';

const BigBox = styled.div`
  display: flex;
  flex-direction: column;
  width: 390px;
  height: 100vh;
  border: 2px solid grey;
  margin: 0 auto;
`;

const SmallBox = styled.div`
  width: 100px;
  height: 100px;
  background-color: gray;
  border-radius: 5px;
  &:hover {
    cursor: pointer;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.4);
    transform: scale(1);
  }
`;

const SquareA = styled.div`
  width: 100%;
  background-color: #3e3eed;
  display: flex;
  flex-direction: column;
  justify-content: center; 
  padding-bottom: 50px;
`;

const SquareB = styled.div`
  width: 100%;
  height: 100px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  border: 2px solid gray;
  border-radius: 2px;
  position: relative; /* 부모 요소에 position: relative 추가 */
  //box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.3), -2px -2px 5px rgba(0, 0, 0, 0.3); /* 상하좌우 그림자 설정 */
  &:hover {
    cursor: pointer;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.4);
    transform: scale(1);
  }
`;

const SquareC = styled.div`
  display: flex;
  justify-content: space-around;
  background-color: white;
  height: 100%;
  padding: 40px 0px;
`;

const AdvertisementBox = styled(Slider)`
  height: 200px;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  overflow: hidden;
  display: flex;
`;

const TextA = styled.div`
  color: white;
  font-size: 20px;
  font-weight: bold;
  margin-left: 20px;
  margin-top: 20px;
`;
const TextB = styled.div`
  color: black;
  font-size: 10px;
  font-weight: bold;
  position: absolute;
  top: 5px;
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

const Circle = styled.div`
  background-color: green;
  width: 10px;
  height: 10px;
  border-radius: 50%;
`;


const images = [
  'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTN55lIKqWaNpSb2A66vQf9u9mY2t9n8P_YYJnPDRykMA&s',
  'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4d/Cat_November_2010-1a.jpg/300px-Cat_November_2010-1a.jpg',
];

function Mainpage() {
  const settings = {
    dots: true,
    infinite: true,
    speed: 300,
    slidesToShow: 1,
    slidesToScroll: 1,
    arrows: true,
    autoplay: true,
    autoplaySpeed: 4000,
  };

  settings.dots = images.length <= settings.slidesToShow;

  return (
    <BigBox>
    <SquareA>
      <TextA>CheQ</TextA>
      <AdvertisementBox {...settings}>
        {images.map((image, index) => (
          <Image key={index} src={image} alt={`AdvertisementBox ${index}`} />
        ))}
      </AdvertisementBox>
    </SquareA>
    <SquareB>
      <TextB>현재 출결 현황</TextB>
      <CirclesContainer>
        <Circle />
        <Circle />
        <Circle />
        <Circle />
        <Circle />
      </CirclesContainer>
    </SquareB>
    <SquareC>
      <SmallBox />
      <SmallBox />
      <SmallBox />
    </SquareC>
  </BigBox>
  );
}

export default Mainpage;
