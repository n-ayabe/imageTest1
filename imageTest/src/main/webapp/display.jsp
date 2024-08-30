<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Display Images</title>
</head>
<body>
    <h1>Uploaded Images</h1>
    <%
        String dbUrl = "jdbc:postgresql://localhost:5432/jdbc";
        String dbUser = "postgres";
        String dbPassword = "password";

        try (java.sql.Connection conn = java.sql.DriverManager.getConnection(dbUrl, dbUser, dbPassword)) {
            String sql = "SELECT img FROM images";
            try (java.sql.PreparedStatement pstmt = conn.prepareStatement(sql);
                 java.sql.ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    String imagePath = rs.getString("img");
                    String fullImagePath = request.getContextPath() + "/" + imagePath;
    %>
                    <img src="<%= fullImagePath %>" alt="Image" style="max-width: 300px; max-height: 300px;" />
    <%
                }
            }
        } catch (java.sql.SQLException e) {
            out.println("Database error: " + e.getMessage());
        }
    %>
</body>
</html>
