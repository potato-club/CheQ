package potato.cheq.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import potato.cheq.entity.UserEntity;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<Long, UserEntity> {
}
