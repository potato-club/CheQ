import styled from "styled-components";
import React, { useState, useEffect } from "react";
import { useForm } from "react-hook-form";
import { useNavigate } from "react-router-dom"; // useNavigate 훅 임포트

interface AdminData {
  checkbox: boolean;
  name: string;
  studentid: number;
  studentclass: string;
  chapel: number;
  chapelseat: string;
}

const AdminPage = () => {
  const [adminData, setAdminData] = useState<AdminData[]>([]);
  const TestData: AdminData[] = [
    {
      checkbox: false,
      name: "정지호",
      studentid: 202110647,
      studentclass: "컴퓨터공학",
      chapel: 3,
      chapelseat: "A36",
    },
    {
      checkbox: false,
      name: "김철수",
      studentid: 202110648,
      studentclass: "전자공학",
      chapel: 3,
      chapelseat: "B24",
    },
    {
      checkbox: false,
      name: "박영희",
      studentid: 202110649,
      studentclass: "섬유패션디자인학",
      chapel: 3,
      chapelseat: "C12",
    },
    {
      checkbox: false,
      name: "강민",
      studentid: 202110650,
      studentclass: "시각정보디자인학",
      chapel: 7,
      chapelseat: "D34",
    },
    {
      checkbox: true,
      name: "남궁지수",
      studentid: 202110651,
      studentclass: "미디어영상광고학",
      chapel: 7,
      chapelseat: "E56",
    },
  ];

  useEffect(() => {
    setAdminData(TestData);
  }, []);

  return (
    <div>
      <StyleAdminPage>
        <AdminTitle>
          <MainTitle>CheQ</MainTitle>
          <SubTitle>관리자 페이지</SubTitle>
        </AdminTitle>
        <AdminManagementBox>
          <RegistrationBtn>등록</RegistrationBtn>
          <CorrectionBtn>수정</CorrectionBtn>
          <DeleteBtn>삭제</DeleteBtn>
          <LogoutBtn>로그아웃</LogoutBtn>
          <SearchBar>검색하기</SearchBar>
        </AdminManagementBox>
        <AdminInfo>
          <SutudentTitleBox>
            <StdTitleBox1>
              <SutudentInfoTitle>이름</SutudentInfoTitle>
              <SutudentInfoTitle>학번</SutudentInfoTitle>
            </StdTitleBox1>
            <SutudentInfoTitle3>학과</SutudentInfoTitle3>
            <StdTitleBox2>
              <SutudentInfoTitle2>채플</SutudentInfoTitle2>
              <SutudentInfoTitle2>좌석</SutudentInfoTitle2>
            </StdTitleBox2>
          </SutudentTitleBox>
          <StudentInfo>
            {adminData.map((data, index) => (
              <StudentInfoRow key={index}>
                <ClickBox
                  type="checkbox"
                  checked={data.checkbox}
                  onChange={() => {
                    const newData = [...adminData];
                    newData[index].checkbox = !newData[index].checkbox;
                    setAdminData(newData);
                  }}
                />
                <StudentName>{data.name}</StudentName>
                <StudentId>{data.studentid}</StudentId>
                <StudentClass>{data.studentclass}</StudentClass>
                <Chapel>{data.chapel}교시</Chapel>
                <ChapelSeat>{data.chapelseat}</ChapelSeat>
              </StudentInfoRow>
            ))}
          </StudentInfo>
        </AdminInfo>
      </StyleAdminPage>
    </div>
  );
};

export default AdminPage;

const AdminManagementBox = styled.div``;
const RegistrationBtn = styled.button``;
const CorrectionBtn = styled.button``;
const DeleteBtn = styled.button``;
const LogoutBtn = styled.button``;
const SearchBar = styled.div``;

const StyleAdminPage = styled.div`
  display: flex;
  flex-direction: column;
  margin: auto;
  width: 100vw;
  min-width: 200px;
  max-width: 580px;
  padding: 0px 20px 40px 20px;
`;

const AdminTitle = styled.div`
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

const AdminInfo = styled.div`
  display: flex;
  flex-direction: column;

  margin-top: 20px;
  box-shadow: 0 2px 4px rgba(76, 76, 76, 0), 0 -2px 4px rgba(76, 76, 76, 0.1),
    2px 0 4px rgba(76, 76, 76, 0.1), -2px 0 4px rgba(76, 76, 76, 0.1);
  padding: 0px 34px;
  border-radius: 30px;
`;

const SutudentTitleBox = styled.div`
  display: flex;
  flex-direction: row;
  padding: 16px 0px;
  max-width: 512px;
  min-width: 200px;
  width: 100vw;
  border-bottom: 1px solid #e3e3e3;
`;

const StdTitleBox1 = styled.div`
  display: flex;
  font-size: 16px;
  font-weight: bold;
  margin-left: 46px;
`;
const StdTitleBox2 = styled.div`
  display: flex;
  font-size: 16px;
  font-weight: bold;
  margin-left: 95px;
`;
const SutudentInfoTitle = styled.div`
  margin-right: 50px;
`;
const SutudentInfoTitle2 = styled.div`
  margin-left: 30px;
`;
const SutudentInfoTitle3 = styled.div`
  margin-left: 28px;
  font-size: 16px;
  font-weight: bold;
`;

const StudentInfo = styled.div`
  display: flex;
  flex-direction: column;
`;

const StudentInfoRow = styled.div`
  display: flex;
  align-items: center;
  padding: 13px 0px;
  border-bottom: 1px solid #e3e3e3;
`;

const ClickBox = styled.input`
  margin-left: 15px;
`;
const StudentName = styled.div`
  max-width: 60px;
  min-width: 30px;
  width: 100vw;
  margin-left: 15px;
  font-size: 14px;
`;
const StudentId = styled.div`
  margin-left: 27px;
  font-size: 14px;
`;
const StudentClass = styled.div`
  display: flex;
  max-width: 120px;
  min-width: 60px;
  width: 100vw;
  font-size: 14px;
  margin-left: 40px;
`;
const Chapel = styled.div`
  font-size: 14px;
  margin-left: 40px;
`;
const ChapelSeat = styled.div`
  font-size: 14px;
  margin-left: 35px;
`;
