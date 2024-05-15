package potato.cheq.service;

import lombok.RequiredArgsConstructor;
import org.apache.catalina.User;
import org.apache.coyote.BadRequestException;
import org.springframework.http.HttpCookie;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;
import potato.cheq.dto.NFCRequestDto;
import potato.cheq.dto.RequestUserDevice;
import potato.cheq.dto.RequestUserDto;
import potato.cheq.entity.UserEntity;
import potato.cheq.repository.UserRepository;

@Service
@Transactional
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;


    public Long setUserData(RequestUserDto dto) throws Exception {
        if (userRepository.existsByStudentId(dto.getStudentId())) {
            throw new Exception("이미 존재하는 사용자 정보입니다.");
        }

        if (userRepository.existsByUuid(dto.getUuid())) {
            throw new Exception("이미 존재하는 기기정보값입니다.");
        }

        UserEntity user = userRepository.save(dto.toEntity());
        return user.getId();
    }

    public Long setUserDevice(RequestUserDevice dto) throws Exception {
        if (userRepository.existsByUuid(dto.getUuid())) {
            throw new Exception("이미 존재하는 기기입니다.");
        }

        UserEntity user = userRepository.save(dto.toEntity());
        return user.getId();
    }

//    public Long checkedNFC(NFCRequestDto dto) throws Exception {
//
//        // 유저의 토큰으로 유저의 id값 or uuid 값을 찾아야함 그럼 토큰 로직이 있어야겠다.
//        // 유저의 토큰으로 찾은 uuid값 = 입력받은 mac_address값 일치해야함
//        // findByToken 에다가 dto.getMac_address() 같은지 비교 아래 로직은 기기 여러개 등록해놓으면 모름
//    }


}
