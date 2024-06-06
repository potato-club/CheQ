package potato.cheq.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import potato.cheq.entity.AdminEntity;

import java.util.Optional;

public interface AdminRepository extends JpaRepository<AdminEntity, Long> {
    Optional<AdminEntity> findByEmail(String email);
}
