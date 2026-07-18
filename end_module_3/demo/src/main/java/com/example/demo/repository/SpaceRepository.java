package com.example.demo.repository;

import com.example.demo.entity.Space;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class SpaceRepository extends BaseRepository implements ISpaceRepository {
    private static final String SELECT_ALL_SPACES = "SELECT * FROM mat_bang ORDER BY dien_tich ASC";
    private static final String SELECT_SPACE_BY_ID = "SELECT * FROM mat_bang WHERE ma_mat_bang = ?";
    private static final String INSERT_SPACE = "INSERT INTO mat_bang (ma_mat_bang, dien_tich, trang_thai, tang, loai_mat_bang, mo_ta_chi_tiet, gia_cho_the) VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_SPACE = "UPDATE mat_bang SET dien_tich = ?, trang_thai = ?, tang = ?, loai_mat_bang = ?, mo_ta_chi_tiet = ?, gia_cho_the = ? WHERE ma_mat_bang = ?";
    private static final String DELETE_SPACE = "DELETE FROM mat_bang WHERE ma_mat_bang = ?";

    @Override
    public List<Space> findAll() {
        List<Space> spaces = new ArrayList<>();
        // Khai báo gộp cả 3 tài nguyên tự đóng theo chuẩn Java 8 (Try-With-Resources)
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_SPACES);
             ResultSet resultSet = preparedStatement.executeQuery()) {

            while (resultSet.next()) {
                spaces.add(mapResultSetToSpace(resultSet));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return spaces;
    }

    private static Space mapResultSetToSpace(ResultSet resultSet) throws SQLException {
        Space space = new Space();
        space.setId(resultSet.getString("ma_mat_bang"));
        space.setArea(resultSet.getDouble("dien_tich"));
        space.setStatus(resultSet.getString("trang_thai"));
        space.setFloor(resultSet.getInt("tang"));
        space.setType(resultSet.getString("loai_mat_bang"));
        space.setDescription(resultSet.getString("mo_ta_chi_tiet"));
        space.setPrice(resultSet.getBigDecimal("gia_cho_the"));
        return space;
    }

    @Override
    public Space findByID(String id) {
        Space space = null;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_SPACE_BY_ID)) {

            preparedStatement.setString(1, id);

            // Thực thi và đóng ResultSet an toàn theo chuẩn Java 8
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    space = mapResultSetToSpace(resultSet);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return space;
    }

    @Override
    public boolean save(Space space) {
        try (Connection connection = getConnection()) {
            return this.save(connection, space);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean save(Connection connection, Space space) throws SQLException {
        try (PreparedStatement stmt = connection.prepareStatement(INSERT_SPACE)) {
            stmt.setString(1, space.getId());
            stmt.setDouble(2, space.getArea());
            stmt.setString(3, space.getStatus());
            stmt.setInt(4, space.getFloor());
            stmt.setString(5, space.getType());
            stmt.setString(6, space.getDescription());
            stmt.setBigDecimal(7, space.getPrice());

            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    public boolean update(Space space) {
        try (Connection conn = getConnection()) {
            return updateInTransaction(conn, space);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateInTransaction(Connection conn, Space space) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(UPDATE_SPACE)) {
            ps.setDouble(1, space.getArea());
            ps.setString(2, space.getStatus());
            ps.setInt(3, space.getFloor());
            ps.setString(4, space.getType());
            ps.setString(5, space.getDescription());
            ps.setBigDecimal(6, space.getPrice());
            ps.setString(7, space.getId());
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean delete(String id) {
        int rowsDeleted = 0;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(DELETE_SPACE)) {

            preparedStatement.setString(1, id);
            rowsDeleted = preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rowsDeleted > 0;
    }

    @Override
    public List<Space> search(String type, Integer floor) {
        // Bước 1: Lấy toàn bộ danh sách mặt bằng đã được DB sắp xếp sẵn tăng dần theo diện tích
        List<Space> allSpaces = this.findAll();

        // Bước 2: Dùng Java 8 Stream lọc cực kỳ an toàn, nhanh gọn, không lo lỗi cú pháp SQL động
        return allSpaces.stream()
                .filter(space -> type == null || type.trim().isEmpty() || space.getType().equalsIgnoreCase(type.trim()))
                .filter(space -> floor == null || floor <= 0 || space.getFloor() == floor)
                .sorted((s1, s2) -> Double.compare(s1.getArea(), s2.getArea()))
                .collect(Collectors.toList());
    }
}