<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.BoardQuestionDao"%>
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
	System.out.println(BG_YELLOW+BLUE+boardQNo+"<--qnaRemoveAction.jsp boardQNo"+RESET);
	
	// BoardQuestionDao
	BoardQuestionDao boardQuestionDao = new BoardQuestionDao();
	
	// 삭제 method
	int removeRow = boardQuestionDao.deleteBoardQuestion(boardQNo);
	
	// removeRow 값 확인, 값에 따른 redirection 분기
	if(removeRow == 0){
		System.out.println(BG_YELLOW+BLUE+removeRow + "<--qnaRemoveAction.jsp 실패 removeRow"+RESET);
		response.sendRedirect(request.getContextPath()+"/board_question/qnaDetail.jsp?boardQNo="+boardQNo);
	} else if(removeRow ==1){
		System.out.println(BG_YELLOW+BLUE+removeRow + "<--qnaRemoveAction.jsp 성공 removeRow"+RESET);
		response.sendRedirect(request.getContextPath()+"/board_question/qnaList.jsp");
	} else{
		System.out.println(BG_YELLOW+BLUE+removeRow + "<--qnaRemoveAction.jsp error removeRow"+RESET);
	}
%>