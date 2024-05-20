package potato.cheq.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import potato.cheq.entity.UserEntity;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<UserEntity, Long> {
    boolean existsByStudentId(String studentId);
    boolean existsByUuid(String uuid);

    UserEntity findByUuid(String uuid);

    UserEntity findByStudentId(String studentId);
    @Query("SELECT u.uuid FROM UserEntity u WHERE u.studentId = :studentId")
    String findUuidByStudentId(@Param("studentId") String studentId);


}
