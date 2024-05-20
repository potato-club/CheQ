package potato.cheq.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Builder
public class NFCEntity extends BaseTime {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "nfc_id")
    private Long id;

    @Column(nullable = false)
    private String mac_address;

//    @Column(nullable = false)
//    private LocalDateTime attendance_time;

    private boolean NFC_type; // 1 = major, 0 = minor
    private String NFC_position;


}
