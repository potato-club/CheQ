import React, { useState, useEffect } from "react";
import styled from "styled-components";
import Nav from "../../components/NavBar";
import NFCImage from "../../image/NFC.png";
import BeaconImage from "../../image/Beacon.png";
import axios from "axios";

const images = [
  "https://pimg.hackers.com/land/main/land_default.jpg",
  "https://i.ytimg.com/vi/zvTgwgams-Q/maxresdefault.jpg",
  "https://cdn.autotribune.co.kr/news/photo/202312/11209_56884_5312.png",
  "https://cdn.bosa.co.kr/news/photo/202206/2174709_206247_5859.png",
];

const Mainpage = () => {
  const [currentImageIndex, setCurrentImageIndex] = useState(0);
  const [NFC, setNFC] = useState(null); //nfc기능 상태 추적하고 해당상태에 따라 함수 동작을 조건부로 제한하기위해서 사용
  const [responseData, setResponseData] = useState(null);
  const [token, setToken] = useState(null); // 토큰 상태 관리

  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentImageIndex((prevIndex) =>
        prevIndex === images.length - 1 ? 0 : prevIndex + 1
      );
    }, 5000);

    return () => clearInterval(interval); // Cleanup function
  }, []);

  const onSubmit = async (address: string, position: string) => {
    //string값이 달라서 발생하는 오류
    try {
      // 주어진 토큰 값을 직접 설정합니다.
      const storedToken =
        "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxYzZlMzA3ZDc0MTFjOTFhZmI0MzU0NTE3MDM2YjJlMDBmNTY2OGEzNjQyYWNlZTNkMzdkOWQ4ZjdhMjBmMzM2ZjMxNGJkMjQwZTNlNGIyNmEyOWI5ZTdjN2ZmMWNmMjQiLCJpYXQiOjE3MjI5Njk1OTYsImV4cCI6MTcyMjk3MzE5Nn0.tUju_dhTd9rRDXne9ONHDrJa7RKgKmFlqAjHO9cA4uov8vD0MWAegRYIVSXLtsOwFB9SVtSh9MVr2dgXD_JISw";

      // 요청 바디를 정의합니다.
      const requestBody = {
        uuid: address,
        nfc_position: position,
        attendanceTime: new Date().toISOString(),
        token: storedToken, // 주어진 토큰 값을 포함합니다.
      };

      // requestBody의 값을 확인합니다.
      console.log("Request Body:", requestBody);

      // POST 요청을 보내고 응답을 처리합니다.
      const response = await axios.post(
        "https://dual-kayla-gamza-9d3cdf9c.koyeb.app/attendance/nfc",
        requestBody,
        {
          headers: {
            "Content-Type": "application/json", // 바디를 JSON으로 전송
          },
        }
      );

      // 응답 데이터를 상태에 저장합니다.
      setResponseData(response.data);
    } catch (error) {
      // 오류가 발생하면 사용자에게 알립니다.
      console.error("Error:", error); // 에러를 콘솔에 출력
      alert("오류가 발생했습니다");
    }
  };

  const attendanceStatuses = [
    "present",
    "absent",
    "late",
    "present",
    "present",
  ];

  const getColor = (status: string): string => {
    switch (status) {
      case "present":
        return "green";
      case "absent":
        return "red";
      case "late":
        return "orange";
      default:
        return "gray";
    }
  };

  const buttonsData = [
    { image: NFCImage },
    { image: BeaconImage },
    { label: "Menu 3" },
    { label: "Menu 4" },
  ];

  return (
    <div>
      <BigBox>
        <Box1>
          <AttendanceTitle>
            <MainTitle>CheQ</MainTitle>
          </AttendanceTitle>
        </Box1>
        <Box2>
          <Box2Advertisement>
            <AdvertisementImage
              src={images[currentImageIndex]}
              alt="Advertisement"
            />
          </Box2Advertisement>
        </Box2>
        <Box3A>
          <Box3Atext>
            <Box3AtextTitle>현재 출결 현황</Box3AtextTitle>
          </Box3Atext>
        </Box3A>
        <Box3B>
          <Box3BCircle>
            {attendanceStatuses.map((status, index) => (
              <Circle key={index} color={getColor(status)} />
            ))}
          </Box3BCircle>
        </Box3B>
        <Box4>
          <Box4MainA>
            {buttonsData.map((button, index) => (
              <Box4MainAButton
                key={index}
                //onClick={index === 0 ? handleNFCScan : undefined
                onClick={
                  index === 0 ? () => onSubmit("string", "string") : undefined
                }
              >
                {button.image && (
                  <ButtonImage src={button.image} alt={button.label} />
                )}
              </Box4MainAButton>
            ))}
          </Box4MainA>
        </Box4>
      </BigBox>
      <Nav />
    </div>
  );
};

export default Mainpage;

const BigBox = styled.div`
  display: flex;
  flex-direction: column;
  margin: auto;
  width: 100vw;
  min-width: 200px;
  max-width: 580px;
  padding: 0px 20px 73px 20px;
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
  align-items: center;
`;

const MainTitle = styled.h1`
  color: white;
  margin-right: 28px;
`;

const Box2 = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  height: 250px;
  //flex-direction: column;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
`;

const Box2Advertisement = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
  overflow: hidden;
`;

const AdvertisementImage = styled.img`
  width: 100%;
  height: 100%;
  //object-fit: cover;
`;

const Box3A = styled.div`
  display: flex;
  align-items: center;
  padding: 5px;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
`;

const Box3Atext = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  font-size: 8px;
  margin-left: 50px;
`;

const Box3AtextTitle = styled.h2`
  color: black;
`;

const Box3B = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 5px;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
`;

const Box3BCircle = styled.div`
  display: flex;
  align-items: center;
  justify-content: space-around;
  flex-direction: row;
  padding: 3px;
  width: 70%;
`;

const Circle = styled.div`
  display: flex;
  background-color: ${(props) => props.color};
  width: 15px;
  height: 15px;
  border-radius: 50%;
`;

const Box4 = styled.div`
  display: flex;
  padding: 30px 10px;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
  width: 100%;
  box-sizing: border-box;
`;

const Box4MainA = styled.div`
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  gap: 20px;
  width: 100%;
  box-sizing: border-box;
  //max-width: 100%; /* 이 속성은 필요한 경우에 추가합니다. */
`;

const Box4MainAButton = styled.div`
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  aspect-ratio: 1 / 1;
  border-radius: 20px;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
  //background-color: #f0f0f0;
  cursor: pointer;
  overflow: hidden;
  box-sizing: border-box;
  //margin: auto;
`;

const ButtonImage = styled.img`
  width: 100%;
  height: 100%;
  /* object-fit: cover; */
`;
