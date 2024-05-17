package potato.cheq.service.jwt;

import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtParser;
import io.jsonwebtoken.*;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.apache.commons.codec.binary.Hex;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import potato.cheq.repository.UserRepository;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
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

    @Value("${jwt.aesKey}")
    private String aesKey;

    private SecretKey getSigningKey() {
        byte[] keyBytes = Decoders.BASE64.decode(this.secretKey);
        return Keys.hmacShaKeyFor(keyBytes);
    }

    public String createAccessToken(String memberId) throws Exception {
        return this.createToken(memberId, getMacAddress(memberId), accessTokenValidTime, "access");
    }

    public String createRefreshToken(String memberId) throws Exception {
        return this.createToken(memberId, getMacAddress(memberId), refreshTokenValidTime, "refresh");
    }

    public String createToken(String memberId, String macAddress, long tokenValid, String tokenType) throws Exception {
        JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty("memberId", memberId);
        jsonObject.addProperty("macAddress",macAddress);

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

    private String getMacAddress(String studentID) throws Exception {
        String userUUID = userRepository.findUuidByStudentId(studentID);

        if (userUUID == null) {
            throw new Exception("사용자의 UUID 값을 찾을 수 없습니다.");
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

    public Long getUserId(String token) {
        JsonElement memberId = extraValue(token).get("memberId");
        if(memberId.isJsonNull()) {
            return null;
        }
        return memberId.getAsLong();
    }

    private JsonObject extraValue(String token) {
        String subject = extraAllClaims(token).getSubject();
        try {
            String decrypted = decrypt(subject);
            JsonObject jsonObject = new Gson().fromJson(decrypted, JsonObject.class);
            return jsonObject;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
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


}
