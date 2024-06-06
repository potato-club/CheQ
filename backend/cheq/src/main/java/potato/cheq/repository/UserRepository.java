package potato.cheq.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import potato.cheq.entity.UserEntity;
import potato.cheq.entity.UuidEntity;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<UserEntity, Long> {
    boolean existsByStudentId(String studentId);
    boolean existsByStUuid(String uuid);

//    UserEntity findByUuid(String uuid);

    UserEntity findUuidById(Long id);
//    UserEntity findStudentIdById(Long id);

    UserEntity findByStudentId(String studentId);

    @Query("SELECT u.stUuid FROM UserEntity u WHERE u.studentId = :studentId")
    String findUuidByStudentId(@Param("studentId") String studentId);

    @Query("SELECT u.studentId FROM UserEntity u WHERE u.id = :id")
    Optional<String> findStudentIdById(@Param("id") Long id);

}
