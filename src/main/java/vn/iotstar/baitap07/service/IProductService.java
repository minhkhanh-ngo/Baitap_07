package vn.iotstar.baitap07.service;

import vn.iotstar.baitap07.entity.Product;

import java.util.List;
import java.util.Optional;

public interface IProductService {

    List<Product> findAll();

    Optional<Product> findById(Long id);

    Optional<Product> findByProductName(String productName);

    <S extends Product> S save(S entity);

    void delete(Product entity);

    void deleteById(Long id);
}