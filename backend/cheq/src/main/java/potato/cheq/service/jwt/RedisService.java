package potato.cheq.service.jwt;

import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Service;

import java.time.Duration;

@Service
@RequiredArgsConstructor
public class RedisService {

    private final RedisTemplate redisTemplate;

    public void setValues(Long id, String token) {
        ValueOperations<String, Long> operations = redisTemplate.opsForValue();
        if(getValues(token) != null) {
            delValues(token);
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
            throw new NullPointerException(); // 커스텀에러로 수정
        }
        return null;
    }

    public void delValues(String token) {
        redisTemplate.delete(token);
    }
}
