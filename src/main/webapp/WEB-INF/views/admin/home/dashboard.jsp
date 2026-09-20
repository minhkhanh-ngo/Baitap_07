<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Bảng Điều Khiển Admin</title>
</head>
<body>
    <div class="row mb-4">
        <div class="col-12">
            <h2 class="fw-bold">Bảng Điều Khiển Quản Trị</h2>
            <p class="text-muted">Vui lòng chọn chức năng bạn muốn quản lý bên dưới.</p>
        </div>
    </div>

    <div class="row">
        <!-- Card Quản lý Category -->
        <div class="col-md-6 mb-4">
            <div class="card h-100 shadow-sm border-0">
                <div class="card-body text-center py-5">
                    <div class="display-4 text-primary mb-3">
                        <i class="fas fa-list-alt"></i>
                    </div>
                    <h4 class="card-title fw-bold">Quản lý Category</h4>
                    <p class="card-text text-muted">Thêm, sửa, xóa và theo dõi các danh mục sản phẩm của hệ thống.</p>
                    <a href="/admin/categories/ajax" class="btn btn-primary mt-3 px-4">
                        Truy cập <i class="fas fa-arrow-right ms-2"></i>
                    </a>
                </div>
            </div>
        </div>

        <!-- Card Quản lý Product -->
        <div class="col-md-6 mb-4">
            <div class="card h-100 shadow-sm border-0">
                <div class="card-body text-center py-5">
                    <div class="display-4 text-success mb-3">
                        <i class="fas fa-box-open"></i>
                    </div>
                    <h4 class="card-title fw-bold">Quản lý Product</h4>
                    <p class="card-text text-muted">Kiểm soát kho hàng, cập nhật giá và thông tin chi tiết sản phẩm.</p>
                    <a href="/admin/products/ajax" class="btn btn-success mt-3 px-4">
                        Truy cập <i class="fas fa-arrow-right ms-2"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>