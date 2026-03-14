import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;


public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String[] roles = request.getParameterValues("role");
        String password = request.getParameter("password");

        String role = String.join(",", roles); // Join if multiple roles selected

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/healsync_db", "root", "Admin");

            PreparedStatement ps = conn.prepareStatement("INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)");
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, role);

            int result = ps.executeUpdate();
            conn.close();

            if (result > 0) {
                response.sendRedirect("success.html");
            } else {
                response.sendRedirect("error.html");
            }

        } catch (Exception e) {
          e.printStackTrace();  // Show full error in Tomcat console
          response.setContentType("text/html");
          PrintWriter out = response.getWriter();
          out.println("<h2>Something went wrong:</h2>");
          out.println("<pre>" + e.getMessage() + "</pre>");
       }

    }
}
