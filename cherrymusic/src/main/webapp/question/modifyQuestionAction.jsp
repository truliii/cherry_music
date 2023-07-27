<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	// 디버깅 표시 코드
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	System.out.println(SJ+ "modifyQuestionAction 시작" + RE);
	
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
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");
	int qNo = Integer.parseInt(request.getParameter("qNo"));
	System.out.println(SJ + qNo +"<--modifyQuestionAction qNo" + RE);
	//요청값이 넘어오는지 확인하기: readonly가 아닌 요청값들
	System.out.println(SJ + request.getParameter("qCategory") + " <--modifyQuestionAction param qCategory" + RE);
	System.out.println(SJ + request.getParameter("qTitle") + " <--modifyQuestionAction param qTitle" + RE);
	System.out.println(SJ + request.getParameter("qContent") + " <--modifyQuestionAction param qContent" + RE);
	//요청값 유효성 검사: 요청값이 null인 경우 메인화면으로 리다이렉션
	if(request.getParameter("qCategory") == null 
			|| request.getParameter("qTitle") == null 
			|| request.getParameter("qContent") == null 
			|| request.getParameter("qCategory").equals("") 
			|| request.getParameter("qTitle").equals("")	
			|| request.getParameter("qContent").equals("")){
		response.sendRedirect(request.getContextPath()+"/question/modifyQuestion.jsp?qNo="+qNo);
		return;
	}
	String id = request.getParameter("id");
	int productNo = Integer.parseInt(request.getParameter("productNo"));
	String qCategory = request.getParameter("qCategory");
	String qTitle = request.getParameter("qTitle");
	String qContent = request.getParameter("qContent");
	System.out.println(SJ + id + " <--modifyQuestionAction id" + RE); 
	System.out.println(SJ + productNo + " <--modifyQuestionAction productNo" + RE); 
	System.out.println(SJ + qCategory + " <--modifyQuestionAction qCategory" + RE); 
	System.out.println(SJ + qTitle + " <--modifyQuestionAction qTitle" + RE);
	System.out.println(SJ + qContent + " <--modifyQuestionAction qContent" + RE);
	
	//변수를 Question 저장
	Question question = new Question();
	question.setId(id);
	question.setqCategory(qCategory);
	question.setqTitle(qTitle);
	question.setqContent(qContent);
	question.setqNo(qNo);
	
	//DB에 question 저장하기 위한 객체생성
	QuestionDao qDao = new QuestionDao();
	int row = qDao.updateQuestion(question);
	
	if(row == 1){
		System.out.println(SJ + row + " <--modifyQuestionAction row 수정성공" + RE);
	} else {
		System.out.println(SJ + row + " <--modifyQuestionAction row 수정실패" + RE);
	}
	
	//수정action 완료 후 고객정보로 리다이렉션
	response.sendRedirect(request.getContextPath()+"/question/questionDetail.jsp?qNo="+qNo);
%>