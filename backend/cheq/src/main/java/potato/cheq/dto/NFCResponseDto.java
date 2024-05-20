package potato.cheq.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Builder;
import lombok.Getter;
import potato.cheq.entity.NFCEntity;

import java.time.LocalDateTime;

@Getter
public class NFCResponseDto {

    private String mac_address;
    private String NFC_position;

//    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy.MM.dd.hh.mm.ss", timezone = "Asia/Seoul")
//    private LocalDateTime attendanceTime;


}