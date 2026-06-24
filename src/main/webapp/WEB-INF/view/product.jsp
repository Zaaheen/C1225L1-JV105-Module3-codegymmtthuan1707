<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 6/24/2026
  Time: 12:55 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%-- Form nhập liệu --%>
<form action="products" method="post">
    <p>Product Description: <input type="text" name="description" value="${product.description}"></p>
    <p>List Price: <input type="text" name="listPrice" value="${product.listPrice}"></p>
    <p>Discount Percent: <input type="text" name="discountPercent" value="${product.discountPercent}"> (%)</p>
    <input type="submit" value="Calculate Discount">
</form>

<%-- Hiển thị kết quả nếu tồn tại đối tượng product trong request --%>
<% if (request.getAttribute("product") != null) { %>
<hr>
<h3>Result:</h3>
<p>Discount Amount: ${product.discountAmount}</p>
<p>Discount Price: ${product.discountPrice}</p>
<% } %>
</body>
</html>
