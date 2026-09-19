package vn.iotstar.baitap07.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import lombok.Data;

@Data
@ConfigurationProperties("storage")
public class StorageProperties {
    private String location;
}