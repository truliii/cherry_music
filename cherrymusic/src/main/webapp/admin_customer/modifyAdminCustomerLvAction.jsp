<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	//로그인 세션 유효성 검사: 로그아웃 상태이면 로그인창으로 리다이렉션
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/id_list/login.jsp");
		System.out.println(KMJ + "modifyAdminCustomerLvAction 로그인필요" + RESET);
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
	System.out.println(request.getParameter("id") + " <--modifyAdminCustomerLvAction param id" + RESET);
	System.out.println(request.getParameter("name") + " <--modifyAdminCustomerLvAction param name" + RESET);
	System.out.println(request.getParameter("idLevel") + " <--modifyAdminCustomerLvAction param idLevel" + RESET);
	
	//요청값 유효성 검사 : 요청값이 null인 경우 회원리스트로 리다이렉션
	if(request.getParameter("id") == null 
		|| request.getParameter("idLevel") == null
		|| request.getParameter("name") == null){
		response.sendRedirect(request.getContextPath()+"/admin_customer/adminCustomerList.jsp");
		return;
	}
	String id = request.getParameter("id");
	String idLevel = request.getParameter("idLevel");
	String empName = request.getParameter("name");
	System.out.println(KMJ + id + " <--modifyAdminCustomerLvAction id" + RESET); 
	System.out.println(KMJ + idLevel + " <--modifyAdminCustomerLvAction idLevel" + RESET);
	System.out.println(KMJ + empName + " <--modifyAdminCustomerLvAction empName" + RESET);
	
	Employees employee = new Employees();
	employee.setId(id);
	employee.setEmpName(empName);
	employee.setEmpLevel(idLevel);
	
	//해당 id를 employees테이블에 추가
	EmployeesDao eDao = new EmployeesDao();
	int row = eDao.insertEmployee(employee);
	if(row == 1){
		System.out.println(KMJ + row + "modifyAdminCustomerLvAction row 사원목록에추가성공" + RESET);
	}
	
	//idList테이블 level변경
	int idRow = iDao.updateIdListIdLevel(id, Integer.parseInt(idLevel));
	
	//관리자로 등록 후 회원상세보기로 리다이렉션
	response.sendRedirect(request.getContextPath()+"/admin_customer/customerOne.jsp?id="+id);

%>