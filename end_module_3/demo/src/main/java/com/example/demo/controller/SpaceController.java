package com.example.demo.controller;

import com.example.demo.entity.Space;
import com.example.demo.service.ISpaceService;
import com.example.demo.service.SpaceService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/spaces")
public class SpaceController extends HttpServlet {

    // Khai báo tầng Service để xử lý logic nghiệp vụ
    private final ISpaceService spaceService = new SpaceService();

    // Hằng số tránh việc gõ sai chính tả các action (Anti-typo)
    private static final String ACTION_LIST = "list";
    private static final String ACTION_CREATE = "create";
    private static final String ACTION_EDIT = "edit";
    private static final String ACTION_DELETE = "delete";
    private static final String ACTION_ADD = "add";
    private static final String ACTION_UPDATE = "update";
    private static final String ACTION_SEARCH = "search";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Cấu hình UTF-8 để không bị lỗi font tiếng Việt
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = ACTION_LIST;
        }

        switch (action) {
            case ACTION_LIST:
                handleList(request, response);
                break;
            case ACTION_CREATE:
                handleCreate(request, response);
                break;
            case ACTION_EDIT:
                handleEdit(request, response);
                break;
            case ACTION_DELETE:
                handleDelete(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/spaces?action=" + ACTION_LIST);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/spaces?action=" + ACTION_LIST);
            return;
        }

        switch (action) {
            case ACTION_ADD:
            case ACTION_UPDATE:
                handleSaveSpace(request, response, action);
                break;
            case ACTION_SEARCH:
                handleSearch(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/spaces?action=" + ACTION_LIST);
        }
    }

    /**
     * Hiển thị danh sách toàn bộ mặt bằng (GET)
     */
    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Space> spaces = spaceService.findAll();
        request.setAttribute("spaces", spaces);
        request.setAttribute("title", "Danh sách mặt bằng");
        // Chuyển hướng sang trang hiển thị danh sách
        request.getRequestDispatcher("/WEB-INF/view/space_list.jsp").forward(request, response);
    }

    /**
     * Tìm kiếm kết hợp đa điều kiện (Loại mặt bằng + Tầng)
     */
    private void handleSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String searchType = request.getParameter("searchType");
        String floorStr = request.getParameter("searchFloor");

        Integer searchFloor = null;
        if (floorStr != null && !floorStr.trim().isEmpty()) {
            try {
                searchFloor = Integer.parseInt(floorStr.trim());
            } catch (NumberFormatException e) {
                searchFloor = null; // Bỏ qua nếu người dùng nhập tầm bậy hoặc chọn "Tất cả"
            }
        }

        List<Space> searchResults = spaceService.search(searchType, searchFloor);
        request.setAttribute("spaces", searchResults);
        request.setAttribute("searchType", searchType);
        request.setAttribute("searchFloor", floorStr);
        request.setAttribute("title", "Kết quả tìm kiếm");
        request.getRequestDispatcher("/WEB-INF/view/space_list.jsp").forward(request, response);
    }

    /**
     * Hiển thị giao diện form thêm mới mặt bằng (GET)
     */
    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("title", "Thêm mặt bằng mới");
        request.getRequestDispatcher("/WEB-INF/view/space_form.jsp").forward(request, response);
    }

    /**
     * Hiển thị giao diện form chỉnh sửa thông tin mặt bằng (GET)
     */
    private void handleEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        if (id == null || id.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/spaces?action=" + ACTION_LIST);
            return;
        }

        Space space = spaceService.findByID(id.trim());
        if (space == null) {
            response.sendRedirect(request.getContextPath() + "/spaces?action=" + ACTION_LIST);
            return;
        }

        request.setAttribute("space", space);
        request.setAttribute("title", "Chỉnh sửa mặt bằng");
        request.getRequestDispatcher("/WEB-INF/view/space_form.jsp").forward(request, response);
    }

    /**
     * Xử lý xóa thông tin mặt bằng (GET)
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String id = request.getParameter("id");
        boolean success = false;
        if (id != null && !id.trim().isEmpty()) {
            success = spaceService.delete(id.trim());
        }
        if (success) {
            response.sendRedirect(request.getContextPath() + "/spaces?action=list&success=delete");
        } else {
            response.sendRedirect(request.getContextPath() + "/spaces?action=list");
        }
    }

    /**
     * Xử lý lưu thông tin mặt bằng gồm cả thêm mới và cập nhật (POST)
     */
    private void handleSaveSpace(HttpServletRequest request, HttpServletResponse response, String action)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        String areaStr = request.getParameter("area");
        String status = request.getParameter("status");
        String floorStr = request.getParameter("floor");
        String type = request.getParameter("type");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");

        // Khởi tạo đối tượng Space lưu trữ giá trị tạm thời phục vụ giữ lại dữ liệu khi lỗi
        Space space = new Space();
        space.setId(id != null ? id.trim() : "");
        space.setStatus(status);
        space.setType(type);
        space.setDescription(description != null ? description.trim() : "");

        boolean hasError = false;

        // 1. Kiểm tra mã mặt bằng: bắt buộc đúng định dạng XXX-XX-XX
        if (id == null || !id.trim().matches("^[A-Z0-9]{3}-[A-Z0-9]{2}-[A-Z0-9]{2}$")) {
            request.setAttribute("err_id", "Mã mặt bằng phải đúng định dạng XXX-XX-XX (X là chữ hoa hoặc số)!");
            hasError = true;
        } else if (ACTION_ADD.equals(action)) {
            // Kiểm tra trùng lặp khóa chính khi thêm mới
            Space existingSpace = spaceService.findByID(id.trim());
            if (existingSpace != null) {
                request.setAttribute("err_id", "Mã mặt bằng này đã tồn tại trong hệ thống!");
                hasError = true;
            }
        }

        // 2. Kiểm tra diện tích: > 20 m2
        double area = 0;
        try {
            if (areaStr != null && !areaStr.trim().isEmpty()) {
                area = Double.parseDouble(areaStr.trim());
                space.setArea(area);
                if (area <= 20) {
                    request.setAttribute("err_area", "Diện tích mặt bằng phải lớn hơn 20m²!");
                    hasError = true;
                }
            } else {
                request.setAttribute("err_area", "Diện tích không được để trống!");
                hasError = true;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("err_area", "Diện tích phải là một số hợp lệ!");
            hasError = true;
        }

        // 3. Kiểm tra Tầng: từ 1 đến 15
        int floor = 0;
        try {
            if (floorStr != null && !floorStr.trim().isEmpty()) {
                floor = Integer.parseInt(floorStr.trim());
                space.setFloor(floor);
                if (floor < 1 || floor > 15) {
                    request.setAttribute("err_floor", "Tòa nhà chỉ gồm 15 tầng (1 - 15)!");
                    hasError = true;
                }
            } else {
                request.setAttribute("err_floor", "Vui lòng chọn tầng!");
                hasError = true;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("err_floor", "Tầng không hợp lệ!");
            hasError = true;
        }

        // 4. Kiểm tra Giá tiền: > 1,000,000 VNĐ
        BigDecimal price = BigDecimal.ZERO;
        try {
            if (priceStr != null && !priceStr.trim().isEmpty()) {
                price = new BigDecimal(priceStr.trim());
                space.setPrice(price);
                if (price.compareTo(new BigDecimal("1000000")) <= 0) {
                    request.setAttribute("err_price", "Giá cho thuê phải lớn hơn 1.000.000 VNĐ!");
                    hasError = true;
                }
            } else {
                request.setAttribute("err_price", "Giá cho thuê không được để trống!");
                hasError = true;
            }
        } catch (Exception e) {
            request.setAttribute("err_price", "Giá tiền không hợp lệ!");
            hasError = true;
        }

        // Nếu phát sinh bất cứ lỗi kiểm tra nào, dừng tiến trình và trả về Form kèm thông báo lỗi
        if (hasError) {
            request.setAttribute("space", space);
            request.setAttribute("title", ACTION_ADD.equals(action) ? "Thêm mặt bằng mới" : "Chỉnh sửa mặt bằng");
            request.getRequestDispatcher("/WEB-INF/view/space_form.jsp").forward(request, response);
            return;
        }

        // 5. Thực thi ghi hoặc cập nhật dữ liệu xuống DB
        boolean success;
        if (ACTION_ADD.equals(action)) {
            success = spaceService.save(space);
        } else {
            success = spaceService.update(space);
        }

        if (success) {
            response.sendRedirect(request.getContextPath() + "/spaces?action=list&success=" + action);
        } else {
            request.setAttribute("error", "Lưu thông tin thất bại. Vui lòng kiểm tra lại kết nối Database!");
            request.setAttribute("space", space);
            request.setAttribute("title", ACTION_ADD.equals(action) ? "Thêm mặt bằng mới" : "Chỉnh sửa mặt bằng");
            request.getRequestDispatcher("/WEB-INF/view/space_form.jsp").forward(request, response);
        }
    }
}