import React, { useState, useEffect } from "react";
import styled from "styled-components";
import Nav from "../../components/NavBar";
import QRImage from "../../Image/qr -1004.png";
import { useNavigate } from "react-router-dom";
import axios from "axios";

function Mypage() {
  const [userData, setUserData] = useState({
    email: "songsj2743@naver.com",
    studentId: "202110228",
    seat: "H13",
  });

  const images = [
    "https://d2v80xjmx68n4w.cloudfront.net/gigs/3wIDg1680183641.jpg",
  ];

  const changeinfo = useNavigate();

  const ChangeInfo = () => {
    changeinfo("/change");
  };

  useEffect(() => {
    // Fetch user data when the component mounts
    const UserData = async () => {
      try {
        const response = await axios.get("http://isaacnas.duckdns.org:8083/user/viewinfo");
        const { email, studentId, seat } = response.data;
        setUserData({ email, studentId, seat});
      } catch (error) {
        console.error("Error fetching user data", error);
      }
    };

    UserData();
  }, [])
  

  // const [currentImageIndex] = useState(0);

  // const handleSubmit = async () => {
  //   try {
  //     /*const data =*/ await axios.get("http://isaacnas.duckdns.org:8083/admin/update", {
  //       // studentId: userData.studentId,
  //       // seat: userData.seat,
  //       // chapelKind: userData.chapelKind
  //     });
  //     // console.log("Data updated successfully", data);
  //     alert("정보가 성공적으로 업데이트되었습니다.");
  //   } catch (error) {
  //     // console.error("Error updating data", error);
  //     alert("정보 업데이트 중 오류가 발생했습니다.");
  //   }
  // };

  return (
    <div>
      <BigBox>
        <AttendanceTitle>
          <MainTitle>CheQ</MainTitle>
          <SubTitle>마이 페이지</SubTitle>
        </AttendanceTitle>

        <BoxB>
          <BoxBMain>
            <BoxBMainProfil>
              <BoxBMainProfilimg src={images[0]} alt="profil" />
            </BoxBMainProfil>
            <BoxBMaininformation>
              <BoxBMaininformation1>
                <FixedText>이메일 | {userData.email}</FixedText>
                
              </BoxBMaininformation1>
              <BoxBMaininformation2>
                <FixedText>학번 | {userData.studentId}</FixedText>
                
              </BoxBMaininformation2>           
              <BoxBMaininformation3>
               <FixedText>좌석 | {userData.seat}</FixedText>
               
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

export default Mypage;

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

// const BoxBMaininformation4 = styled.div`
//   display: flex;
//   align-items: baseline;
//   flex-direction: row;
//   width: 100%;
//   font-weight: bold;
//   font-size: 12px;
// `;

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
