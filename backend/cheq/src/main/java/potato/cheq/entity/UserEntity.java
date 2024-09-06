package potato.cheq.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import potato.cheq.dto.admin.RequestUpdateStudentDto;
import potato.cheq.dto.request.UserUpdateRequestDto;
import potato.cheq.enums.ChapelKind;
import potato.cheq.enums.UserRole;

import java.time.LocalDateTime;

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

    @Column()
    private String major;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private UserRole userRole;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ChapelKind chapelKind;

    @Column()
    private LocalDateTime lastUpdated;


    public UserEntity updateUuid(String stUuid) {
        this.stUuid = stUuid;
        return this;
    }

    public void update(UserUpdateRequestDto requestDto) {
        this.email = requestDto.getEmail();
        this.seat = requestDto.getSeat();
        this.chapelKind = requestDto.getChapelKind();
        this.lastUpdated = LocalDateTime.now();
        this.major = requestDto.getMajor();
    }

    public void Adminupdate(RequestUpdateStudentDto requestDto) {
        this.studentId = requestDto.getStudentId();
        this.seat = requestDto.getSeat();
        this.chapelKind = ChapelKind.valueOf(requestDto.getChapelKind());
        this.major = requestDto.getMajor();
    }


}
