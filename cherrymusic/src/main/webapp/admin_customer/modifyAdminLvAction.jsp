<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	//로그인 세션 유효성 검사 : 로그아웃 상태면 로그인창으로 리다이렉션
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/id_list/login.jsp");
		System.out.println(KMJ + "modifyAdminLvAction 로그인필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	}

	//관리자가 아닌 경우 홈으로 리다이렉션
	IdListDao iDao = new IdListDao();
	IdList loginIdInfo = iDao.selectIdListOne(loginId);
	int loginLevel = loginIdInfo.getIdLevel();
	if(loginLevel == 0){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");
	
	//요청값이 넘어오는지 확인하기
	System.out.println(KMJ + request.getParameter("id") + " <--modifyAdinLvAction param id" + RESET);
	System.out.println(KMJ + request.getParameter("idLevel") + " <--modifyAdinLvAction param id" + RESET);
	
	//요청값 유효성 검사 : 요청값이 null인 경우 회원목록으로 리다이렉션
	if(request.getParameter("id") == null 
		|| request.getParameter("idLevel") == null){
		response.sendRedirect(KMJ + request.getContextPath()+"/admin_customer/adminCustomerList.jsp" + RESET);
		return;
	}
	String id = request.getParameter("id");
	int idLevel = Integer.parseInt(request.getParameter("idLevel"));
	
	System.out.println(KMJ + id + " <--modifyAdminLvAction id" + RESET); 
	System.out.println(KMJ + idLevel + " <--modifyAdminLvAction idLevel" + RESET); 
	
	//사원목록에서 삭제
	EmployeesDao eDao = new EmployeesDao();
	int row = eDao.deleteEmployee(id);
	if(row == 1){
		System.out.println(KMJ + row + "modifyAdminCustomerLvAction row 사원목록 삭제성공" + RESET);
	}
	
	//idList테이블 level변경(1->0)
	int idRow = iDao.updateIdListIdLevel(id, idLevel);
	
	//관리자->회원 변경 후 회원상세로 리다이렉션
	response.sendRedirect(request.getContextPath()+"/admin_customer/customerOne.jsp?id="+id);

%>