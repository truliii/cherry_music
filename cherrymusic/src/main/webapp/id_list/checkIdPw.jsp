<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.IdList"%>
<%@ page import="com.google.gson.Gson"%>
<%
	String id = request.getParameter("id");
	String password = request.getParameter("password");
	
	// vo.IdList 값 저장
	IdList idList = new IdList();
	idList.setId(id);
	idList.setLastPw(password);
	
	IdListDao idListDao = new IdListDao();
	boolean result = idListDao.selectIdList(idList);
	System.out.println(result);
	out.print(result);
%>