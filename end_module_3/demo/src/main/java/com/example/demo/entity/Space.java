package com.example.demo.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Space {
    private String id;
    private double area;
    private String status;
    private int floor;
    private String type;
    private String description;
    private BigDecimal price;
}
