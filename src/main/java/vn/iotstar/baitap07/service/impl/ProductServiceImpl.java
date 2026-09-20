package vn.iotstar.baitap07.service.impl;

import org.springframework.stereotype.Service;
import vn.iotstar.baitap07.entity.Product;
import vn.iotstar.baitap07.repository.ProductRepository;
import vn.iotstar.baitap07.service.IProductService;

import java.util.List;
import java.util.Optional;

@Service
public class ProductServiceImpl implements IProductService {

    private final ProductRepository productRepository;

    // Sử dụng Constructor Injection
    public ProductServiceImpl(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @Override
    public List<Product> findAll() {
        return productRepository.findAll();
    }

    @Override
    public Optional<Product> findById(Long id) {
        return productRepository.findById(id);
    }

    @Override
    public Optional<Product> findByProductName(String productName) {
        return productRepository.findByProductName(productName);
    }

    @Override
    public <S extends Product> S save(S entity) {
        return productRepository.save(entity);
    }

    @Override
    public void delete(Product entity) {
        productRepository.delete(entity);
    }

    @Override
    public void deleteById(Long id) {
        productRepository.deleteById(id);
    }
}