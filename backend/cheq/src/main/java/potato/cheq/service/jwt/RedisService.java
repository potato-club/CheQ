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

    public void setValues(String studentId, String token) {
        ValueOperations<String, String> operations = redisTemplate.opsForValue();
        if(getValues(token) != null) {
            delValues(token);
        }
        operations.set(token, studentId, Duration.ofDays(7)); // 우선 7일이긴한데 음
    }

    public String getValues(String token) {

        try {
            ValueOperations<String, String> operations = redisTemplate.opsForValue();
            String studentId = operations.get(token);

            if(studentId != null) {
                return studentId;
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
