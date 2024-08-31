<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Upload Image</title>
</head>
<body>
    <h1>Upload Image</h1>
    
    <h2>保存したい画像を選択してください。</h2>
    <form action="UploadServlet" method="post" enctype="multipart/form-data">
        <input type="file" name="image" accept="image/*" />
        <input type="submit" value="Upload" />
    </form>

    <h2>モザイク処理したい画像を選択してください。</h2>
    <form action="MosaicServlet" method="post" enctype="multipart/form-data">
        <input type="file" name="image" accept="image/*" />
        <input type="submit" value="Mosaic" />
    </form>
    
</body>
</html>