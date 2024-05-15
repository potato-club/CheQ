import styled from "styled-components";
const LoginPage = () => {
  return (
    <div>
      <StyleLoginPage>
        <AttendanceTitle>
          <MainTitle>CheQ</MainTitle>
        </AttendanceTitle>
      </StyleLoginPage>
    </div>
  );
};

export default LoginPage;

const StyleLoginPage = styled.div`
  display: flex;
  flex-direction: column;
  margin: auto;
  /* min-width: 200px;
  max-width: 600px; */
  width: 580px;
  padding: 0px 20px 73px 20px;
`;

const AttendanceTitle = styled.div`
  display: flex;
  width: 260px;
  justify-content: space-between;
  align-items: center;
`;
const MainTitle = styled.h1`
  color: #375cde;
`;

const AttendanceIcon = styled.div`
  display: flex;
  justify-content: space-between;
  width: 280px;
  margin-left: 20px;
`;
const IconBox = styled.div`
  display: flex;
  align-items: center;
`;
const GreenIcon = styled.div`
  width: 10px;
  height: 10px;
  background-color: #22d013;
  border-radius: 50%;
`;
const OrangeIcon = styled.div`
  width: 10px;
  height: 10px;
  background-color: #ffb800;
  border-radius: 50%;
`;
const RedIcon = styled.div`
  width: 10px;
  height: 10px;
  background-color: #ff0000;
  border-radius: 50%;
`;
const GrayIcon = styled.div`
  width: 10px;
  height: 10px;
  background-color: #bdbdbd;
  border-radius: 50%;
`;
const IconTitle = styled.div`
  font-size: 13px;
  margin-left: 8px;
`;

const AttendanceCurrent = styled.div`
  display: flex;
  margin-top: 20px;
`;
const CurrentBox = styled.div`
  font-size: 13px;
  font-weight: bold;
  margin-left: 10px;
`;

const AttendanceInfo = styled.div`
  display: flex;
  flex-direction: column;
  margin-top: 20px;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
  padding: 0px 34px 0px 34px;
  border-radius: 30px;
  // 수정
  /* max-width: 546px;
  max-height: 600px;
  overflow-y: auto; */
`;

const WeekInfo = styled.div`
  display: flex;
  justify-content: space-between;
  height: 30px;
  padding: 30px 0px 30px 0px;
  border-bottom: 1px solid #e3e3e3;
  width: 512px;
`;
const InfoBox = styled.div`
  display: flex;
  align-items: center;
`;

const IconColorR = styled.div`
  width: 13px;
  height: 13px;
  background-color: #ff0000;
  border-radius: 50%;
  margin-left: 5px;
`;
const IconColorG = styled.div`
  width: 13px;
  height: 13px;
  background-color: #22d013;
  border-radius: 50%;
  margin-left: 5px;
`;
const IconColorO = styled.div`
  width: 13px;
  height: 13px;
  background-color: #ffb800;
  border-radius: 50%;
  margin-left: 5px;
`;
const IconColorGray = styled.div`
  width: 13px;
  height: 13px;
  background-color: #bdbdbd;
  border-radius: 50%;
  margin-left: 5px;
`;

const HowWeek = styled.div`
  margin-left: 15px;
  font-size: 16px;
  font-weight: bold;
`;
const CurrentDate = styled.div`
  margin-left: 5px;
  font-size: 16px;
  font-weight: bold;
`;
const CurrentInfo = styled.div`
  padding: 30px;
  font-size: 16px;
  font-weight: bold;
`;

const HowWeekGray = styled.div`
  margin-left: 15px;
  color: #c9c9c9;
  font-size: 16px;
  font-weight: bold;
`;
const CurrentDateGray = styled.div`
  margin-left: 5px;
  color: #c9c9c9;
  font-size: 16px;
  font-weight: bold;
`;
const CurrentInfoGray = styled.div`
  color: #c9c9c9;
  padding: 30px;
  font-size: 16px;
  font-weight: bold;
`;

const NavBar = styled.div`
  display: flex;
  justify-content: space-around;
  background-color: #375cde;
  height: 80px;
  border-radius: 14px;
  width: 620px;
  /* min-width: 200px;
  max-width: 600px; */
  margin: auto;
  position: fixed;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
`;
const NavBtn = styled.button`
  border: none;
  outline: none;
  background-color: transparent;
  color: white;
  font-size: 16px;
  cursor: pointer;
`;
