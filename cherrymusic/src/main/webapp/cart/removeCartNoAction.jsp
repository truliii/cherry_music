<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	//요청값 잘 들어오는지 확인
	System.out.println(KMJ + request.getParameter("cartNo") + " <--modifyCartCnt param cartCnt" + RESET);
	
	//로그인 유효성 검사
	if(session.getAttribute("loginId") == null){ 
		response.sendRedirect(request.getContextPath()+"/cart/cart.jsp");
		return;
	} 
	
	//로그인이 되어있는 경우 -> db에서 삭제
	String loginId = "";
	Object o = session.getAttribute("loginId");
	if(o instanceof String){
		loginId = (String)o;
	}
	
	//요청값 유효성 검사
	if(request.getParameter("cartNo") == null){
		response.sendRedirect(request.getContextPath()+"/cart/cart.jsp");
		System.out.println("modifyCartCnt에서 리다이렉션");
		return;
	} 
	
	int cartNo = Integer.parseInt(request.getParameter("cartNo"));
	
	CartDao cDao = new CartDao();
	int row = cDao.deletecart(cartNo);
	if(row == 1){
		System.out.println(KMJ + row + " <--removeCartNo row 삭제 성공" + RESET);
	} else {
		System.out.println(KMJ + row + " <--removeCartNo row 삭제 실패" + RESET);
	}
	
	response.sendRedirect(request.getContextPath()+"/cart/cart.jsp");
%>