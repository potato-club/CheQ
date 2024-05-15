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

    public String getMacAddress(String studentID) throws Exception {
        String userUUID = userRepository.findUuidByStudentId(studentID);

        if (userUUID == null) {
            throw new Exception("사용자의 UUID 값을 찾을 수 없습니다.");
        }
        return userUUID;
    }



}
