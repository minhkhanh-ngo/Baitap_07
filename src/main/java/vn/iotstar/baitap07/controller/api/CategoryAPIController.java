package vn.iotstar.baitap07.controller.api;

import java.util.Optional;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import vn.iotstar.baitap07.entity.Category;
import vn.iotstar.baitap07.model.Response;
import vn.iotstar.baitap07.service.ICategoryService;
import vn.iotstar.baitap07.service.IStorageService;

@RestController
@RequestMapping(path = "/api/category")
public class CategoryAPIController {
    
    private final ICategoryService categoryService;
    private final IStorageService storageService;

    public CategoryAPIController(ICategoryService categoryService, IStorageService storageService) {
        this.categoryService = categoryService;
        this.storageService = storageService;
    }

    @GetMapping
    public ResponseEntity<?> getAllCategory() {
        return new ResponseEntity<Response>(new Response(true, "Thành công", categoryService.findAll()), HttpStatus.OK);
    }

    @PostMapping(path = "/getCategory")
    public ResponseEntity<?> getCategory(@Validated @RequestParam("id") Long id) {
        Optional<Category> category = categoryService.findById(id);
        if (category.isPresent()) {
            return new ResponseEntity<Response>(new Response(true, "Thành công", category.get()), HttpStatus.OK);
        } else {
            return new ResponseEntity<Response>(new Response(false, "Thất bại", null), HttpStatus.NOT_FOUND);
        }
    }

    @PostMapping(path = "/addCategory", consumes = "multipart/form-data")
    public ResponseEntity<?> addCategory(
            @Validated @RequestParam("categoryName") String categoryName,
            @RequestParam(value = "icon", required = false) MultipartFile icon) { 
        
        Optional<Category> optCategory = categoryService.findByCategoryName(categoryName);
        if (optCategory.isPresent()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Category đã tồn tại trong hệ thống");
        } else {
            Category category = new Category();
            if(icon != null && !icon.isEmpty()) {
                UUID uuid = UUID.randomUUID();
                String uuString = uuid.toString();
                category.setIcon(storageService.getSorageFilename(icon, uuString));
                storageService.store(icon, category.getIcon());
            }
            category.setCategoryName(categoryName);
            categoryService.save(category);
            return new ResponseEntity<Response>(new Response(true, "Thêm Thành công", category), HttpStatus.OK);
        }
    }

    @PutMapping(path = "/updateCategory", consumes = "multipart/form-data")
    public ResponseEntity<?> updateCategory(
            @Validated @RequestParam("categoryId") Long categoryId,
            @Validated @RequestParam("categoryName") String categoryName,
            @RequestParam(value = "icon", required = false) MultipartFile icon) {
        
        Optional<Category> optCategory = categoryService.findById(categoryId);
        if (optCategory.isEmpty()) {
            return new ResponseEntity<Response>(new Response(false, "Không tìm thấy Category", null), HttpStatus.BAD_REQUEST);
        } else if(optCategory.isPresent()) {
            if(icon != null && !icon.isEmpty()) {
                UUID uuid = UUID.randomUUID();
                String uuString = uuid.toString();
                optCategory.get().setIcon(storageService.getSorageFilename(icon, uuString));
                storageService.store(icon, optCategory.get().getIcon());
            }
            optCategory.get().setCategoryName(categoryName);
            categoryService.save(optCategory.get());
            return new ResponseEntity<Response>(new Response(true, "Cập nhật Thành công", optCategory.get()), HttpStatus.OK);
        }
        return null;
    }

    @DeleteMapping(path = "/deleteCategory")
    public ResponseEntity<?> deleteCategory(@Validated @RequestParam("categoryId") Long categoryId) {
        Optional<Category> optCategory = categoryService.findById(categoryId);
        if (optCategory.isEmpty()) {
            return new ResponseEntity<Response>(new Response(false, "Không tìm thấy Category", null), HttpStatus.BAD_REQUEST);
        } else if(optCategory.isPresent()) {
            categoryService.delete(optCategory.get());
            return new ResponseEntity<Response>(new Response(true, "Xóa Thành công", optCategory.get()), HttpStatus.OK);
        }
        return null;
    }
}