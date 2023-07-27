<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*"%>
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
	
	/* 요청값 유효성 검사
	 * 값이 null, ""이면 adminQnAList.jsp 페이지로 리턴
	*/ 
	if(request.getParameter("qNo") == null
		|| request.getParameter("qCategory") == null
		|| request.getParameter("qNo").equals("")
		|| request.getParameter("qCategory").equals("")){
		response.sendRedirect(request.getContextPath()+"/admin_question/adminQnAList.jsp");
		return;
	}
	
	// 값 저장
	int qNo = Integer.parseInt(request.getParameter("qNo"));
	String qCategory = request.getParameter("qCategory");
	// 디버깅코드
	System.out.println(BG_YELLOW+BLUE+qNo+"<-- adminQnADetail.jsp qNo"+RESET);
	System.out.println(BG_YELLOW+BLUE+qCategory+"<-- adminQnADetail.jsp qCategory"+RESET);
	
	AdminQuestionDao adminQuestionDao = new AdminQuestionDao();
	
	// 카테고리의 따라 사용할 dao Method 분기
	Question question = null;
	BoardQuestion boardQuestion = null;
	ArrayList<Answer> answerList = null;
	ArrayList<BoardAnswer> boardAnswerList = null;
	
	if(qCategory.equals("상품")){
		question = adminQuestionDao.selectQuestionOne(qNo);
		answerList = adminQuestionDao.selectAnswerList(qNo);
		
	} else{
		boardQuestion = adminQuestionDao.selectBoardQuestionOne(qNo);
		boardAnswerList = adminQuestionDao.selectBoardAnswerList(qNo);
	}			
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>adminQnADetail</title>
<jsp:include page="/inc/link.jsp"></jsp:include>
</head>
<body>
	<!-- 메뉴 -->
	<jsp:include page="/inc/menu.jsp"></jsp:include>
	
	<!-- 메인 -->
	<div id="all">
		<div id="content">
			<div class="container">
				<div class="row">
					<div class="col-lg-12">
						<!-- breadcrumb -->
						<nav aria-label="breadcrumb">
							<ol class="breadcrumb">
								<li aria-current="page" class="breadcrumb-item active">관리자페이지</li>
								<li aria-current="page" class="breadcrumb-item active">문의관리</li>
								<li aria-current="page" class="breadcrumb-item active">문의상세</li>
							</ol>
						</nav>
					</div>
					<!-- 관리자메뉴 시작 -->
					<div class="col-lg-3">
						<jsp:include page="/inc/adminSideMenu.jsp"></jsp:include>
					</div>
					<!-- 관리자메뉴 끝 -->
					<div class="col-lg-9">
              			<div class="box">
						<!-- 카테고리의 따라 상세페이지 내용 분기 -->
						<%
							if(qCategory.equals("상품")){
						%>
							<!-- 문의 상세내용 -->
							<div>
								<table class="table">
									<tr>
										<th>카테고리</th>
										<td><%=question.getqCategory()%></td>
									</tr>
									<tr>
										<th>문의번호</th>
										<td><%=question.getqNo()%></td>
									</tr>
									<tr>
										<th>상품번호</th>
										<td><%=question.getProductNo()%></td>
									</tr>
									<tr>
										<th>아이디</th>
										<td><%=question.getId()%></td>
									</tr>
									<tr>
										<th>문의제목</th>
										<td><%=question.getqTitle()%></td>
									</tr>
									<tr>
										<th>문의내용</th>
										<td><%=question.getqContent()%></td>
									</tr>
									<tr>
										<th>등록일</th>
										<td><%=question.getCreatedate()%></td>
									</tr>
									<tr>
										<th>수정일</th>
										<td><%=question.getUpdatedate()%></td>
									</tr>
								</table>
							</div>
							<!-- 답변 폼 -->
							<div>
								<form method="post" id="addAnswerForm">
									<input type="hidden" name="qCategory" value="<%=question.getqCategory()%>">
									<input type="hidden" name="qNo" value ="<%=question.getqNo()%>">
									<input type="hidden" name="id" value ="<%=loginId%>">
										<table class="table">
											<tr>
												<th>답변</th>
												<td>
													<textarea rows="2" cols="80" name="addAContent" class="form-control"></textarea>
												</td>
											</tr>
										</table>
									<div class="text-right">
										<button type="button" id="addAnswerBtn" class="btn btn-primary">답변등록</button>
									</div>
								</form>
							</div>
							<br>
							<!-- 답변 출력 
							 * answerList.size() > 0, 출력
							-->
							<%
								if(answerList.size() > 0){
							%>
							<div>
								<table class="table">
									<tr>
										<th>작성자</th>
										<th>답변</th>
										<th>&nbsp;</th>
									</tr>
									<%
										int num = 0;
										String adminAnswer = "";
										
										for(Answer answer : answerList){
											num = num + 1;
											adminAnswer = "adminAnswer" +num;
									%>
										<tr>
											<td><%=answer.getId()%></td>
											<td>
												<form method="post" id="modifyAnswerForm">
													<input type="hidden" name="aNo" value ="<%=answer.getaNo()%>">
													<input type="hidden" name="qNo" value ="<%=answer.getqNo()%>">
													<input type="hidden" name="qCategory" value ="<%=qCategory%>">
													<input type="hidden" name="id" value="<%=loginId%>">
													<textarea rows="2" cols="60" name="modifyAContent" class="form-control" 
														data-answer=<%=adminAnswer%> disabled="disabled"><%=answer.getaContent()%></textarea>
												</form>
											</td>
											<td class="text-right">
												<!-- 수정, 삭제, 확인, 취소 버튼 -->
												<div class="text-right">
													<button type="button" class="modifyAnswerBtn btn btn-primary" data-answer-modify="<%=adminAnswer%>">수정</button>
													<button type="button" class="removeAnswerBtn btn btn-primary" data-answer-modify="<%=adminAnswer%>" data-remove=<%=answer.getaNo()%>>삭제</button>
													<button type="button" class="confirmAnswerBtn btn btn-primary" data-answer-confirm="<%=adminAnswer%>" style="display:none">확인</button>
													<button type="button" class="cancelAnswerBtn btn btn-primary" data-answer-cancel="<%=adminAnswer%>"style="display:none">취소</button>
												</div>
											</td>
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
		
					<%		
						} else {
					%>
						<!-- 문의 상세내용 -->
						<div>
							<table class="table">
								<tr>
									<th>카테고리</th>
									<td><%=boardQuestion.getBoardQCategory()%></td>
								</tr>
								<tr>
									<th>문의번호</th>
									<td><%=boardQuestion.getBoardQNo()%></td>
								</tr>
								<tr>
									<th>아이디</th>
									<td><%=boardQuestion.getId()%></td>
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
									<th>등록일</th>
									<td><%=boardQuestion.getCreatedate()%></td>
								</tr>
								<tr>
									<th>수정일</th>
									<td><%=boardQuestion.getUpdatedate()%></td>
								</tr>
							</table>
						</div>
						<!-- 답변입력 폼 -->
						<div>
							<form method="post" id="addBoardAnswerForm">
								<input type="hidden" name="qCategory" value="<%=boardQuestion.getBoardQCategory()%>">
								<input type="hidden" name="qNo" value ="<%=boardQuestion.getBoardQNo()%>">
								<input type="hidden" name="id" value ="<%=loginId%>">
									<table class="table">
										<tr>
											<th>답변</th>
											<td>
												<textarea rows="2" cols="80" name="addAContent" class="form-control"></textarea>
											</td>
										</tr>
									</table>
								<div class="container text-right">
									<button type="button" id="addBoardAnswerBtn" class="btn btn-primary">답변등록</button>
								</div>
							</form>
						</div>
						<br>
						
						<!-- 답변 출력 
						 * boardAnswerList.size() > 0, 출력
						-->
						<%
							if(boardAnswerList.size() > 0){
						%>
						<div>
							<table class="table">
								<tr>
									<th>작성자</th>
									<th>답변내용</th>
									<th>&nbsp;</th>
								</tr>
								<%
									int num = 0;
									String adminBoardAnswer = "";
									
									for(BoardAnswer boardAnswer : boardAnswerList){
										num = num + 1;
										adminBoardAnswer = "adminBoardAnswer" +num;
									
								%>
									<tr>
										<td><%=boardAnswer.getId()%></td>
										<td>
											<form method="post" id="modifyBoardAnswerForm">
												<input type="hidden" name="aNo" value ="<%=boardAnswer.getBoardANo()%>">
												<input type="hidden" name="qNo" value ="<%=boardAnswer.getBoardQNo()%>">
												<input type="hidden" name="qCategory" value ="<%=qCategory%>">
												<input type="hidden" name="id" value="<%=loginId%>">
												<textarea rows="2" cols="60" name="modifyAContent" class="form-control" 
													data-board-answer="<%=adminBoardAnswer%>" disabled="disabled"><%=boardAnswer.getBoardAContent()%></textarea>
												
											</form>
										</td>
										<!-- 수정, 삭제, 확인, 취소 버튼 -->
										<td class="text-right">
								            <button type="button" class="modifyBoardAnswerBtn btn btn-primary" data-board-answer-modify="<%=adminBoardAnswer%>">수정</button>
								            <button type="button" class="removeBoardAnswerBtn btn btn-primary" data-board-answer-modify="<%=adminBoardAnswer%>" data-board-remove="<%=boardAnswer.getBoardANo()%>">삭제</button>
								            <button type="button" class="confirmBoardAnswerBtn btn btn-primary" data-board-answer-confirm="<%=adminBoardAnswer%>" style="display:none">확인</button>
								            <button type="button" class="cancelBoardAnswerBtn btn btn-primary" data-board-answer-cancel="<%=adminBoardAnswer%>" style="display:none">취소</button>
								        </td>
									</tr>
								<%		
									}
								%>	
							</table>
						</div>
					<%		
						}
					}
					%>	
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
	// Answer
	// addAnswerBtn click
	$('#addAnswerBtn').click(function() {
		// textarea 요소 중 name 속성이 "addAContent"인 요소의 값 저장	   
		let addAContent = $('textarea[name="addAContent"]').val();
	    
	    // 입력값이 비어있는지 확인
	    if(addAContent.trim() == '') {
		    alert('답변을 입력해주세요.');
		    return;
		}
	    // 입력값이 있을 경우, adminAnswerAddAction.jsp로 이동
	    let addAnswerFormUrl = '<%=request.getContextPath()%>/admin_question/adminAnswerAddAction.jsp';
	    $('#addAnswerForm').attr('action', addAnswerFormUrl);
	    $('#addAnswerForm').submit();
  	});
	
	/* modifyAnswerBtn click
	 * textarea disabled, false 변경
	 * 수정 버튼 숨기기
	 * 확인, 취소 버튼 보여주기
	*/
	$('.modifyAnswerBtn').on('click', function() {
	    $(this).closest('tr').find('textarea[data-answer]').attr("disabled", false);
	    $(this).closest('tr').find('button[data-answer-modify]').hide();
	    $(this).closest('tr').find('button[data-answer-confirm]').show();
	    $(this).closest('tr').find('button[data-answer-cancel]').show();
	});
	
	// confirmAnswerBtn click
	$(document).on('click', '.confirmAnswerBtn', function(){
		
		// textarea 요소 중 name 속성이 "modifyAContent"인 요소의 값 저장
		let modifyAContent = $('textarea[name="modifyAContent"]').val();
		
		// 입력값이 비어있는지 확인
		if(modifyAContent.trim() == ''){
			alert('내용을 입력해주세요');
			return;
		}
		// 입력값이 있을 경우, adminAnswerModifyAction.jsp로 이동
		let modifyAnswerFormUrl = '<%=request.getContextPath()%>/admin_question/adminAnswerModifyAction.jsp';
		$('#modifyAnswerForm').attr('action', modifyAnswerFormUrl);
	    $('#modifyAnswerForm').submit();
	});
	
	// cancelAnswerBtn click
	$(document).on('click', '.cancelAnswerBtn', function(){
		let qNo = '<%=qNo%>';
		let qCategory = '<%=qCategory%>';
		let cancelAnswerUrl = '<%=request.getContextPath()%>/admin_question/adminQnADetail.jsp?qNo='+qNo+'&qCategory='+qCategory;
		location.href = cancelAnswerUrl;
	});
	
	// removeAnswerBtn click
	$(document).on('click', '.removeAnswerBtn', function() {
		let aNo = $(this).data('remove');
		let qNo = '<%=qNo%>';
		let qCategory = '<%=qCategory%>';
		let removeAnswerUrl = '<%=request.getContextPath()%>/admin_question/adminAnswerRemoveAction.jsp?aNo='+aNo+'&qNo='+qNo+'&qCategory='+qCategory;
		location.href = removeAnswerUrl;
	});
	
	// BoardAnswer
	// addBoardAnswerBtn click
	$('#addBoardAnswerBtn').click(function() {
		// textarea 요소 중 name 속성이 "addAContent"인 요소의 값 저장	   
		let addAContent = $('textarea[name="addAContent"]').val();
	    
	    // 입력값이 비어있는지 확인
	    if(addAContent.trim() == '') {
		    alert('답변을 입력해주세요.');
		    return;
		}
	    // 입력값이 있을 경우, adminAnswerAddAction.jsp로 이동
	    let addBoardAnswerFormUrl = '<%=request.getContextPath()%>/admin_question/adminAnswerAddAction.jsp';
	    $('#addBoardAnswerForm').attr('action', addBoardAnswerFormUrl);
	    $('#addBoardAnswerForm').submit();
  	});
	
	/* modifyBoardAnswerBtn click
	 * textarea disabled, false 변경
	 * 수정 버튼 숨기기
	 * 확인, 취소 버튼 보여주기
	*/
	$('.modifyBoardAnswerBtn').on('click', function() {
	    $(this).closest('tr').find('textarea[data-board-answer]').attr("disabled", false);
	    $(this).closest('tr').find('button[data-board-answer-modify]').hide();
	    $(this).closest('tr').find('button[data-board-answer-confirm]').show();
	    $(this).closest('tr').find('button[data-board-answer-cancel]').show();
	});
	
	// confirmBoardAnswerBtn click
	$(document).on('click', '.confirmBoardAnswerBtn', function(){
		
		// textarea 요소 중 name 속성이 "modifyAContent"인 요소의 값 저장
		let modifyAContent = $('textarea[name="modifyAContent"]').val();
		
		// 입력값이 비어있는지 확인
		if(modifyAContent.trim() == ''){
			alert('내용을 입력해주세요');
			return;
		}
		
		// 입력값이 있을 경우, adminAnswerModifyAction.jsp로 이동
		let modifyBoardAnswerFormUrl = '<%=request.getContextPath()%>/admin_question/adminAnswerModifyAction.jsp';
		$('#modifyBoardAnswerForm').attr('action', modifyBoardAnswerFormUrl);
	    $('#modifyBoardAnswerForm').submit();
	});
	
	// cancelBoardAnswerBtn click
	$(document).on('click', '.cancelBoardAnswerBtn', function(){
		let qNo = '<%=qNo%>';
		let qCategory = '<%=qCategory%>';
		let cancelBoardAnswerUrl = '<%=request.getContextPath()%>/admin_question/adminQnADetail.jsp?qNo='+qNo+'&qCategory='+qCategory;
		location.href = cancelBoardAnswerUrl;
	})
	
	// removeBoardAnswerBtn click
	$(document).on('click', '.removeBoardAnswerBtn', function() {
		let aNo = $(this).data('board-remove');
		let qNo = '<%=qNo%>';
		let qCategory = '<%=qCategory%>';
		let removeBoardAnswerUrl = '<%=request.getContextPath()%>/admin_question/adminAnswerRemoveAction.jsp?aNo='+aNo+'&qNo='+qNo+'&qCategory='+qCategory;
		location.href = removeBoardAnswerUrl;
	});
</script>

</html>