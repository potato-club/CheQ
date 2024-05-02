package potato.cheq.service;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import potato.cheq.repository.UserRepository;

import java.security.Key;
import java.util.Base64;
import java.util.Date;

@Service
@Transactional
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Value("${jwt.secret}")
    private String secretkey;

    @Value("${jwt.accessExpiration}")
    private long accessExpiration;

    @Value("${jwt.refreshExpiration}")
    private long refreshExpiration;

    @PostConstruct
    public void init() {
        secretkey = Base64.getEncoder().encodeToString(secretkey.getBytes());
    }

    public String createAccessToken(String student_id) {
        return this.createToken(student_id, accessExpiration, "access");
    }

    public String createRefreshToken(String student_id) {
        return this.createToken(student_id, refreshExpiration, "refresh");
    }

    public String createToken(String student_id, long tokenValid, String tokenType) {
        Claims claims = Jwts.claims().setSubject(student_id);
        claims.put("type", tokenType);

        Key key = Keys.hmacShaKeyFor(secretkey.getBytes();
        Date date = new Date();

        return Jwts.builder()
                .setClaims(claims)
                .setIssuedAt(date)
                .setExpiration(new Date(date.getTime() + tokenValid))
                .signWith(key, SignatureAlgorithm.HS256)
                .compact();
    }





}

