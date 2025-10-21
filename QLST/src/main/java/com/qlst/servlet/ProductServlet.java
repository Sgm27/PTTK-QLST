package com.qlst.servlet;

import com.qlst.dao.ProductDAO;
import com.qlst.entity.Product;
import org.apache.commons.lang3.StringUtils;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

/**
 * Handles product CRUD operations for warehouse staff.
 */
public class ProductServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<Product> products = productDAO.findAll();
            req.setAttribute("products", products);
        } catch (SQLException e) {
            throw new ServletException("Không thể tải danh sách sản phẩm", e);
        }

        String success = req.getParameter("success");
        if ("created".equals(success)) {
            req.setAttribute("success", "Đã thêm sản phẩm mới thành công.");
        } else if ("updated".equals(success)) {
            req.setAttribute("success", "Đã cập nhật sản phẩm thành công.");
        } else if ("deleted".equals(success)) {
            req.setAttribute("success", "Đã xóa sản phẩm thành công.");
        }
        req.getRequestDispatcher("/jsp/product_list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        try {
            if ("create".equals(action)) {
                Product product = buildProduct(req, null);
                productDAO.save(product);
                resp.sendRedirect(req.getContextPath() + "/products?success=created");
                return;
            } else if ("update".equals(action)) {
                Long id = parseId(req.getParameter("id"));
                Product product = buildProduct(req, id);
                productDAO.update(product);
                resp.sendRedirect(req.getContextPath() + "/products?success=updated");
                return;
            } else if ("delete".equals(action)) {
                Long id = parseId(req.getParameter("id"));
                productDAO.delete(id);
                resp.sendRedirect(req.getContextPath() + "/products?success=deleted");
                return;
            } else {
                req.setAttribute("error", "Hành động không hợp lệ.");
            }
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", e.getMessage());
        } catch (SQLException e) {
            throw new ServletException("Không thể xử lý yêu cầu sản phẩm", e);
        }

        try {
            List<Product> products = productDAO.findAll();
            req.setAttribute("products", products);
        } catch (SQLException e) {
            throw new ServletException("Không thể tải danh sách sản phẩm", e);
        }
        req.getRequestDispatcher("/jsp/product_list.jsp").forward(req, resp);
    }

    private Product buildProduct(HttpServletRequest req, Long id) {
        String name = StringUtils.trimToEmpty(req.getParameter("name"));
        if (StringUtils.isBlank(name)) {
            throw new IllegalArgumentException("Tên sản phẩm không được để trống.");
        }
        String sku = StringUtils.trimToEmpty(req.getParameter("sku"));
        if (StringUtils.isBlank(sku)) {
            throw new IllegalArgumentException("Mã SKU không được để trống.");
        }

        Product product = new Product();
        product.setId(id);
        product.setName(name);
        product.setSku(sku);
        product.setDescription(StringUtils.trimToNull(req.getParameter("description")));
        product.setUnitPrice(parsePrice(req.getParameter("unitPrice")));
        product.setStockQuantity(parseQuantity(req.getParameter("stockQuantity")));
        product.setSupplierId(parseOptionalId(req.getParameter("supplierId")));
        product.setCategory(StringUtils.trimToNull(req.getParameter("category")));
        return product;
    }

    private BigDecimal parsePrice(String value) {
        String trimmed = StringUtils.trimToEmpty(value);
        if (StringUtils.isBlank(trimmed)) {
            return BigDecimal.ZERO;
        }
        try {
            return new BigDecimal(trimmed);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Giá sản phẩm không hợp lệ.");
        }
    }

    private int parseQuantity(String value) {
        String trimmed = StringUtils.trimToEmpty(value);
        if (StringUtils.isBlank(trimmed)) {
            return 0;
        }
        try {
            return Integer.parseInt(trimmed);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Số lượng tồn không hợp lệ.");
        }
    }

    private Long parseOptionalId(String value) {
        String trimmed = StringUtils.trimToEmpty(value);
        if (StringUtils.isBlank(trimmed)) {
            return null;
        }
        try {
            return Long.parseLong(trimmed);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Mã định danh không hợp lệ.");
        }
    }

    private Long parseId(String value) {
        try {
            return Long.parseLong(StringUtils.trimToEmpty(value));
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Thiếu mã sản phẩm hợp lệ.");
        }
    }
}
