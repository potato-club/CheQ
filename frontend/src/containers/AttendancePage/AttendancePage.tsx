import styled from "styled-components";
import { Link } from "react-router-dom";
import NavBar from "../../components/NavBar";

const AttendancePage = () => {
  const attendance: number = 4;
  const lateAndEarlyLeave: number = 1;
  const absence: number = 1;

  return (
    <div>
      <StyleAttendancePage>
        <AttendanceTitle>
          <MainTitle>CheQ</MainTitle>
          <SubTitle>내 출결 정보 확인</SubTitle>
        </AttendanceTitle>
        <AttendanceIcon>
          <IconBox>
            <GreenIcon />
            <IconTitle>출석</IconTitle>
          </IconBox>
          <IconBox>
            <OrangeIcon />
            <IconTitle>지각, 조퇴</IconTitle>
          </IconBox>
          <IconBox>
            <RedIcon />
            <IconTitle>결석</IconTitle>
          </IconBox>
          <IconBox>
            <GrayIcon />
            <IconTitle>미출결</IconTitle>
          </IconBox>
        </AttendanceIcon>
        <AttendanceCurrent>
          <CurrentBox>
            출석: {attendance} | 지각,조퇴: {lateAndEarlyLeave} | 결석:{" "}
            {absence}
          </CurrentBox>
        </AttendanceCurrent>
        <AttendanceInfo>
          <WeekInfo>
            <InfoBox>
              <IconColorR />
              <HowWeek>1주차</HowWeek>
              <CurrentDate>( 03월 05일 )</CurrentDate>
            </InfoBox>
            <InfoBox>
              <CurrentInfo>결석</CurrentInfo>
            </InfoBox>
          </WeekInfo>
          <WeekInfo>
            <InfoBox>
              <IconColorG />
              <HowWeek>2주차</HowWeek>
              <CurrentDate>( 03월 12일 )</CurrentDate>
            </InfoBox>
            <InfoBox>
              <CurrentInfo>출석</CurrentInfo>
            </InfoBox>
          </WeekInfo>
          <WeekInfo>
            <InfoBox>
              <IconColorO />
              <HowWeek>3주차</HowWeek>
              <CurrentDate>( 03월 19일 )</CurrentDate>
            </InfoBox>
            <InfoBox>
              <CurrentInfo>지각</CurrentInfo>
            </InfoBox>
          </WeekInfo>
          <WeekInfo>
            <InfoBox>
              <IconColorG />
              <HowWeek>4주차</HowWeek>
              <CurrentDate>( 03월 26일 )</CurrentDate>
            </InfoBox>
            <InfoBox>
              <CurrentInfo>출석</CurrentInfo>
            </InfoBox>
          </WeekInfo>
          <WeekInfo>
            <InfoBox>
              <IconColorGray />
              <HowWeekGray>5주차</HowWeekGray>
              <CurrentDateGray>( 04월 02일 )</CurrentDateGray>
            </InfoBox>
            <InfoBox>
              <CurrentInfoGray>출결</CurrentInfoGray>
            </InfoBox>
          </WeekInfo>
          <WeekInfo>
            <InfoBox>
              <IconColorGray />
              <HowWeekGray>6주차</HowWeekGray>
              <CurrentDateGray>( 04월 09일 )</CurrentDateGray>
            </InfoBox>
            <InfoBox>
              <CurrentInfoGray>미출결</CurrentInfoGray>
            </InfoBox>
          </WeekInfo>
          <WeekInfo>
            <InfoBox>
              <IconColorGray />
              <HowWeekGray>7주차</HowWeekGray>
              <CurrentDateGray>( 04월 16일 )</CurrentDateGray>
            </InfoBox>
            <InfoBox>
              <CurrentInfoGray>미출결</CurrentInfoGray>
            </InfoBox>
          </WeekInfo>
          <WeekInfo>
            <InfoBox>
              <IconColorGray />
              <HowWeekGray>8주차</HowWeekGray>
              <CurrentDateGray>( 04월 23일 )</CurrentDateGray>
            </InfoBox>
            <InfoBox>
              <CurrentInfoGray>미출결</CurrentInfoGray>
            </InfoBox>
          </WeekInfo>
          <WeekInfo>
            <InfoBox>
              <IconColorGray />
              <HowWeekGray>9주차</HowWeekGray>
              <CurrentDateGray>( 04월 30일 )</CurrentDateGray>
            </InfoBox>
            <InfoBox>
              <CurrentInfoGray>미출결</CurrentInfoGray>
            </InfoBox>
          </WeekInfo>
          <WeekInfo>
            <InfoBox>
              <IconColorGray />
              <HowWeekGray>10주차</HowWeekGray>
              <CurrentDateGray>( 05월 07일 )</CurrentDateGray>
            </InfoBox>
            <InfoBox>
              <CurrentInfoGray>미출결</CurrentInfoGray>
            </InfoBox>
          </WeekInfo>
          <WeekInfo>
            <InfoBox>
              <IconColorGray />
              <HowWeekGray>11주차</HowWeekGray>
              <CurrentDateGray>( 05월 14일 )</CurrentDateGray>
            </InfoBox>
            <InfoBox>
              <CurrentInfoGray>미출결</CurrentInfoGray>
            </InfoBox>
          </WeekInfo>
          <WeekInfo>
            <InfoBox>
              <IconColorGray />
              <HowWeekGray>12주차</HowWeekGray>
              <CurrentDateGray>( 05월 21일 )</CurrentDateGray>
            </InfoBox>
            <InfoBox>
              <CurrentInfoGray>미출결</CurrentInfoGray>
            </InfoBox>
          </WeekInfo>
          <WeekInfo>
            <InfoBox>
              <IconColorGray />
              <HowWeekGray>13주차</HowWeekGray>
              <CurrentDateGray>( 05월 28일 )</CurrentDateGray>
            </InfoBox>
            <InfoBox>
              <CurrentInfoGray>미출결</CurrentInfoGray>
            </InfoBox>
          </WeekInfo>
          <WeekInfo>
            <InfoBox>
              <IconColorGray />
              <HowWeekGray>14주차</HowWeekGray>
              <CurrentDateGray>( 06월 04일 )</CurrentDateGray>
            </InfoBox>
            <InfoBox>
              <CurrentInfoGray>미출결</CurrentInfoGray>
            </InfoBox>
          </WeekInfo>
          <WeekInfo>
            <InfoBox>
              <IconColorGray />
              <HowWeekGray>15주차</HowWeekGray>
              <CurrentDateGray>( 06월 11일 )</CurrentDateGray>
            </InfoBox>
            <InfoBox>
              <CurrentInfoGray>미출결</CurrentInfoGray>
            </InfoBox>
          </WeekInfo>
          <WeekInfo>
            <InfoBox>
              <IconColorGray />
              <HowWeekGray>16주차</HowWeekGray>
              <CurrentDateGray>( 06월 18일 )</CurrentDateGray>
            </InfoBox>
            <InfoBox>
              <CurrentInfoGray>미출결</CurrentInfoGray>
            </InfoBox>
          </WeekInfo>
        </AttendanceInfo>
      </StyleAttendancePage>
      <NavBar />
    </div>
  );
};

export default AttendancePage;
// const Wrapper = styled.div`
//   margin: auto;
//   min-width: 200px;
//   max-width: 600px;
// `;

const StyleAttendancePage = styled.div`
  display: flex;
  flex-direction: column;
  margin: auto;
  width: 100vw;
  min-width: 200px;
  max-width: 580px;
  /* width: 580px; */
  padding: 0px 20px 73px 20px;
`;

const AttendanceTitle = styled.div`
  display: flex;
  /* width: 260px;
  justify-content: space-between; */
  align-items: center;
`;
const MainTitle = styled.h1`
  color: #375cde;
  margin-right: 28px;
`;
const SubTitle = styled.h3`
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
  /* width: 512px; */
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
  font-size: 14px;
  font-weight: bold;
`;
const CurrentInfoGray = styled.div`
  color: #c9c9c9;
  padding: 30px;
  font-size: 16px;
  font-weight: bold;
`;
