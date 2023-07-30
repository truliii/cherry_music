<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	int cartNo = Integer.parseInt(request.getParameter("cartNo"));
	int cartCnt = Integer.parseInt(request.getParameter("cartCnt"));
	System.out.println(KMJ + cartNo + " <--modifyCartCntAction.jsp cartNo" + RESET);
	System.out.println(KMJ + cartNo + " <--modifyCartCntAction.jsp cartCnt" + RESET);
	
	Cart cart = new Cart();
	cart.setCartNo(cartNo);
	cart.setCartCnt(cartCnt);
	
	CartDao cDao = new CartDao();
	int row = cDao.updateCartCnt(cart);
	
	//자바객체 list변수를 json문자열로 변경
	Gson gson = new Gson();
	String jsonStr = gson.toJson(row);
	out.print(jsonStr);
%>