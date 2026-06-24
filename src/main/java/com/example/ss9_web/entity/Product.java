package com.example.ss9_web.entity;

public class Product {
    private String description;
    private double listPrice;
    private double discountPercent;
    private double discountAmount;
    private double discountPrice;

    public Product(String description, double listPrice, double discountPercent) {
        this.description = description;
        this.listPrice = listPrice;
        this.discountPercent = discountPercent;
    }

    public String getDescription() { return description; }
    public double getListPrice() { return listPrice; }
    public double getDiscountPercent() { return discountPercent; }

    public void setDiscountAmount(double discountAmount) { this.discountAmount = discountAmount; }
    public double getDiscountAmount() { return discountAmount; }

    public void setDiscountPrice(double discountPrice) { this.discountPrice = discountPrice; }
    public double getDiscountPrice() { return discountPrice; }
}
