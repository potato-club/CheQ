import styled from "styled-components";
import React, { useState, useEffect } from "react";
import { UseFormReturn, useForm } from "react-hook-form";
import { useNavigate } from "react-router-dom";

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
  const [filteredData, setFilteredData] = useState<AdminData[]>([]);
  const [showLogoutModal, setShowLogoutModal] = useState(false);
  const [showRegistrationModal, setShowRegistrationModal] = useState(false);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const navigate = useNavigate();

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
      checkbox: false,
      name: "남궁지수",
      studentid: 202110651,
      studentclass: "미디어영상광고학",
      chapel: 7,
      chapelseat: "E56",
    },
    {
      checkbox: false,
      name: "송태진",
      studentid: 202110034,
      studentclass: "컴퓨터공학",
      chapel: 3,
      chapelseat: "A01",
    },
  ];

  useEffect(() => {
    setAdminData(TestData);
    setFilteredData(TestData);
  }, []);

  const handleLogout = () => {
    setShowLogoutModal(true);
  };

  const handleConfirmLogout = () => {
    navigate("/");
  };

  const handleCancelLogout = () => {
    setShowLogoutModal(false);
  };

  const handleDelete = () => {
    setShowDeleteModal(true);
  };

  const handleConfirmDelete = () => {
    const newData = adminData.filter((item) => !item.checkbox);
    setAdminData(newData);
    setFilteredData(newData);
    setShowDeleteModal(false);
  };

  const handleCancelDelete = () => {
    setShowDeleteModal(false);
  };

  const { register, handleSubmit } = useForm();

  const onSubmit = (data: any) => {
    const searchQuery = data.search.toLowerCase();
    const filtered = adminData.filter((student) => {
      const chapelWithSuffix = `${student.chapel}교시`;
      return (
        student.name.toLowerCase().includes(searchQuery) ||
        student.studentid.toString().includes(searchQuery) ||
        student.studentclass.toLowerCase().includes(searchQuery) ||
        student.chapel.toString().includes(searchQuery) ||
        chapelWithSuffix.includes(searchQuery) ||
        student.chapelseat.toLowerCase().includes(searchQuery)
      );
    });
    setFilteredData(filtered);
  };
  const handleRegistration = (data: any) => {
    const existingStudent = adminData.some(
      (student) =>
        student.name === data.name ||
        student.studentid === parseInt(data.studentid)
    );

    if (existingStudent) {
      alert("이미 등록된 데이터입니다.");
    } else {
      const newAdminData = [
        ...adminData,
        {
          checkbox: false,
          name: data.name,
          studentid: parseInt(data.studentid),
          studentclass: data.studentclass,
          chapel: parseInt(data.chapel),
          chapelseat: data.chapelseat,
        },
      ];
      setAdminData(newAdminData);
      setFilteredData(newAdminData);
      setShowRegistrationModal(false);
    }
  };

  const handleCheckboxChange = (index: number) => {
    const newData = [...adminData];
    newData[index].checkbox = !newData[index].checkbox;
    setAdminData(newData);
  };

  return (
    <div>
      <StyleAdminPage>
        <AdminTitle>
          <MainTitle>CheQ</MainTitle>
          <SubTitle>관리자 페이지</SubTitle>
        </AdminTitle>
        <AdminManagementBox>
          <AdminMangementBtnBox>
            <RegistrationBtn onClick={() => setShowRegistrationModal(true)}>
              등록
            </RegistrationBtn>
            <CorrectionBtn>수정</CorrectionBtn>
            <DeleteBtn onClick={handleDelete}>삭제</DeleteBtn>
            <LogoutBtn onClick={handleLogout}>로그아웃</LogoutBtn>
          </AdminMangementBtnBox>
          <AdminMangementSearchBox>
            <SearchBar>
              <form onSubmit={handleSubmit(onSubmit)}>
                <SearchInput
                  type="text"
                  placeholder="원하는 정보를 입력하세요"
                  {...register("search")}
                />
                <SearchButton type="submit">검색</SearchButton>
              </form>
            </SearchBar>
          </AdminMangementSearchBox>
        </AdminManagementBox>
        <AdminInfo>
          <StudentTitleBox>
            <StdTitleBox1>
              <StudentInfoTitle>이름</StudentInfoTitle>
              <StudentInfoTitle>학번</StudentInfoTitle>
            </StdTitleBox1>
            <StudentInfoTitle3>학과</StudentInfoTitle3>
            <StdTitleBox2>
              <StudentInfoTitle2>채플</StudentInfoTitle2>
              <StudentInfoTitle2>좌석</StudentInfoTitle2>
            </StdTitleBox2>
          </StudentTitleBox>
          <StudentInfo>
            {filteredData.map((data, index) => (
              <StudentInfoRow key={index}>
                <ClickBox
                  type="checkbox"
                  checked={data.checkbox}
                  onChange={() => handleCheckboxChange(index)}
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

      {showRegistrationModal && (
        <RegistrationModal>
          <ModalContent>
            <ModalTitle>학생 등록</ModalTitle>
            <InputContainer>
              <InputLabel>이름:</InputLabel>
              <InputField {...register("name")} />
            </InputContainer>
            <InputContainer>
              <InputLabel>학번:</InputLabel>
              <InputField type="number" {...register("studentid")} />
            </InputContainer>
            <InputContainer>
              <InputLabel>학과:</InputLabel>
              <InputField {...register("studentclass")} />
            </InputContainer>
            <InputContainer>
              <InputLabel>채플:</InputLabel>
              <InputField type="number" {...register("chapel")} />
            </InputContainer>
            <InputContainer>
              <InputLabel>좌석:</InputLabel>
              <InputField {...register("chapelseat")} />
            </InputContainer>
            <ModulButtonBox>
              <ModalButton onClick={handleSubmit(handleRegistration)}>
                등록
              </ModalButton>
              <ModalButtonCancel
                onClick={() => setShowRegistrationModal(false)}
              >
                취소
              </ModalButtonCancel>
            </ModulButtonBox>
          </ModalContent>
        </RegistrationModal>
      )}

      {showDeleteModal && (
        <DeleteModal>
          <ModalContent>
            <ModalMessage>정말로 삭제할까요?</ModalMessage>
            <ModalButtonBox>
              <ModalButton onClick={handleConfirmDelete}>Yes</ModalButton>
              <ModalButton onClick={handleCancelDelete}>No</ModalButton>
            </ModalButtonBox>
          </ModalContent>
        </DeleteModal>
      )}

      {showLogoutModal && (
        <LogoutModal>
          <ModalContent>
            <ModalMessage>로그아웃 하시겠습니까?</ModalMessage>
            <ModalButtonBox>
              <ModalButton onClick={handleConfirmLogout}>Yes</ModalButton>
              <ModalButton onClick={handleCancelLogout}>No</ModalButton>
            </ModalButtonBox>
          </ModalContent>
        </LogoutModal>
      )}
    </div>
  );
};

export default AdminPage;

const DeleteModal = styled.div`
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 30%;
  padding: 20px;
  background-color: white;
  border: 1px solid #375cde;
  border-radius: 10px;
  display: flex;
  flex-direction: column;
  align-items: center;
`;

const RegistrationModal = styled.div`
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 30%;
  padding: 20px;
  background-color: white;
  border: 1px solid #375cde;
  border-radius: 10px;
  display: flex;
  flex-direction: column;
  align-items: center;
`;

const ModalTitle = styled.h2`
  font-size: 18px;
  margin-bottom: 20px;
`;

const InputContainer = styled.div`
  margin-bottom: 15px;
`;

const InputLabel = styled.label`
  font-size: 16px;
  margin-bottom: 5px;
`;

const InputField = styled.input`
  padding: 5px;
  font-size: 14px;
  border-radius: 5px;
  border: 1px solid #ccc;
  width: 100%;
`;
const ModulButtonBox = styled.div`
  display: flex;
  flex-direction: row;
`;
//
const ModalContent = styled.div`
  display: flex;
  padding: 20px;
  border-radius: 10px;
  flex-direction: column;
  align-items: center;
`;

const LogoutModal = styled.div`
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -100%);
  width: 20%;
  height: 20%;
  background-color: rgba(0, 0, 0, 0.5);
  padding: 20px;
  background-color: white;
  border: 1px solid #375cde;
  border-radius: 10px;
  display: flex;
  flex-direction: column;
  align-items: center;
`;

const ModalMessage = styled.p`
  font-size: 15px;
  margin-bottom: 20px;
`;

const ModalButtonBox = styled.div`
  display: flex;
  font-size: 13px;
`;

const ModalButton = styled.button`
  padding: 10px 20px;
  margin: 0 10px;
  border-radius: 5px;
  border: none;
  background-color: #375cde;
  color: white;
  cursor: pointer;
`;
const ModalButtonCancel = styled.button`
  padding: 10px 20px;
  margin: 0 10px;
  border-radius: 5px;
  border: none;
  background-color: #375cde;
  color: white;
  cursor: pointer;
`;

const AdminManagementBox = styled.div`
  display: flex;
  flex-direction: row;
  justify-content: space-between;
`;
const AdminMangementBtnBox = styled.div``;
const AdminMangementSearchBox = styled.div``;
const RegistrationBtn = styled.button`
  padding: 5px 13px;
  border-radius: 10px;
  font-size: 12px;
  border: none;
  color: white;
  background-color: #375cde;
  margin-right: 10px;
  cursor: pointer;
`;
const CorrectionBtn = styled.button`
  padding: 5px 13px;
  border-radius: 10px;
  font-size: 12px;
  border: none;
  color: white;
  background-color: #375cde;
  margin-right: 10px;
  cursor: pointer;
`;
const DeleteBtn = styled.button`
  padding: 5px 13px;
  border-radius: 10px;
  font-size: 12px;
  border: none;
  color: white;
  background-color: #375cde;
  margin-right: 10px;
  cursor: pointer;
`;
const LogoutBtn = styled.button`
  padding: 5px 13px;
  border-radius: 10px;
  font-size: 12px;
  border: none;
  color: white;
  background-color: #375cde;
  cursor: pointer;
`;
const SearchBar = styled.div`
  form {
    display: flex;
    align-items: center;
  }
`;

const SearchInput = styled.input`
  padding: 5px;
  font-size: 14px;
  border: none;
  border-bottom: 2px solid #375cde;
  margin-right: 5px;
  outline: none;
`;

const SearchButton = styled.button`
  padding: 5px 10px;
  font-size: 14px;
  border-radius: 5px;
  border: none;
  color: white;
  background-color: #375cde;
  cursor: pointer;
`;

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

const StudentTitleBox = styled.div`
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
  margin-left: 48px;
`;
const StdTitleBox2 = styled.div`
  display: flex;
  font-size: 16px;
  font-weight: bold;
  margin-left: 100px;
`;
const StudentInfoTitle = styled.div`
  margin-right: 50px;
`;
const StudentInfoTitle2 = styled.div`
  margin-left: 30px;
`;
const StudentInfoTitle3 = styled.div`
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
