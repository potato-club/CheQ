package potato.cheq.service;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import potato.cheq.dto.NFCRequestDto;
import potato.cheq.entity.NFCEntity;
import potato.cheq.entity.UserEntity;
import potato.cheq.error.security.ErrorCode;
import potato.cheq.error.security.requestError.UnAuthorizedException;
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
            throw new UnAuthorizedException("기기정보가 등록되지 않은 회원입니다.", ErrorCode.ACCESS_DENIED_EXCEPTION);
        }

        if (!jwtTokenProvider.validateAccessToken(userToken)) {
            throw new UnAuthorizedException("AccessToken이 만료되었습니다.", ErrorCode.EXPIRED_ACCESS_TOKEN);
        }

        if (uuid.equals(nfcRequestDto.getMac_address())) {

            NFCEntity nfc = NFCEntity.builder()
                    .mac_address(nfcRequestDto.getMac_address())
                    .nfc_position(nfcRequestDto.getNfc_position())
                    .build();

            nfcRepository.save(nfc);

            return uuid;
        }
        return null;
    }
}
