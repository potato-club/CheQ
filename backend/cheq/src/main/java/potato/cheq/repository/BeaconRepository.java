package potato.cheq.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import potato.cheq.entity.BeaconEntity;

import java.util.List;

@Repository
public interface BeaconRepository extends JpaRepository<BeaconEntity, Long> {
    List<BeaconEntity> findByUuid(String uuid);
}
