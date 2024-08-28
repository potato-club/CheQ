import React, { useState, useEffect } from "react";
import styled from "styled-components";
import Nav from "../../components/NavBar";
import QRImage from "../../Image/qr -1004.png";
import { useNavigate } from "react-router-dom";
import axios from "axios";

// interface UserData {
//   email: string;
//   studentId: string;
//   seat: string;
// }

function MyPage() {
  const navigate = useNavigate();
  //const [userData, setUserData] = useState<UserData | null>(null); // Use appropriate type
  const [responseData, setResponseData] = useState(null);
  const [email, setEmail] = useState("");
  const [studentId, setStudentId] = useState("");
  const [seat, setSeat] = useState("");

  const images = [
    "https://d2v80xjmx68n4w.cloudfront.net/gigs/3wIDg1680183641.jpg",
  ];

 useEffect(() => {
    const fetchUserInfo = async () => {
      try {
        // localStorage에서 토큰을 가져옴
        const storedToken = localStorage.getItem("at");

       

          // Authorization 헤더에 AT: token 형식으로 추가
          if (storedToken) {
            console.log("Loaded token from localStorage:", storedToken);
  
            // Authorization 헤더에 Bearer <token> 형식으로 추가
            const response = await axios.get(
              "https://dual-kayla-gamza-9d3cdf9c.koyeb.app/user/viewinfo",
              {
                headers: {
                 AT: `${storedToken}`, // Bearer 형식으로 변경
                },
              }
            );

          // 응답 데이터에서 필요한 정보 추출
          const { email, studentId, seat } = response.data;

          // 상태에 데이터 설정
          setEmail(email);
          setStudentId(studentId);
          setSeat(seat);
        } else {
          console.warn("No token found in localStorage");
        }
      } catch (error) {
        alert("문제 발생");
        console.error("Error fetching user info:", error);
      }
    };

    fetchUserInfo();
  }, []); // 빈 배열을 의존성 배열로 전달하여 컴포넌트가 마운트될 때만 호출되도록 합니다.

  const ChangeInfo = () => {
    navigate("/change");
  };

  return (
    <div>
      <Nav />
      <BigBox>
        <AttendanceTitle>
          <MainTitle>CheQ</MainTitle>
          <SubTitle>마이 페이지</SubTitle>
        </AttendanceTitle>

        <BoxB>
          <BoxBMain>
            <BoxBMainProfil>
              <BoxBMainProfilimg src={images[0]} alt="profile" />
            </BoxBMainProfil>

            <BoxBMaininformation>
              <BoxBMaininformation1>
                <FixedText>이메일 | </FixedText>
                <span>{email}</span>
              </BoxBMaininformation1>
              <BoxBMaininformation2>
                <FixedText>학번 | </FixedText>
                <span>{studentId}</span>
              </BoxBMaininformation2>
              <BoxBMaininformation3>
                <FixedText>좌석 | </FixedText>
                <span>{seat}</span>
              </BoxBMaininformation3>
            </BoxBMaininformation>

            <BoXBProfilchangeBox>
              <BoxBProfilchangeButton>
                <BoxBProfilchangeButtontext onClick={ChangeInfo}>
                  정보수정
                </BoxBProfilchangeButtontext>
              </BoxBProfilchangeButton>
            </BoXBProfilchangeBox>
          </BoxBMain>
        </BoxB>
        <BoxC>
          <BoxCMain>
            <BoxCMainTextBox>
              <BoxCMainText>내 QR 코드</BoxCMainText>
            </BoxCMainTextBox>
            <Line />
            <BoxCMainQRBox>
              <BoxCMainQrBoxTag>
                <BoxCMainQr src={QRImage} alt="QR Code" />
              </BoxCMainQrBoxTag>
            </BoxCMainQRBox>
          </BoxCMain>
        </BoxC>
        <BoxD>
          <BoxDMain>
            <BoxDMainA>
              <BoxDmainAtext>푸쉬 알람설정</BoxDmainAtext>
            </BoxDMainA>
            <Line />
            <BoxDMainB>
              <BoxDmainBtext>앱 설정</BoxDmainBtext>
            </BoxDMainB>
            <Line />
            <BoxDMainC></BoxDMainC>
          </BoxDMain>
        </BoxD>
      </BigBox>
      <Nav />
    </div>
  );
}

export default MyPage;

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
const SubTitle = styled.h3`
  color: #375cde;
`;

