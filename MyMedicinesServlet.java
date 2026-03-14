import model.Medicine;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class MyMedicinesServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.html");
            return;
        }

        List<Medicine> medicines = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/healsync_db", "root", "Admin");
            String query = "SELECT * FROM medicine_schedule WHERE user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, userId);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Medicine med = new Medicine();
                med.setId(rs.getInt("id"));
                med.setMedicineName(rs.getString("medicine_name"));
                med.setStartDate(rs.getDate("start_date").toString());
                med.setEndDate(rs.getDate("end_date").toString());
                med.setDosageCount(rs.getInt("dosage_count"));
                med.setDosageInstructions(rs.getString("dosage_instructions"));
                med.setReminderType(rs.getString("reminder_type"));
                medicines.add(med);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("medicines", medicines);
        RequestDispatcher dispatcher = request.getRequestDispatcher("my_medicines.jsp");
        dispatcher.forward(request, response);
    }
}
