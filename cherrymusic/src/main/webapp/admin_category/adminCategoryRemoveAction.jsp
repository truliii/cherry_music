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
	
	/* session 유효성 검사
	* session 값이 null이면 redirection. return
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
	
	/* 요청값 유효성 검사(categoryName)
	 * 값이 null, ""이면 adminCategoryList.jsp 페이지로 리턴
	*/
	if(request.getParameter("categoryName") == null
		|| request.getParameter("categoryName").equals("")){
		response.sendRedirect(request.getContextPath()+"/admin_category/adminCategoryList.jsp");
		return;
	}
	// 요청 값 저장
	String categoryName = request.getParameter("categoryName");
	System.out.println(BLUE+BG_YELLOW+categoryName+"<-- adminCategoryRemoveAction.jsp categoryName"+RESET);
	
	
	// ProductDao
	ProductDao productDao = new ProductDao();
	
	/* product에서 참조하고 있는 카테고리는 삭제 할 수 없어 참조하고 있는 카테고리가 있는지 조회 후 삭제
	 * true, adminCategoryList.jsp return
	 * false, categoryDao.deleteCategory(categoryName)
	*/
	
	// 참조카테고리 조회 method
	boolean categoryCk = productDao.selectCategory(categoryName);
	
	if(categoryCk == true){
		System.out.println(BLUE+BG_YELLOW+categoryCk+"<--참조카테고리 있어 삭제 실패 categoryCk"+RESET);
		response.sendRedirect(request.getContextPath()+"/admin_category/adminCategoryList.jsp");
		return;
	} else{
		// CategoryDao
		CategoryDao categoryDao = new CategoryDao();
		// 카테고리 삭제 method
		int removeRow = categoryDao.deleteCategory(categoryName);
		
		// removeRow값 확인
		if(removeRow == 0){
			System.out.println(BLUE+BG_YELLOW+removeRow+"<--adminCategoryRemoveAction.jsp 실패 removeRow"+RESET);
		} else if(removeRow == 1){
			System.out.println(BLUE+BG_YELLOW+removeRow+"<--adminCategoryRemoveAction.jsp 성공 removeRow"+RESET);
		} else{
			System.out.println(BLUE+BG_YELLOW+removeRow+"<--adminCategoryRemoveAction.jsp error removeRow"+RESET);
		}
	}
	
	// redirection adminCategoryList.jsp
	response.sendRedirect(request.getContextPath()+"/admin_category/adminCategoryList.jsp");
%>