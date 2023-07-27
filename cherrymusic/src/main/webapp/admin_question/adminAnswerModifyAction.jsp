<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="vo.*"%>
<%@page import="dao.*"%>
<%@page import="java.net.*"%>
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
	
	/* 요청값 유효성 검사(aNo, qNo, id, qCategory)
	 * 값이 null, ""이면 adminQnAList.jsp 페이지로 리턴
	*/
	if(request.getParameter("aNo") == null
		|| request.getParameter("qNo") == null
		|| request.getParameter("id") == null
		|| request.getParameter("qCategory") == null
		|| request.getParameter("aNo").equals("")
		|| request.getParameter("qNo").equals("")
		|| request.getParameter("id").equals("")
		|| request.getParameter("qCategory").equals("")
		){
		response.sendRedirect(request.getContextPath()+"/admin_question/adminQnAList.jsp");
		return;	
	}
	// 값 저장
	int aNo = Integer.parseInt(request.getParameter("aNo"));
	int qNo = Integer.parseInt(request.getParameter("qNo"));
	String id = request.getParameter("id");
	String qCategory = request.getParameter("qCategory");
	// 디버깅코드
	System.out.println(BLUE+BG_YELLOW+aNo+"<-- adminAnswerModifyAction.jsp aNo"+RESET);
	System.out.println(BLUE+BG_YELLOW+qNo+"<-- adminAnswerModifyAction.jsp qNo"+RESET);
	System.out.println(BLUE+BG_YELLOW+id+"<-- adminAnswerModifyAction.jsp id"+RESET);
	System.out.println(BLUE+BG_YELLOW+qCategory+"<-- adminAnswerModifyAction.jsp qCategory"+RESET);
	
	/* 요청값 유효성 검사(mdifyAContent)
	 * 값이 null, ""이면 adminQnADetail.jsp 페이지로 리턴. qNo, qCategory 전달
	 * qCategory 인코딩
	*/
	String category = URLEncoder.encode(qCategory,"utf-8");
	if(request.getParameter("modifyAContent") == null
		|| request.getParameter("modifyAContent").equals("")){
		response.sendRedirect(request.getContextPath()+"/admin_question/adminQnADetail.jsp?qNo="+qNo+"&qCategory="+category);
		return;
	}
	// 값 저장
	String aContent = request.getParameter("modifyAContent");
	System.out.println(BLUE+BG_YELLOW+aContent+"<-- adminAnswerModifyAction.jsp aContent"+RESET);
	
	// category 값의 따라 분기하여 각 dao method 호출하여 실행
	if(qCategory.equals("상품")){
		// vo.Answer 값 저장
		Answer answer = new Answer();
		answer.setaNo(aNo);
		answer.setId(id);
		answer.setaContent(aContent);
		
		// AdminQuestionDao
		AdminQuestionDao adminQuestionDao = new AdminQuestionDao();
		int modifyRow = adminQuestionDao.updateAnswer(answer);
		
		// modifyRow값 확인
		if(modifyRow == 0){
			System.out.println(BG_YELLOW+BLUE+modifyRow + "<--adminAnswerModifyAction.jsp 실패 modifyRow"+RESET);
		} else if(modifyRow == 1){
			System.out.println(BG_YELLOW+BLUE+modifyRow + "<--adminAnswerModifyAction.jsp 성공 modifyRow"+RESET);
		} else{
			System.out.println(BG_YELLOW+BLUE+modifyRow + "<--adminAnswerModifyAction.jsp error modifyRow"+RESET);
		}
	} else{
		// vo.BoardAnswer 값 저장
		BoardAnswer boardAnswer = new BoardAnswer();
		boardAnswer.setBoardANo(aNo);
		boardAnswer.setId(id);
		boardAnswer.setBoardAContent(aContent);
		
		// AdminQuestionDao updateBoardAnswer(boardAnswer) Method
		AdminQuestionDao adminQuestionDao = new AdminQuestionDao();
		int boardAnswerRow = adminQuestionDao.updateBoardAnswer(boardAnswer);
		
		// boardAnswerRow 값 확인
		if(boardAnswerRow == 0){
			System.out.println(BG_YELLOW+BLUE+boardAnswerRow+"<-- adminAnswerAction.jsp updateBoardAnswer 실패 boardAnswerRow"+RESET);
		} else if(boardAnswerRow == 1){
			System.out.println(BG_YELLOW+BLUE+boardAnswerRow+"<-- adminAnswerAction.jsp updateBoardAnswer 성공 boardAnswerRow"+RESET);
			
		} else{
			System.out.println(BG_YELLOW+BLUE+boardAnswerRow+"<-- adminAnswerAction.jsp error boardAnswerRow"+RESET);
		}
	}
	
	// redirection adminQnADetail.jsp, qNo, qCategory 전달
	response.sendRedirect(request.getContextPath()+"/admin_question/adminQnADetail.jsp?qNo="+qNo+"&qCategory="+category);
%>