package potato.cheq.service.jwt;

import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtParser;
import io.jsonwebtoken.*;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.codec.binary.Hex;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import potato.cheq.error.security.ErrorCode;
import potato.cheq.error.security.requestError.ExpiredRefreshTokenException;
import potato.cheq.repository.UserRepository;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.Date;

@Component
@RequiredArgsConstructor
@Slf4j
public class JwtTokenProvider {

    private final RedisService redisService;
    private final UserRepository userRepository;
    private final CustomUserDetailsService customUserDetailsService;

    @Value("${jwt.secretKey}")
    private String secretKey;

    @Value("${jwt.accessExpiration}")
    private long accessTokenValidTime;

    @Value("${jwt.refreshExpiration}")
    private long refreshTokenValidTime;

    @Value("${jwt.aesKey}")
    private String aesKey;

    private SecretKey getSigningKey() {
        byte[] keyBytes = Decoders.BASE64.decode(this.secretKey);
        return Keys.hmacShaKeyFor(keyBytes);
    }

    public String createAccessToken(Long id) {
        try {
            return this.createToken(id, accessTokenValidTime, "access");
        } catch (Exception e) {
            throw new RuntimeException(e);
        } // token 생성에서 오류처리를 Exceptions로 하면 다해줘야하네 흠
    }

    public String createRefreshToken(Long id) {
        try {
            return this.createToken(id, refreshTokenValidTime, "refresh");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public String createToken(Long id, long tokenValid, String tokenType) throws Exception {
        JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty("pk", id);
        jsonObject.addProperty("tokenType", tokenType);

        Claims claims = Jwts.claims().subject(encrypt(jsonObject.toString())).build();
        Date date = new Date();

        return Jwts.builder()
                .claims(claims)
                .issuedAt(date)
                .expiration(new Date(date.getTime() + tokenValid))
                .signWith(getSigningKey())
                .compact();
    }

    public void setHeaderAccessToken(HttpServletResponse response, String accessToken) {
        response.setHeader("authorization", "Bearer " + accessToken);
    }

    public void setHeaderRefreshToken(HttpServletResponse response, String refreshToken) {
        response.setHeader("refreshToken", "Bearer " + refreshToken);
    }

    public String getMacAddress(String studentID) {  // 사용 X
        String userUUID = userRepository.findUuidByStudentId(studentID);
        if (userUUID == null) {
            throw new NullPointerException();
        }
        return userUUID;
    }

    private String encrypt(String plainToken) throws Exception {
        SecretKeySpec secretKeySpec = new SecretKeySpec(aesKey.getBytes(StandardCharsets.UTF_8), "AES");
        IvParameterSpec IV = new IvParameterSpec(aesKey.substring(0, 16).getBytes());

        Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
        c.init(Cipher.ENCRYPT_MODE, secretKeySpec, IV);

        byte[] encryptionByte = c.doFinal(plainToken.getBytes(StandardCharsets.UTF_8));

        return Hex.encodeHexString(encryptionByte);
    }

    private String decrypt(String encodeText) throws Exception {
        SecretKeySpec secretKeySpec = new SecretKeySpec(aesKey.getBytes(StandardCharsets.UTF_8), "AES");
        IvParameterSpec IV = new IvParameterSpec(aesKey.substring(0, 16).getBytes());

        Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
        c.init(Cipher.DECRYPT_MODE, secretKeySpec, IV);

        byte[] decodeByte = Hex.decodeHex(encodeText);

        return new String(c.doFinal(decodeByte), StandardCharsets.UTF_8);

    }

    public Long extractId(String token) throws Exception {
        Long id = extraValue(token).get("pk").getAsLong();
        return id;
    }

    public String extractMemberId(String token) throws Exception { // 사용 X
        JsonElement memberId = extraValue(token).get("studentId");
        if (memberId.isJsonNull()) {
            return null;
        }
        return memberId.getAsString();
    }

    private JsonObject extraValue(String token) throws Exception {
        String subject = extraAllClaims(token).getSubject();
        String decrypted = decrypt(subject);
        JsonObject jsonObject = new Gson().fromJson(decrypted, JsonObject.class);
        return jsonObject;
    }

    private Claims extraAllClaims(String token) {
        return getParser()
                .parseSignedClaims(token)
                .getPayload();
    }

    private JwtParser getParser() {
        return Jwts.parser()
                .verifyWith(this.getSigningKey())
                .build();
    }

    public String resolveAccessToken(HttpServletRequest request) {
        if (request.getHeader("authorization") != null)
            return request.getHeader("authorization").substring(7);
        return null;
    }

    public UsernamePasswordAuthenticationToken getAuthentication(String token) throws Exception {
        UserDetails userDetails = customUserDetailsService.loadUserByUsername(extractMemberId(token));
        return new UsernamePasswordAuthenticationToken(userDetails, "", userDetails.getAuthorities());
    }


    public String resolveRefreshToken(HttpServletRequest request) {
        if (request.getHeader("refreshToken") != null)
            return request.getHeader("refreshToken").substring(7);
        return null;
    }

    public boolean validateRefreshToken(String refreshToken) {
        try {
            Claims claims = extraAllClaims(refreshToken);

            return !claims.getExpiration().before(new Date());
        } catch (MalformedJwtException e) {
            throw new MalformedJwtException("Invalid JWT token");
        } catch (ExpiredJwtException e) {
            throw new ExpiredRefreshTokenException("1006", ErrorCode.EXPIRED_REFRESH_TOKEN);
        } catch (UnsupportedJwtException ex) {
            throw new UnsupportedJwtException("JWT token is unsupported");
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("JWT claims string is empty");
        }
    }


    public boolean validateAccessToken(String accessToken) {
        try {
            Claims claims = extraAllClaims(accessToken);

            return !claims.getExpiration().before(new Date());
        } catch (MalformedJwtException e) {
            throw new MalformedJwtException("Invalid JWT token");
        } catch (ExpiredJwtException e) {
            throw new ExpiredJwtException(null, null, "AccessToken is Expired");
        } catch (UnsupportedJwtException ex) {
            throw new UnsupportedJwtException("JWT token is unsupported");
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("JWT claims string is empty");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public String reissueAccessToken(String accessToken, HttpServletResponse response) {
        try {
            Long id = redisService.getValues(accessToken);
            return createAccessToken(id);
        } catch (ExpiredJwtException e) {
            response.setStatus(HttpStatus.UNAUTHORIZED.value());
            return ErrorCode.EXPIRED_ACCESS_TOKEN.getMessage();
        }
    }

    public String reissueRefreshToken(String refreshToken, HttpServletResponse response) {
        try {
            Long id = redisService.getValues(refreshToken);
            String newRefreshToken = createRefreshToken(id);

            redisService.delValues(refreshToken);
            redisService.setValues(id, newRefreshToken);

            return newRefreshToken;
        } catch (ExpiredJwtException e) {
            response.setStatus(HttpStatus.UNAUTHORIZED.value());
            return ErrorCode.EXPIRED_REFRESH_TOKEN.getMessage();
        }
    }


}
