package potato.cheq.service;

import lombok.RequiredArgsConstructor;
import org.apache.coyote.BadRequestException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import potato.cheq.dto.RequestUserDto;
import potato.cheq.entity.UserEntity;
import potato.cheq.repository.UserRepository;

@Service
@Transactional
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;

    public Long setUserData(RequestUserDto dto) throws Exception { // 임시 오류 처리
        if(userRepository.existsByStudentId(dto.getStudentId())){
            throw new Exception("이미 존재하는 사용자 정보입니다.");
        }

        UserEntity user = userRepository.save(dto.toEntity());
        return user.getId();

    }
}
