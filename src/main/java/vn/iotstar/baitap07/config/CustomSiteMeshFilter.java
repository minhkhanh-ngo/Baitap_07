package vn.iotstar.baitap07.config;

import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;

public class CustomSiteMeshFilter extends ConfigurableSiteMeshFilter {
    @Override
    protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
        builder.addDecoratorPath("/*", "/decorators/web.jsp")
               .addDecoratorPath("/admin/*", "/decorators/admin.jsp")
               .addExcludedPath("/login*").addExcludedPath("/login/*")
               .addExcludedPath("/alogin*").addExcludedPath("/alogin/*")
               .addExcludedPath("/api/**").addExcludedPath("/api/**")
               .addExcludedPath("/swagger-ui**").addExcludedPath("/swagger-ui/**")
               .addExcludedPath("/v3/api-docs**").addExcludedPath("/v3/api-docs/**")
               .addExcludedPath("/swagger-ui.html"); 
    }
}