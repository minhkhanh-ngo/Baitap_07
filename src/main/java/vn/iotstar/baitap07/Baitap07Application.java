package vn.iotstar.baitap07;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import vn.iotstar.baitap07.config.StorageProperties;
import vn.iotstar.baitap07.service.IStorageService;

@SpringBootApplication
@EnableConfigurationProperties(StorageProperties.class)
public class Baitap07Application {

	public static void main(String[] args) {
		SpringApplication.run(Baitap07Application.class, args);
	}

	@Bean
    CommandLineRunner init(IStorageService storageService) {
        return (args -> {
            storageService.init();
        });
    }

}
