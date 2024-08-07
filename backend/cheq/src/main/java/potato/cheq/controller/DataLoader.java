//package potato.cheq.controller;
//
//import org.springframework.boot.CommandLineRunner;
//import org.springframework.security.crypto.password.PasswordEncoder;
//import org.springframework.stereotype.Component;
//import potato.cheq.entity.AdminEntity;
//import potato.cheq.enums.UserRole;
//import potato.cheq.repository.AdminRepository;
//
//@Component
//public class DataLoader implements CommandLineRunner {
//
//    private final AdminRepository adminRepository;
//    private final PasswordEncoder passwordEncoder;
//
//    public DataLoader(AdminRepository adminRepository, PasswordEncoder passwordEncoder) {
//        this.adminRepository = adminRepository;
//        this.passwordEncoder = passwordEncoder;
//    }
//
//    @Override
//    public void run(String... args) throws Exception {
//        String encodedPassword = passwordEncoder.encode("admin1234");
//
//        // 데이터가 이미 존재하는지 확인하여 중복 삽입을 방지
//        if (adminRepository.count() == 0) {
//            // 초기 데이터 생성
//            AdminEntity admin = AdminEntity.builder()
//                    .email("admin@naver.com")
//                    .password(encodedPassword)
//                    .telephoneNumber("123-456-7890")
//                    .userRole(UserRole.ADMIN)  // UserRole의 ADMIN 값을 설정
//                    .build();
//
//            // 데이터베이스에 저장
//            adminRepository.save(admin);
//        }
//    }
//}