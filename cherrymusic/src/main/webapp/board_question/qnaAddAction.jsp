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
	
	// 요청 값(category, boardQTitle, boardQContent) 유효성 검사
	if(request.getParameter("category") == null
		|| request.getParameter("boardQTitle") == null
		|| request.getParameter("boardQContent") == null
		|| request.getParameter("category").equals("")
		|| request.getParameter("boardQTitle").equals("")
		|| request.getParameter("boardQContent").equals("")){
		response.sendRedirect(request.getContextPath()+"/board_question/qnaAdd.jsp");
		return;
	}
	
	// 요청 값 저장
	String category = request.getParameter("category");
	String boardQTitle = request.getParameter("boardQTitle");
	String boardQContent = request.getParameter("boardQContent");
	// 디버깅코드
	System.out.println(BG_YELLOW+BLUE+category +"<--qnaAddAction.jsp category"+RESET);
	System.out.println(BG_YELLOW+BLUE+boardQContent +"<--qnaAddAction.jsp boardQContent"+RESET);
	System.out.println(BG_YELLOW+BLUE+boardQTitle +"<--qnaAddAction.jsp boardQTitle"+RESET);
	
	// vo.BoardQuestion 값 저장
	BoardQuestion boardQuestion = new BoardQuestion();
	boardQuestion.setId(loginId);
	boardQuestion.setBoardQCategory(category);
	boardQuestion.setBoardQTitle(boardQTitle);
	boardQuestion.setBoardQContent(boardQContent);
	
	// BoardQuestionDao
	BoardQuestionDao boardQuestionDao = new BoardQuestionDao();
	
	// 입력 method
	int addRow = boardQuestionDao.insertBoardQuestion(boardQuestion);
	
	// addRow 값 확인, 값에 따른 redirection 분기
	if(addRow == 0){
		System.out.println(BG_YELLOW+BLUE+addRow + "<--qnaAddAction.jsp 실패 addRow"+RESET);
		response.sendRedirect(request.getContextPath()+"/board_question/qnaAdd.jsp");
	} else if(addRow== 1){
		System.out.println(BG_YELLOW+BLUE+addRow + "<--qnaAddAction.jsp 성공 addRow"+RESET);
		response.sendRedirect(request.getContextPath()+"/board_question/qnaList.jsp");
	} else{
		System.out.println(BG_YELLOW+BLUE+addRow + "<--qnaAddAction.jsp error addRow"+RESET);
	}

%>