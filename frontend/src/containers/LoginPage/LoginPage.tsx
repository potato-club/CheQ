import styled from "styled-components";
import { useForm } from "react-hook-form";
import Hansei from "../../image/hansei.png";
import { useNavigate } from "react-router-dom";
import axios from "axios";

const LoginPage = () => {
  const navigate = useNavigate();
  const { register, handleSubmit } = useForm();

  const onSubmit = async (data: any) => {
    const loginData = {
      studentId: data.studentId,
      password: data.password,
    };
    const adminData = {
      email: data.studentId,
      password: data.password,
    };

    const adminUrl = "https://dual-kayla-gamza-9d3cdf9c.koyeb.app/admin/login";
    const userUrl = "https://dual-kayla-gamza-9d3cdf9c.koyeb.app/user/login";

    try {
      const response = await axios.post(userUrl, loginData);

      if (response.status === 200) {
        const token = response.data.token;
        localStorage.setItem("token", token);
        alert("사용자로 로그인 되었습니다!");
        navigate("/main");
      }
    } catch (userError) {
      console.error("User login failed:", userError);

      try {
        const adminResponse = await axios.post(adminUrl, adminData);

        if (adminResponse.status === 200) {
          const adminToken = adminResponse.data.token;
          localStorage.setItem("token", adminToken);
          alert("관리자로 로그인 되었습니다!");
          navigate("/admin");
        } else {
          alert("로그인에 실패했습니다. 다시 시도해주세요.");
        }
      } catch (adminError) {
        console.error("Admin login failed:", adminError);
        alert("로그인 중 오류가 발생했습니다. 다시 시도해주세요.");
      }
    }
  };

  return (
    <div>
      <StyleLoginPage>
        <LoginTitle>
          <MainTitle>CheQ</MainTitle>
        </LoginTitle>
        <HanseiIcon />
        <LoginForm onSubmit={handleSubmit(onSubmit)}>
          <FormRow>
            <label htmlFor="studentId">아이디</label>
            <input
              id="studentId"
              type="text"
              placeholder="학번을 입력해주세요."
              {...register("studentId")}
            />
          </FormRow>

          <FormRow>
            <label htmlFor="password">비밀번호</label>
            <input
              id="password"
              type="password"
              placeholder="비밀번호를 입력하세요."
              {...register("password")}
            />
          </FormRow>
          <LoginBtn>
            <SubmitButton type="submit">로그인</SubmitButton>
          </LoginBtn>
        </LoginForm>
      </StyleLoginPage>
    </div>
  );
};

export default LoginPage;

const LoginForm = styled.form`
  display: flex;
  flex-direction: column;
  padding-right: 28px;
`;

const FormRow = styled.div`
  display: flex;
  flex-direction: column;
  margin-bottom: 15px;
  label {
    font-size: 18px;
    color: #cdd6f7;
    font-weight: bold;
    margin-bottom: 4px;
  }

  input {
    width: 100%;
    padding: 10px 10px 10px 15px;
    border: 1px solid #375cde;
    border-radius: 20px;
    &::placeholder {
      color: #375cde;
    }
  }
`;

const StyleLoginPage = styled.div`
  display: flex;
  flex-direction: column;
  margin: auto;
  width: 100vw;
  min-width: 200px;
  max-width: 580px;
  padding: 0px 20px 40px 20px;
`;

const LoginTitle = styled.div`
  display: flex;
  width: 100%;
  justify-content: space-between;
  align-items: center;
`;

const MainTitle = styled.h1`
  color: #375cde;
`;

const LoginBtn = styled.div`
  display: flex;
  flex-direction: column;
  margin: auto;
  width: 100vw;
  min-width: 200px;
  max-width: 580px;
  position: fixed;
  bottom: 1%;
  left: 50%;
  transform: translateX(-50%);
  z-index: 1;
`;

const SubmitButton = styled.button`
  width: 100%;
  padding: 12px;
  background-color: #375cde;
  color: white;
  font-weight: bold;
  border: none;
  border-radius: 10px;
  cursor: pointer;
  margin-bottom: 15px;
  margin-top: 20px;
`;

const HanseiIcon = styled.img`
  display: flex;
  margin: auto;
  padding: 20px 0px 40px;
  width: 100vw;
  max-width: 300px;
  height: auto;
  object-fit: contain;
  content: url(${Hansei});
`;
