package potato.cheq.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class NFCRequestDto {
    private String mac_address;
    private String NFC_position;
}
