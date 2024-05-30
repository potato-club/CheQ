import styled from "styled-components";
import { useForm } from "react-hook-form";
import { useNavigate } from "react-router-dom"; // useNavigate 훅 임포트

const AdminPage = () => {
  return (
    <div>
      <StyleAdminPage>
        <AdminTitle>
          <MainTitle>CheQ</MainTitle>
          <SubTitle>관리자 페이지</SubTitle>
        </AdminTitle>
        학생 정보 수정 <br />
        학생 등록 <br />
        기기 값 등록
      </StyleAdminPage>
    </div>
  );
};

export default AdminPage;

const StyleAdminPage = styled.div`
  display: flex;
  flex-direction: column;
  margin: auto;
  /* width: 580px; */
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
