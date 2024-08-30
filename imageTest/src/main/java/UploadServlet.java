import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/UploadServlet")
@MultipartConfig
public class UploadServlet extends HttpServlet {
	private static final String DB_URL = "jdbc:postgresql://localhost:5432/jdbc";
	private static final String DB_USER = "postgres";
	private static final String DB_PASSWORD = "password";

    private static final String UPLOAD_DIR = "imag"; // webapp フォルダ内の imag フォルダ

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Part filePart = request.getPart("image"); // Retrieves <input type="file" name="image">
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString(); // Get the original file name

        // Generate a unique file name by appending timestamp
        String uniqueFileName = generateUniqueFileName(fileName);

        // Get the absolute path of the upload directory inside webapp
        String uploadPath = getServletContext().getRealPath("/") + File.separator + UPLOAD_DIR;
        System.out.println("Upload path: " + uploadPath); // Debugging line to check path

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            boolean dirCreated = uploadDir.mkdirs(); // Create the directory if it does not exist
            System.out.println("Directory created: " + dirCreated); // Debugging line to check directory creation
        } else {
            System.out.println("Directory already exists."); // Debugging line to confirm directory exists
        }

        File file = new File(uploadPath + File.separator + uniqueFileName);
        System.out.println("File to save: " + file.getAbsolutePath()); // Debugging line to check file path

        // Save file on the server
        try (InputStream inputStream = filePart.getInputStream()) {
            Files.copy(inputStream, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
            System.out.println("File saved at: " + file.getAbsolutePath()); // Debugging line to confirm file save
        }

        // Save file path to the database
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String sql = "INSERT INTO images (img) VALUES (?)";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, UPLOAD_DIR + File.separator + uniqueFileName);
                pstmt.executeUpdate();
            }
            response.sendRedirect("display.jsp");
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    private String generateUniqueFileName(String originalFileName) {
        String timeStamp = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
        return timeStamp + "_" + originalFileName;
    }
}
