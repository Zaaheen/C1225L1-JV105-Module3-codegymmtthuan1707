<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title}</title>
    <!-- Nhúng thư viện Tailwind CSS phục vụ thiết kế giao diện chuẩn quốc tế -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-slate-50 font-sans text-slate-800 antialiased min-h-screen flex flex-col">

<!-- Phần đầu trang (Header) hiển thị Logo và Trạng thái -->
<header class="bg-blue-600 text-white shadow-md">
    <div class="max-w-4xl mx-auto px-4 h-16 flex items-center justify-between">
        <div class="flex items-center space-x-3">
            <i class="fa-solid fa-building-circle-check text-2xl"></i>
            <div>
                <h1 class="font-bold text-lg leading-tight">TComplex Portal</h1>
                <p class="text-xs text-blue-100">Quản lý mặt bằng cho thuê cao cấp Đà Nẵng</p>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/spaces?action=list" class="text-sm bg-blue-700 hover:bg-blue-800 px-4 py-2 rounded-lg font-semibold transition-all">
            <i class="fa-solid fa-arrow-left mr-2"></i>Quay lại danh sách
        </a>
    </div>
</header>

<!-- Container chính bọc form thêm mới/chỉnh sửa -->
<main class="flex-grow max-w-4xl w-full mx-auto px-4 py-8">
    <div class="bg-white shadow-xl rounded-2xl border border-slate-100 overflow-hidden">

        <!-- Tiêu đề của Form -->
        <div class="bg-gradient-to-r from-blue-600 to-indigo-600 px-6 py-5 text-white flex items-center justify-between">
            <div>
                <h2 class="text-xl font-bold">${title}</h2>
                <p class="text-xs text-blue-100 mt-1">Vui lòng nhập đầy đủ các thông tin có đánh dấu sao đỏ (*)</p>
            </div>
            <i class="fa-solid fa-file-invoice text-3xl opacity-30"></i>
        </div>

        <!-- Form chính liên kết logic -->
        <form id="spaceForm" action="${pageContext.request.contextPath}/spaces" method="POST" onsubmit="return validateClientSide(event)" class="p-6 sm:p-8 space-y-6">
            <!-- Truyền action ẩn để servlet nhận biết luồng xử lý -->
            <input type="hidden" name="action" value="${space != null && not empty space.id ? 'update' : 'add'}">

            <!-- 1. Mã mặt bằng (ID) -->
            <div>
                <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">
                    Mã mặt bằng <span class="text-red-500">*</span>
                </label>
                <input type="text" id="spaceId" name="id" value="${space != null ? space.id : ''}"
                       placeholder="VD: ABC-12-34"
                ${space != null && not empty space.id ? 'readonly class="w-full text-sm border border-slate-200 bg-slate-100 text-slate-500 rounded-lg px-4 py-3 focus:outline-none cursor-not-allowed"' : 'class="w-full text-sm border border-slate-200 rounded-lg px-4 py-3 focus:ring-2 focus:ring-blue-500 focus:border-blue-500 focus:outline-none transition-all"'}
                       required>

                <!-- Dòng thông báo lỗi Client-side -->
                <p id="err_client_id" class="text-xs text-red-500 font-medium mt-1.5 hidden"></p>
                <!-- Dòng hiển thị lỗi trả về từ Server (Servlet) -->
                <c:if test="${not empty err_id}">
                    <p class="text-xs text-red-500 font-medium mt-1.5"><i class="fa-solid fa-circle-exclamation mr-1"></i> ${err_id}</p>
                </c:if>
            </div>

            <!-- 2. Hàng chứa Diện tích và Trạng thái -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <!-- Diện tích -->
                <div>
                    <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">
                        Diện tích (m²) <span class="text-red-500">*</span>
                    </label>
                    <input type="number" step="0.01" id="spaceArea" name="area" value="${space != null ? space.area : ''}"
                           placeholder="Phải lớn hơn 20 m²"
                           class="w-full text-sm border border-slate-200 rounded-lg px-4 py-3 focus:ring-2 focus:ring-blue-500 focus:border-blue-500 focus:outline-none transition-all"
                           required>
                    <p id="err_client_area" class="text-xs text-red-500 font-medium mt-1.5 hidden"></p>
                    <c:if test="${not empty err_area}">
                        <p class="text-xs text-red-500 font-medium mt-1.5"><i class="fa-solid fa-circle-exclamation mr-1"></i> ${err_area}</p>
                    </c:if>
                </div>

                <!-- Trạng thái -->
                <div>
                    <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">
                        Trạng thái <span class="text-red-500">*</span>
                    </label>
                    <select id="spaceStatus" name="status" class="w-full text-sm border border-slate-200 rounded-lg px-4 py-3 focus:ring-2 focus:ring-blue-500 focus:border-blue-500 focus:outline-none bg-white transition-all" required>
                        <option value="Trống" ${space != null && space.status == 'Trống' ? 'selected' : ''}>Trống</option>
                        <option value="Hạ tầng" ${space != null && space.status == 'Hạ tầng' ? 'selected' : ''}>Hạ tầng</option>
                        <option value="Đầy đủ" ${space != null && space.status == 'Đầy đủ' ? 'selected' : ''}>Đầy đủ</option>
                    </select>
                </div>
            </div>

            <!-- 3. Hàng chứa Tầng và Loại mặt bằng -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <!-- Tầng -->
                <div>
                    <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">
                        Tầng (1 - 15) <span class="text-red-500">*</span>
                    </label>
                    <select id="spaceFloor" name="floor" class="w-full text-sm border border-slate-200 rounded-lg px-4 py-3 focus:ring-2 focus:ring-blue-500 focus:border-blue-500 focus:outline-none bg-white transition-all" required>
                        <option value="">-- Chọn tầng --</option>
                        <c:forEach var="i" begin="1" end="15">
                            <option value="${i}" ${space != null && space.floor == i ? 'selected' : ''}>Tầng ${i}</option>
                        </c:forEach>
                    </select>
                    <p id="err_client_floor" class="text-xs text-red-500 font-medium mt-1.5 hidden"></p>
                    <c:if test="${not empty err_floor}">
                        <p class="text-xs text-red-500 font-medium mt-1.5"><i class="fa-solid fa-circle-exclamation mr-1"></i> ${err_floor}</p>
                    </c:if>
                </div>

                <!-- Loại mặt bằng -->
                <div>
                    <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">
                        Loại mặt bằng <span class="text-red-500">*</span>
                    </label>
                    <select id="spaceType" name="type" class="w-full text-sm border border-slate-200 rounded-lg px-4 py-3 focus:ring-2 focus:ring-blue-500 focus:border-blue-500 focus:outline-none bg-white transition-all" required>
                        <option value="Văn phòng chia sẻ" ${space != null && space.type == 'Văn phòng chia sẻ' ? 'selected' : ''}>Văn phòng chia sẻ</option>
                        <option value="Văn phòng trọn gói" ${space != null && space.type == 'Văn phòng trọn gói' ? 'selected' : ''}>Văn phòng trọn gói</option>
                    </select>
                </div>
            </div>

            <!-- 4. Mô tả chi tiết -->
            <div>
                <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">
                    Mô tả chi tiết mặt bằng
                </label>
                <textarea id="spaceDescription" name="description" rows="3" placeholder="Nhập thêm các ghi chú, tiện ích đi kèm (nếu có)..." class="w-full text-sm border border-slate-200 rounded-lg px-4 py-3 focus:ring-2 focus:ring-blue-500 focus:border-blue-500 focus:outline-none transition-all">${space != null ? space.description : ''}</textarea>
            </div>

            <!-- 5. Giá cho thuê -->
            <div>
                <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">
                    Giá cho thuê (VNĐ) <span class="text-red-500">*</span>
                </label>
                <div class="relative">
                    <input type="number" id="spacePrice" name="price" value="${space != null ? space.price : ''}"
                           placeholder="Giá tối thiểu là 1,000,001 VNĐ"
                           class="w-full text-sm border border-slate-200 rounded-lg pl-4 pr-16 py-3 focus:ring-2 focus:ring-blue-500 focus:border-blue-500 focus:outline-none transition-all"
                           required>
                    <span class="absolute right-4 top-1/2 -translate-y-1/2 text-sm font-semibold text-slate-400">VNĐ</span>
                </div>
                <p id="err_client_price" class="text-xs text-red-500 font-medium mt-1.5 hidden"></p>
                <c:if test="${not empty err_price}">
                    <p class="text-xs text-red-500 font-medium mt-1.5"><i class="fa-solid fa-circle-exclamation mr-1"></i> ${err_price}</p>
                </c:if>
            </div>

            <!-- Hàng nút tác vụ lưu trữ/hủy bỏ -->
            <div class="flex items-center justify-end space-x-4 pt-6 border-t border-slate-100">
                <a href="${pageContext.request.contextPath}/spaces?action=list" class="px-6 py-3 border border-slate-200 rounded-xl text-sm font-semibold text-slate-600 hover:bg-slate-50 transition-all">
                    Hủy (No)
                </a>
                <button type="submit" class="px-8 py-3 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-sm font-semibold shadow-lg hover:shadow-xl transition-all">
                    Lưu thông tin
                </button>
            </div>

        </form>
    </div>
