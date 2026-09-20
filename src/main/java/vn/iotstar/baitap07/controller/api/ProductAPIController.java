package vn.iotstar.baitap07.controller.api;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import vn.iotstar.baitap07.entity.Category;
import vn.iotstar.baitap07.entity.Product;
import vn.iotstar.baitap07.model.Response;
import vn.iotstar.baitap07.service.ICategoryService;
import vn.iotstar.baitap07.service.IProductService;
import vn.iotstar.baitap07.service.IStorageService;

import java.sql.Timestamp;
import java.util.Date;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping(path = "/api/product")
public class ProductAPIController {

    private final IProductService productService;
    private final ICategoryService categoryService;
    private final IStorageService storageService;

    public ProductAPIController(IProductService productService, ICategoryService categoryService, IStorageService storageService) {
        this.productService = productService;
        this.categoryService = categoryService;
        this.storageService = storageService;
    }

    @GetMapping
    public ResponseEntity<?> getAllProduct() {
        return new ResponseEntity<>(new Response(true, "Thành công", productService.findAll()), HttpStatus.OK);
    }

    @GetMapping(path = "/getProduct")
    public ResponseEntity<?> getProduct(@RequestParam("id") Long id) {
        Optional<Product> product = productService.findById(id);
        if (product.isPresent()) {
            return new ResponseEntity<>(new Response(true, "Thành công", product.get()), HttpStatus.OK);
        }
        return new ResponseEntity<>(new Response(false, "Không tìm thấy sản phẩm", null), HttpStatus.NOT_FOUND);
    }

    @PostMapping(path = "/addProduct", consumes = "multipart/form-data")
    public ResponseEntity<?> addProduct(
            @Validated @RequestParam("productName") String productName,
            @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
            @Validated @RequestParam("unitPrice") Double unitPrice,
            @Validated @RequestParam(value = "discount", required = false, defaultValue = "0") Double discount,
            @Validated @RequestParam(value = "description", required = false) String description,
            @Validated @RequestParam("categoryId") Long categoryId,
            @Validated @RequestParam("quantity") Integer quantity,
            @Validated @RequestParam("status") Short status) {

        Optional<Product> optProduct = productService.findByProductName(productName);
        if (optProduct.isPresent()) {
            return new ResponseEntity<>(new Response(false, "Sản phẩm này đã tồn tại trong hệ thống", null), HttpStatus.BAD_REQUEST);
        }

        Optional<Category> optCategory = categoryService.findById(categoryId);
        if (optCategory.isEmpty()) {
            return new ResponseEntity<>(new Response(false, "Danh mục không tồn tại", null), HttpStatus.BAD_REQUEST);
        }

        Product product = new Product();
        product.setProductName(productName);
        product.setUnitPrice(unitPrice);
        product.setDiscount(discount);
        product.setDescription(description);
        product.setQuantity(quantity);
        product.setStatus(status);
        product.setCategory(optCategory.get());
        product.setCreateDate(new Timestamp(new Date().getTime()));

        if (imageFile != null && !imageFile.isEmpty()) {
            UUID uuid = UUID.randomUUID();
            String filename = storageService.getSorageFilename(imageFile, uuid.toString());
            storageService.store(imageFile, filename);
            product.setImages(filename);
        }

        productService.save(product);
        return new ResponseEntity<>(new Response(true, "Thêm sản phẩm thành công", product), HttpStatus.OK);
    }

    @PutMapping(path = "/updateProduct", consumes = "multipart/form-data")
    public ResponseEntity<?> updateProduct(
            @Validated @RequestParam("productId") Long productId,
            @Validated @RequestParam("productName") String productName,
            @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
            @Validated @RequestParam("unitPrice") Double unitPrice,
            @Validated @RequestParam(value = "discount", required = false, defaultValue = "0") Double discount,
            @Validated @RequestParam(value = "description", required = false) String description,
            @Validated @RequestParam("categoryId") Long categoryId,
            @Validated @RequestParam("quantity") Integer quantity,
            @Validated @RequestParam("status") Short status) {

        Optional<Product> optProduct = productService.findById(productId);
        if (optProduct.isEmpty()) {
            return new ResponseEntity<>(new Response(false, "Không tìm thấy sản phẩm", null), HttpStatus.BAD_REQUEST);
        }

        Optional<Category> optCategory = categoryService.findById(categoryId);
        if (optCategory.isEmpty()) {
            return new ResponseEntity<>(new Response(false, "Danh mục không tồn tại", null), HttpStatus.BAD_REQUEST);
        }

        Product product = optProduct.get();
        product.setProductName(productName);
        product.setUnitPrice(unitPrice);
        product.setDiscount(discount);
        product.setDescription(description);
        product.setQuantity(quantity);
        product.setStatus(status);
        product.setCategory(optCategory.get());

        if (imageFile != null && !imageFile.isEmpty()) {
            UUID uuid = UUID.randomUUID();
            String filename = storageService.getSorageFilename(imageFile, uuid.toString());
            storageService.store(imageFile, filename);
            product.setImages(filename);
        }

        productService.save(product);
        return new ResponseEntity<>(new Response(true, "Cập nhật sản phẩm thành công", product), HttpStatus.OK);
    }

    @DeleteMapping(path = "/deleteProduct")
    public ResponseEntity<?> deleteProduct(@RequestParam("productId") Long productId) {
        Optional<Product> optProduct = productService.findById(productId);
        if (optProduct.isEmpty()) {
            return new ResponseEntity<>(new Response(false, "Không tìm thấy sản phẩm", null), HttpStatus.BAD_REQUEST);
        }
        
        productService.delete(optProduct.get());
        return new ResponseEntity<>(new Response(true, "Xóa sản phẩm thành công", optProduct.get()), HttpStatus.OK);
    }
}