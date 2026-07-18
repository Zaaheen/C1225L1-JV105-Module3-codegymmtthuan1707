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

<!-- Toast thông báo thành công (Tự động biến mất sau 4 giây) -->
<c:if test="${not empty param.success}">
    <div id="successToast" class="fixed top-5 right-5 z-50 flex items-center w-full max-w-sm p-4 text-slate-800 bg-white rounded-xl shadow-2xl border border-emerald-100 transition-all duration-500 transform translate-y-0 opacity-100" role="alert">
        <div class="inline-flex items-center justify-center flex-shrink-0 w-10 h-10 text-emerald-500 bg-emerald-50 rounded-lg">
            <i class="fa-solid fa-circle-check text-lg"></i>
        </div>
        <div class="ml-3 text-sm font-medium pr-4">
            <c:choose>
                <c:when test="${param.success == 'add'}">
                    Thêm mới mặt bằng thành công!
                </c:when>
                <c:when test="${param.success == 'update'}">
                    Cập nhật thông tin mặt bằng thành công!
                </c:when>
                <c:when test="${param.success == 'delete'}">
                    Xóa mặt bằng khỏi hệ thống thành công!
                </c:when>
                <c:otherwise>
                    Thực hiện thao tác thành công!
                </c:otherwise>
            </c:choose>
        </div>
        <button type="button" onclick="closeToast()" class="ml-auto -mx-1.5 -my-1.5 bg-white text-slate-400 hover:text-slate-900 rounded-lg focus:ring-2 focus:ring-slate-300 p-1.5 hover:bg-slate-100 inline-flex h-8 w-8 items-center justify-center" aria-label="Close">
            <i class="fa-solid fa-xmark"></i>
        </button>
    </div>

    <script>
        // Tự động tắt Toast sau 4 giây
        setTimeout(function() {
            closeToast();
        }, 4000);

        function closeToast() {
            const toast = document.getElementById("successToast");
            if (toast) {
                toast.classList.add("translate-y-[-20px]", "opacity-0");
                setTimeout(() => toast.remove(), 500);
            }
        }
    </script>
</c:if>

<!-- Hộp thoại Xác nhận Xóa tùy chỉnh (Custom Modal) -->
<div id="deleteConfirmModal" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm opacity-0 pointer-events-none transition-all duration-300" role="dialog" aria-modal="true">
    <div id="modalContainer" class="bg-white rounded-2xl max-w-md w-full shadow-2xl border border-slate-100 transform scale-95 transition-all duration-300 overflow-hidden">
        <div class="p-6">
            <div class="flex items-start space-x-4">
                <div class="flex-shrink-0 w-12 h-12 bg-rose-50 text-rose-600 rounded-xl flex items-center justify-center">
                    <i class="fa-solid fa-triangle-exclamation text-xl"></i>
                </div>
                <div class="flex-1">
                    <h3 class="text-lg font-bold text-slate-900">Xác nhận xóa mặt bằng</h3>
                    <p class="text-xs text-slate-400 mt-1 uppercase tracking-wider font-semibold">Cảnh báo hệ thống</p>
                    <p class="text-sm text-slate-600 mt-3 leading-relaxed">
                        Bạn có thực sự chắc chắn muốn loại bỏ hoàn toàn mặt bằng <span id="deleteTargetId" class="font-bold text-rose-600 bg-rose-50 px-2 py-0.5 rounded"></span> khỏi hệ thống quản lý của TComplex không?
                    </p>
                </div>
            </div>
        </div>
        <div class="bg-slate-50 px-6 py-4 flex items-center justify-end space-x-3 border-t border-slate-100">
            <button type="button" onclick="closeDeleteModal()" class="px-4 py-2.5 border border-slate-200 hover:border-slate-300 rounded-xl text-sm font-semibold text-slate-600 hover:bg-slate-100 transition-all">
                Hủy bỏ (No)
            </button>
            <a id="confirmDeleteBtn" href="#" class="px-5 py-2.5 bg-rose-600 hover:bg-rose-700 text-white rounded-xl text-sm font-semibold shadow-md hover:shadow-lg hover:shadow-rose-500/10 transition-all flex items-center space-x-2">
                <i class="fa-solid fa-trash-can text-xs"></i>
                <span>Xác nhận xóa</span>
            </a>
        </div>
    </div>