</main>

<!-- Script JavaScript kiểm soát định dạng phía Client -->
<script>
    function validateClientSide(event) {
        // Thiết lập trạng thái ban đầu là hợp lệ
        let isValid = true;

        // Xóa toàn bộ thông điệp lỗi cũ của Client
        const fields = ["id", "area", "floor", "price"];
        fields.forEach(field => {
            const errElement = document.getElementById("err_client_" + field);
            if (errElement) {
                errElement.classList.add("hidden");
                errElement.innerHTML = "";
            }
        });

        // 1. Kiểm tra mã mặt bằng (Regex: XXX-XX-XX)
        const spaceIdInput = document.getElementById("spaceId");
        if (spaceIdInput && !spaceIdInput.readOnly) {
            const idVal = spaceIdInput.value.trim();
            const idRegex = /^[A-Z0-9]{3}-[A-Z0-9]{2}-[A-Z0-9]{2}$/;
            if (!idRegex.test(idVal)) {
                showError("id", "Mã mặt bằng phải đúng định dạng XXX-XX-XX (Với X là số hoặc ký tự hoa)!");
                isValid = false;
            }
        }

        // 2. Kiểm tra diện tích (Phải > 20 m2)
        const areaInput = document.getElementById("spaceArea");
        if (areaInput) {
            const areaVal = parseFloat(areaInput.value);
            if (isNaN(areaVal) || areaVal <= 20) {
                showError("area", "Diện tích mặt bằng phải là số lớn hơn 20 m²!");
                isValid = false;
            }
        }

        // 3. Kiểm tra chọn Tầng (1 - 15)
        const floorInput = document.getElementById("spaceFloor");
        if (floorInput) {
            const floorVal = parseInt(floorInput.value);
            if (isNaN(floorVal) || floorVal < 1 || floorVal > 15) {
                showError("floor", "Vui lòng chọn tầng phù hợp trong khoảng từ 1 đến 15!");
                isValid = false;
            }
        }

        // 4. Kiểm tra giá cho thuê (Phải > 1.000.000 VNĐ)
        const priceInput = document.getElementById("spacePrice");
        if (priceInput) {
            const priceVal = parseFloat(priceInput.value);
            if (isNaN(priceVal) || priceVal <= 1000000) {
                showError("price", "Giá cho thuê phải lớn hơn 1.000.000 VNĐ!");
                isValid = false;
            }
        }

        // Ngăn cản form submit nếu có bất kỳ trường dữ liệu nào bị vi phạm
        if (!isValid) {
            event.preventDefault();
        }
        return isValid;
    }

    // Hàm vẽ thông báo lỗi nhỏ dưới input tương ứng
    function showError(fieldId, message) {
        const errElement = document.getElementById("err_client_" + fieldId);
        if (errElement) {
            errElement.innerHTML = '<i class="fa-solid fa-circle-exclamation mr-1"></i> ' + message;
            errElement.classList.remove("hidden");
        }
    }
</script>
</body>
</html>