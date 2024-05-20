package potato.cheq.service.jwt;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;
import potato.cheq.entity.UserEntity;
import potato.cheq.repository.UserRepository;

@Component("userDetailsService")
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository memberRepository;

    @Override
    public UserDetails loadUserByUsername(String studentId) throws UsernameNotFoundException {
        UserEntity user = memberRepository.findByStudentId(studentId);

        if (user == null) {
            throw new UsernameNotFoundException(studentId + "는 존재하지 않는 사용자입니다.");
        }

        return new CustomUserDetails(user);

    }
}