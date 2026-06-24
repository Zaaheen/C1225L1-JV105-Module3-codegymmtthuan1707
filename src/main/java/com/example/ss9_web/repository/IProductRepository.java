package com.example.ss9_web.repository;

import com.example.ss9_web.entity.Product;

public interface IProductRepository {
    void save(Product product);
    Product findById(String id);
}

