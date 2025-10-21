<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách sản phẩm - QLST</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<header class="site-header">
    <div class="wrapper header-inner">
        <a class="logo" href="${pageContext.request.contextPath}/" aria-label="Trang chủ QLST">
            <span>QL</span>
            Hệ thống QLST
        </a>
        <div class="tagline">Theo dõi tồn kho và danh mục sản phẩm trong một bảng điều khiển</div>
        <nav class="main-nav" aria-label="Điều hướng chính">
            <ul>
                <li><a href="${pageContext.request.contextPath}/dashboard">Bảng điều khiển</a></li>
                <li><a href="${pageContext.request.contextPath}/products">Sản phẩm</a></li>
                <li><a href="${pageContext.request.contextPath}/warehouse">Kho hàng</a></li>
                <li><a href="${pageContext.request.contextPath}/reports">Báo cáo</a></li>
            </ul>
        </nav>
    </div>
</header>
<main>
    <div class="wrapper">
        <section class="section-card">
            <c:set var="totalProducts" value="${not empty products ? fn:length(products) : 0}" />
            <div class="section-header">
                <div>
                    <h2>Danh sách sản phẩm</h2>
                    <p>Quản lý danh mục hàng hóa, kiểm tra tồn kho và cập nhật thông tin chỉ với vài thao tác.</p>
                </div>
                <div class="status-pill">Tổng số: <strong>${totalProducts}</strong></div>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-error">${error}</div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>

            <c:choose>
                <c:when test="${not empty products}">
                    <div class="table-card">
                        <div class="table-responsive">
                            <table aria-label="Danh sách sản phẩm">
                                <thead>
                                <tr>
                                    <th scope="col">ID</th>
                                    <th scope="col">Tên sản phẩm</th>
                                    <th scope="col">SKU</th>
                                    <th scope="col">Giá</th>
                                    <th scope="col">Tồn kho</th>
                                    <th scope="col">Nhà cung cấp</th>
                                    <th scope="col">Danh mục</th>
                                    <th scope="col">Thao tác</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="product" items="${products}">
                                    <tr>
                                        <td>${product.id}</td>
                                        <td>${product.name}</td>
                                        <td>${product.sku}</td>
                                        <td>${product.unitPrice}</td>
                                        <td>${product.stockQuantity}</td>
                                        <td><c:out value="${product.supplierId}" default="-"/></td>
                                        <td><c:out value="${product.category}" default="-"/></td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/products" method="post" class="table-actions">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="${product.id}">
                                                <button type="submit" class="danger" onclick="return confirm('Bạn có chắc muốn xóa sản phẩm này?');">Xóa</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <p>Chưa có sản phẩm nào trong kho. Hãy thêm sản phẩm đầu tiên để bắt đầu quản lý.</p>
                </c:otherwise>
            </c:choose>
        </section>

        <section class="form-card" aria-labelledby="create-product">
            <h3 id="create-product">Thêm sản phẩm mới</h3>
            <p class="page-intro">Nhập thông tin sản phẩm để đồng bộ tồn kho và dữ liệu bán hàng.</p>
            <form action="${pageContext.request.contextPath}/products" method="post" class="form-grid two-column">
                <input type="hidden" name="action" value="create">
                <div>
                    <label for="name">Tên sản phẩm</label>
                    <input type="text" id="name" name="name" required>
                </div>
                <div>
                    <label for="sku">Mã SKU</label>
                    <input type="text" id="sku" name="sku" required>
                </div>
                <div class="full-width">
                    <label for="description">Mô tả</label>
                    <textarea id="description" name="description"></textarea>
                </div>
                <div>
                    <label for="unitPrice">Giá bán</label>
                    <input type="number" step="0.01" id="unitPrice" name="unitPrice" required>
                </div>
                <div>
                    <label for="stockQuantity">Số lượng tồn</label>
                    <input type="number" id="stockQuantity" name="stockQuantity" min="0" value="0">
                </div>
                <div>
                    <label for="supplierId">Mã nhà cung cấp</label>
                    <input type="number" id="supplierId" name="supplierId" min="0">
                </div>
                <div>
                    <label for="category">Danh mục</label>
                    <input type="text" id="category" name="category">
                </div>
                <div class="form-actions full-width">
                    <button type="submit" class="btn btn-primary">Thêm sản phẩm</button>
                </div>
            </form>
        </section>

        <section class="form-card" aria-labelledby="update-product">
            <h3 id="update-product">Cập nhật sản phẩm</h3>
            <p class="page-intro">Chọn ID và điều chỉnh thông tin để đảm bảo dữ liệu hàng hóa luôn chính xác.</p>
            <form action="${pageContext.request.contextPath}/products" method="post" class="form-grid two-column">
                <input type="hidden" name="action" value="update">
                <div>
                    <label for="updateId">ID sản phẩm</label>
                    <input type="number" id="updateId" name="id" min="1" required>
                </div>
                <div>
                    <label for="updateName">Tên sản phẩm</label>
                    <input type="text" id="updateName" name="name" required>
                </div>
                <div>
                    <label for="updateSku">Mã SKU</label>
                    <input type="text" id="updateSku" name="sku" required>
                </div>
                <div class="full-width">
                    <label for="updateDescription">Mô tả</label>
                    <textarea id="updateDescription" name="description"></textarea>
                </div>
                <div>
                    <label for="updateUnitPrice">Giá bán</label>
                    <input type="number" step="0.01" id="updateUnitPrice" name="unitPrice" required>
                </div>
                <div>
                    <label for="updateStock">Số lượng tồn</label>
                    <input type="number" id="updateStock" name="stockQuantity" min="0" required>
                </div>
                <div>
                    <label for="updateSupplier">Mã nhà cung cấp</label>
                    <input type="number" id="updateSupplier" name="supplierId" min="0">
                </div>
                <div>
                    <label for="updateCategory">Danh mục</label>
                    <input type="text" id="updateCategory" name="category">
                </div>
                <div class="form-actions full-width">
                    <button type="submit" class="btn btn-primary">Cập nhật sản phẩm</button>
                </div>
            </form>
        </section>
    </div>
</main>
<footer class="site-footer">
    <div class="wrapper">
        <small>&copy; 2024 QLST &mdash; Trung tâm quản lý sản phẩm cho siêu thị điện máy</small>
    </div>
</footer>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
