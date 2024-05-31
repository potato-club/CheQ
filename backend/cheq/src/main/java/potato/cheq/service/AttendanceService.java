package potato.cheq.service;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import potato.cheq.dto.NFCRequestDto;
import potato.cheq.entity.NFCEntity;
import potato.cheq.entity.UserEntity;
import potato.cheq.repository.NFCRepository;
import potato.cheq.repository.UserRepository;
import potato.cheq.service.jwt.JwtTokenProvider;

import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class AttendanceService {

    private final NFCRepository nfcRepository;
    private final UserRepository userRepository;
    private final JwtTokenProvider jwtTokenProvider;

    public String checkAttendanceByNfcService(HttpServletRequest request, NFCRequestDto nfcRequestDto) throws Exception {
        String userToken = jwtTokenProvider.resolveAccessToken(request);
        Long tokenId = jwtTokenProvider.extractId(userToken);
        Optional<UserEntity> id = userRepository.findById(tokenId);
        String uuid = id.get().getStUuid();

        if(uuid == null) {
            throw new NullPointerException(); // 일단 uuid 없으면 nullpoint 오류임 에러커스텀하면 추가하자
        }

        if (!jwtTokenProvider.validateAccessToken(userToken)) {
            throw new NullPointerException(); // AccessToken 만료
        }


        if (uuid.equals(nfcRequestDto.getMac_address())) {

            NFCEntity nfc = NFCEntity.builder()
                    .mac_address(nfcRequestDto.getMac_address())
                    .nfc_position(nfcRequestDto.getNfc_position())
                    .build();

            nfcRepository.save(nfc);

            return uuid;
        }
        return null; // 만약 null 이 컨트롤러로 날라가면 사용자가 등록된 기기가 없다고 @HttpStatus 어노테이션으로 나타내보자
    }
}
