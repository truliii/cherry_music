<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>

<% 	
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	
	//request 인코딩
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
	 * IdListDao selectIdListOne(loginId) method 호출
	*/
	
	IdListDao idListDao = new IdListDao();
	IdList idList = idListDao.selectIdListOne(loginId);
	int idLevel = idList.getIdLevel();
	
	if(idLevel == 0){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;	
	}
	
	// 요청값(productNo, discountNo) 유효성 검사
	if(request.getParameter("productNo") == null
		|| request.getParameter("discountNo") == null  
		|| request.getParameter("productNo").equals("")
		|| request.getParameter("discountNo").equals("")) {
		 
		response.sendRedirect(request.getContextPath() + "/product/productList.jsp");
		return;
	}
	// 요청값 저장
	int productNo = Integer.parseInt(request.getParameter("productNo"));
	int discountNo = Integer.parseInt(request.getParameter("discountNo"));
	
	// sql 메서드들이 있는 클래스의 객체 생성
	DiscountDao dDao = new DiscountDao();
	
	// 삭제 메서드 실행
	int row = dDao.deleteDiscount(discountNo);
	
	if(row == 1){
		System.out.println(SJ + "할인율 삭제 성공" + RE);
	}
	
	response.sendRedirect(request.getContextPath() + "/product/productDetail.jsp?productNo="+productNo);
%>