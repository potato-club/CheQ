package potato.cheq.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AttendanceEntity extends BaseTime {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "attendance_id")
    private Long id;

    @Column(nullable = false)
    private Long NFCid;

    @Column(nullable = false)
    private Long beaconId;

    @Column(nullable = false)
    private Long userId;

    @Column(nullable = false)
    private boolean checkInout; // checkIn = 1, checkOut = 0
}
