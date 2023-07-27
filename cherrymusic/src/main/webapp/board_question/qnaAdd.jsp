<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
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
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>qnaAdd</title>
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
								<li class="breadcrumb-item"><a href="#">홈</a></li>
								<li aria-current="page" class="breadcrumb-item active">QnA</li>
								<li aria-current="page" class="breadcrumb-item active">문의작성</li>
							</ol>
						</nav>
						</div>
						<div class="col-lg-12">
							<div class="box">
							<div>
								<form method="post" id="qnaAddForm">
									<table class="table">
										<tr>
											<th>작성자</th>
											<td><%=loginId%></td>
										</tr>
										<tr>
											<th>카테고리</th>
											<td>
												<select name="category" id="category" class="form-control w-25">
													<option value="">선택하세요</option>
													<option value="교환환불">교환환불</option>
													<option value="결제">결제</option>
													<option value="기타">기타</option>
												</select>
											</td>
										</tr>
										<tr>
											<th>문의제목</th>
											<td>
												<input type="text" name="boardQTitle" id="boardQTitle" class="form-control">
											</td>
										</tr>
										<tr>
											<th>문의내용</th>
											<td>
												<textarea rows="2" cols="80" name="boardQContent" id="boardQContent" class="form-control"></textarea>
											</td>
										</tr>
									</table>
									
									<div class="text-right">
										<button type="button" id="qnaAddBtn" class="btn btn-primary">등록</button>
										<button type="button" class="btn btn-primary" id="qnaListBtn">목록</button>
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
	
	// qnaAddBtn click
	$('#qnaAddBtn').on('click', function() {
		
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
		
		let qnaAddActionUrl = '<%=request.getContextPath()%>/board_question/qnaAddAction.jsp';
	    $('#qnaAddForm').attr('action', qnaAddActionUrl);
	    $('#qnaAddForm').submit();
	});
	
	// qnaListBtn click
	$('#qnaListBtn').click(function(){
		let qnaListUrl = '<%=request.getContextPath()%>/board_question/qnaList.jsp';
		location.href = qnaListUrl;
	});
</script>
</html>