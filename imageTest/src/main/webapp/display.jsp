<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Display Images</title>
</head>
<body>
    <h1>Display Images</h1>
    <%
        String dbUrl = "jdbc:postgresql://localhost:5432/jdbc";
        String dbUser = "postgres";
        String dbPassword = "password";
        String uploadDir = "img/image_origin"; // Directory for uploaded images
        String mosaicDir = "img/image_mosaic"; // Directory for mosaic images

        try (java.sql.Connection conn = java.sql.DriverManager.getConnection(dbUrl, dbUser, dbPassword)) {
            String sql = "SELECT img FROM images";
            try (java.sql.PreparedStatement pstmt = conn.prepareStatement(sql);
                 java.sql.ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    String imagePath = rs.getString("img");
                    String imageName = imagePath.substring(imagePath.lastIndexOf('/') + 1); // Extract file name

                    // Construct paths for both original and mosaic images
                    String fullImagePath = request.getContextPath() + "/" + uploadDir + "/" + imageName;
                    String fullMosaicPath = request.getContextPath() + "/" + mosaicDir + "/" + imageName;
    %>
                    <h2>Original Image</h2>
                    <img src="<%= fullImagePath %>" alt="Original Image" style="max-width: 300px; max-height: 300px;" />
                    <h2>Mosaic Image</h2>
                    <img src="<%= fullMosaicPath %>" alt="Mosaic Image" style="max-width: 300px; max-height: 300px;" />
    <%
                }
            }
        } catch (java.sql.SQLException e) {
            out.println("Database error: " + e.getMessage());
        }
    %>
</body>
</html>
