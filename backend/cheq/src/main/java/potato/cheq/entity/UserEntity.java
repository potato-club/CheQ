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

    @Column()
    private String stUuid;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ChapelKind chapelKind;

}
