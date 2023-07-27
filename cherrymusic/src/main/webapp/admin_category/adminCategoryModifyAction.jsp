<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%@ page import="dao.*"%>
<%
	//RESET ANST CODE 콘솔창 글자색, 배경색 지정
	final String RESET = "\u001B[0m";
	final String BLUE ="\u001B[34m";
	final String BG_YELLOW ="\u001B[43m";
	
	// request 인코딩
	request.setCharacterEncoding("utf-8");
	
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
	
	/* 요청값 유효성 검사
	 * 값이 null, ""이면 adminCategoryList.jsp 페이지로 리턴
	*/
	if(request.getParameter("categoryName") == null
		|| request.getParameter("modifyCategoryName") == null
		|| request.getParameter("categoryName").equals("")
		|| request.getParameter("modifyCategoryName").equals("")){
		response.sendRedirect(request.getContextPath()+"/admin_category/adminCategoryList.jsp");
		return;
	}
	
	// 요청 값 저장
	String categoryName = request.getParameter("categoryName");
	String modifyCategoryName = request.getParameter("modifyCategoryName");
	System.out.println(BLUE+BG_YELLOW+categoryName+"<-- adminCategoryModifyAction.jsp categoryName"+RESET);
	System.out.println(BLUE+BG_YELLOW+modifyCategoryName+"<-- adminCategoryModifyAction.jsp modifyCategoryName"+RESET);
	
	// CategoryDao
	CategoryDao categoryDao = new CategoryDao();
	
	/* categoryCk값 확인, 분기
	 * true, adminCategoryList.jsp 페이지로 리턴
	 * false, categoryDao.updateCategory(categoryName, modifyCategoryName)
	*/
	
	// 카테고리 중복검사
	boolean categoryCk = categoryDao.selectCategoryOne(categoryName);
	
	// 중복되는 카테고리의 따른 분기
	if(categoryCk == true){
		System.out.println(BG_YELLOW+BLUE+categoryCk + "<--adminCategoryModifyAction.jsp categoryCk 중복카테고리"+RESET);
		response.sendRedirect(request.getContextPath()+"/admin_category/adminCategoryList.jsp");
		return;
		
	} else{
		// 카테고리명 수정
		int modifyRow = categoryDao.updateCategory(categoryName, modifyCategoryName);
		
		// modifyRow값 확인
		if(modifyRow == 0){
			System.out.println(BG_YELLOW+BLUE+modifyRow + "<--adminCategoryModifyAction.jsp 실패 modifyRow"+RESET);
		} else if(modifyRow == 1){
			System.out.println(BG_YELLOW+BLUE+modifyRow + "<--adminCategoryModifyAction.jsp 성공 modifyRow"+RESET);
		} else{
			System.out.println(BG_YELLOW+BLUE+modifyRow + "<--adminCategoryModifyAction.jsp error modifyRow"+RESET);
		}
	}
	
	// redirection adminCategoryList.jsp
	response.sendRedirect(request.getContextPath()+"/admin_category/adminCategoryList.jsp");
%>