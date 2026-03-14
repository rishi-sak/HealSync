<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%
   
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("login.html");
        return;
    }

    List<Map<String, String>> doseList = (List<Map<String, String>>) request.getAttribute("doseList");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dose History | HealSync</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: #f5f7fa;
            margin: 0;
            padding: 40px 20px;
        }
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }
        .dose-container {
            max-width: 900px;
            margin: auto;
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
        }
        .dose-card {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transition: transform 0.2s;
        }
        .dose-card:hover {
            transform: translateY(-5px);
        }
        .dose-name {
            font-weight: 600;
            font-size: 1.1rem;
            margin-bottom: 8px;
        }
        .dose-info {
            font-size: 0.95rem;
            margin-bottom: 4px;
        }
        .status {
            font-weight: 600;
            padding: 4px 8px;
            border-radius: 6px;
            display: inline-block;
            color: white;
        }
        .status.taken {
            background: #2ecc71;
        }
        .status.missed {
            background: #e74c3c;
        }
        .status.skipped {
            background: #f39c12;
        }
        .back-btn {
            display: block;
            text-align: center;
            margin: 30px auto;
            width: fit-content;
            padding: 10px 20px;
            background: #0078ff;
            color: white;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
        }
        .back-btn:hover {
            background: #005fcc;
        }
        @media(max-width: 500px){
            body { padding: 20px 10px; }
            .dose-container { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <h2>Dose History</h2>

    <div class="dose-container">
        <% if (doseList != null && !doseList.isEmpty()) {
               for (Map<String, String> dose : doseList) {
                   String statusClass = dose.get("status").toLowerCase();
        %>
        <div class="dose-card">
            <div class="dose-name"><%= dose.get("name") %></div>
            <div class="dose-info"><strong>Time:</strong> <%= dose.get("time") %></div>
            <div class="dose-info">
                <strong>Status:</strong> 
                <span class="status <%= statusClass %>"><%= dose.get("status") %></span>
            </div>
            <div class="dose-info"><strong>Date:</strong> <%= dose.get("date") %></div>
        </div>
        <%   }
           } else { %>
        <div style="grid-column: 1 / -1; text-align:center; color:#666;">No dose history available.</div>
        <% } %>
    </div>

    <a href="dashboard" class="back-btn">← Back to Dashboard</a>
</body>
</html>
