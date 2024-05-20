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
    private String studentId;

//    @Column(nullable = false)
    private String password; // 우선 사용하지않는 필드

    @Column(nullable = false)
    private String seat;

//    private String st_mac_address; // 회원 기기 mac_address

    @Column()
    private String uuid;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ChapelKind chapelKind;

}
