<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	//로그인 세션 유효성 검사: 로그아웃 상태면 로그인창으로 리다이렉션
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/id_list/login.jsp");
		System.out.println(KMJ + "removeCustomerAddressAction 로그인필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	}
	
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");
	
	//요청값이 넘어오는지 확인하기
	System.out.println(KMJ + request.getParameter("addNo") + " <--removeCustomerAddressAction param addNo" + RESET);
	
	//요청값 유효성 검사: 요청값이 null인 경우 메인화면으로 리다이렉션
	if(request.getParameter("addNo") == null){
		response.sendRedirect(request.getContextPath()+"customer/addCustomerAddress.jsp");
		return;
	}
	int addNo = Integer.parseInt(request.getParameter("addNo"));
	System.out.println(KMJ + addNo + " <--removeCustomerAddressAction addNo" + RESET); 
	
	//기본주소는 삭제 불가
	AddressDao aDao = new AddressDao();
	Address defaultAdd = aDao.selectDefaultAddress(loginId);
	if(addNo != defaultAdd.getAddressNo()){
		int row = aDao.deleteAddress(addNo);
		System.out.println(KMJ + row + " <--removeCustomerAddressAction row 삭제성공" + RESET);
	}
	
	//삭제action 완료 후 주소목록으로 리다이렉션
	response.sendRedirect(request.getContextPath()+"/customer/addCustomerAddress.jsp");
%>