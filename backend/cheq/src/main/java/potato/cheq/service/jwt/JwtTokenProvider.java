package potato.cheq.service.jwt;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtParser;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;
import jakarta.servlet.http.HttpServletResponse;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import potato.cheq.repository.UserRepository;
import potato.cheq.service.UserService;

import java.security.Key;
import java.util.Base64;
import java.util.Date;

@Component
@Transactional
@RequiredArgsConstructor
public class JwtTokenProvider {

    private final UserRepository userRepository;

    @Value("${jwt.secretKey}")
    private String secretKey;

    @Value("${jwt.accessExpiration}")
    private long accessTokenValidTime;

    @Value("${jwt.refreshExpiration}")
    private long refreshTokenValidTime;

    @PostConstruct
    public void init() {
        secretKey = Base64.getEncoder().encodeToString(secretKey.getBytes());
    }

    public String createAccessToken(String memberId) throws Exception {
        return this.createToken(memberId, getMacAddress(memberId), accessTokenValidTime, "access");
    }

    public String createRefreshToken(String memberId) throws Exception {
        return this.createToken(memberId, getMacAddress(memberId), refreshTokenValidTime, "refresh");
    }

    public String createToken(String memberId, String macAddress, long tokenValid, String tokenType) {
        Claims claims = Jwts.claims().setSubject(memberId);
        claims.put("macAddress", macAddress);
        claims.put("type", tokenType);

        Key key = Keys.hmacShaKeyFor(secretKey.getBytes());
        Date date = new Date();

        return Jwts.builder()
                .setClaims(claims)
                .setIssuedAt(date)
                .setExpiration(new Date(date.getTime() + tokenValid))
                .signWith(key, SignatureAlgorithm.HS256)
                .compact();
    }

    public void setHeaderAccessToken(HttpServletResponse response, String accessToken) {
        response.setHeader("authorization", "Bearer " + accessToken);
    }

    public void setHeaderRefreshToken(HttpServletResponse response, String refreshToken) {
        response.setHeader("refreshToken", "Bearer " + refreshToken);
    }

    private String getMacAddress(String studentID) throws Exception {
        String userUUID = userRepository.findUuidByStudentId(studentID);

        if (userUUID == null) {
            throw new Exception("사용자의 UUID 값을 찾을 수 없습니다.");
        }
        return userUUID;
    }





}
