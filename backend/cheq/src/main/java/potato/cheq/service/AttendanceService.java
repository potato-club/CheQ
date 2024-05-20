package potato.cheq.service;

import io.jsonwebtoken.ExpiredJwtException;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import potato.cheq.dto.NFCRequestDto;
import potato.cheq.entity.UserEntity;
import potato.cheq.repository.NFCRepository;
import potato.cheq.repository.UserRepository;
import potato.cheq.service.jwt.JwtTokenProvider;

@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class AttendanceService {

    private final NFCRepository nfcRepository;
    private final UserRepository userRepository;
    private final JwtTokenProvider jwtTokenProvider;

    public String checkAttendanceByNfcService(HttpServletRequest request, NFCRequestDto nfcRequestDto) {
        String userToken = jwtTokenProvider.resolveAccessToken(request);

        if(!jwtTokenProvider.validateAccessToken(userToken)){
            throw new NullPointerException(); // AccessToken 만료
        }

        String userUUID = jwtTokenProvider.getMacAddress(userToken);
        log.info(userUUID);
        System.out.println(userToken); // 자동으로 decrypt?

        if(userUUID.equals(nfcRequestDto.getMac_address())) {

            UserEntity userId = userRepository.findByUuid(nfcRequestDto.getMac_address());

            if (userId == null) {
                throw new NullPointerException();
            }

            nfcRepository.save(nfcRequestDto.toEntity());

            return userUUID;
        }

        return null; // 만약 null 이 컨트롤러로 날라가면 사용자가 등록된 기기가 없다고 @HttpStatus 어노테이션으로 나타내보자
    }
}
