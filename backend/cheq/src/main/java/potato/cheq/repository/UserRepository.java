package potato.cheq.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import potato.cheq.entity.UserEntity;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<UserEntity, Long> {
    boolean existsByStudentId(String studentId);
    boolean existsByUuid(String uuid);
    UserEntity findUserEntityByUuid(String uuid);
}