</div>

<!-- Phần đầu trang (Header) hiển thị Logo và Trạng thái -->
<header class="bg-blue-600 text-white shadow-md">
    <div class="max-w-6xl mx-auto px-4 h-16 flex items-center justify-between">
        <div class="flex items-center space-x-3">
            <i class="fa-solid fa-building-circle-check text-2xl"></i>
            <div>
                <h1 class="font-bold text-lg leading-tight">TComplex Portal</h1>
                <p class="text-xs text-blue-100">Quản lý mặt bằng cho thuê cao cấp Đà Nẵng</p>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/spaces?action=list" class="text-sm bg-blue-700 hover:bg-blue-800 px-4 py-2 rounded-lg font-semibold transition-all">
            <i class="fa-solid fa-rotate-right mr-2"></i>Tải lại danh sách
        </a>
    </div>
</header>

<!-- Container chính bọc nội dung danh sách -->
<main class="flex-grow max-w-6xl w-full mx-auto px-4 py-8">
    <div class="bg-white shadow-xl rounded-2xl border border-slate-100 overflow-hidden">

        <!-- Tiêu đề của Trang -->
        <div class="bg-gradient-to-r from-blue-600 to-indigo-600 px-6 py-5 text-white flex items-center justify-between">
            <div>
                <h2 class="text-xl font-bold">${title}</h2>
                <p class="text-xs text-blue-100 mt-1">Danh sách các mặt bằng hiện có trong hệ thống</p>
            </div>
            <i class="fa-solid fa-list-ul text-3xl opacity-30"></i>
        </div>

        <!-- Thông báo lỗi/thành công từ Server -->
        <c:if test="${not empty error}">
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative m-4" role="alert">
                <strong class="font-bold">Lỗi!</strong>
                <span class="block sm:inline">${error}</span>
            </div>
        </c:if>

        <div class="p-6 sm:p-8 space-y-6">

            <!-- Hành động thêm mới & Chỉ dẫn bộ lọc -->
            <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                <a href="${pageContext.request.contextPath}/spaces?action=create" class="inline-flex items-center justify-center px-6 py-3 bg-green-600 hover:bg-green-700 text-white rounded-xl text-sm font-semibold shadow-lg hover:shadow-xl transition-all">
                    <i class="fa-solid fa-plus mr-2"></i> Thêm mặt bằng mới
                </a>
                <span class="text-xs text-slate-500 italic"><i class="fa-solid fa-info-circle mr-1"></i>Thay đổi các tùy chọn lọc phía dưới để tìm kiếm nhanh mặt bằng</span>
            </div>

            <!-- ==================== BỘ LỌC TÌM KIẾM NÂNG CAO ==================== -->
            <div class="bg-slate-50 border border-slate-200/80 rounded-xl p-5">
                <div class="grid grid-cols-1 md:grid-cols-12 gap-4 items-end">

                    <!-- 1. Ô tìm kiếm văn bản -->
                    <div class="md:col-span-4">
                        <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">
                            Tìm kiếm từ khóa
                        </label>
                        <div class="relative">
                            <input type="text" id="searchKeyword"
                                   class="w-full pl-10 pr-4 py-2.5 text-sm border border-slate-200 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 focus:outline-none transition-all bg-white"
                                   placeholder="Nhập mã mặt bằng hoặc mô tả...">
                            <span class="absolute left-3 top-3 text-slate-400">
                                <i class="fa-solid fa-magnifying-glass text-sm"></i>
                            </span>
                        </div>
                    </div>

                    <!-- 2. Lọc theo Loại mặt bằng -->
                    <div class="md:col-span-3">
                        <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">
                            Loại mặt bằng
                        </label>
                        <select id="filterType" class="w-full px-3 py-2.5 text-sm border border-slate-200 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 focus:outline-none bg-white transition-all">
                            <option value="">-- Tất cả loại --</option>
                            <option value="Văn phòng chia sẻ">🏢 Văn phòng chia sẻ</option>
                            <option value="Văn phòng trọn gói">🏢 Văn phòng trọn gói</option>
                        </select>
                    </div>

                    <!-- 3. Lọc theo Tầng -->
                    <div class="md:col-span-2">
                        <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">
                            Tầng tòa nhà
                        </label>
                        <select id="filterFloor" class="w-full px-3 py-2.5 text-sm border border-slate-200 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 focus:outline-none bg-white transition-all">
                            <option value="">-- Tất cả tầng --</option>
                            <c:forEach var="i" begin="1" end="15">
                                <option value="${i}">Tầng ${i}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- 4. Sắp xếp Diện tích (Mới tích hợp) -->
                    <div class="md:col-span-2">
                        <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">
                            Sắp xếp diện tích
                        </label>
                        <select id="sortArea" class="w-full px-3 py-2.5 text-sm border border-slate-200 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 focus:outline-none bg-white transition-all">
                            <option value="asc">📈 Thấp đến Cao</option>
                            <option value="desc">📉 Cao đến Thấp</option>
                        </select>
                    </div>

                    <!-- 5. Nút khôi phục (Reset) -->
                    <div class="md:col-span-1">
                        <button type="button" id="btnReset" class="w-full py-2.5 bg-slate-200 hover:bg-slate-300 text-slate-700 rounded-lg text-sm font-semibold transition-all flex items-center justify-center" title="Làm mới bộ lọc">
                            <i class="fa-solid fa-arrow-rotate-left"></i>
                        </button>
                    </div>

                </div>
            </div>

            <!-- Bảng hiển thị danh sách mặt bằng -->
            <div class="border border-slate-200 rounded-xl overflow-hidden shadow-sm">
                <table id="spaceTable" class="min-w-full divide-y divide-slate-200">
                    <thead class="bg-slate-50">
                    <tr>
                        <th scope="col" class="px-6 py-3.5 text-left text-xs font-bold text-slate-500 uppercase tracking-wider">Mã MB</th>
                        <th scope="col" class="px-6 py-3.5 text-left text-xs font-bold text-slate-500 uppercase tracking-wider">Diện tích</th>
                        <th scope="col" class="px-6 py-3.5 text-left text-xs font-bold text-slate-500 uppercase tracking-wider">Trạng thái</th>
                        <th scope="col" class="px-6 py-3.5 text-left text-xs font-bold text-slate-500 uppercase tracking-wider">Tầng</th>
                        <th scope="col" class="px-6 py-3.5 text-left text-xs font-bold text-slate-500 uppercase tracking-wider">Loại</th>
                        <th scope="col" class="px-6 py-3.5 text-left text-xs font-bold text-slate-500 uppercase tracking-wider">Giá</th>
                        <th scope="col" class="px-6 py-3.5 text-center text-xs font-bold text-slate-500 uppercase tracking-wider">Hành động</th>
                    </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-slate-200">
                    <c:forEach var="space" items="${spaces}">
                        <!-- Gắn các data attributes hỗ trợ cho việc lọc & sắp xếp nhanh bằng JS -->
                        <tr class="space-row hover:bg-slate-50/50 transition-colors"
                            data-id="${space.id}"
                            data-type="${space.type}"
                            data-floor="${space.floor}"
                            data-desc="${space.description}"
                            data-area="${space.area}"
                            data-price="${space.price}">
                            <td class="px-6 py-4 whitespace-nowrap text-sm font-semibold text-blue-600">${space.id}</td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-slate-700">${space.area} m²</td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm">
                                <span class="px-2.5 py-1 text-xs font-semibold rounded-full
                                    ${space.status == 'Trống' ? 'bg-emerald-100 text-emerald-800' :
                                      space.status == 'Hạ tầng' ? 'bg-amber-100 text-amber-800' : 'bg-blue-100 text-blue-800'}">
                                        ${space.status}
                                </span>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-slate-600 font-medium">Tầng ${space.floor}</td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-slate-700">${space.type}</td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-slate-900 font-semibold">${space.price} VNĐ</td>
                            <td class="px-6 py-4 whitespace-nowrap text-center text-sm font-medium">
                                <div class="flex items-center justify-center space-x-3">
                                    <a href="${pageContext.request.contextPath}/spaces?action=edit&id=${space.id}"
                                       class="text-blue-600 hover:text-blue-800 bg-blue-50 hover:bg-blue-100 px-3 py-1.5 rounded-lg transition-all"
                                       title="Sửa thông tin">
                                        <i class="fa-solid fa-pen-to-square mr-1"></i>Sửa
                                    </a>
                                    <button type="button"
                                            onclick="openDeleteModal('${space.id}', '${pageContext.request.contextPath}/spaces?action=delete&id=${space.id}')"
                                            class="text-red-600 hover:text-red-800 bg-red-50 hover:bg-red-100 px-3 py-1.5 rounded-lg transition-all cursor-pointer"
                                            title="Xóa mặt bằng">
                                        <i class="fa-solid fa-trash mr-1"></i>Xóa
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>

                    <!-- Dòng hiển thị khi bộ lọc tìm kiếm không tìm thấy bản ghi nào khớp -->
                    <tr id="noResultsRow" class="hidden">
                        <td colspan="7" class="px-6 py-10 whitespace-nowrap text-center">
                            <div class="flex flex-col items-center justify-center text-slate-400 space-y-2">
                                <i class="fa-solid fa-cubes-stacked text-3xl"></i>
                                <p class="text-sm font-medium">Không tìm thấy mặt bằng nào phù hợp với bộ lọc!</p>
                            </div>
                        </td>
                    </tr>

                    <c:if test="${empty spaces}">
                        <tr>
                            <td colspan="7" class="px-6 py-10 whitespace-nowrap text-center">
                                <div class="flex flex-col items-center justify-center text-slate-400 space-y-2">
                                    <i class="fa-solid fa-folder-open text-3xl"></i>
                                    <p class="text-sm font-medium">Không có dữ liệu mặt bằng nào hiển thị.</p>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>

        </div>
    </div>
