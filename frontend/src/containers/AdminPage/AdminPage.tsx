import styled from "styled-components";
import React, { useState, useEffect } from "react";
import { useForm } from "react-hook-form";
import { useNavigate } from "react-router-dom";
import axios from "axios";

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
  const [showEditModal, setShowEditModal] = useState(false);
  const [editIndex, setEditIndex] = useState<number | null>(null);
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

  const handleEdit = (data: any) => {
    const editedData: AdminData = {
      checkbox: false,
      name: data.name,
      studentid: parseInt(data.studentid),
      studentclass: data.studentclass,
      chapel: parseInt(data.chapel),
      chapelseat: data.chapelseat,
    };

    const updatedData = [...adminData];
    updatedData[editIndex!] = editedData;

    axios
      .put(
        `http://isaacnas.duckdns.org:8083/user/
${editedData.studentid}`,
        editedData
      )
      .then((response) => {
        setAdminData(updatedData);
        setFilteredData(updatedData);
        setShowEditModal(false);
      })
      .catch((error) => {
        console.error("Error editing student data:", error);
      });
  };

  const handleCheckboxChange = (index: number) => {
    const newData = [...adminData];
    newData[index].checkbox = !newData[index].checkbox;
    setAdminData(newData);
  };

  const handleEditClick = (index: number) => {
    setEditIndex(index);
    setShowEditModal(true);
  };

  return (
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
          {/* <CorrectionBtn>수정</CorrectionBtn> */}
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
            <StudentInfoTitle3>학번</StudentInfoTitle3>
            <StudentInfoTitle2>학과</StudentInfoTitle2>
            <StudentInfoTitle2>채플</StudentInfoTitle2>
            <StudentInfoTitle2>좌석</StudentInfoTitle2>
          </StdTitleBox1>
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
              <EditButton onClick={() => handleEditClick(index)}>
                수정
              </EditButton>
            </StudentInfoRow>
          ))}
        </StudentInfo>
      </AdminInfo>
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
      {showEditModal && (
        <EditModal>
          <ModalContent>
            <ModalTitle>학생 정보 수정</ModalTitle>
            <InputContainer>
              <InputLabel>이름:</InputLabel>
              <InputField
                defaultValue={adminData[editIndex!].name}
                {...register("name")}
              />
            </InputContainer>
            <InputContainer>
              <InputLabel>학번:</InputLabel>
              <InputField
                defaultValue={adminData[editIndex!].studentid}
                type="number"
                {...register("studentid")}
              />
            </InputContainer>
            <InputContainer>
              <InputLabel>학과:</InputLabel>
              <InputField
                defaultValue={adminData[editIndex!].studentclass}
                {...register("studentclass")}
              />
            </InputContainer>
            <InputContainer>
              <InputLabel>채플:</InputLabel>
              <InputField
                defaultValue={adminData[editIndex!].chapel}
                type="number"
                {...register("chapel")}
              />
            </InputContainer>
            <InputContainer>
              <InputLabel>좌석:</InputLabel>
              <InputField
                defaultValue={adminData[editIndex!].chapelseat}
                {...register("chapelseat")}
              />
            </InputContainer>
            <ModulButtonBox>
              <ModalButton onClick={handleSubmit(handleEdit)}>수정</ModalButton>
              <ModalButtonCancel onClick={() => setShowEditModal(false)}>
                취소
              </ModalButtonCancel>
            </ModulButtonBox>
          </ModalContent>
        </EditModal>
      )}
      {showDeleteModal && (
        <DeleteModal>
          <ModalContent>
            <ModalTitle>학생 삭제</ModalTitle>
            <DeleteModalText>선택된 학생을 삭제하시겠습니까?</DeleteModalText>
            <ModulButtonBox>
              <ModalButton onClick={handleConfirmDelete}>확인</ModalButton>
              <ModalButtonCancel onClick={handleCancelDelete}>
                취소
              </ModalButtonCancel>
            </ModulButtonBox>
          </ModalContent>
        </DeleteModal>
      )}
      {showLogoutModal && (
        <LogoutModal>
          <ModalContent>
            <ModalTitle>로그아웃</ModalTitle>
            <LogoutModalText>로그아웃 하시겠습니까?</LogoutModalText>
            <ModulButtonBox>
              <ModalButton onClick={handleConfirmLogout}>확인</ModalButton>
              <ModalButtonCancel onClick={handleCancelLogout}>
                취소
              </ModalButtonCancel>
            </ModulButtonBox>
          </ModalContent>
        </LogoutModal>
      )}
    </StyleAdminPage>
  );
};

export default AdminPage;

const StyleAdminPage = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-top: 50px;
`;

const AdminTitle = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
`;

const MainTitle = styled.h1`
  font-size: 32px;
  font-weight: bold;
  margin-bottom: 5px;
`;

