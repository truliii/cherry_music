<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*"%>
<%@page import="java.util.*"%>
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
	System.out.println(BG_YELLOW+BLUE+boardQNo+"<--qnaModify.jsp boardQNo"+RESET);
	
	// BoardQuestionDao
	BoardQuestionDao boardQuestionDao = new BoardQuestionDao();
	// 상세페이지 조회
	BoardQuestion boardQuestion = boardQuestionDao.selectBoardQuestionOne(boardQNo);
	
	/* 작성자 id, 현재 로그인 id 일치 검사
	 * 불일치 하면 redirection. return.
	*/ 
	if(loginId.equals(boardQuestion.getId()) == false){
		response.sendRedirect(request.getContextPath()+"/board_question/qnaList.jsp");
		return;	
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>qnaModify</title>
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
								<li aria-current="page" class="breadcrumb-item active">문의수정</li>
							</ol>
						</nav>
						</div>
						<div class="col-lg-12">
							<div class="box">
							<!-- 수정폼-->
							<div>
								<form method ="post" id="qnaModifyForm">
									<table class="table">
										<tr>
											<th>문의번호</th>
											<td>
												<input type="hidden" name="boardQNo" value="<%=boardQuestion.getBoardQNo()%>">
												<%=boardQuestion.getBoardQNo()%>
											</td>
										</tr>
										<tr>
											<th>작성자</th>
											<td><%=boardQuestion.getId()%></td>
										</tr>
										<tr>
											<th>카테고리</th>
											<td>
												<select name="category" id="category" class="form-control w-25">
													<option value="상품">상품</option>
													<option value="교환환불">교환환불</option>
													<option value="결제">결제</option>
													<option value="기타">기타</option>
												</select>
											</td>
										</tr>
										<tr>
											<th>문의제목</th>
											<td>
												<input type="text" name="boardQTitle" id="boardQTitle" class="form-control" value="<%=boardQuestion.getBoardQTitle()%>">
											</td>
										</tr>
										<tr>
											<th>문의내용</th>
											<td>
												<textarea rows="2" cols="80" name="boardQContent" id="boardQContent" class="form-control"><%=boardQuestion.getBoardQContent()%></textarea>
											</td>
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
									<div class="text-right">
										<button type="button" id="qnaModifyBtn" class="btn btn-primary">수정</button>
										<button type="button" id="cancelBtn" class="btn btn-primary">취소</button>
									</div>
								</form>
							</div>
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
	// category selected
	let qCategory = '<%=boardQuestion.getBoardQCategory()%>';
	$('select[name="category"] option').each(function() {
	  if ($(this).val() == qCategory) {
	    $(this).prop('selected', true);
	  }
	});
	
	// qnaModifyBtn click
	$('#qnaModifyBtn').on('click', function() {
		
		// 값 저장
		let category = $('#category').val();
		let boardQTitle = $('#boardQTitle').val();
		let boardQContent = $('#boardQContent').val();
		
		// 입력값이 비어있는지 확인
	    if(category.trim() == '') {
		    alert('카테고리를 선택해주세요.');
		    $('#category').focus();
		    return;
		} else if(boardQTitle.trim() == ''){
			alert('문의제목을 입력해주세요.');
			$('#boardQTitle').focus();
		    return;
		} else if(boardQContent.trim() == ''){
			alert('문의내용을 입력해주세요.');
			$('#boardQContent').focus();
		    return;
		}
		
	    let qnaModifyUrl = '<%=request.getContextPath()%>/board_question/qnaModifyAction.jsp';
	    $('#qnaModifyForm').attr('action', qnaModifyUrl);
	    $('#qnaModifyForm').submit();
	});
	
	// cancelBtn click
	$('#cancelBtn').click(function(){
		// 값 저장
		let boardQNo = '<%=boardQNo%>';
		let cancelUrl = '<%=request.getContextPath()%>/board_question/qnaDetail.jsp?boardQNo='+boardQNo;
		location.href = cancelUrl;
	});
</script>
</html>