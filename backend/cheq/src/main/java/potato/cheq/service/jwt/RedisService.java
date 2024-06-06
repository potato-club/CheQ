package potato.cheq.service.jwt;

import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Service;
import potato.cheq.error.security.ErrorCode;
import potato.cheq.error.security.requestError.ExpiredRefreshTokenException;

import java.time.Duration;

@Service
@RequiredArgsConstructor
public class RedisService {

    private final RedisTemplate redisTemplate;

    public void setValues(Long id, String token) {
        ValueOperations<String, Long> operations = redisTemplate.opsForValue();

        if(this.getValues(token) != null) {
            this.delValues(token);
        }
        operations.set(token, id, Duration.ofDays(7)); // 우선 7일이긴한데 음
    }

    public Long getValues(String token) {

        try {
            ValueOperations<String, Long> operations = redisTemplate.opsForValue();
            Long id = operations.get(token);

            if(id != null) {
                return id;
            }
        } catch (NullPointerException e) {
            throw new ExpiredRefreshTokenException("RefreshToken Expired", ErrorCode.EXPIRED_REFRESH_TOKEN);
        }
            return null;
    }

    public void delValues(String token) {
        redisTemplate.delete(token);
    }
}
