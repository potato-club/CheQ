package potato.cheq.service.jwt;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtParser;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;
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
    private final UserService userService;

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
        return this.createToken(memberId, userService.getMacAddress(memberId), accessTokenValidTime, "access");
    }

    public String createRefreshToken(String memberId) throws Exception {
        return this.createToken(memberId, userService.getMacAddress(memberId), refreshTokenValidTime, "refresh");
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




}
