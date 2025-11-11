package com.qlst.servlet;

import com.qlst.dao.MemberDAO;
import com.qlst.dao.UserDAO;
import com.qlst.model.Member;
import com.qlst.util.PasswordUtil;
import org.apache.commons.lang3.StringUtils;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Handles the member registration flow (GET render, POST persist).
 */
public class RegisterServlet extends HttpServlet {

    private static final String FORM_VIEW = "/jsp/FillInformation.jsp";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        forwardToForm(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String rawPassword = StringUtils.defaultString(req.getParameter("password"));
        Member formData = extractFormData(req);
        List<String> errors = new ArrayList<>();

        req.setAttribute("formData", formData);

        validateRequiredFields(formData, rawPassword, errors);

        if (errors.isEmpty()) {
            try (UserDAO userDAO = new UserDAO()) {
                userDAO.validateUniqueness(formData.getName(), formData.getEmail(), errors);
            } catch (SQLException e) {
                throw new ServletException("Không thể kiểm tra được tính duy nhất của tên đăng nhập/email.", e);
            }
        }

        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            forwardToForm(req, resp);
            return;
        }

        Member memberToPersist = buildMemberToPersist(formData, rawPassword);

        boolean savedSuccessfully;
        try (MemberDAO memberDAO = new MemberDAO()) {
            savedSuccessfully = memberDAO.saveInformation(memberToPersist);
        } catch (SQLException e) {
            log("Unable to persist member registration", e);
            errors.add("Không thể tạo tài khoản mới. Vui lòng thử lại sau.");
            req.setAttribute("errors", errors);
            forwardToForm(req, resp);
            return;
        }

        if (!savedSuccessfully) {
            errors.add("Không thể tạo tài khoản mới. Vui lòng thử lại sau.");
            req.setAttribute("errors", errors);
            forwardToForm(req, resp);
            return;
        }

        // Forward to success page with member information
        req.setAttribute("member", memberToPersist);
        req.getRequestDispatcher("/jsp/DoSaveMember.jsp").forward(req, resp);
    }

    private Member extractFormData(HttpServletRequest req) {
        Member member = new Member();
        member.setName(StringUtils.trimToEmpty(req.getParameter("name")));
        member.setEmail(StringUtils.trimToEmpty(req.getParameter("email")));
        member.setAddress(StringUtils.trimToNull(req.getParameter("address")));
        member.setPhone(StringUtils.trimToNull(req.getParameter("phone")));
        return member;
    }

    private void validateRequiredFields(Member formData, String rawPassword, List<String> errors) {
        if (StringUtils.isBlank(formData.getName())) {
            errors.add("Họ và tên không được để trống.");
        }
        if (StringUtils.isBlank(rawPassword)) {
            errors.add("Mật khẩu không được để trống.");
        } else if (rawPassword.length() < 8) {
            errors.add("Mật khẩu phải có ít nhất 8 ký tự.");
        }
        if (StringUtils.isBlank(formData.getEmail())) {
            errors.add("Email không được để trống.");
        }
    }

    private Member buildMemberToPersist(Member formData, String rawPassword) {
        Member member = new Member();
        member.setName(formData.getName());
        member.setPassword(PasswordUtil.hashPassword(rawPassword));
        member.setEmail(formData.getEmail());
        member.setAddress(formData.getAddress());
        member.setPhone(formData.getPhone());
        return member;
    }

    private void forwardToForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher(FORM_VIEW).forward(req, resp);
    }
}
