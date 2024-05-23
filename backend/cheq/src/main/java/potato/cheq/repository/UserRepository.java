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
//    boolean existsByUuid(UuidEntity uuid);

//    UserEntity findByUuid(String uuid);

    UserEntity findByStudentId(String studentId);
    @Query("SELECT u.uuidEntity.deviceUuid FROM UserEntity u WHERE u.studentId = :studentId")
    String findUuidByStudentId(@Param("studentId") String studentId);


}
