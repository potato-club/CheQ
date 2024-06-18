import styled from "styled-components";
import { useForm } from "react-hook-form";
import Hansei from "../../image/hansei.png";
import { useNavigate } from "react-router-dom"; // useNavigate 훅 임포트
import { useState } from "react";
import axios from "axios";

const LoginPage = () => {
  // const [error, setError] = useState("");
  const signup = useNavigate(); // useNavigate 훅 사용
  const {
    register,
    handleSubmit,
    formState: { errors },
    watch,
  } = useForm();

  // 정보를 출력하는 코드
  const onSubmit = async (data: any) => {
    const loginData = {
      studentId: data.studentId,
      password: data.password,
    };
    if (data.studentId === "admin" && data.password === "admin") {
      try {
        const adminResponse = await axios.post(
          "http://isaacnas.duckdns.org:8083/admin/login",
          loginData
        );

        console.log("서버 응답 (admin):", adminResponse); // 디버깅을 위해 콘솔에 출력

        if (adminResponse.status === 200 || adminResponse.data.success) {
          alert("관리자 로그인 되었습니다!");
          signup("/admin");
        } else {
          alert("관리자 로그인에 실패했습니다. 다시 시도해주세요.");
        }
      } catch (error: any) {
        if (error.response) {
          // 요청이 이루어졌고 서버가 2xx 범위 외의 상태 코드로 응답함
          console.error("Error response (admin):", error.response.data);
          alert(`관리자 로그인에 실패했습니다: ${error.response.data.message}`);
        } else if (error.request) {
          // 요청이 이루어졌지만 응답을 받지 못함
          console.error("Error request (admin):", error.request);
          alert(
            "관리자 로그인 서버로부터 응답이 없습니다. 나중에 다시 시도해주세요."
          );
        } else {
          // 요청 설정 중 오류가 발생함
          console.error("Error message (admin):", error.message);
          alert("관리자 로그인 중 오류가 발생했습니다. 다시 시도해주세요.");
        }
      }
    } else {
      try {
        const response = await axios.post(
          "http://isaacnas.duckdns.org:8083/user/login",
          loginData
        );

        console.log("서버 응답:", response); // 디버깅을 위해 콘솔에 출력

        if (response.status === 200 || response.data.success) {
          alert("로그인 되었습니다!");
          signup("/main");
        } else {
          alert("로그인에 실패했습니다. 다시 시도해주세요.");
        }
      } catch (error: any) {
        if (error.response) {
          // 요청이 이루어졌고 서버가 2xx 범위 외의 상태 코드로 응답함
          console.error("Error response:", error.response.data);
          alert(`로그인에 실패했습니다: ${error.response.data.message}`);
        } else if (error.request) {
          // 요청이 이루어졌지만 응답을 받지 못함
          console.error("Error request:", error.request);
          alert("로그인 서버로부터 응답이 없습니다. 나중에 다시 시도해주세요.");
        } else {
          // 요청 설정 중 오류가 발생함
          console.error("Error message:", error.message);
          alert("로그인 중 오류가 발생했습니다. 다시 시도해주세요.");
        }
      }
    }
  };
  //   if (data.studentId === "admin" && data.password === "admin") {
  //     signup("/admin");
  //     // if (data.studentId === "admin") {
  //     //   signup("/admin");
  //   }
  //   try {
  //     const response = await axios.post(
  //       "http://isaacnas.duckdns.org:8083/user/login",
  //       loginData
  //     );

  //     console.log("서버 응답:", response); // 디버깅을 위해 콘솔에 출력

  //     if (response.status === 200 || response.data.success) {
  //       alert("로그인 되었습니다!");
  //       signup("/main");
  //     } else {
  //       alert("로그인에 실패했습니다. 다시 시도해주세요.");
  //     }
  //   } catch (error: any) {
  //     if (error.response) {
  //       // 요청이 이루어졌고 서버가 2xx 범위 외의 상태 코드로 응답함
  //       console.error("Error response:", error.response.data);
  //       alert(`로그인에 실패했습니다: ${error.response.data.message}`);
  //     } else if (error.request) {
  //       // 요청이 이루어졌지만 응답을 받지 못함
  //       console.error("Error request:", error.request);
  //       alert("로그인 서버로부터 응답이 없습니다. 나중에 다시 시도해주세요.");
  //     } else {
  //       // 요청 설정 중 오류가 발생함
  //       console.error("Error message:", error.message);
  //       alert("로그인 중 오류가 발생했습니다. 다시 시도해주세요.");
  //     }
  //   }
  // };

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
              id="studentId" // studentid로 변경
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
                // "영문+숫자 조합 8자 이상 입력해주세요.",
              })}
            />
            {errors.password && (
              <ErrorMessage>{errors.password.message as string}</ErrorMessage>
            )}
          </FormRow>
          <LoginBtn>
            <SubmitButton type="submit">로그인</SubmitButton>
            {/* <SignUpButton>회원가입</SignUpButton> */}
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
      /* font-weight: bold; */
      color: #375cde;
    }
  }
`;

const StyleLoginPage = styled.div`
  display: flex;
  flex-direction: column;
  margin: auto;
  /* width: 580px; */
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
  bottom: 3%;
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
  /* width: 580px; */
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
