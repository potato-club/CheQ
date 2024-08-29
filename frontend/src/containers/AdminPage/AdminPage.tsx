import styled from "styled-components";
import React, { useState, useEffect } from "react";
import { useForm } from "react-hook-form";
import { useNavigate } from "react-router-dom";
import axios from "axios";

interface AdminData {
  checkbox: boolean;
  email: string;
  studentId: number;
  major: string;
  chapelKind: string;
  seat: string;
}

const AdminPage = () => {
  const [adminData, setAdminData] = useState<AdminData[]>([]);
  const [filteredData, setFilteredData] = useState<AdminData[]>([]);
  const [showLogoutModal, setShowLogoutModal] = useState(false);
  const [showRegistrationModal, setShowRegistrationModal] = useState(false);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);
  const [editIndex, setEditIndex] = useState<number | null>(null);
  const [primaryKey, setPrimaryKey] = useState<string | undefined>(undefined);
  const [studentIdsToDelete, setStudentIdsToDelete] = useState<number[]>([]); // 상태 추가
  const navigate = useNavigate();

  const atToken = localStorage.getItem("at");

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await axios.get(
          "https://dual-kayla-gamza-9d3cdf9c.koyeb.app/admin/view",
          {
            headers: {
              AT: `${atToken}`,
            },
          }
        );

        const fetchedData = response.data.map((item: any) => ({
          checkbox: false,
          email: item.email,
          studentId: parseInt(item.studentId),
          major: item.major,
          chapelKind: item.chapelKind,
          seat: item.seat,
        }));

        setAdminData(fetchedData);
        setFilteredData(fetchedData);
      } catch (error) {
        console.error("Error fetching student data:", error);
      }
    };

    fetchData();
  }, [atToken]);

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
    try {
      for (const studentId of studentIdsToDelete) {
        await axios.delete(
          `https://dual-kayla-gamza-9d3cdf9c.koyeb.app/admin/delete/${studentId}`,
          {
            headers: {
              AT: `${atToken}`,
            },
          }
        );
      }
      const newData = adminData.filter(
        (item) => !studentIdsToDelete.includes(item.studentId)
      );
      setAdminData(newData);
      setFilteredData(newData);
      setStudentIdsToDelete([]); // 선택된 ID 리스트 초기화
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
      const chapelWithSuffix = student.chapelKind;
      return (
        student.email.toLowerCase().includes(searchQuery) ||
        student.studentId.toString().includes(searchQuery) ||
        student.major.toLowerCase().includes(searchQuery) ||
        chapelWithSuffix.toLowerCase().includes(searchQuery) ||
        student.seat.toLowerCase().includes(searchQuery)
      );
    });
    setFilteredData(filtered);
  };
  const handleRegistration = async (data: any) => {
    const existingStudent = adminData.some(
      (student) =>
        student.email === data.name ||
        student.studentId === parseInt(data.studentId)
    );

    if (existingStudent) {
      alert("이미 등록된 데이터입니다.");
    } else {
      const newStudent = {
        checkbox: false,
        email: data.name,
        studentId: parseInt(data.studentId),
        major: data.major,
        chapelKind: `CHAPEL${data.chapel}`,
        seat: data.seat,
      };

      const studentData = {
        email: data.name,
        studentId: data.studentId.toString(),
        seat: data.seat,
        major: data.major,
        chapelKind: `CHAPEL${data.chapel}`,
      };

      try {
        const response = await axios.post(
          "https://dual-kayla-gamza-9d3cdf9c.koyeb.app/user/join",
          studentData
        );

        const primaryKey = response.data;

        // 각 사용자 이메일을 키로 하여 primaryKey를 저장합니다.
        const storedKeys = JSON.parse(
          localStorage.getItem("primaryKeys") || "{}"
        );
        storedKeys[data.name] = primaryKey;
        localStorage.setItem("primaryKeys", JSON.stringify(storedKeys));

        setPrimaryKey(primaryKey);

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
    // 사용자 이메일에 해당하는 primaryKey를 로컬스토리지에서 가져옵니다.
    const storedKeys = JSON.parse(localStorage.getItem("primaryKeys") || "{}");
    const primaryKey = storedKeys[data.name];

    if (!primaryKey) {
      console.error("No primary key found for this user.");
      return;
    }

    const editedData: AdminData = {
      checkbox: false,
      email: data.name,
      studentId: parseInt(data.studentId),
      major: data.major,
      chapelKind: `CHAPEL${data.chapel}`,
      seat: data.seat,
    };

    const updatedData = [...adminData];
    updatedData[editIndex!] = editedData;

    try {
      await axios.put(
        `https://dual-kayla-gamza-9d3cdf9c.koyeb.app/user/${primaryKey}`,
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
    const studentId = newData[index].studentId;
    newData[index].checkbox = !newData[index].checkbox;

    if (newData[index].checkbox) {
      setStudentIdsToDelete([...studentIdsToDelete, studentId]);
    } else {
      setStudentIdsToDelete(
        studentIdsToDelete.filter((id) => id !== studentId)
      );
    }

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
              <StudentName>{data.email}</StudentName>
              <StudentId>{data.studentId}</StudentId>
              <StudentClass>{data.major}</StudentClass>
              <Chapel>{data.chapelKind}</Chapel> {/* 변경된 부분 */}
              <ChapelSeat>{data.seat}</ChapelSeat>
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
                  {...register("studentId", { required: true })}
                />
              </ModalInputBox>
              <ModalInputBox>
                <ModalLabel>학과</ModalLabel>
                <ModalInput
                  type="text"
                  {...register("major", { required: true })}
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
                  {...register("seat", { required: true })}
                />
              </ModalInputBox>
              <ModalButton type="submit">등록</ModalButton>
              <ModalButton onClick={() => setShowRegistrationModal(false)}>
                취소
              </ModalButton>
            </form>
          </ModalContent>
        </RegistrationModal>
      )}
      {showDeleteModal && (
        <Modal>
          <ModalContent>
            <ModalTitle>삭제 확인</ModalTitle>
            <p>선택한 학생 데이터를 삭제하시겠습니까?</p>
            <ModalButton onClick={handleConfirmDelete}>확인</ModalButton>
            <ModalButton onClick={handleCancelDelete}>취소</ModalButton>
          </ModalContent>
        </Modal>
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
                  defaultValue={filteredData[editIndex].email}
                  {...register("name", { required: true })}
                />
              </ModalInputBox>
              <ModalInputBox>
                <ModalLabel>학번</ModalLabel>
                <ModalInput
                  type="number"
                  defaultValue={filteredData[editIndex].studentId}
                  {...register("studentId", { required: true })}
                />
              </ModalInputBox>
              <ModalInputBox>
                <ModalLabel>학과</ModalLabel>
                <ModalInput
                  type="text"
                  defaultValue={filteredData[editIndex].major}
                  {...register("major", { required: true })}
                />
              </ModalInputBox>
              <ModalInputBox>
                <ModalLabel>채플</ModalLabel>
                <ModalInput
                  type="number"
                  defaultValue={parseInt(
                    filteredData[editIndex].chapelKind.replace("CHAPEL", "")
                  )} // 변경된 부분
                  {...register("chapel", { required: true })}
                />
              </ModalInputBox>
              <ModalInputBox>
                <ModalLabel>좌석</ModalLabel>
                <ModalInput
                  type="text"
                  defaultValue={filteredData[editIndex].seat}
                  {...register("seat", { required: true })}
                />
              </ModalInputBox>
              <ModalButton type="submit">저장</ModalButton>
              <ModalButton onClick={() => setShowEditModal(false)}>
                취소
              </ModalButton>
            </form>
          </ModalContent>
        </EditModal>
      )}
      {showLogoutModal && (
        <Modal>
          <ModalContent>
            <ModalTitle>로그아웃</ModalTitle>
            <p>정말 로그아웃하시겠습니까?</p>
            <ModalButton onClick={handleConfirmLogout}>확인</ModalButton>
            <ModalButton onClick={handleCancelLogout}>취소</ModalButton>
          </ModalContent>
        </Modal>
      )}
    </StyleAdminPage>
  );
};

export default AdminPage;

const StyleAdminPage = styled.div`
  display: flex;
  flex-direction: column;
  margin: auto;
  width: 100vw;
  min-width: 200px;
  max-width: 580px;
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
  padding: 10px 56px 10px 35px;
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
