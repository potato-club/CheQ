package potato.cheq.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import potato.cheq.entity.NFCEntity;

import java.util.List;

@Repository
public interface NFCRepository extends JpaRepository<NFCEntity, Long> {
    List<NFCEntity> findByUuid(String uuid);
}