</main>

<!-- JavaScript xử lý Logic Tìm kiếm, Bộ lọc & Sắp xếp nhanh -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const inputKeyword = document.getElementById("searchKeyword");
        const selectType = document.getElementById("filterType");
        const selectFloor = document.getElementById("filterFloor");
        const selectSort = document.getElementById("sortArea");
        const btnReset = document.getElementById("btnReset");
        const rows = document.querySelectorAll(".space-row");
        const noResultsRow = document.getElementById("noResultsRow");

        // Hàm thực thi bộ lọc đa điều kiện tích hợp thuật toán sắp xếp DOM
        function filterSpaces() {
            const keyword = inputKeyword.value.toLowerCase().trim();
            const targetType = selectType.value;
            const targetFloor = selectFloor.value;
            const sortVal = selectSort.value;

            let visibleCount = 0;

            // Bước 1: Duyệt và áp dụng bộ lọc (Ẩn/Hiện dòng)
            rows.forEach(row => {
                const spaceId = row.getAttribute("data-id").toLowerCase();
                const spaceType = row.getAttribute("data-type");
                const spaceFloor = row.getAttribute("data-floor");
                const spaceDesc = (row.getAttribute("data-desc") || "").toLowerCase();

                // Kiểm tra Từ khóa (Mã mặt bằng hoặc Mô tả chi tiết)
                const matchesKeyword = keyword === "" ||
                    spaceId.includes(keyword) ||
                    spaceDesc.includes(keyword);

                // Kiểm tra Loại mặt bằng
                const matchesType = targetType === "" || spaceType === targetType;

                // Kiểm tra Tầng
                const matchesFloor = targetFloor === "" || spaceFloor === targetFloor;

                // Hiển thị hoặc ẩn dòng dữ liệu tùy theo kết quả các điều kiện
                if (matchesKeyword && matchesType && matchesFloor) {
                    row.classList.remove("hidden");
                    visibleCount++;
                } else {
                    row.classList.add("hidden");
                }
            });

            // Bước 2: Thực hiện sắp xếp DOM theo thuộc tính diện tích (data-area)
            const tbody = document.querySelector("#spaceTable tbody");
            const rowsArray = Array.from(rows);

            rowsArray.sort((a, b) => {
                const areaA = parseFloat(a.getAttribute("data-area") || 0);
                const areaB = parseFloat(b.getAttribute("data-area") || 0);
                return sortVal === "asc" ? areaA - areaB : areaB - areaA;
            });

            // Gắn lại các phần tử đã sắp xếp vào bảng
            rowsArray.forEach(row => tbody.appendChild(row));

            // Đảm bảo phần tử thông báo không tìm thấy kết quả luôn nằm ở cuối cùng bảng
            tbody.appendChild(noResultsRow);

            // Xử lý hiển thị thông báo trống khi không có dòng nào thỏa mãn bộ lọc
            if (rows.length > 0) {
                if (visibleCount === 0) {
                    noResultsRow.classList.remove("hidden");
                } else {
                    noResultsRow.classList.add("hidden");
                }
            }
        }

        // Đăng ký sự kiện thay đổi cho các ô lọc dữ liệu và sắp xếp
        inputKeyword.addEventListener("input", filterSpaces);
        selectType.addEventListener("change", filterSpaces);
        selectFloor.addEventListener("change", filterSpaces);
        selectSort.addEventListener("change", filterSpaces);

        // Sự kiện làm mới (Reset) toàn bộ các trường lọc & sắp xếp về trạng thái mặc định
        btnReset.addEventListener("click", function () {
            inputKeyword.value = "";
            selectType.value = "";
            selectFloor.value = "";
            selectSort.value = "asc"; // Mặc định sắp xếp từ Thấp đến Cao
            filterSpaces();
        });
    });

    // --- KHU VỰC JAVASCRIPT XỬ LÝ MODAL XÁC NHẬN XÓA TÙY CHỈNH ---
    let pendingDeleteUrl = "";

    function openDeleteModal(spaceId, deleteUrl) {
        pendingDeleteUrl = deleteUrl;
        document.getElementById("deleteTargetId").textContent = spaceId;

        const modal = document.getElementById("deleteConfirmModal");
        const container = document.getElementById("modalContainer");

        // Gỡ bỏ class ẩn và thêm hiệu ứng chuyển động mượt mà
        modal.classList.remove("opacity-0", "pointer-events-none");
        container.classList.remove("scale-95");
        container.classList.add("scale-100");
    }

    function closeDeleteModal() {
        const modal = document.getElementById("deleteConfirmModal");
        const container = document.getElementById("modalContainer");

        // Thu nhỏ container và làm mờ nền dần
        container.classList.remove("scale-100");
        container.classList.add("scale-95");
        modal.classList.add("opacity-0", "pointer-events-none");

        pendingDeleteUrl = "";
    }

    // Đăng ký hành động kích hoạt liên kết khi xác nhận xóa thực tế
    document.getElementById("confirmDeleteBtn").addEventListener("click", function (e) {
        if (pendingDeleteUrl) {
            this.href = pendingDeleteUrl;
        } else {
            e.preventDefault();
        }
    });

    // Tắt modal khi người dùng bấm phím Escape (ESC) tăng trải nghiệm sử dụng
    document.addEventListener("keydown", function (e) {
        if (e.key === "Escape") {
            closeDeleteModal();
        }
    });
</script>

</body>
</html>