<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.IdList"%>
<%@ page import="com.google.gson.Gson"%>
<%
	String categoryName = request.getParameter("categoryName");
	
	// DAO
	CategoryDao categoryDao = new CategoryDao();
	boolean result = categoryDao.selectCategoryOne(categoryName);	
    
	Gson gson = new Gson();
    String jsonResult = gson.toJson(result);  // result 값을 JSON 형식으로 변환
    
    response.setContentType("application/json");
    response.getWriter().write(jsonResult);
	
	System.out.println(result+"<--selectCategory.jsp result");
	
%>