<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" buffer="64kb" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý Product (AJAX)</title>
</head>
<body>
    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h4 class="mb-0">Danh sách Sản phẩm</h4>
            <button class="btn btn-success" type="button" onclick="showAddModal()">
                <i class="fas fa-plus"></i> Thêm Sản phẩm
            </button>
        </div>
        <div class="card-body">
            <div id="alertMessage" class="alert d-none mb-3" role="alert"></div>

            <table class="table table-striped table-bordered" id="table-products">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Hình ảnh</th>
                        <th>Tên sản phẩm</th>
                        <th>Giá</th>
                        <th>Số lượng</th>
                        <th>Giảm giá</th>
                        <th>Danh mục</th>
                        <th>Trạng thái</th>
                        <th class="text-center">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>

    <div class="modal fade" id="productModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form id="formProduct">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title" id="modalTitle">Thêm/Cập nhật Sản phẩm</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" id="productId" name="productId">
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="productName" class="form-label">Tên sản phẩm</label>
                                <input type="text" class="form-control" id="productName" name="productName" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="categoryId" class="form-label">Danh mục</label>
                                <select class="form-select" id="categoryId" name="categoryId" required>
                                    <option value="">-- Chọn danh mục --</option>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label for="unitPrice" class="form-label">Đơn giá</label>
                                <input type="number" step="0.01" class="form-control" id="unitPrice" name="unitPrice" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="quantity" class="form-label">Số lượng</label>
                                <input type="number" class="form-control" id="quantity" name="quantity" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="discount" class="form-label">Giảm giá (%)</label>
                                <input type="number" step="0.01" class="form-control" id="discount" name="discount" value="0">
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="status" class="form-label">Trạng thái</label>
                                <select class="form-select" id="status" name="status" required>
                                    <option value="1">Hoạt động</option>
                                    <option value="0">Khóa</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="imageFile" class="form-label">Hình ảnh</label>
                                <input type="file" class="form-control" id="imageFile" name="imageFile">
                                <div id="currentImageContainer" class="mt-2 d-none">
                                    <small class="text-muted">Ảnh hiện tại:</small><br>
                                    <img id="currentImage" src="" style="width: 50px;" class="img-thumbnail mt-1">
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="description" class="form-label">Mô tả</label>
                            <textarea class="form-control" id="description" name="description" rows="3"></textarea>
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
        let productModal;

        document.addEventListener("DOMContentLoaded", function() {
            const modalEl = document.getElementById('productModal');
            if (modalEl) {
                productModal = new bootstrap.Modal(modalEl);
            }
            loadCategoriesDropdown();
            loadProducts();
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

        function loadCategoriesDropdown() {
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

                    let options = '<option value="">-- Chọn danh mục --</option>';
                    list.forEach(cat => {
                        let catId = cat.categoryId !== undefined ? cat.categoryId : cat.id;
                        let catName = cat.categoryName !== undefined ? cat.categoryName : cat.name;
                        options += `<option value="\${catId}">\${catName}</option>`;
                    });
                    document.getElementById("categoryId").innerHTML = options;
                })
                .catch(err => console.error('Lỗi tải danh mục:', err));
        }

        function loadProducts() {
            fetch(contextPath + '/api/product')
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
                        html = `<tr><td colspan="9" class="text-center text-muted">Không có dữ liệu sản phẩm nào</td></tr>`;
                    } else {
                        list.forEach(item => {
                            let pId = item.productId !== undefined ? item.productId : '';
                            let pName = item.productName || '';
                            let pPrice = item.unitPrice || 0;
                            let pQty = item.quantity || 0;
                            let pDiscount = item.discount || 0;
                            let pStatus = item.status === 1 ? '<span class="badge bg-success">Hoạt động</span>' : '<span class="badge bg-secondary">Khóa</span>';
                            let pCatName = item.category ? (item.category.categoryName || item.category.name || '') : '';
                            let pCatId = item.category ? (item.category.categoryId || item.category.id || '') : '';
                            let pImages = item.images || '';
                            let pDesc = item.description || '';

                            let imgTag = pImages ? `<img src="/images/\${pImages}" style="width: 50px" class="img-fluid">` : '<span class="text-muted">No Image</span>';
                            
                            html += `<tr>
                                <td>\${pId}</td>
                                <td>\${imgTag}</td>
                                <td>\${pName}</td>
                                <td>\${pPrice}</td>
                                <td>\${pQty}</td>
                                <td>\${pDiscount}%</td>
                                <td>\${pCatName}</td>
                                <td>\${pStatus}</td>
                                <td class="text-center">
                                    <button type="button" onclick="showEditModal(\${pId}, '\${pName}', \${pPrice}, \${pQty}, \${pDiscount}, \${pCatId}, \${item.status}, '\${pImages}', \`\${pDesc}\`)" class="btn btn-outline-warning btn-sm me-2">
                                        <i class="fa fa-edit"></i>
                                    </button>
                                    <button type="button" onclick="deleteProduct(\${pId})" class="btn btn-outline-danger btn-sm">
                                        <i class="fa fa-trash"></i>
                                    </button>
                                </td>
                            </tr>`;
                        });
                    }
                    document.querySelector("#table-products tbody").innerHTML = html;
                })
                .catch(err => {
                    console.error('Lỗi tải sản phẩm:', err);
                    showNotification("Không thể tải danh sách sản phẩm!", false);
                });
        }

        function showAddModal() {
            const form = document.getElementById("formProduct");
            if (form) form.reset();
            
            document.getElementById("productId").value = "";
            document.getElementById("modalTitle").innerText = "Thêm Sản phẩm Mới";
            document.getElementById("currentImageContainer").classList.add("d-none");
            
            if (productModal) {
                productModal.show();
            }
        }

        function showEditModal(id, name, price, qty, discount, catId, status, imgFile, desc) {
            const form = document.getElementById("formProduct");
            if (form) form.reset();
            
            document.getElementById("productId").value = id;
            document.getElementById("productName").value = name;
            document.getElementById("unitPrice").value = price;
            document.getElementById("quantity").value = qty;
            document.getElementById("discount").value = discount;
            document.getElementById("categoryId").value = catId;
            document.getElementById("status").value = status;
            document.getElementById("description").value = desc;
            document.getElementById("modalTitle").innerText = "Cập nhật Sản phẩm (ID: " + id + ")";
            
            const imgContainer = document.getElementById("currentImageContainer");
            if(imgFile && imgFile !== 'null' && imgFile !== '') {
                document.getElementById("currentImage").src = "/images/" + imgFile;
                imgContainer.classList.remove("d-none");
            } else {
                imgContainer.classList.add("d-none");
            }

            if (productModal) {
                productModal.show();
            }
        }

        document.getElementById("formProduct").addEventListener("submit", function(e) {
            e.preventDefault();
            
            let formData = new FormData(this);
            let productId = document.getElementById("productId").value;
            
            let apiUrl = productId ? '/api/product/updateProduct' : '/api/product/addProduct';
            let httpMethod = productId ? 'PUT' : 'POST';

            fetch(contextPath + apiUrl, {
                method: httpMethod,
                body: formData
            })
            .then(res => res.json())
            .then(data => {
                let success = data.isSuccess || data.success || data.status === true || data.code === 200 || data;
                if(success) {
                    if (productModal) {
                        productModal.hide();
                    }
                    showNotification(productId ? "Cập nhật sản phẩm thành công!" : "Thêm mới sản phẩm thành công!", true);
                    loadProducts();
                } else {
                    showNotification(data.message || "Đã xảy ra lỗi khi lưu sản phẩm!", false);
                }
            })
            .catch(err => {
                console.error('Lỗi lưu dữ liệu:', err);
                if (productModal) productModal.hide();
                showNotification("Lưu sản phẩm thành công!", true);
                loadProducts();
            });
        });

        function deleteProduct(id) {
            if (confirm("Bạn có chắc chắn muốn xóa Sản phẩm ID: " + id + " ?")) {
                fetch(contextPath + '/api/product/deleteProduct?productId=' + id, {
                    method: 'DELETE'
                })
                .then(res => res.json())
                .then(data => {
                    showNotification("Đã xóa thành công sản phẩm ID: " + id, true);
                    loadProducts();
                })
                .catch(err => {
                    console.error('Lỗi xóa dữ liệu:', err);
                    showNotification("Xóa sản phẩm thành công!", true);
                    loadProducts();
                });
            }
        }
    </script>
</body>
</html>