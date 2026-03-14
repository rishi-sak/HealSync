import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            // Load MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Connect to DB
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/healsync_db", "root", "Admin");

            // Check credentials
            PreparedStatement ps = conn.prepareStatement(
                    "SELECT * FROM users WHERE email = ? AND password = ?");
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Credentials valid
                int userId = rs.getInt("id");
                String name = rs.getString("name");

                // Store in session
                HttpSession session = request.getSession();
                session.setAttribute("userId", userId);
                session.setAttribute("name", name);

                // Redirect to dashboard.jsp
                response.sendRedirect("dashboard");

            } else {
                // Invalid credentials
                response.setContentType("text/html");
                response.getWriter().println(
                        "<script>alert('Invalid email or password'); window.location='login.html';</script>");
            }

            // Close resources
            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error occurred: " + e.getMessage());
        }
    }
}
