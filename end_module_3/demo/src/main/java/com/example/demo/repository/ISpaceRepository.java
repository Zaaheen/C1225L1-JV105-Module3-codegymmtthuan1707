package com.example.demo.repository;

import com.example.demo.entity.Space;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public interface ISpaceRepository {
    List<Space> findAll();
    Space findByID(String id);
    boolean save(Space space);
    boolean delete(String id);
    boolean update(Space space);
    List<Space> search(String type, Integer floor);
    boolean save(Connection connection, Space space) throws SQLException;
    boolean updateInTransaction(Connection connection, Space space) throws SQLException;
}
