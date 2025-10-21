<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách sản phẩm - QLST</title>
</head>
<body>
<h2>Danh sách sản phẩm</h2>
<c:if test="${not empty error}">
    <div class="alert alert-error">${error}</div>
</c:if>
<c:if test="${not empty success}">
    <div class="alert alert-success">${success}</div>
</c:if>

<c:choose>
    <c:when test="${not empty products}">
        <table border="1" cellpadding="5" cellspacing="0">
            <thead>
            <tr>
                <th>ID</th>
                <th>Tên sản phẩm</th>
                <th>SKU</th>
                <th>Giá</th>
                <th>Tồn kho</th>
                <th>Nhà cung cấp</th>
                <th>Danh mục</th>
                <th>Thao tác</th>
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
                        <form action="${pageContext.request.contextPath}/products" method="post" style="display:inline">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="${product.id}">
                            <button type="submit" onclick="return confirm('Bạn có chắc muốn xóa sản phẩm này?');">Xóa</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:when>
    <c:otherwise>
        <p>Chưa có sản phẩm nào trong kho.</p>
    </c:otherwise>
</c:choose>

<section>
    <h3>Thêm sản phẩm mới</h3>
    <form action="${pageContext.request.contextPath}/products" method="post">
        <input type="hidden" name="action" value="create">
        <label for="name">Tên sản phẩm</label>
        <input type="text" id="name" name="name" required>

        <label for="sku">Mã SKU</label>
        <input type="text" id="sku" name="sku" required>

        <label for="description">Mô tả</label>
        <textarea id="description" name="description"></textarea>

        <label for="unitPrice">Giá bán</label>
        <input type="number" step="0.01" id="unitPrice" name="unitPrice" required>

        <label for="stockQuantity">Số lượng tồn</label>
        <input type="number" id="stockQuantity" name="stockQuantity" min="0" value="0">

        <label for="supplierId">Mã nhà cung cấp</label>
        <input type="number" id="supplierId" name="supplierId" min="0">

        <label for="category">Danh mục</label>
        <input type="text" id="category" name="category">

        <button type="submit">Thêm sản phẩm</button>
    </form>
</section>

<section>
    <h3>Cập nhật sản phẩm</h3>
    <form action="${pageContext.request.contextPath}/products" method="post">
        <input type="hidden" name="action" value="update">
        <label for="updateId">ID sản phẩm</label>
        <input type="number" id="updateId" name="id" min="1" required>

        <label for="updateName">Tên sản phẩm</label>
        <input type="text" id="updateName" name="name" required>

        <label for="updateSku">Mã SKU</label>
        <input type="text" id="updateSku" name="sku" required>

        <label for="updateDescription">Mô tả</label>
        <textarea id="updateDescription" name="description"></textarea>

        <label for="updateUnitPrice">Giá bán</label>
        <input type="number" step="0.01" id="updateUnitPrice" name="unitPrice" required>

        <label for="updateStock">Số lượng tồn</label>
        <input type="number" id="updateStock" name="stockQuantity" min="0" required>

        <label for="updateSupplier">Mã nhà cung cấp</label>
        <input type="number" id="updateSupplier" name="supplierId" min="0">

        <label for="updateCategory">Danh mục</label>
        <input type="text" id="updateCategory" name="category">

        <button type="submit">Cập nhật</button>
    </form>
</section>
</body>
</html>
