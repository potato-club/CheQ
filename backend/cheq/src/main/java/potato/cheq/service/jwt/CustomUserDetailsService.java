package potato.cheq.service.jwt;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;
import potato.cheq.entity.AdminEntity;
import potato.cheq.entity.UserEntity;
import potato.cheq.repository.AdminRepository;
import potato.cheq.repository.UserRepository;

import java.util.Optional;

@Component("userDetailsService")
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;
    private final AdminRepository adminRepository;


    @Override
    public UserDetails loadUserByUsername(String id) throws UsernameNotFoundException {

        UserEntity user = userRepository.findByStudentId(id);
        if (user != null) {
            return new CustomUserDetails(user, null);
        }

        // userRepository에서 찾지 못하면 adminRepository에서 관리자 조회
        Optional<AdminEntity> adminOptional = adminRepository.findByEmail(id);

        if (adminOptional.isPresent()) {
            AdminEntity admin = adminOptional.get();
            return new CustomUserDetails(null, admin);
        }

        // 둘 다 찾지 못한 경우 예외 발생
        throw new UsernameNotFoundException(id + "는 존재하지 않는 사용자입니다.");
    }
}