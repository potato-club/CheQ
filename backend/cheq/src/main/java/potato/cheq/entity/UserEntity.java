package potato.cheq.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import potato.cheq.enums.ChapelKind;

@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Long id;

    @Column(nullable = false)
    private String email;

    @Column(nullable = false)
    private String student_id;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false)
    private String seat;

    @Column(nullable = false)
    private ChapelKind chapelKind;

    @Column(nullable = false)
    private boolean attendance;

    @Column(nullable = false)
    private String qrNum;

    @OneToOne
    @JoinColumn(name = "nfc_id")
    private NFCEntity nfc_attendance;

    @OneToOne
    @JoinColumn(name = "beacon_id")
    private BeaconEntity beacon_attendance;
}
