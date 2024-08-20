import React, { useState, useEffect } from "react";
import styled from "styled-components";
import NavBar from "../../components/NavBar";
import axios from "axios";

interface AttendanceData {
  week: number;
  date: string;
  status: "출석" | "지각" | "조퇴" | "결석" | "미출결";
}

const AttendancePage = () => {
  const [attendanceData, setAttendanceData] = useState<AttendanceData[]>([]);
  const [attendanceCount, setAttendanceCount] = useState(0);
  const [lateAndEarlyLeaveCount, setLateAndEarlyLeaveCount] = useState(0);
  const [absenceCount, setAbsenceCount] = useState(0);

  useEffect(() => {
    const fetchData = async () => {
      const token = localStorage.getItem("at");
      if (!token) {
        alert("로그인이 필요합니다.");
        return;
      }

      try {
        const response = await axios.get(
          "https://dual-kayla-gamza-9d3cdf9c.koyeb.app/attendance/all",
          {
            data: {
              AT: `${token}`,
            },
          }
        );

        const Data = response.data;

        setAttendanceData(Data);

        const attendance = Data.filter(
          (item: AttendanceData) => item.status === "출석"
        ).length;
        const lateAndEarlyLeave = Data.filter(
          (item: AttendanceData) =>
            item.status === "지각" || item.status === "조퇴"
        ).length;
        const absence = Data.filter(
          (item: AttendanceData) => item.status === "결석"
        ).length;

        setAttendanceCount(attendance);
        setLateAndEarlyLeaveCount(lateAndEarlyLeave);
        setAbsenceCount(absence);
      } catch (error) {
        console.error("Error fetching attendance data:", error);
        alert("출결 데이터를 가져오는데 실패했습니다.");
      }
    };

    fetchData();
  }, []);

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
            출석: {attendanceCount} | 지각,조퇴: {lateAndEarlyLeaveCount} |
            결석: {absenceCount}
          </CurrentBox>
        </AttendanceCurrent>
        <AttendanceInfo>
          {attendanceData.map((item, index) => (
            <WeekInfo key={index}>
              <InfoBox>
                <div>{item.week}주차</div>
                <HowWeek status={item.status}>{item.status}</HowWeek>
              </InfoBox>
              <InfoBox>
                <CurrentDate status={item.status}>{item.date}</CurrentDate>
                <CurrentInfo status={item.status}>{item.status}</CurrentInfo>
                <IconColor status={item.status} />
              </InfoBox>
            </WeekInfo>
          ))}
        </AttendanceInfo>
        <NavBar />
      </StyleAttendancePage>
    </div>
  );
};

export default AttendancePage;
const IconColor = styled.div<{ status: string }>`
  width: 13px;
  height: 13px;
  border-radius: 50%;
  margin-left: 5px;
  background-color: ${({ status }) =>
    status === "출석"
      ? "#22d013"
      : status === "지각" || status === "조퇴"
      ? "#ffb800"
      : status === "결석"
      ? "#ff0000"
      : "#bdbdbd"};
`;

const StyleAttendancePage = styled.div`
  display: flex;
  flex-direction: column;
  margin: auto;
  width: 100vw;
  min-width: 200px;
  max-width: 580px;
  padding: 0px 20px 65px 20px;
`;

const AttendanceTitle = styled.div`
  display: flex;
  align-items: center;
  margin-bottom: 20px;
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
`;

const WeekInfo = styled.div`
  display: flex;
  justify-content: space-between;
  height: 30px;
  padding: 24px 0px;
  border-bottom: 1px solid #e3e3e3;
`;

const InfoBox = styled.div`
  display: flex;
  align-items: center;
`;

const HowWeek = styled.div<{ status: string }>`
  margin-left: 15px;
  font-size: 14px;
  font-weight: bold;
  color: ${({ status }) => (status === "미출결" ? "#c9c9c9" : "black")};
`;

const CurrentDate = styled.div<{ status: string }>`
  margin-left: 5px;
  font-size: 14px;
  font-weight: bold;
  color: ${({ status }) => (status === "미출결" ? "#c9c9c9" : "black")};
`;

const CurrentInfo = styled.div<{ status: string }>`
  padding: 30px;
  font-size: 14px;
  font-weight: bold;
  color: ${({ status }) => (status === "미출결" ? "#c9c9c9" : "black")};
`;