const SubTitle = styled.h2`
  font-size: 20px;
  color: #777;
`;

const AdminManagementBox = styled.div`
  display: flex;
  justify-content: space-between;
  width: 70%;
  margin-top: 20px;
`;

const AdminMangementBtnBox = styled.div`
  display: flex;
  gap: 10px;
`;

const AdminMangementSearchBox = styled.div`
  width: 30%;
`;

const SearchBar = styled.div`
  display: flex;
  align-items: center;
  border: 1px solid #ccc;
  border-radius: 5px;
  padding: 5px;
`;

const SearchInput = styled.input`
  flex: 1;
  border: none;
  outline: none;
  padding: 5px;
`;

const SearchButton = styled.button`
  padding: 5px 13px;
  border-radius: 10px;
  font-size: 12px;
  border: none;
  color: white;
  background-color: #375cde;
  margin-right: 10px;
  cursor: pointer;
`;

const AdminInfo = styled.div`
  width: 70%;
  margin-top: 20px;
`;

const StudentTitleBox = styled.div`
  display: flex;
  align-items: center;
  background-color: #f0f0f0;
  padding: 10px 0;
  border-top-left-radius: 5px;
  border-top-right-radius: 5px;
`;

const StdTitleBox1 = styled.div`
  display: flex;
  flex: 1;
  justify-content: center;
`;

const StdTitleBox2 = styled.div`
  display: flex;
  flex: 1;
  justify-content: center;
`;

const StudentInfoTitle = styled.div`
  font-size: 16px;
  font-weight: bold;
  flex: 1;
  text-align: center;
`;

const StudentInfoTitle2 = styled(StudentInfoTitle)`
  flex: 1;
`;

const StudentInfoTitle3 = styled(StudentInfoTitle)`
  flex: 1;
`;

const StudentInfo = styled.div`
  border: 1px solid #ccc;
  border-top: none;
`;

const StudentInfoRow = styled.div`
  display: flex;
  align-items: center;
  padding: 10px 0;
  border-bottom: 1px solid #ccc;
`;

const ClickBox = styled.input`
  margin-right: 10px;
`;

const StudentName = styled.div`
  flex: 1;
  text-align: center;
`;

const StudentId = styled.div`
  flex: 1;
  text-align: center;
`;

const StudentClass = styled.div`
  flex: 2;
  text-align: center;
`;

const Chapel = styled.div`
  flex: 1;
  text-align: center;
`;

const ChapelSeat = styled.div`
  flex: 1;
  text-align: center;
`;

const EditButton = styled.button`
  padding: 5px 13px;
  border-radius: 10px;
  font-size: 12px;
  border: none;
  color: white;
  background-color: #375cde;
  margin-right: 10px;
  cursor: pointer;
`;

const ModulButtonBox = styled.div`
  display: flex;
  justify-content: flex-end;
  margin-top: 20px;
`;

const ModalContent = styled.div`
  background-color: #fff;
  border: 1px solid #ccc;
  border-radius: 5px;
  padding: 20px;
  width: 300px;
`;

const ModalTitle = styled.h2`
  font-size: 20px;
  font-weight: bold;
  margin-bottom: 10px;
  text-align: center;
`;

const InputContainer = styled.div`
  margin-bottom: 10px;
`;

const InputLabel = styled.label`
  font-size: 16px;
  font-weight: bold;
`;

const InputField = styled.input`
  width: 100%;
  padding: 5px;
  font-size: 16px;
  margin-top: 5px;
  border: 1px solid #ccc;
  border-radius: 5px;
`;

const ModalButton = styled.button`
  background-color: #007bff;
  color: white;
  border: none;
  outline: none;
  padding: 8px 16px;
  cursor: pointer;
  margin-right: 10px;
`;

const ModalButtonCancel = styled(ModalButton)`
  background-color: #dc3545;
`;

const RegistrationModal = styled.div`
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
`;

const EditModal = styled(RegistrationModal)``;

const DeleteModal = styled(RegistrationModal)``;

const LogoutModal = styled(RegistrationModal)``;

const LogoutModalText = styled.p`
  text-align: center;
`;

const DeleteModalText = styled.p`
  text-align: center;
`;

const CorrectionBtn = styled.button``;

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

const DeleteBtn = styled(RegistrationBtn)`
  padding: 5px 13px;
  border-radius: 10px;
  font-size: 12px;
  border: none;
  color: white;
  background-color: #375cde;
  margin-right: 10px;
  cursor: pointer;
`;

const LogoutBtn = styled(RegistrationBtn)`
  padding: 5px 13px;
  border-radius: 10px;
  font-size: 12px;
  border: none;
  color: white;
  background-color: #375cde;
  margin-right: 10px;
  cursor: pointer;
`;
