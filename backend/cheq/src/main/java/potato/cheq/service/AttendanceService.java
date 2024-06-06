package potato.cheq.service;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import potato.cheq.dto.request.BeaconRequestDto;
import potato.cheq.dto.request.NFCRequestDto;
import potato.cheq.entity.AttendanceEntity;
import potato.cheq.entity.BeaconEntity;
import potato.cheq.entity.NFCEntity;
import potato.cheq.entity.UserEntity;
import potato.cheq.error.security.ErrorCode;
import potato.cheq.error.security.requestError.UnAuthorizedException;
import potato.cheq.repository.AttendanceRepository;
import potato.cheq.repository.BeaconRepository;
import potato.cheq.repository.NFCRepository;
import potato.cheq.repository.UserRepository;
import potato.cheq.service.jwt.JwtTokenProvider;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class AttendanceService {

    private final NFCRepository nfcRepository;
    private final UserRepository userRepository;
    private final BeaconRepository beaconRepository;
    private final AttendanceRepository attendanceRepository;
    private final JwtTokenProvider jwtTokenProvider;

    public String checkAttendanceByNfcService(HttpServletRequest request, NFCRequestDto nfcRequestDto) throws Exception {
        String userToken = jwtTokenProvider.resolveAccessToken(request);
        String uuid = checkUuid(request);

        if(uuid == null) {
            throw new UnAuthorizedException("기기정보가 등록되지 않은 회원입니다.", ErrorCode.ACCESS_DENIED_EXCEPTION);
        }

        if (!jwtTokenProvider.validateAccessToken(userToken)) {
            throw new UnAuthorizedException("AccessToken이 만료되었습니다.", ErrorCode.EXPIRED_ACCESS_TOKEN);
        }

        if (uuid.equals(nfcRequestDto.getUuid())) {

            NFCEntity nfc = NFCEntity.builder()
                    .uuid(nfcRequestDto.getUuid())
                    .nfc_position(nfcRequestDto.getNfc_position())
                    .build();

            nfcRepository.save(nfc);

            return uuid;
        }
        return null;
    }

    public String checkAttendanceByBeaconService(HttpServletRequest request, BeaconRequestDto beaconRequestDto) throws Exception {
        String userToken = jwtTokenProvider.resolveAccessToken(request);
        String uuid = checkUuid(request);

        if(uuid == null) {
            throw new UnAuthorizedException("기기정보가 등록되지 않은 회원입니다.", ErrorCode.ACCESS_DENIED_EXCEPTION);
        }

        if (!jwtTokenProvider.validateAccessToken(userToken)) {
            throw new UnAuthorizedException("AccessToken이 만료되었습니다.", ErrorCode.EXPIRED_ACCESS_TOKEN);
        }

        if(uuid.equals(beaconRequestDto.getUuid())) {
            BeaconEntity beacon = BeaconEntity.builder()
                    .uuid(beaconRequestDto.getUuid())
                    .beacon_position(beaconRequestDto.getBeacon_position())
                    .build();

            beaconRepository.save(beacon);
            return uuid;
        }
        return null;
    }

    public boolean checkAttendance(HttpServletRequest request) throws Exception {
        String userToken = jwtTokenProvider.resolveAccessToken(request);
        Long tokenId = jwtTokenProvider.extractId(userToken);
        Optional<UserEntity> user = userRepository.findById(tokenId);

        if (user.isEmpty()) {
            throw new UnAuthorizedException("유저를 찾을 수 없습니다.", ErrorCode.NOT_FOUND_EXCEPTION);
        }

        String uuid = user.get().getStUuid();

        List<NFCEntity> nfcEntities = nfcRepository.findByUuid(uuid);
        List<BeaconEntity> beaconEntities = beaconRepository.findByUuid(uuid);

        boolean isAttendanceValid = nfcEntities.size() >= 2 && beaconEntities.size() >= 3;

        AttendanceEntity attendanceEntity = AttendanceEntity.builder()
                .NFC_id(nfcEntities.size() > 0 ? nfcEntities.get(0).getId() : null)
                .beacon_id(beaconEntities.size() > 0 ? beaconEntities.get(0).getId() : null)
                .user_id(user.get().getId())
                .check_inout(isAttendanceValid)
                .build();

        if (isAttendanceValid){
            attendanceRepository.save(attendanceEntity);
        }
        return isAttendanceValid;
    }


    public String checkUuid(HttpServletRequest request) throws Exception {
        String userToken = jwtTokenProvider.resolveAccessToken(request);
        Long tokenId = jwtTokenProvider.extractId(userToken);
        Optional<UserEntity> id = userRepository.findById(tokenId);
        return id.get().getStUuid();
    }
}
