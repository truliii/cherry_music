<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="vo.*"%>
<%@page import="dao.*"%>
<%
	//RESET ANST CODE 콘솔창 글자색, 배경색 지정
	final String RESET = "\u001B[0m";
	final String BLUE ="\u001B[34m";
	final String BG_YELLOW ="\u001B[43m";

	// request 인코딩
	request.setCharacterEncoding("utf-8");
	
	/* session 유효성 검사
	* session 값이 null이면 redirection. return.
	*/
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;	
	}
	
	// 현재 로그인 Id
	String loginId = null;
	if(session.getAttribute("loginId") != null){
		loginId = (String)session.getAttribute("loginId");
	}
	
	/* idLevel 유효성 검사
	 * idLevel == 0이면 redirection. return
	*/
	
	// IdListDao selectIdListOne(loginId) method
	IdListDao idListDao = new IdListDao();
	IdList idList = idListDao.selectIdListOne(loginId);
	int idLevel = idList.getIdLevel();
	
	if(idLevel == 0){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;	
	}
	
	/* 요청값 유효성 검사(addCategoryName)
	 * 값이 null, ""이면 adminCategoryList.jsp 페이지로 리턴
	*/
	if(request.getParameter("addCategoryName") == null
		|| request.getParameter("addCategoryName").equals("")){
		response.sendRedirect(request.getContextPath()+"/admin_category/adminCategoryList.jsp");
		return;
	}
	// 요청 값 저장
	String categoryName = request.getParameter("addCategoryName");
	System.out.println(BLUE+BG_YELLOW+categoryName+"<-- adminCategoryAddAction.jsp categoryName"+RESET);
	
	// CategoryDao
	CategoryDao categoryDao = new CategoryDao();
	
	/* categoryCk값 확인, 분기
	 * true, adminCategoryList.jsp 페이지로 리턴
	 * false, categoryDao.insertCategory(categoryName)
	*/
	
	// 카테고리 중복검사
	boolean categoryCk = categoryDao.selectCategoryOne(categoryName);
	
	if(categoryCk == true){
		System.out.println(BG_YELLOW+BLUE+categoryCk+"<-- adminCategoryAddAction.jsp categoryCk 중복카테고리"+RESET);
		response.sendRedirect(request.getContextPath()+"/admin_category/adminCategoryList.jsp");
		return;	
	} else {
		System.out.println(BG_YELLOW+BLUE+categoryCk+"<-- adminCategoryAddAction.jsp categoryCk"+RESET);
		
		// 카테고리 삽입
		int addRow = categoryDao.insertCategory(categoryName);
		
		// addRow값 확인
		if(addRow == 0){
			System.out.println(BG_YELLOW+BLUE+addRow+"<-- adminCategoryAddAction.jsp insertCategory 실패 addRow"+RESET);
		} else if(addRow == 1){
			System.out.println(BG_YELLOW+BLUE+addRow+"<-- adminCategoryAddAction.jsp insertCategory 성공 addRow"+RESET);
			
		} else{
			System.out.println(BG_YELLOW+BLUE+addRow+"<-- adminCategoryAddAction.jsp error addRow"+RESET);
		}
	} 
	
	
	
	// redirection adminCategoryList.jsp
	response.sendRedirect(request.getContextPath()+"/admin_category/adminCategoryList.jsp");
%>