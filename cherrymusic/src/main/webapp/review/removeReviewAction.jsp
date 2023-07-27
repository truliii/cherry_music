<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%@ page import="java.io.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	//로그인 유효성 검사
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/id_list/login.jsp");
		System.out.println(KMJ + "removeReviewAction 로그인 필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	}
	System.out.println(KMJ + loginId + " <--removeReviewAction loginId" + RESET);
	
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");

	//요청값 유효성 검사
	if(request.getParameter("reviewNo") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	int reviewNo = Integer.parseInt(request.getParameter("reviewNo"));
	
	//리뷰이미지 폴더에서 삭제
	ReviewDao rDao = new ReviewDao();
	String dir = request.getServletContext().getRealPath("/review/reviewImg");
	HashMap<String, Object> imgInfo = rDao.selectReviewByReviewNo(reviewNo);
	String saveFilename = (String)imgInfo.get("reviewSaveFilename");
	File f = new File(dir+"/"+saveFilename);
	if(f.exists()){
		f.delete();
		System.out.println(KMJ + "removeReviewAction 리뷰이미지 삭제" + RESET);
	}
	
	//리뷰답변이 있으면 리뷰답변 삭제
	ReviewAnswerDao rADao = new ReviewAnswerDao();
	if(rADao.selectReviewAnswerCnt(reviewNo) > 0){
		int aRow = rADao.deleteReviewAnswer(reviewNo);
		System.out.println(KMJ + "removeReviewAction 리뷰답변 삭제" + RESET);
	}
	
	//리뷰삭제
	int row = rDao.deleteReview(reviewNo);
	System.out.println(KMJ + row + " <--removeReviewAction row 리뷰삭제 결과" + RESET);
	
	//삭제완료 후 주문목록으로 리다이렉션
	response.sendRedirect(request.getContextPath()+"/customer/customerOrderList.jsp?currentPage=1");
%>