package vn.iotstar.baitap07.config;

import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;

public class CustomSiteMeshFilter extends ConfigurableSiteMeshFilter {
    @Override
    protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
        builder.addDecoratorPath("/admin", "admin.jsp")
               .addDecoratorPath("/admin/*", "admin.jsp")
               .addDecoratorPath("/*", "web.jsp");
               
        builder.addExcludedPath("/api/**")
               .addExcludedPath("/error")
               .addExcludedPath("/error/**")
               .addExcludedPath("/login*")
               .addExcludedPath("/alogin*")
               .addExcludedPath("/css/**")
               .addExcludedPath("/js/**")
               .addExcludedPath("/images/**");
    }
}