<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.BoardQuestionDao"%>
<%@ page import="vo.BoardQuestion"%>
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
	
	/* 요청 값(boardQNo) 유효성 검사
	 * 값이 null이면 redirection. return.
	*/
	if(request.getParameter("boardQNo") == null
		|| request.getParameter("boardQNo").equals("")){
		response.sendRedirect(request.getContextPath()+"/board_question/qnaList.jsp");
		return;	
	}
	
	// 요청 값 저장
	int boardQNo = Integer.parseInt(request.getParameter("boardQNo"));
	System.out.println(BG_YELLOW+BLUE+boardQNo+"<--qnaModifyAction.jsp boardQNo"+RESET);
	
	/* 요청 값(boardQTitle, boardQContent) 유효성 검사
	 * 값이 null이면 redirection. return.
	*/
	if(request.getParameter("boardQTitle") == null
		|| request.getParameter("boardQContent") == null
		|| request.getParameter("boardQTitle").equals("")
		|| request.getParameter("boardQContent").equals("")){
		response.sendRedirect(request.getContextPath()+"/board_question/qnaModify.jsp?boardQNo="+boardQNo);
		return;	
	}
	
	// 요청 값 저장
	String category = request.getParameter("category");
	String boardQTitle = request.getParameter("boardQTitle");
	String boardQContent = request.getParameter("boardQContent");
	// 디버깅코드
	System.out.println(BG_YELLOW+BLUE+category +"<--qnaModifyAction.jsp category"+RESET);
	System.out.println(BG_YELLOW+BLUE+boardQContent +"<--qnaModifyAction.jsp boardQContent"+RESET);
	System.out.println(BG_YELLOW+BLUE+boardQTitle +"<--qnaModifyAction.jsp boardQTitle"+RESET);
	
	// vo.BoardQuestion 값 저장
	BoardQuestion boardQuestion = new BoardQuestion();
	boardQuestion.setBoardQNo(boardQNo);
	boardQuestion.setBoardQCategory(category);
	boardQuestion.setBoardQTitle(boardQTitle);
	boardQuestion.setBoardQContent(boardQContent);
	
	// BoardQuestionDao
	BoardQuestionDao boardQuestionDao = new BoardQuestionDao();
	
	// 수정 method
	int modifyRow = boardQuestionDao.updateBoardQuestion(boardQuestion);
	
	// modifyRow값 확인, 값에 따른 redirection 분기
	if(modifyRow == 0){
		System.out.println(BG_YELLOW+BLUE+modifyRow + "<--qnaModifyAction.jsp 실패 modifyRow"+RESET);
		response.sendRedirect(request.getContextPath()+"/board_question/qnaModify.jsp?boardQNo="+boardQNo);
	} else if(modifyRow == 1){
		System.out.println(BG_YELLOW+BLUE+modifyRow + "<--qnaModifyAction.jsp 성공 modifyRow"+RESET);
		response.sendRedirect(request.getContextPath()+"/board_question/qnaDetail.jsp?boardQNo="+boardQNo);
	} else{
		System.out.println(BG_YELLOW+BLUE+modifyRow + "<--qnaModifyAction.jsp error modifyRow"+RESET);
	}
%>