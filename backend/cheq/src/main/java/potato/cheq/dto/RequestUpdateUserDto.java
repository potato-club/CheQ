package potato.cheq.dto;


import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class RequestUpdateUserDto {
    private String uuid;
}

