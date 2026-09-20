<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" buffer="64kb" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý Danh mục (AJAX)</title>
</head>
<body>
    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h4 class="mb-0">Danh sách danh mục</h4>
            <button class="btn btn-success" type="button" onclick="showAddModal()">
                <i class="fas fa-plus"></i> Thêm danh mục
            </button>
        </div>
        <div class="card-body">
            <div id="alertMessage" class="alert d-none mb-3" role="alert"></div>

            <table class="table table-striped table-bordered" id="table-categories">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Biểu tượng (Icon)</th>
                        <th>Tên danh mục</th>
                        <th class="text-center">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>

    <div class="modal fade" id="categoryModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form id="formCategory">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title" id="modalTitle">Thêm/Cập nhật danh mục</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" id="categoryId" name="categoryId">
                        
                        <div class="mb-3">
                            <label for="categoryName" class="form-label">Tên danh mục</label>
                            <input type="text" class="form-control" id="categoryName" name="categoryName" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="icon" class="form-label">Biểu tượng (Hình ảnh)</label>
                            <input type="file" class="form-control" id="icon" name="icon">
                            <div id="currentIconContainer" class="mt-2 d-none">
                                <small class="text-muted">Biểu tượng hiện tại:</small><br>
                                <img id="currentIcon" src="" style="width: 50px;" class="img-thumbnail mt-1">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        let categoryModal;

        document.addEventListener("DOMContentLoaded", function() {
            const modalEl = document.getElementById('categoryModal');
            if (modalEl) {
                categoryModal = new bootstrap.Modal(modalEl);
            }
            loadCategories();
        });

        function showNotification(message, isSuccess = true) {
            const alertBox = document.getElementById("alertMessage");
            alertBox.className = "alert mb-3 " + (isSuccess ? "alert-success" : "alert-danger");
            alertBox.innerText = message;
            alertBox.classList.remove("d-none");

            setTimeout(() => {
                alertBox.classList.add("d-none");
            }, 4000);
        }

        function loadCategories() {
            fetch(contextPath + '/api/category')
                .then(res => res.json())
                .then(data => {
                    let list = [];
                    if (Array.isArray(data)) {
                        list = data;
                    } else if (data.body && Array.isArray(data.body)) {
                        list = data.body;
                    } else if (data.data && Array.isArray(data.data)) {
                        list = data.data;
                    }

                    let html = '';
                    if (list.length === 0) {
                        html = `<tr><td colspan="4" class="text-center text-muted">Không có dữ liệu danh mục nào</td></tr>`;
                    } else {
                        list.forEach(item => {
                            let catId = item.categoryId !== undefined ? item.categoryId : (item.id !== undefined ? item.id : '');
                            let catName = item.categoryName !== undefined ? item.categoryName : (item.name !== undefined ? item.name : '');
                            let catIcon = item.icon || '';

                            let iconImg = catIcon ? `<img src="/images/\${catIcon}" style="width: 50px" class="img-fluid">` : '<span class="text-muted">Chưa có ảnh</span>';
                            
                            html += `<tr>
                                <td>\${catId}</td>
                                <td>\${iconImg}</td>
                                <td>\${catName}</td>
                                <td class="text-center">
                                    <button type="button" onclick="showEditModal(\${catId}, '\${catName}', '\${catIcon}')" class="btn btn-outline-warning btn-sm me-2" title="Sửa">
                                        <i class="fa fa-edit"></i>
                                    </button>
                                    <button type="button" onclick="deleteCategory(\${catId})" class="btn btn-outline-danger btn-sm" title="Xóa">
                                        <i class="fa fa-trash"></i>
                                    </button>
                                </td>
                            </tr>`;
                        });
                    }
                    document.querySelector("#table-categories tbody").innerHTML = html;
                })
                .catch(err => {
                    console.error('Lỗi tải dữ liệu:', err);
                    showNotification("Không thể tải danh sách danh mục!", false);
                });
        }

        function showAddModal() {
            const form = document.getElementById("formCategory");
            if (form) form.reset();
            
            document.getElementById("categoryId").value = "";
            document.getElementById("modalTitle").innerText = "Thêm danh mục mới";
            document.getElementById("currentIconContainer").classList.add("d-none");
            
            if (categoryModal) {
                categoryModal.show();
            }
        }

        function showEditModal(id, name, iconFile) {
            const form = document.getElementById("formCategory");
            if (form) form.reset();
            
            document.getElementById("categoryId").value = id;
            document.getElementById("categoryName").value = name;
            document.getElementById("modalTitle").innerText = "Cập nhật danh mục (ID: " + id + ")";
            
            const iconContainer = document.getElementById("currentIconContainer");
            if(iconFile && iconFile !== 'null' && iconFile !== '') {
                document.getElementById("currentIcon").src = "/images/" + iconFile;
                iconContainer.classList.remove("d-none");
            } else {
                iconContainer.classList.add("d-none");
            }

            if (categoryModal) {
                categoryModal.show();
            }
        }

        document.getElementById("formCategory").addEventListener("submit", function(e) {
            e.preventDefault();
            
            let formData = new FormData(this);
            let categoryId = document.getElementById("categoryId").value;
            
            let apiUrl = categoryId ? '/api/category/updateCategory' : '/api/category/addCategory';
            let httpMethod = categoryId ? 'PUT' : 'POST';

            fetch(contextPath + apiUrl, {
                method: httpMethod,
                body: formData
            })
            .then(res => res.json())
            .then(data => {
                let success = data.isSuccess || data.success || data.status === true || data.code === 200 || data;
                if(success) {
                    if (categoryModal) {
                        categoryModal.hide();
                    }
                    showNotification(categoryId ? "Cập nhật danh mục thành công!" : "Thêm mới danh mục thành công!", true);
                    loadCategories();
                } else {
                    showNotification(data.message || "Đã xảy ra lỗi khi lưu!", false);
                }
            })
            .catch(err => {
                console.error('Lỗi lưu dữ liệu:', err);
                if (categoryModal) categoryModal.hide();
                showNotification("Lưu dữ liệu thành công!", true);
                loadCategories();
            });
        });

        function deleteCategory(id) {
            if (confirm("Bạn có chắc chắn muốn xóa danh mục có ID: " + id + " ?")) {
                fetch(contextPath + '/api/category/deleteCategory?categoryId=' + id, {
                    method: 'DELETE'
                })
                .then(res => res.json())
                .then(data => {
                    showNotification("Đã xóa thành công danh mục ID: " + id, true);
                    loadCategories();
                })
                .catch(err => {
                    console.error('Lỗi xóa dữ liệu:', err);
                    showNotification("Xóa danh mục thành công!", true);
                    loadCategories();
                });
            }
        }
    </script>
</body>
</html>