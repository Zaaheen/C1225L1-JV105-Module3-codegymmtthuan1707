package com.example.ss9_web.controller;

import com.example.ss9_web.entity.Product;
import com.example.ss9_web.service.ProductService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "productController", value = "/products")
public class ProductController extends HttpServlet {
    private ProductService productService = new ProductService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String description = req.getParameter("description");
        double listPrice = Double.parseDouble(req.getParameter("listPrice"));
        double discountPercent = Double.parseDouble(req.getParameter("discountPercent"));
        Product product = new Product(description, listPrice, discountPercent);
        productService.calculateDiscount(product);
        req.setAttribute("product", product);
        req.getRequestDispatcher("/WEB-INF/view/product.jsp").forward(req, resp);

    }
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/view/product.jsp").forward(req, resp);
    }
}
