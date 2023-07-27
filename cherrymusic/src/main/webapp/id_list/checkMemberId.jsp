<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.IdList"%>
<%@ page import="com.google.gson.Gson"%>
<%
	String idCheck = request.getParameter("idCheck");
	IdListDao idListDao = new IdListDao();
	boolean result = idListDao.checkMemberId(idCheck);
	out.print(result);
%>