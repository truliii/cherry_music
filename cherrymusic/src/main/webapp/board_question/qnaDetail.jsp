<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*"%>
<%@ page import="java.util.*"%>
<%
	//RESET ANST CODE 콘솔창 글자색, 배경색 지정
	final String RESET = "\u001B[0m";
	final String BLUE ="\u001B[34m";
	final String BG_YELLOW ="\u001B[43m";

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
	
	/* 요청 값 유효성 검사
	 * 값이 null이면 redirection. return.
	*/
	if(request.getParameter("boardQNo") == null
		|| request.getParameter("boardQNo").equals("")){
		response.sendRedirect(request.getContextPath()+"/board_question/qnaList.jsp");
		return;	
	}
	
	// 요청 값 저장
	int boardQNo = Integer.parseInt(request.getParameter("boardQNo"));
	System.out.println(BG_YELLOW+BLUE+boardQNo+"<--qnaDetail.jsp boardQNo"+RESET);
	
	// BoardQuestionDao
	BoardQuestionDao boardQuestionDao = new BoardQuestionDao();
	
	// QnA 상세페이지 조회
	BoardQuestion boardQuestion = boardQuestionDao.selectBoardQuestionOne(boardQNo);
	
	// 작성자 id 저장
	String id = boardQuestion.getId();
	
	/* 작성자 id, 현재 로그인 id 일치 검사
	 * 불일치 하면 redirection. return.
	*/ 
	if(loginId.equals(id) == false){
		response.sendRedirect(request.getContextPath()+"/board_question/qnaList.jsp");
		return;	
	}
	
	// AdminQuestionDao
	AdminQuestionDao adminQuestionDao = new AdminQuestionDao();
	
	// 관리자 답변 조회
	ArrayList<BoardAnswer> boardAnswerList = adminQuestionDao.selectBoardAnswerList(boardQNo);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>qnaDetail</title>
<jsp:include page="/inc/link.jsp"></jsp:include>
</head>
<body>
	<!-- navbar -->
    <jsp:include page="/inc/menu.jsp"></jsp:include>
	<!-- 메인 -->
	<div id="all">
		<div id="content">
			<div class="container">
				<div class="row">
					<div class="col-lg-12">
						<!-- breadcrumb-->
						<nav aria-label="breadcrumb">
							<ol class="breadcrumb">
								<li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/home.jsp">홈</a></li>
								<li aria-current="page" class="breadcrumb-item active">Q&A</li>
								<li aria-current="page" class="breadcrumb-item active">상세문의</li>
							</ol>
						</nav>
						</div>
						<div class="col-lg-12">
							<div class="box">
								<div>
									<table class="table">
										<tr>
											<th>문의번호</th>
											<td><%=boardQuestion.getBoardQNo()%></td>
										</tr>
										<tr>
											<th>작성자</th>
											<td><%=boardQuestion.getId()%></td>
										</tr>
										<tr>
											<th>카테고리</th>
											<td><%=boardQuestion.getBoardQCategory()%></td>
										</tr>
										<tr>
											<th>문의제목</th>
											<td><%=boardQuestion.getBoardQTitle()%></td>
										</tr>
										<tr>
											<th>문의내용</th>
											<td><%=boardQuestion.getBoardQContent()%></td>
										</tr>
										<tr>
											<th>작성일</th>
											<td><%=boardQuestion.getCreatedate()%></td>
										</tr>
										<tr>
											<th>수정일</th>
											<td><%=boardQuestion.getUpdatedate()%></td>
										</tr>
									</table>
								</div>
								<!-- 수정, 삭제, 목록 버튼 -->
								<div class="text-right">
									<button type="button" class="btn btn-primary" id="qnaModifyBtn">수정</button>
									<button type="button" class="btn btn-primary" id="qnaRemoveBtn">삭제</button>
									<button type="button" class="btn btn-primary" id="qnaListBtn">목록</button>
								</div>
								
								<br>
								<!-- 관리자 답변 
									* 값이 있을 경우만 답변 table 보여주기
								-->
								<%
									if(boardAnswerList.size() != 0){
								%>
										<div>
											<table class="table">
												<tr>
													<th>문의 답변</th>
													<th class="text-right">작성자</th>
												</tr>
												<%
													for(BoardAnswer boardAnswer : boardAnswerList){
												%>
													<tr>
														<td><%=boardAnswer.getBoardAContent()%></td>
														<td class="text-right"><%=boardAnswer.getId()%></td>
													</tr>
												<%		
													}
												%>
											</table>	
										</div>
								<%		
									}
								%>
							</div>	    
						</div>
					</div>
				</div>
			</div>
		</div>
		
	<!-- copy -->
	<jsp:include page="/inc/copy.jsp"></jsp:include>
	<!-- 자바스크립트 -->
	<jsp:include page="/inc/script.jsp"></jsp:include>			
</body>
<script>
	
	// 값 저장
	let boardQNo = '<%=boardQNo%>';
	
	// qnaModifyBtn click
	$('#qnaModifyBtn').click(function(){
		let qnaModifyUrl = '<%=request.getContextPath()%>/board_question/qnaModify.jsp?boardQNo='+boardQNo;
		location.href = qnaModifyUrl;
	});
	
	// qnaRemoveBtn click
	$('#qnaRemoveBtn').click(function(){
		let qnaRemoveUrl = '<%=request.getContextPath()%>/board_question/qnaRemoveAction.jsp?boardQNo='+boardQNo;
		location.href = qnaRemoveUrl;
	});
	
	// qnaListBtn click
	$('#qnaListBtn').click(function(){
		let qnaListUrl = '<%=request.getContextPath()%>/board_question/qnaList.jsp';
		location.href = qnaListUrl;
	});
	
</script>

</html>