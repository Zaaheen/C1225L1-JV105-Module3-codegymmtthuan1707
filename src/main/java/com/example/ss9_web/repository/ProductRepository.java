package com.example.ss9_web.repository;

import com.example.ss9_web.entity.Product;

public class ProductRepository implements IProductRepository{
    @Override
    public void save(Product product) {
        System.out.println("Sản phẩm đã được lưu: " + product.getDescription());
    }

    @Override
    public Product findById(String id) {
        return null;
    }
}
