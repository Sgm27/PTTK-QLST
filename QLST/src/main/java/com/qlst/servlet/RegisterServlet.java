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
    private final UserDAO userDAO = new UserDAO();

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
            validateUniqueness(formData, errors);
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
            errors.add("Khong the tao tai khoan moi. Vui long thu lai sau.");
            req.setAttribute("errors", errors);
            forwardToForm(req, resp);
            return;
        }

        if (!savedSuccessfully) {
            errors.add("Khong the tao tai khoan moi. Vui long thu lai sau.");
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
            errors.add("Ho va ten khong duoc de trong.");
        }
        if (StringUtils.isBlank(rawPassword)) {
            errors.add("Mat khau khong duoc de trong.");
        } else if (rawPassword.length() < 8) {
            errors.add("Mat khau phai co it nhat 8 ky tu.");
        }
        if (StringUtils.isBlank(formData.getEmail())) {
            errors.add("Email khong duoc de trong.");
        }
    }

    private void validateUniqueness(Member formData, List<String> errors) throws ServletException {
        try {
            if (userDAO.findByUsername(formData.getName()).isPresent()) {
                errors.add("Ten dang nhap da ton tai. Vui long chon ten khac.");
            }
            if (userDAO.findByEmail(formData.getEmail()).isPresent()) {
                errors.add("Email da duoc su dung.");
            }
        } catch (SQLException e) {
            throw new ServletException("Khong the kiem tra tinh duy nhat cua ten dang nhap/email.", e);
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