const BoxB = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 5px;
`;

const BoxBMain = styled.div`
  display: flex;
  align-items: center;
  flex-direction: row;
  width: 100%;
  height: 150px;
  border-radius: 20px;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
`;

const BoxBMainProfil = styled.div`
  display: flex;
  align-items: center;
  width: 125px;
  aspect-ratio: 1/1;
  border-radius: 20px;
  margin-left: 10px;
  margin-right: 25px;
  overflow: hidden;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
`;

const BoxBMainProfilimg = styled.img`
  width: 100%;
  height: 100%;
  object-fit: cover; /* 이미지를 컨테이너에 꽉 차도록 함 */
`;

const BoxBMaininformation = styled.div`
  display: flex;
  align-items: center;
  justify-content: space-around;
  flex-direction: column;
  width: 300px;
  height: 125px;
  margin-left: 10px;
  margin-right: 10px;
`;

const BoxBMaininformation1 = styled.div`
  display: flex;
  align-items: baseline;
  flex-direction: row;
  width: 100%;
  font-weight: bold;
  font-size: 12px;
`;

const BoxBMaininformation2 = styled.div`
  display: flex;
  align-items: baseline;
  flex-direction: row;
  width: 100%;
  font-weight: bold;
  font-size: 12px;
`;

const BoxBMaininformation3 = styled.div`
  display: flex;
  align-items: baseline;
  flex-direction: row;
  width: 100%;
  font-weight: bold;
  font-size: 12px;
`;

const FixedText = styled.span`
  //flex: 0 0 40px; /* 고정된 너비를 설정 */
  display: inline;
  margin-right: 5px;
`;

const BoXBProfilchangeBox = styled.div`
  display: flex;
  justify-content: center;
  align-items: flex-end;
  width: 110px;
  height: 125px;
  margin-left: 10px;
  margin-right: 10px;
`;

const BoxBProfilchangeButton = styled.button`
  display: flex;
  justify-content: center;
  align-items: center;
  width: 58px;
  height: 58px;
  border-radius: 26px;
  background-color: #375cde;
  border: none;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
`;

const BoxBProfilchangeButtontext = styled.h1`
  cursor: pointer;
  font-size: 10px;
  font-weight: bold;
  color: white;
`;

const BoxC = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 5px;
`;

const BoxCMain = styled.div`
  display: flex;
  align-items: center;
  flex-direction: column;
  width: 100%;
  aspect-ratio: 1 / 1;
  border-radius: 20px;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
`;

const BoxCMainTextBox = styled.div`
  display: flex;
  align-items: center;
  justify-content: flex-start;
  width: 100%;
  height: 15%;
  border-radius: 20px;
`;

const BoxCMainText = styled.h1`
  margin-left: 20px;
  font-size: 12px;
  font-weight: bold;
  color: black;
`;

const Line = styled.div`
  width: 95%;
  height: 2px; //선 두께
  background-color: #e3e3e3;
`;

const BoxCMainQRBox = styled.div`
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 85%;
  border-radius: 20px;
`;

const BoxCMainQrBoxTag = styled.div`
  display: flex;
  width: 70%;
  aspect-ratio: 1/1;
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
`;
const BoxCMainQr = styled.img`
  width: 100%;
  height: 100%;
  object-fit: cover; /* 이미지를 컨테이너에 꽉 차도록 함 */
`;

const BoxD = styled.div`
  display: flex;
  padding: 5px;
  align-items: center;
  justify-content: center;
  flex-direction: column;
`;

const BoxDMain = styled.div`
  display: flex;
  align-items: center;
  width: 100%;
  height: 100px;
  border-radius: 20px;
  margin: 15px 0px 5px 0px;
  flex-direction: column;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
`;

const BoxDMainA = styled.div`
  display: flex;
  width: 100%;
  height: 30px;
  border-radius: 20px;
  margin-top: 5px;
`;

const BoxDmainAtext = styled.h1`
  display: flex;
  margin-left: 15px;
  font-size: 12px;
  font-weight: bold;
  color: black;
`;

const BoxDMainB = styled.div`
  display: flex;
  width: 100%;
  height: 30px;
  border-radius: 20px;
`;

const BoxDmainBtext = styled.h1`
  display: flex;
  margin-left: 15px;
  font-size: 12px;
  font-weight: bold;
  color: black;
`;

const BoxDMainC = styled.div`
  display: flex;
  width: 100%;
  height: 30px;
  margin-bottom: 5px;
  border-radius: 20px;
`;
