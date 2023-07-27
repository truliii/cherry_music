<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="com.google.gson.Gson"%>
<%
	int boardQNo = Integer.parseInt(request.getParameter("boardQNo"));
	BoardQuestionDao boardQuestionDao = new BoardQuestionDao();
	int result = boardQuestionDao.updateBoardQuestionCheckCnt(boardQNo);
	out.print(result);
%>