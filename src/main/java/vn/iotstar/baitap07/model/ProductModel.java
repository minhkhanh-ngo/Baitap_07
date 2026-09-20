package vn.iotstar.baitap07.model;

import org.springframework.web.multipart.MultipartFile;
import lombok.Data;

@Data
public class ProductModel {
    private Long productId;
    private String productName;
    private Double unitPrice;
    private Double discount;
    private String description;
    private Integer quantity;
    private Short status;
    private Long categoryId;
    private MultipartFile imageFile;
}