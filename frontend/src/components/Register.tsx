import styled from "styled-components";

function Register() {
  return (
    <div>
      <RegisterBar>
        <ResgisterBtn>등록</ResgisterBtn>
      </RegisterBar>
    </div>
  );
}

export default Register;

const RegisterBar = styled.div`
  display: flex;
  justify-content: center;
  background-color: #375cde;
  height: 80px;
  border-radius: 14px;
  width: 100vw;
  min-width: 200px;
  max-width: 620px;
  padding: 0px 20px 0px 20px;
  margin: auto;
  position: fixed;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
`;
const ResgisterBtn = styled.button`
  border: none;
  outline: none;
  background-color: transparent;
  color: white;
  font-size: 20px;
  cursor: pointer;
`;
