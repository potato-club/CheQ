import styled from "styled-components";
import { useForm } from "react-hook-form";
import Hansei from "../../Image/hansei.png";
import { useNavigate } from "react-router-dom";
import { useState } from "react";
import axios from "axios";

const LoginPage = () => {
  const signup = useNavigate();
  const {
    register,
    handleSubmit,
    formState: { errors },
    watch,
  } = useForm();

  const onSubmit = async (data: any) => {
    const loginData = {
      studentId: data.studentId,
      password: data.password,
    };
    const url =
      data.studentId === "admin" && data.password === "admin"
        ? "http://isaacnas.duckdns.org:8083/admin/login"
        : "http://isaacnas.duckdns.org:8083/user/login";

    try {
      const response = await axios.post(url, loginData);
      console.log("서버 응답:", response);

      if (response.status === 200 || response.data.success) {
        const token = response.data.token;
        localStorage.setItem("token", token);
        alert("로그인 되었습니다!");
        const redirectUrl = data.studentId === "admin" ? "/admin" : "/main";
        signup(redirectUrl);
      } else {
        alert("로그인에 실패했습니다. 다시 시도해주세요.");
      }
    } catch (error: any) {
      if (error.response) {
        console.error("Error response:", error.response.data);
        alert(`로그인에 실패했습니다: ${error.response.data.message}`);
      } else if (error.request) {
        console.error("Error request:", error.request);
        alert("로그인 서버로부터 응답이 없습니다. 나중에 다시 시도해주세요.");
      } else {
        console.error("Error message:", error.message);
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
              {...register("studentId", {
                required: "학번은 필수 입력입니다.",
                validate: (value) =>
                  value === "admin" ||
                  /^\d{9}$/.test(value) ||
                  "자신의 학번을 입력해주세요.",
              })}
            />
            {errors.studentId && (
              <ErrorMessage>{errors.studentId.message as string}</ErrorMessage>
            )}
          </FormRow>

          <FormRow>
            <label htmlFor="password">비밀번호</label>
            <input
              id="password"
              type="password"
              placeholder="비밀번호를 입력하세요."
              {...register("password", {
                required: "비밀번호는 필수 입력입니다.",
                validate: (value) =>
                  value === "admin" ||
                  value === watch("studentId") ||
                  /^(?=.*[a-zA-Z])(?=.*[0-9]).{8,}$/.test(value) ||
                  "비밀번호를 제대로 입력해주세요.",
              })}
            />
            {errors.password && (
              <ErrorMessage>{errors.password.message as string}</ErrorMessage>
            )}
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

const ErrorMessage = styled.small`
  margin-top: 5px;
  color: red;
  margin-left: 16px;
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
