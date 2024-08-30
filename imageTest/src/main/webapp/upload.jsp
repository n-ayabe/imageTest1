<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Upload Image</title>
</head>
<body>
    <h1>Upload Image</h1>
    <form action="UploadServlet" method="post" enctype="multipart/form-data">
        <input type="file" name="image" accept="imag/*" />
        <input type="submit" value="Upload" />
    </form>
    
</body>
</html>
