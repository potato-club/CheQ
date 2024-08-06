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
      studentid: 201910052,
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

  const handleConfirmDelete = async () => {
    const studentsToDelete = adminData.filter((item) => item.checkbox);

    try {
      for (const student of studentsToDelete) {
        await axios.delete(
          `http://isaacnas.duckdns.org:8083/admin/delete/${student.studentid}`
        );
      }
      const newData = adminData.filter((item) => !item.checkbox);
      setAdminData(newData);
      setFilteredData(newData);
      setShowDeleteModal(false);
    } catch (error) {
      console.error("Error deleting student data:", error);
    }
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

  const handleRegistration = async (data: any) => {
    const existingStudent = adminData.some(
      (student) =>
        student.name === data.name ||
        student.studentid === parseInt(data.studentid)
    );

    if (existingStudent) {
      alert("이미 등록된 데이터입니다.");
    } else {
      const newStudent = {
        checkbox: false,
        name: data.name,
        studentid: parseInt(data.studentid),
        studentclass: data.studentclass,
        chapel: parseInt(data.chapel),
        chapelseat: data.chapelseat,
      };

      const studentData = {
        email: data.name,
        studentId: data.studentid.toString(),
        seat: data.chapelseat,
        uuid: data.studentclass,
        chapelKind: `CHAPEL${data.chapel}`,
      };

      try {
        await axios.post(
          "http://isaacnas.duckdns.org:8083/user/join",
          studentData
        );
        const newAdminData = [...adminData, newStudent];
        setAdminData(newAdminData);
        setFilteredData(newAdminData);
        setShowRegistrationModal(false);
      } catch (error) {
        console.error("Error registering student data:", error);
      }
    }
  };

  const handleEdit = async (data: any) => {
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

    try {
      await axios.put(
        `http://isaacnas.duckdns.org:8083/user/${editedData.studentid}`,
        editedData
      );
      setAdminData(updatedData);
      setFilteredData(updatedData);
      setShowEditModal(false);
    } catch (error) {
      console.error("Error editing student data:", error);
    }
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
            <form onSubmit={handleSubmit(handleRegistration)}>
              <ModalInputBox>
                <ModalLabel>이름</ModalLabel>
                <ModalInput
                  type="text"
                  {...register("name", { required: true })}
                />
              </ModalInputBox>
              <ModalInputBox>
                <ModalLabel>학번</ModalLabel>
                <ModalInput
                  type="number"
                  {...register("studentid", { required: true })}
                />
              </ModalInputBox>
              <ModalInputBox>
                <ModalLabel>학과</ModalLabel>
                <ModalInput
                  type="text"
                  {...register("studentclass", { required: true })}
                />
              </ModalInputBox>
              <ModalInputBox>
                <ModalLabel>채플</ModalLabel>
                <ModalInput
                  type="number"
                  {...register("chapel", { required: true })}
                />
              </ModalInputBox>
              <ModalInputBox>
                <ModalLabel>좌석</ModalLabel>
                <ModalInput
                  type="text"
                  {...register("chapelseat", { required: true })}
                />
              </ModalInputBox>
              <ModalButton type="submit">등록</ModalButton>
              <ModalButton
                type="button"
                onClick={() => setShowRegistrationModal(false)}
              >
                취소
              </ModalButton>
            </form>
          </ModalContent>
        </RegistrationModal>
      )}
      {showEditModal && editIndex !== null && (
        <EditModal>
          <ModalContent>
            <ModalTitle>학생 정보 수정</ModalTitle>
            <form onSubmit={handleSubmit(handleEdit)}>
              <ModalInputBox>
                <ModalLabel>이름</ModalLabel>
                <ModalInput
                  type="text"
                  defaultValue={adminData[editIndex].name}
                  {...register("name", { required: true })}
                />
              </ModalInputBox>
              <ModalInputBox>
                <ModalLabel>학번</ModalLabel>
                <ModalInput
                  type="number"
                  defaultValue={adminData[editIndex].studentid}
                  {...register("studentid", { required: true })}
                />
              </ModalInputBox>
              <ModalInputBox>
                <ModalLabel>학과</ModalLabel>
                <ModalInput
                  type="text"
                  defaultValue={adminData[editIndex].studentclass}
                  {...register("studentclass", { required: true })}
                />
              </ModalInputBox>
              <ModalInputBox>
                <ModalLabel>채플</ModalLabel>
                <ModalInput
                  type="number"
                  defaultValue={adminData[editIndex].chapel}
                  {...register("chapel", { required: true })}
                />
              </ModalInputBox>
              <ModalInputBox>
                <ModalLabel>좌석</ModalLabel>
                <ModalInput
                  type="text"
                  defaultValue={adminData[editIndex].chapelseat}
                  {...register("chapelseat", { required: true })}
                />
              </ModalInputBox>
              <ModalButton type="submit">수정</ModalButton>
              <ModalButton
                type="button"
                onClick={() => setShowEditModal(false)}
              >
                취소
              </ModalButton>
            </form>
          </ModalContent>
        </EditModal>
      )}
      {showLogoutModal && (
        <LogoutModal>
          <ModalContent>
            <ModalTitle>로그아웃</ModalTitle>
            <ModalMessage>정말 로그아웃 하시겠습니까?</ModalMessage>
            <ModalButton onClick={handleConfirmLogout}>예</ModalButton>
            <ModalButton onClick={handleCancelLogout}>아니오</ModalButton>
          </ModalContent>
        </LogoutModal>
      )}
      {showDeleteModal && (
        <DeleteModal>
          <ModalContent>
            <ModalTitle>삭제 확인</ModalTitle>
            <ModalMessage>선택한 학생들을 삭제하시겠습니까?</ModalMessage>
            <ModalButton onClick={handleConfirmDelete}>예</ModalButton>
            <ModalButton onClick={handleCancelDelete}>아니오</ModalButton>
          </ModalContent>
        </DeleteModal>
      )}
    </StyleAdminPage>
  );
};

