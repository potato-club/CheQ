package potato.cheq.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import potato.cheq.entity.UuidEntity;

@Repository
public interface UuidRepository extends JpaRepository<UuidEntity, Long> {

    boolean existsByDeviceUuid(String uuid);

}
