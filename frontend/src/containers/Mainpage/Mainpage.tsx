import React, { useState, useEffect } from "react";
import styled from "styled-components";
import Nav from "../../components/NavBar";
import NFCImage from "../../Image/NFC.png";
import BeaconImage from "../../Image/Beacon.png";
import axios from "axios";

const images = [
  "https://pimg.hackers.com/land/main/land_default.jpg",
  "https://i.ytimg.com/vi/zvTgwgams-Q/maxresdefault.jpg",
  "https://cdn.autotribune.co.kr/news/photo/202312/11209_56884_5312.png",
  "https://cdn.bosa.co.kr/news/photo/202206/2174709_206247_5859.png",
];

// declare global {
//   interface Window {
//     cheq: {
//       scanNFC: () => void; // 안드로이드
//     };
//     webkit: { // iOS
//       messageHandlers: {
//         scanNFC: {
//           postMessage: (message: string) => void;
//         };
//       };
//     };
//   }
// }

const Mainpage = () => {
  const [currentImageIndex, setCurrentImageIndex] = useState(0);
  const [NFC, setNFC] = useState(false); //nfc기능 상태 추적하고 해당상태에 따라 함수 동작을 조건부로 제한하기위해서 사용

  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentImageIndex((prevIndex) =>
        prevIndex === images.length - 1 ? 0 : prevIndex + 1
      );
    }, 5000);

    return () => clearInterval(interval); // Cleanup function
  }, []);

  // const handleNFCScan = () => {
  //   // Android
  //   if (window.cheq && typeof window.cheq.scanNFC === "function") {
  //     window.cheq.scanNFC();
  //   } else {
  //     console.error("window.cheq.scanNFC is not available");
  //   }

  //   // iOS
  //   if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.scanNFC) {
  //     window.webkit.messageHandlers.scanNFC.postMessage("");
  //   } else {
  //     console.error("window.webkit.messageHandlers.scanNFC.postMessage is not available");
  //   }
  // };

  const onSubmit = async (data: any) => {
    if (NFC) {
      return;
    }

    try {
      const nfc = await axios.post(
        "http://isaacnas.duckdns.org:8083/attendance/nfc",
        {
          mac_address: data.address,
          nfc_position: data.position,
          attendanceTime: new Date().toISOString(), // or any appropriate time format
        },
        {
          headers: {
            Authorization: "Bearer your-auth-token", // Include your token here
          },
        }
      );
    } catch (error) {
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
            <AdvertisementImage src={images[currentImageIndex]} alt="Advertisement" />
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
                //onClick={index === 0 ? handleNFCScan : undefined}
                
                onClick={
                  index === 0
                    ? () =>
                        onSubmit({
                          address: "exampleAddress",
                          position: "examplePosition",
                        })
                    : undefined
                }
              >
              
                {button.image && <ButtonImage src={button.image} alt={button.label} />}
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