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
		System.out.println(KMJ + "customer/addCustomerAddressAction에서 리다이렉션" + RESET);
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
	System.out.println(KMJ + request.getParameter("addName") + " <--addCustomerAddressAction param addName" + RESET);
	System.out.println(KMJ + request.getParameter("add") + " <--addCustomerAddressAction param add" + RESET);
	System.out.println(KMJ + request.getParameter("addDefault") + " <--addCustomerAddressAction param addDefault" + RESET);
	
	//요청값 유효성 검사: 요청값이 null인 경우 메인화면으로 리다이렉션
	if(request.getParameter("addName") == null
		|| request.getParameter("zip") == null
		|| request.getParameter("add1") == null
		|| request.getParameter("add2") == null
		|| request.getParameter("add1").equals("")
		|| request.getParameter("add2").equals("")
		|| request.getParameter("addName").equals("")){
		response.sendRedirect("/customer/addCustomerAddress.jsp");
		System.out.println(KMJ + "customer/addCustomerAddressAction에서 리다이렉션" + RESET);
		return;
	}
	String addName = request.getParameter("addName");
	
	//우편번호와 추가내용은 없어도 되는 내용이므로 null이 아닌 경우에만 합쳐서 주소에 저장
	String add1 = request.getParameter("add1"); 
	String add2 = request.getParameter("add2");
	String zip = request.getParameter("zip"); 
	String add3 = "*";
	if(request.getParameter("add3") != null
	&& !request.getParameter("add3").equals("")){
		add3 = request.getParameter("add3");
	}
	String[] addArr = {zip, add1, add3, add2};
	String add = String.join("-", addArr); //DB에 저장되는 주소
	
	String addDefault = "N"; //체크박스 체크되어있으면 on,아니면 null
	if(request.getParameter("addDefault") != null){
		addDefault = "Y";
	}
	
	System.out.println(KMJ + addName + " <--addCustomerAddressAction addName" + RESET); 
	System.out.println(KMJ + add + " <--addCustomerAddressAction add" + RESET); 
	System.out.println(KMJ + addDefault + " <--addCustomerAddressAction addDefault" + RESET); 
	
	//변수를 Address타입으로 묶기
	Address address = new Address();
	address.setId(loginId);
	address.setAddressName(addName);
	address.setAddress(add);
	address.setAddressDefault(addDefault);
	
	//addDefault가 on인 경우에는(null이 아닌 경우) 주소추가하고 기존 기본주소는 기본값여부 N으로 바꾸기
	AddressDao aDao = new AddressDao();
	int insertRow = 0;
	int updateRow = 0;
	if(addDefault.equals("Y")){
		updateRow = aDao.updateAddressDefault(loginId); //기존 기본주소값 N으로 바꾸기
		insertRow = aDao.insertAddress(address); //기본주소 추가
		System.out.println(KMJ + insertRow + " <--addCustomerAddressAction inserRow 추가여부" + RESET);
		System.out.println(KMJ + updateRow + " <--addCustomerAddressAction inserRow 기본주소변경여부" + RESET);
	} else {
		insertRow = aDao.insertAddress(address); //기본주소 추가
		System.out.println(KMJ + insertRow + " <--addCustomerAddressAction inserRow 추가여부" + RESET);
	}

	//주소추가action 후 주소목록으로 리다이렉션
	response.sendRedirect(request.getContextPath() + "/customer/addCustomerAddress.jsp");
%>