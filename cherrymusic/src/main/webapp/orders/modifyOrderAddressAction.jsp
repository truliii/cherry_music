<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	String loginId = request.getParameter("loginId");
	String addressName = request.getParameter("addressName");
	System.out.println(KMJ + loginId + " <--modifyOrderAddressAction.jsp loginId" + RESET);
	System.out.println(KMJ + addressName + " <--modifyOrderAddressAction.jsp addressName" + RESET);
	
	AddressDao aDao = new AddressDao();
	Address add = new Address();
	add.setId(loginId);
	add.setAddressName(addressName);
	
	Address resultAddress = aDao.selectAddressByName(add);
	String fullAddress = resultAddress.getAddress();
	
	//자바객체 list변수를 json문자열로 변경
	Gson gson = new Gson();
	String jsonStr = gson.toJson(fullAddress);
	out.print(jsonStr);
%>