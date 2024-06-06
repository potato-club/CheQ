package potato.cheq.dto.admin;

import lombok.Data;

@Data
public class UpdateAdminDto {
    private String email;
    private String password;
    private String telephoneNumber;
}
