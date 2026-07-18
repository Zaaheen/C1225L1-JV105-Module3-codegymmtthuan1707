package com.example.ss9_web.service;

import com.example.ss9_web.entity.Product;
import com.example.ss9_web.repository.ProductRepository;

public class ProductService implements IProductService{
    private ProductRepository repository = new ProductRepository();
    @Override
    public void calculateDiscount(Product product) {
        double amount = product.getListPrice() * product.getDiscountPercent() * 0.01;
        double finalPrice = product.getListPrice() - amount;

        product.setDiscountAmount(amount);
        product.setDiscountPrice(finalPrice);

        // 2. Lưu kết quả thông qua Repository
        repository.save(product);
    }
}
