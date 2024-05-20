package potato.cheq.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import potato.cheq.entity.AttendanceEntity;
import potato.cheq.entity.NFCEntity;

@Repository
public interface NFCRepository extends JpaRepository<NFCEntity, Long> {


}