export default AdminPage;

// 스타일 컴포넌트들...
const StyleAdminPage = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 100%;
  padding: 20px;
`;

const AdminTitle = styled.div`
  text-align: center;
  margin-bottom: 20px;
`;

const MainTitle = styled.h1`
  font-size: 36px;
  margin: 0;
`;

const SubTitle = styled.h2`
  font-size: 24px;
  margin: 0;
`;

const AdminManagementBox = styled.div`
  display: flex;
  justify-content: space-between;
  width: 100%;
  margin-bottom: 20px;
`;

const AdminMangementBtnBox = styled.div`
  display: flex;
  gap: 10px;
`;

const RegistrationBtn = styled.button`
  padding: 10px 20px;
  background-color: #4caf50;
  color: white;
  border: none;
  cursor: pointer;
`;

const DeleteBtn = styled.button`
  padding: 10px 20px;
  background-color: #f44336;
  color: white;
  border: none;
  cursor: pointer;
`;

const LogoutBtn = styled.button`
  padding: 10px 20px;
  background-color: #008cba;
  color: white;
  border: none;
  cursor: pointer;
`;

const AdminMangementSearchBox = styled.div`
  flex-grow: 1;
  display: flex;
  justify-content: flex-end;
`;

const SearchBar = styled.div`
  display: flex;
`;

const SearchInput = styled.input`
  padding: 10px;
  font-size: 16px;
`;

const SearchButton = styled.button`
  padding: 10px;
  background-color: #4caf50;
  color: white;
  border: none;
  cursor: pointer;
`;

const AdminInfo = styled.div`
  width: 100%;
`;

const StudentTitleBox = styled.div`
  background-color: #f2f2f2;
  padding: 10px;
`;

const StdTitleBox1 = styled.div`
  display: flex;
  justify-content: space-between;
`;

const StudentInfoTitle = styled.span`
  flex: 1;
  text-align: center;
`;

const StudentInfoTitle2 = styled.span`
  flex: 1;
  text-align: center;
`;

const StudentInfoTitle3 = styled.span`
  flex: 1;
  text-align: center;
`;

const StudentInfo = styled.div`
  width: 100%;
`;

const StudentInfoRow = styled.div`
  display: flex;
  justify-content: space-between;
  padding: 10px;
  border-bottom: 1px solid #ddd;
`;

const ClickBox = styled.input`
  margin-right: 10px;
`;

const StudentName = styled.span`
  flex: 1;
  text-align: center;
`;

const StudentId = styled.span`
  flex: 1;
  text-align: center;
`;

const StudentClass = styled.span`
  flex: 1;
  text-align: center;
`;

const Chapel = styled.span`
  flex: 1;
  text-align: center;
`;

const ChapelSeat = styled.span`
  flex: 1;
  text-align: center;
`;

const EditButton = styled.button`
  padding: 5px 10px;
  background-color: #4caf50;
  color: white;
  border: none;
  cursor: pointer;
`;

const Modal = styled.div`
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
`;

const ModalContent = styled.div`
  background: white;
  padding: 20px;
  border-radius: 5px;
  text-align: center;
`;

const ModalTitle = styled.h3`
  margin: 0 0 20px 0;
`;

const ModalMessage = styled.p`
  margin: 0 0 20px 0;
`;

const ModalInputBox = styled.div`
  margin-bottom: 10px;
`;

const ModalLabel = styled.label`
  display: block;
  margin-bottom: 5px;
`;

const ModalInput = styled.input`
  width: 100%;
  padding: 8px;
  box-sizing: border-box;
`;

const ModalButton = styled.button`
  padding: 10px 20px;
  background-color: #4caf50;
  color: white;
  border: none;
  cursor: pointer;
  margin: 10px;
`;

const RegistrationModal = styled(Modal)``;

const EditModal = styled(Modal)``;

const LogoutModal = styled(Modal)``;

const DeleteModal = styled(Modal)``;
