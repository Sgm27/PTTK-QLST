package com.qlst.servlet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Provides reporting views for managers.
 */
public class ManagerReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // TODO: Populate statistics data from DAO layer
        req.getRequestDispatcher("/jsp/dashboard.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // TODO: Handle filtering by date range for revenue reports
        req.getRequestDispatcher("/jsp/customer_stat.jsp").forward(req, resp);
    }
}
