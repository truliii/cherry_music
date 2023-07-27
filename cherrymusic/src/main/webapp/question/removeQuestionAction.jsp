<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>

<% 	// 관리자 상품 삭제
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
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
	// 요청값 변수에 저장
		int qNo = Integer.parseInt(request.getParameter("qNo"));
	System.out.println(SJ+ "removeQuestionAction 시작" + RE);
	// productNo 값읽기 위한 객체 생성
	QuestionDao qDao = new QuestionDao();
	Question qList = qDao.selectQuestion(qNo);
	int productNo = qList.getProductNo();
	System.out.println(SJ + productNo +"<--removeQuestionAction productNo" + RE);
	//요청값 유효성 검사
	if(request.getParameter("qNo") == null  
		|| request.getParameter("qNo").equals("")) {
		// 
		response.sendRedirect(request.getContextPath() + "/product/productDetail.jsp?p.productNo="+productNo);
		return;
	}
	
	
	// sql 메서드들이 있는 클래스의 객체 생성
	// 삭제 메서드 실행
	int row = qDao.deleteQuestion(qNo);
	
	if(row == 1){
		System.out.println(SJ + "문의 삭제 성공" + RE);
	}
	// 
	response.sendRedirect(request.getContextPath() + "/product/productDetail.jsp?p.productNo="+productNo);
%>