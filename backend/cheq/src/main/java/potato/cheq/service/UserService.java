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
import potato.cheq.dto.RequestUserDevice;
import potato.cheq.dto.RequestUserDto;
import potato.cheq.entity.UserEntity;
import potato.cheq.repository.UserRepository;

@Service
@Transactional
@RequiredArgsConstructor
public class UserService {

    private final String BASE_URL = "https://m.hansei.ac.kr/Main/onLoad.do";
    private final UserRepository userRepository;


    public Long setUserData(RequestUserDto dto) throws Exception { // 임시 오류 처리
        if(userRepository.existsByStudentId(dto.getStudentId())){
            throw new Exception("이미 존재하는 사용자 정보입니다.");
        }

        UserEntity user = userRepository.save(dto.toEntity());
        return user.getId();
    }

    public Long setUserDevice(RequestUserDevice dto) throws Exception {
        if(userRepository.existsByUuid(dto.getUuid())){
            throw new Exception("이미 존재하는 기기입니다.");
        }

        UserEntity user = userRepository.save(dto.toEntity());
        return user.getId();
    }

//    public Long checkedNFC(RequestUserDto dto) {
//        String student_mac =
//    }







//    public void fetchDataFromApi(String cookieValue) {
//        RestTemplate restTemplate = new RestTemplate();
//
//        HttpHeaders headers = new HttpHeaders();
//        headers.add("Cookie", cookieValue);
//        HttpEntity<String> entity = new HttpEntity<>(headers);
//
//        ResponseEntity<ApiRes> response = restTemplate.exchange(
//                BASE_URL,
//                HttpMethod.GET,
//                entity,
//                ApiResponse.class
//        );
//    }
//
//    ApiRes apiResponse = response.getBody();
//        if (apiResponse != null) {
//        DmUserInfo userInfo = apiResponse.getDmUserInfo();
//
//        // 이제 userInfo 객체에 있는 데이터를 서비스 로직에서 활용할 수 있습니다.
//        String email = userInfo.getEMAIL();
//        String userNo = userInfo.getG_USER_NO();
//
//        // 여기서부터는 이 데이터를 활용하는 나머지 서비스 로직을 작성합니다.
//    }



}
