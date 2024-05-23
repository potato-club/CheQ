import styled from "styled-components";
import { useNavigate } from "react-router-dom"; // useNavigate 훅 임포트

function Navbar() {
  const movebtn = useNavigate(); // useNavigate 훅 사용

  const MainBtn = () => {
    movebtn("/login");
  };
  const AttendanceBtn = () => {
    movebtn("/login");
  };
  const MypageBtn = () => {
    movebtn("/login");
  };
  return (
    <div>
      <NavBar>
        <NavBtn onClick={MainBtn}>HOME</NavBtn>
        <NavBtn onClick={AttendanceBtn}>내 출결</NavBtn>
        <NavBtn onClick={MypageBtn}>MY</NavBtn>
      </NavBar>
    </div>
  );
}

export default Navbar;

const NavBar = styled.div`
  display: flex;
  justify-content: space-around;
  background-color: #375cde;
  height: 80px;
  border-radius: 14px;
  width: 100vw;
  min-width: 200px;
  max-width: 620px;
  /* width: 620px; */
  /* min-width: 200px;
  max-width: 600px; */
  padding: 0px 20px 0px 20px;
  margin: auto;
  position: fixed;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
`;
const NavBtn = styled.button`
  border: none;
  outline: none;
  background-color: transparent;
  color: white;
  font-size: 16px;
  cursor: pointer;
`;
