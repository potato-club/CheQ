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

const Mainpage: React.FC = () => {
  const [currentImageIndex, setCurrentImageIndex] = useState(0);
  const [responseData, setResponseData] = useState(null);
  const [token, setToken] = useState<string | null>(null);

  useEffect(() => {
    // Load the token from localStorage when the component mounts
    const storedToken = localStorage.getItem("at");
    setToken(storedToken); // Store the token in state

    // Set an interval to rotate images
    const interval = setInterval(() => {
      setCurrentImageIndex((prevIndex) =>
        prevIndex === images.length - 1 ? 0 : prevIndex + 1
      );
    }, 5000);

    return () => clearInterval(interval); // Cleanup function
  }, []);

  // Handle the NFC submission using uuid and nfc_position from the button data
  const onSubmit = async (uuid: string, nfc_position: string) => {
    try {
      // Use the token from localStorage
      const storedToken = token;

      if (!storedToken) {
        alert("No token found. Please log in.");
        return;
      }

      // POST request with uuid, nfc_position, and attendanceTime
      const response = await axios.post(
        "https://dual-kayla-gamza-9d3cdf9c.koyeb.app/attendance/nfc",
        {
          uuid: uuid,
          nfc_position: nfc_position,
          attendanceTime: new Date().toISOString(), // Set current time as ISO string
        },
        {
          headers: {
            AT: storedToken, // Send token in headers
            "Content-Type": "application/json",
          },
        }
      );

      // Store the response data in state
      setResponseData(response.data);
    } catch (error) {
      // Handle any errors
      console.error("Error:", error);
      alert("An error occurred during NFC submission.");
    }
  };

  const attendanceStatuses = ["present", "absent", "late", "present", "present"];

  // Get the color based on the attendance status
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
    { image: NFCImage,  }, // Added label for NFC buttons
    { image: BeaconImage, }, // Added label for NFC buttons
    { label: "Menu 3" }, // This button will not trigger NFC submission
    { label: "Menu 4" }, // This button will not trigger NFC submission
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
                onClick={() => {
                  if (button.image) {
                    onSubmit("uuid-value", "nfc_position-value"); // Trigger NFC submission
                  }
                }}
              >
                {/* Display the image for NFC-related buttons */}
                {button.image && <ButtonImage src={button.image} alt={button.label || "Button"} />}
                {/* Display the label if present */}
                {button.label && <span>{button.label}</span>}
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
