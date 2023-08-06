<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.IdList"%>
<%@ page import="com.google.gson.Gson"%>
<%
	String categoryName = request.getParameter("categoryName");
	
	// DAO
	ProductDao productDao = new ProductDao();
	boolean result = productDao.selectCategory(categoryName);	
		
	System.out.println(result);
	out.print(result);
	
%>