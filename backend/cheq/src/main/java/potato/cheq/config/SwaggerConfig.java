package potato.cheq.config;

import io.swagger.v3.oas.models.info.Info;
import org.springdoc.core.models.GroupedOpenApi;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SwaggerConfig {

    @Bean
    public GroupedOpenApi AllApi() {
        Info info = new Info().title("모든 API").version("v0.1");

        return GroupedOpenApi.builder()
                .group("all")
                .pathsToMatch("/**")
                .displayName("All API")
                .addOpenApiCustomizer(api -> api.setInfo(info))
                .build();
    }

    @Bean
    public GroupedOpenApi userApi() {
        Info info = new Info().title("유저 관련 API").version("v0.1");
        String[] paths = {"/user/**"};

        return GroupedOpenApi.builder()
                .group("user")
                .pathsToMatch(paths)
                .displayName("User's API")
                .addOpenApiCustomizer(api -> api.setInfo(info))
                .build();
    }

    @Bean
    public GroupedOpenApi attendanceApi() {
        Info info = new Info().title("출결 관련 API").version("v0.1");
        String[] paths = {"/attendance/**"};

        return GroupedOpenApi.builder()
                .group("attendance")
                .pathsToMatch(paths)
                .displayName("Attendance's API")
                .addOpenApiCustomizer(api -> api.setInfo(info))
                .build();
    }

}
