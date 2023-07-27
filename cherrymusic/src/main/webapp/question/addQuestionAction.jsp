<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>

<%
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	
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
	//요청값 유효성 검사
	if(request.getParameter("productNo") == null
		|| request.getParameter("id") == null 
		|| request.getParameter("qCategory") == null
		|| request.getParameter("qTitle") == null 
		|| request.getParameter("qContent") == null
		|| request.getParameter("productNo").equals("")
		|| request.getParameter("id").equals("")
		|| request.getParameter("qCategory").equals("")
		|| request.getParameter("qTitle").equals("")
		|| request.getParameter("qContent").equals("")){
		response.sendRedirect(request.getContextPath()+"/addQuestion.jsp");
		System.out.println(SJ +"addQuestionAction 유효성검사실패"+ RE );
		return;
	}
	int productNo = Integer.parseInt(request.getParameter("productNo"));
	String id = request.getParameter("id");
	String qCategory = request.getParameter("qCategory");
	String qTitle = request.getParameter("qTitle");
	String qContent = request.getParameter("qContent");
	
	System.out.println(SJ+id + " <-- id"+RE);
	System.out.println(SJ+qCategory + " <-- qCategory"+RE);
	System.out.println(SJ+qTitle + " <-- qTitle"+RE);
	System.out.println(SJ+qContent + " <-- qContent"+RE);
	
	//orders DB에 저장하기 위하여 Orders타입으로 묶기
	Question question = new Question();
	question.setProductNo(productNo);
	question.setId(id);
	question.setqCategory(qCategory);
	question.setqTitle(qTitle);
	question.setqContent(qContent);
	
	QuestionDao qDao = new QuestionDao();
	
	// 실행 확인
	int row = qDao.insertQuestion(question);
	
	if(row == 1){
		System.out.println(SJ+ "상품 추가 성공"+RE);
	}
	
	
	// 이미지 업로드 폼으로
	response.sendRedirect(request.getContextPath() + "/product/productDetail.jsp");
%>