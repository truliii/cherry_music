<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	//로그인 유효성 검사 : 로그아웃 상태면 로그인창으로 리다이렉션
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/id_list/login.jsp");
		System.out.println(KMJ + "modifyReviewAnswerAction 로그인 필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	} 
	
	//관리자가 아닌 경우 홈으로 리다이렉션
	IdListDao iDao = new IdListDao();
	IdList loginLevel = iDao.selectIdListOne(loginId);
	int idLevel = loginLevel.getIdLevel();
	if(idLevel == 0){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");
	
	//요청값이 넘어오는지 확인하기
	System.out.println(KMJ + request.getParameter("reviewNo") + " <--modifyReviewAnswerAction param reviewNo" + RESET);
	System.out.println(KMJ + request.getParameter("modAContent") + " <--modifyReviewAnswerAction param modAContent" + RESET);
	
	//요청값 유효성 검사
	if(request.getParameter("reviewNo") == null){
		response.sendRedirect(request.getContextPath()+"/admin_review/addReviewAnswer.jsp");
		return;
	} else if(request.getParameter("modAContent") == null
		|| request.getParameter("modAContent").equals("")){
		response.sendRedirect(request.getContextPath()+"/admin_review/addReviewAnswer.jsp?reviewNo="+Integer.parseInt(request.getParameter("reviewNo")));
		return;
	}
	int reviewNo = Integer.parseInt(request.getParameter("reviewNo"));
	String modAContent = request.getParameter("modAContent");	
	System.out.println(KMJ + reviewNo + " <--modifyReviewAnswerAction reviewNo" + RESET);
	
	ReviewAnswer rAnswer = new ReviewAnswer();
	rAnswer.setReviewNo(reviewNo);
	rAnswer.setReviewAContent(modAContent);
	
	//review_answer테이블 수정
	ReviewAnswerDao rDao = new ReviewAnswerDao();
	int row = rDao.updateReviewAnswer(rAnswer);
	
	if(row == 0){
		System.out.println(KMJ + row + " <--modifyReviewAnswerAction row 수정실패" + RESET);
	} else {
		System.out.println(KMJ + row + " <--modifyReviewAnswerAction row 수정성공" + RESET);
	}
	
	//리뷰수정action 완료 후 리뷰 상세로 리다이렉션
	response.sendRedirect(request.getContextPath()+"/admin_review/addReviewAnswer.jsp?reviewNo="+reviewNo);
%>
