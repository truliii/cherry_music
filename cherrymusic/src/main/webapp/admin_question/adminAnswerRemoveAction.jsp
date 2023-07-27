<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*"%>
<%@ page import="java.net.*"%>
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
	
	/* 요청값 유효성 검사(qNo, aNo, qCategory)
	 * 값이 null, ""이면 adminQnAList.jsp 페이지로 리턴
	*/
	if(request.getParameter("qNo") == null
		|| request.getParameter("aNo") == null
		|| request.getParameter("qCategory") == null
		|| request.getParameter("qNo").equals("")
		|| request.getParameter("aNo").equals("")
		|| request.getParameter("qCategory").equals("")){
		response.sendRedirect(request.getContextPath()+"/admin_question/adminQnAList.jsp");
		return;	
	}
	
	// 값 저장
	int qNo = Integer.parseInt(request.getParameter("qNo"));
	int aNo = Integer.parseInt(request.getParameter("aNo"));
	String qCategory = request.getParameter("qCategory");
	System.out.println(BLUE+BG_YELLOW+qNo+"<-- adminAnswerRemoveAction.jsp qNo"+RESET);
	System.out.println(BLUE+BG_YELLOW+aNo+"<-- adminAnswerRemoveAction.jsp aNo"+RESET);
	System.out.println(BLUE+BG_YELLOW+qCategory+"<-- adminAnswerRemoveAction.jsp qCategory"+RESET);
	
	// AdminQuestionDao
	AdminQuestionDao adminQuestionDao = new AdminQuestionDao();
	
	// 카테고리의 따라 사용할 dao Method 분기
	int removeRow = 0;
	if(qCategory.equals("상품")){
		removeRow = adminQuestionDao.deleteAnswer(aNo);	
	} else{
		removeRow = adminQuestionDao.deleteBoardAnswer(aNo);
	}
	
	// removeRow 값 확인
	if(removeRow == 0){
		System.out.println(BLUE+BG_YELLOW+removeRow+"<--adminAnswerRemoveAction.jsp 실패 removeRow"+RESET);
	} else if(removeRow == 1){
		System.out.println(BLUE+BG_YELLOW+removeRow+"<--adminAnswerRemoveAction.jsp 성공 removeRow"+RESET);
	} else{
		System.out.println(BLUE+BG_YELLOW+removeRow+"<--adminAnswerRemoveAction.jsp error removeRow"+RESET);
	}
	
	/* redirection adminQnADetail.jsp, qNo, qCategory 전달
	 * qCategory 인코딩
	*/
	String category = URLEncoder.encode(qCategory,"utf-8");
	response.sendRedirect(request.getContextPath()+"/admin_question/adminQnADetail.jsp?qNo="+qNo+"&qCategory="+category);
%>