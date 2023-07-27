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
		response.sendRedirect(KMJ + request.getContextPath()+"/id_list/login.jsp" + RESET);
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
	System.out.println(KMJ + request.getParameter("addNo") + " <--modifyCustomerAddressAction param addNo" + RESET);
	System.out.println(KMJ + request.getParameter("addName") + " <--modifyCustomerAddressAction param addName" + RESET);
	System.out.println(KMJ + request.getParameter("add") + " <--modifyCustomerAddressAction param add" + RESET);
	System.out.println(KMJ + request.getParameter("addDefault") + " <--modifyCustomerAddressAction param addDefault" + RESET);
	
	//요청값 유효성 검사: 요청값이 null인 경우 메인화면으로 리다이렉션
	if(request.getParameter("addName") == null
		|| request.getParameter("zip") == null
		|| request.getParameter("addNo") == null
		|| request.getParameter("add1") == null
		|| request.getParameter("add2") == null
		|| request.getParameter("addName").equals("")
		|| request.getParameter("add1").equals("")
		|| request.getParameter("add2").equals("")){
		response.sendRedirect(request.getContextPath()+"/customer/addCustomerAddress.jsp");
		System.out.println(KMJ + "customer/addCustomerAddressAction에서 리다이렉션" + RESET);
		return;
	}
	int addNo = Integer.parseInt(request.getParameter("addNo"));
	String addName = request.getParameter("addName");
	
	//우편번호와 추가내용은 없어도 되는 내용이므로 null이 아닌 경우에만 합쳐서 주소에 저장
	String zip = request.getParameter("zip");
	String add1 = request.getParameter("add1"); 
	String add2 = request.getParameter("add2");
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
	System.out.println(KMJ + addNo + " <--modifyCustomerAddressAction addNo" + RESET); 
	System.out.println(KMJ + addName + " <--modifyCustomerAddressAction addName" + RESET); 
	System.out.println(KMJ + add + " <--modifyCustomerAddressAction add" + RESET); 
	System.out.println(KMJ + addDefault + " <--modifyCustomerAddressAction addDefault" + RESET); 
	
	//변수를 Address타입으로 묶기
	Address address = new Address();
	address.setId(loginId);
	address.setAddressNo(addNo);
	address.setAddressName(addName);
	address.setAddress(add);
	address.setAddressDefault(addDefault);

	//addDefault가 on인 경우에는(null이 아닌 경우) 주소추가하고 기존 기본주소는 기본값여부 N으로 바꾸기
	AddressDao aDao = new AddressDao();
	CustomerDao cDao = new CustomerDao();
	int defaultRow = 0;
	int updateRow = 0;
	int customerRow = 0;
	if (addDefault.equals("Y")) {
		defaultRow = aDao.updateAddressDefault(loginId); //기존 기본주소값 N으로 바꾸기
		updateRow = aDao.updateAddress(address); //기본주소 추가
		customerRow = cDao.updateAddress(loginId, add); //customer테이블 주소는 기본주소로 업데이트
		System.out.println(KMJ + defaultRow + " <--modifyCustomerAddressAction inserRow 수정여부" + RESET);
		System.out.println(KMJ + updateRow + " <--modifyCustomerAddressAction inserRow 기본주소변경여부" + RESET);
	} else {
		defaultRow = aDao.updateAddress(address); //기본주소 추가
		System.out.println(KMJ + defaultRow + " <--modifyCustomerAddressAction inserRow 수정여부" + RESET);
	}

	//주소목록으로 리다이렉션
	response.sendRedirect(request.getContextPath() + "/customer/addCustomerAddress.jsp");
%>