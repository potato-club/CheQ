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
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import potato.cheq.error.security.ErrorCode;
import potato.cheq.error.security.requestError.ExpiredRefreshTokenException;
import potato.cheq.repository.UserRepository;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.util.Base64;
import java.util.Date;

@Component
//@Transactional -> 당근 필요없지
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

    public String createAccessToken(String memberId) {
        try {
            return this.createToken(memberId, getMacAddress(memberId), accessTokenValidTime, "access");
        } catch (Exception e) {
            throw new RuntimeException(e);
        } // token 생성에서 오류처리를 Exceptions로 하면 다해줘야하네 흠
    }

    public String createRefreshToken(String memberId) {
        try {
            return this.createToken(memberId, getMacAddress(memberId), refreshTokenValidTime, "refresh");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public String createToken(String memberId, String macAddress, long tokenValid, String tokenType) throws Exception {
        JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty("memberId", memberId);
        jsonObject.addProperty("macAddress", macAddress);

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

    private String getMacAddress(String studentID) {
        String userUUID = userRepository.findUuidByStudentId(studentID);
        log.info(userUUID);
        System.out.println(userUUID);

        if (userUUID == null) {
            throw new NullPointerException();
//            throw new Exception("사용자의 UUID 값을 찾을 수 없습니다.");
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
        c.init(Cipher.ENCRYPT_MODE, secretKeySpec, IV);

        byte[] decodeByte = Hex.decodeHex(encodeText);

        return new String(c.doFinal(decodeByte), StandardCharsets.UTF_8);

    }

    public String extractMacAddress(String token) throws Exception {
        JsonElement macAddress = extraValue(token).get("macAddress");
        if (macAddress.isJsonNull()) {
            return null;
        }
        return macAddress.getAsString();
    }

    public Long extractMemberId(String token) throws Exception {
        JsonElement memberId = extraValue(token).get("memberId");
        if (memberId.isJsonNull()) {
            return null;
        }
        return memberId.getAsLong();
    }

    private JsonObject extraValue(String token) throws Exception {
        String subject = extraAllClaims(token).getSubject();
//        try {
        String decrypted = decrypt(subject);
        JsonObject jsonObject = new Gson().fromJson(decrypted, JsonObject.class);
        return jsonObject;
//        } catch (Exception e) {
//            e.printStackTrace();
//            return null;
//        }
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
        UserDetails userDetails = customUserDetailsService.loadUserByUsername(extractMacAddress(token));
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

    public String reissueAccessToken(String refreshToken, HttpServletResponse response) {
        try {
            String studentId = redisService.getValues(refreshToken);
            return createAccessToken(studentId);
        } catch (ExpiredJwtException e) {
            response.setStatus(HttpStatus.UNAUTHORIZED.value());
            return ErrorCode.EXPIRED_ACCESS_TOKEN.getMessage();
        }
    }

    public String reissueRefreshToken(String refreshToken, HttpServletResponse response) {
        try {
            String studentId = redisService.getValues(refreshToken);
            String newRefreshToken = createRefreshToken(studentId);

            redisService.delValues(refreshToken);
            redisService.setValues(studentId, newRefreshToken);

            return newRefreshToken;
        } catch (ExpiredJwtException e) {
            response.setStatus(HttpStatus.UNAUTHORIZED.value());
            return ErrorCode.EXPIRED_REFRESH_TOKEN.getMessage();
        }
    }


}
