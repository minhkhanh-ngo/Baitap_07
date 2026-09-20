package vn.iotstar.baitap07.config;

import jakarta.servlet.DispatcherType;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Path;
import java.nio.file.Paths;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    private final StorageProperties properties;

    public WebConfig(StorageProperties properties) {
        this.properties = properties;
    }

    @Bean
    public FilterRegistrationBean<CustomSiteMeshFilter> siteMeshFilter() {
        FilterRegistrationBean<CustomSiteMeshFilter> filterRegistrationBean = new FilterRegistrationBean<>();
        filterRegistrationBean.setFilter(new CustomSiteMeshFilter());
        filterRegistrationBean.addUrlPatterns("/*");
        filterRegistrationBean.setDispatcherTypes(DispatcherType.REQUEST);
        return filterRegistrationBean;
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        Path uploadDir = Paths.get(properties.getLocation());
        String uploadPath = uploadDir.toUri().toString();

        registry.addResourceHandler("/images/**")
                .addResourceLocations(uploadPath);
    }
}