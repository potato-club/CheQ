import styled from "styled-components";
import { useForm } from "react-hook-form";
import Hansei from "../../image/hansei.png";
import { useNavigate } from "react-router-dom"; // useNavigate 훅 임포트

const LoginPage = () => {
  const signup = useNavigate(); // useNavigate 훅 사용
  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm();

  // 정보를 출력하는 코드
  const onSubmit = (data: any) => {
    console.log(data);
    if (data.studentid === "admin" && data.password === "admin") {
      signup("/admin");
    } else {
      signup("/main");
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
            <label htmlFor="studentid">아이디</label>
            <input
              id="studentid" // studentid로 변경
              type="text"
              placeholder="학번을 입력해주세요."
              {...register("studentid", {
                required: "학번은 필수 입력입니다.",
                validate: (value) =>
                  value === "admin" ||
                  /^\d{9}$/.test(value) ||
                  "자신의 학번을 입력해주세요.",
              })}
            />
            {errors.studentid && (
              <ErrorMessage>{errors.studentid.message as string}</ErrorMessage>
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
                  /^(?=.*[a-zA-Z])(?=.*[0-9]).{8,}$/.test(value) ||
                  "영문+숫자 조합 8자 이상 입력해주세요.",
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

// const HanseiIcon = styled.img`
//   margin: auto;
//   padding: 70px 0px 70px 0px;
//   width: 400px;
//   height: 400px;
//   content: url(${Hansei});
// `;

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

// const SignUpButton = styled.button`
//   width: 100%;
//   padding: 12px;
//   background-color: white;
//   color: #375cde;
//   font-weight: bold;
//   border: 1px solid #375cde;
//   border-radius: 10px;
//   /* width: 580px; */
//   cursor: default; /* 클릭 비활성화 */
//   pointer-events: none; /* 클릭 이벤트 비활성화 */
// `;
