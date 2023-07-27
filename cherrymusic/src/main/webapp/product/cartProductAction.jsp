<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
final String RE = "\u001B[0m"; 
final String SJ = "\u001B[44m";
System.out.println(SJ+ request.getParameter("productNo") + "<-- cart/addToCartAction productNo" + RE );
System.out.println(SJ+ request.getParameter("orderCnt") + "<-- cart/addToCartAction orderCnt" + RE );
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>장바구니 상품 이동</title>
</head>
<body>

</body>
</html>