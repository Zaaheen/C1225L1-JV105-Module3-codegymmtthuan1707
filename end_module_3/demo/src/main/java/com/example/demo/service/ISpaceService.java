package com.example.demo.service;

import com.example.demo.entity.Space;

import java.util.List;

public interface ISpaceService {
    List<Space> findAll();
    Space findByID(String id);
    boolean save(Space space);
    boolean delete(String id);
    boolean update(Space space);
    List<Space> search(String type, Integer floor);
}
