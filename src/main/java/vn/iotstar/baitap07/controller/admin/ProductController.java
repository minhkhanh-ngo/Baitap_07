package vn.iotstar.baitap07.controller.admin;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.core.io.Resource;
import vn.iotstar.baitap07.service.IStorageService;

@Controller
@RequestMapping("/admin/products")
public class ProductController {

    private final IStorageService storageService;

    public ProductController(IStorageService storageService) {
        this.storageService = storageService;
    }

    @GetMapping("/ajax")
    public String adminProductPage() {
        return "admin/product/product-ajax"; 
    }
    @GetMapping("/images/{filename:.+}")
    @ResponseBody
    public ResponseEntity<Resource> serveFile(@PathVariable String filename) {
        Resource file = storageService.loadAsResource(filename);
        if (file == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok().body(file);
    }
}   