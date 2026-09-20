<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" buffer="64kb" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><sitemesh:write property='title'>Admin Panel</sitemesh:write></title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Biến toàn cục để JS Fetch gọi API -->
    <script>
        var contextPath = "${pageContext.request.contextPath}";
    </script>

    <sitemesh:write property='head'></sitemesh:write>
</head>
<body>

    <header class="row">
        <div class="col">
            <%@include file="/common/admin/header.jsp" %>
        </div>
    </header>

    <main class="container-fluid mt-4 mb-5">
        <sitemesh:write property='body'></sitemesh:write>
    </main>

    <footer class="row">
        <div class="col">
            <%@include file="/common/admin/footer.jsp" %>
        </div>
    </footer>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>