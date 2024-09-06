package potato.cheq.service.jwt;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import potato.cheq.entity.AdminEntity;
import potato.cheq.entity.UserEntity;

import java.util.Collection;
import java.util.Collections;

@RequiredArgsConstructor
public class CustomUserDetails implements UserDetails {
    private final UserEntity user;
    private final AdminEntity admin;

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        if (user != null) {
            return Collections.singletonList(new SimpleGrantedAuthority(user.getUserRole().name()));
        } else if (admin != null) {
            return Collections.singletonList(new SimpleGrantedAuthority(admin.getUserRole().name()));
        }
        return Collections.emptyList();
    }

    @Override
    public String getPassword() {
        if (user != null) {
            return user.getPassword();
        } else if (admin != null) {
            return admin.getPassword();
        }
        return null;
    }

    @Override
    public String getUsername() {
        if (user != null) {
            return user.getEmail();
        } else if (admin != null) {
            return admin.getEmail();
        }
        return null;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}
