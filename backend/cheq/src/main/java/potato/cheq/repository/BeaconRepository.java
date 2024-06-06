package potato.cheq.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import potato.cheq.entity.BeaconEntity;

public interface BeaconRepository extends JpaRepository<BeaconEntity, Long> {
}
