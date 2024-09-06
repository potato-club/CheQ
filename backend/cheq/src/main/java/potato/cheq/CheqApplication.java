package potato.cheq;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@SpringBootApplication
@EnableJpaAuditing
public class CheqApplication {

	public static void main(String[] args) {
		SpringApplication.run(CheqApplication.class, args);
	}

}
