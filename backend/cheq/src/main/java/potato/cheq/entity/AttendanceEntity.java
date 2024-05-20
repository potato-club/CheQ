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
    private Long NFC_id;

    @Column(nullable = false)
    private Long beacon_id;

    @Column(nullable = false)
    private Long user_id;

    private boolean check; // checkIn = 1, checkOut = 0
}
