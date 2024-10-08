package potato.cheq.service;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import potato.cheq.dto.request.BeaconRequestDto;
import potato.cheq.dto.request.NFCRequestDto;
import potato.cheq.dto.response.AttendanceDto;
import potato.cheq.entity.AttendanceEntity;
import potato.cheq.entity.BeaconEntity;
import potato.cheq.entity.NFCEntity;
import potato.cheq.entity.UserEntity;
import potato.cheq.enums.ChapelKind;
import potato.cheq.error.security.ErrorCode;
import potato.cheq.error.security.requestError.NotFoundException;
import potato.cheq.error.security.requestError.UnAuthorizedException;
import potato.cheq.repository.AttendanceRepository;
import potato.cheq.repository.BeaconRepository;
import potato.cheq.repository.NFCRepository;
import potato.cheq.repository.UserRepository;
import potato.cheq.service.jwt.JwtTokenProvider;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

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

        if (uuid == null) {
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

        if (uuid == null) {
            throw new UnAuthorizedException("기기정보가 등록되지 않은 회원입니다.", ErrorCode.ACCESS_DENIED_EXCEPTION);
        }

        if (!jwtTokenProvider.validateAccessToken(userToken)) {
            throw new UnAuthorizedException("AccessToken이 만료되었습니다.", ErrorCode.EXPIRED_ACCESS_TOKEN);
        }

        if (uuid.equals(beaconRequestDto.getUuid())) {
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
                .NFCid(nfcEntities.size() > 0 ? nfcEntities.get(0).getId() : null)
                .beaconId(beaconEntities.size() > 0 ? beaconEntities.get(0).getId() : null)
                .userId(user.get().getId())
                .checkInout(isAttendanceValid)
                .build();

        if (isAttendanceValid) {
            attendanceRepository.save(attendanceEntity);
        }
        return isAttendanceValid;
    }

    public List<AttendanceDto> getAttendanceByDate(HttpServletRequest request) throws Exception {
        Optional<UserEntity> userOptional = jwtTokenProvider.extractIdByRequest(request);

        if(userOptional.isEmpty()) {
            throw new NotFoundException("해당하는 회원을 찾을 수 없습니다.", ErrorCode.NOT_FOUND_EXCEPTION);
        }

        UserEntity user = userOptional.get();
        List<AttendanceEntity> attendanceEntities = attendanceRepository.findByUserId(user.getId());


        // 이런식으로 map함수를 써서 날짜별로 그룹화할 수 있고 람다식을 사용
        Map<LocalDate, List<AttendanceEntity>> groupedByDate = attendanceEntities.stream()
                .collect(Collectors.groupingBy(attendance -> attendance.getAttendanceTime().toLocalDate()));

        List<AttendanceDto> attendanceDtoList = new ArrayList<>();

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM/dd");

        for(Map.Entry<LocalDate, List<AttendanceEntity>> entry : groupedByDate.entrySet()) {
            LocalDate date = entry.getKey();
            List<AttendanceEntity> records = entry.getValue();

            Long status = determineAttendanceStatus(records, user.getChapelKind());
            String formattedDate = date.format(formatter);
            attendanceDtoList.add(new AttendanceDto(formattedDate, status));
        }
        return attendanceDtoList;
    }

    public Long determineAttendanceStatus(List<AttendanceEntity> records, ChapelKind chapelKind) throws Exception {
//        Optional<UserEntity> id = jwtTokenProvider.extractIdByRequest(request);
//
//        if (id.isEmpty()) {
//            throw new NotFoundException("해당하는 회원을 찾을 수 없습니다.", ErrorCode.NOT_FOUND_EXCEPTION);
//        }
        if(records.isEmpty()) {
            return 0L;
        }

//        UserEntity user = id.get();
//        ChapelKind chapelKind = user.getChapelKind();
//
//        List<NFCEntity> nfcEntities = nfcRepository.findByUuid(user.getStUuid());
//
//        if (nfcEntities.isEmpty()) {
//            return 0L;
//        }
//
//        NFCEntity firstNFC = nfcEntities.get(0);
//        NFCEntity endNFC = nfcEntities.get(nfcEntities.size() - 1);
//
//        LocalTime firstAttendanceTime = LocalTime.from(firstNFC.getAttendanceTime());
//        LocalTime endAttendanceTime = LocalTime.from(endNFC.getAttendanceTime());
//
//        LocalTime chapelStartTime = LocalTime.parse(chapelKind.getStartTime());
//        LocalTime chapelEndTime = LocalTime.parse(chapelKind.getEndTime());
//        LocalTime chapelTardyTime = LocalTime.parse(chapelKind.getTardyTime());

//        log.info(String.valueOf(firstAttendanceTime)); // 해당 유저의 첫번쨰 태그 시간
//        log.info(String.valueOf(endAttendanceTime)); // 해당 유저의 마지막 태그 시간
//        log.info(String.valueOf(chapelStartTime)); // 해당 유저가 참가하고있는 채플종류의 시작시간
//        log.info(String.valueOf(chapelEndTime)); // 해당 유저가 참가하고있는 채플종류의 종료시간
//        log.info(String.valueOf(chapelTardyTime)); // 해당 유저가 참가하고있는 채플종류의 지각 마감시간


        LocalTime firstAttendanceTime = records.get(0).getAttendanceTime().toLocalTime();
        LocalTime endAttendanceTime = records.get(records.size()-1).getAttendanceTime().toLocalTime();

        LocalTime chapelStartTime = LocalTime.parse(chapelKind.getStartTime());
        LocalTime chapelEndTime = LocalTime.parse(chapelKind.getEndTime());
        LocalTime chapelTardyTime = LocalTime.parse(chapelKind.getTardyTime());
        if (firstAttendanceTime.isBefore(chapelStartTime) && endAttendanceTime.isAfter(chapelEndTime)) {
            return 1L; // 출석
        } else if (firstAttendanceTime.isBefore(chapelTardyTime) && endAttendanceTime.isAfter(chapelEndTime)) {
            return 2L; // 지각
        } else if (firstAttendanceTime.isAfter(chapelTardyTime) || firstAttendanceTime.isAfter(chapelEndTime)) {
            return 3L; // 결석
        } else {
            return 0L; // 기타 오류
        }
    }

    public String checkUuid(HttpServletRequest request) throws Exception {
        String userToken = jwtTokenProvider.resolveAccessToken(request);
        Long tokenId = jwtTokenProvider.extractId(userToken);
        Optional<UserEntity> id = userRepository.findById(tokenId);
        return id.get().getStUuid();
    }

}
