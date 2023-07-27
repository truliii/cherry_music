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
		System.out.println(KMJ + "modifyCustomerAction 로그인필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	}
	
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");
	
	//요청값이 넘어오는지 확인하기: readonly가 아닌 요청값들
	System.out.println(KMJ + request.getParameter("name") + " <--modifyCustomerAction param name" + RESET);
	System.out.println(KMJ + request.getParameter("address") + " <--modifyCustomerAction param address" + RESET);
	System.out.println(KMJ + request.getParameter("email") + " <--modifyCustomerAction param email" + RESET);
	System.out.println(KMJ + request.getParameter("birth") + " <--modifyCustomerAction param birth" + RESET);
	System.out.println(KMJ + request.getParameter("gender") + " <--modifyCustomerAction param gender" + RESET);
	
	//요청값 유효성 검사: 요청값이 null인 경우 메인화면으로 리다이렉션
	if(request.getParameter("name") == null || request.getParameter("address") == null
			|| request.getParameter("email") == null || request.getParameter("birth") == null
			|| request.getParameter("phone") == null || request.getParameter("gender") == null 
			|| request.getParameter("name").equals("") || request.getParameter("address").equals("") 
			|| request.getParameter("email").equals("")	|| request.getParameter("birth").equals("") 
			|| request.getParameter("phone").equals("") || request.getParameter("gender").equals("")){
		response.sendRedirect(request.getContextPath()+"/customer/modifyCustomer.jsp?id="+loginId);
		return;
	}
	String name = request.getParameter("name");
	String address = request.getParameter("address");
	String email = request.getParameter("email");
	String birth = request.getParameter("birth");
	String phone = request.getParameter("phone");
	String gender = request.getParameter("gender");
	System.out.println(KMJ + name + " <--modifyCustomerAction name" + RESET); 
	System.out.println(KMJ + address + " <--modifyCustomerAction address" + RESET); 
	System.out.println(KMJ + email + " <--modifyCustomerAction email" + RESET); 
	System.out.println(KMJ + birth + " <--modifyCustomerAction birth" + RESET);
	System.out.println(KMJ + phone + " <--modifyCustomerAction phone" + RESET);
	System.out.println(KMJ + gender + " <--modifyCustomerAction gender" + RESET); 
	
	//변수를 Customer타입에 저장
	Customer customer = new Customer();
	customer.setId(loginId);
	customer.setCstmName(name);
	customer.setCstmAddress(address);
	customer.setCstmEmail(email);
	customer.setCstmBirth(birth);
	customer.setCstmPhone(phone);
	customer.setCstmGender(gender);
	
	//DB에 customer저장하기 위한 객체생성
	CustomerDao cDao = new CustomerDao();
	int row = cDao.updateCustomer(customer);
	
	if(row == 1){
		System.out.println(KMJ + row + " <--modifyCustomerAction row 수정성공" + RESET);
	} else {
		System.out.println(KMJ + row + " <--modifyCustomerAction row 수정실패" + RESET);
	}
	
	//수정action 완료 후 고객정보로 리다이렉션
	response.sendRedirect(request.getContextPath()+"/customer/customerOne.jsp");
%>