<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	/* session 유효성 검사
	* session의 값이 null이면 home.jsp 페이지로 리턴
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
<title>customerInfoRemove</title>
<jsp:include page="/inc/link.jsp"></jsp:include>
</head>
<body>
	<!-- navbar-->
    <jsp:include page="/inc/menu.jsp"></jsp:include>
    
    <div id="all">
		<div id="content">
			<div class="container">
					<div class="row">
						<div class="col-lg-12">
							<!-- breadcrumb-->
							<nav aria-label="breadcrumb">
								<ol class="breadcrumb">
									<li class="breadcrumb-item"><a href="#">홈</a></li>
									<li aria-current="page" class="breadcrumb-item active">마이페이지</li>
									<li aria-current="page" class="breadcrumb-item active">회원탈퇴</li>
								</ol>
							</nav>
						</div>
						<!-- customerInfoRemove form -->
						<div class="col-lg-6">
							<div class="box">
								<h1>회원탈퇴</h1>
								<hr>
								<form method="post" id="customerInfoRemoveForm">
									<input type="hidden" id="id" name="id" value="<%=loginId%>">
									<div class="form-group">
										<label for="password">비밀번호</label>
										<input id="password" name="password" type="password" class="form-control">
									</div>
									<div class="text-center">
										<button type="button" id="customerInfoRemoveBtn" class="btn btn-primary">회원탈퇴</button>
									</div>
								</form>
							</div>
						</div>
						<!-- img -->
						<div class="col-lg-6">
						<div class="box">
						          
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>  
    <!-- COPYRIGHT -->
    <jsp:include page="/inc/copy.jsp"></jsp:include>
    <!-- JavaScript files-->
    <jsp:include page="/inc/script.jsp"></jsp:include>
</body>
<script>
	$('#customerInfoRemoveBtn').on('click', function(){
		
		// password 값 저장
		let password = $('#password').val();
		
		// 입력값이 비어있는지 확인
		if(password.trim() == ''){
			alert('비밀번호를 입력해주세요');
			$('#password').focus();
			return;
		}
		
		// 비밀번호 일치 확인
		$.ajax({
			url:'<%=request.getContextPath()%>/id_list/checkIdPw.jsp',
			data: {id : $('#id').val(),
				   password : $('#password').val()},
			dataType: 'json',
			success : function(param){
				console.log(param);
				if(param === false) {
					alert('비밀번호가 일치하지 않습니다');
					$('#password').val('');
					$('#password').focus();
				} 
			},
			error : function(err) {
				alert('err');
				console.log(err);
				}
		});
		
		// 입력값이 있을 경우, custmoerInfoRemove.jsp로 이동
		let customerInfoRemoveActionUrl = '<%=request.getContextPath()%>/id_list/customerInfoRemoveAction.jsp';
		$('#customerInfoRemoveForm').attr('action', customerInfoRemoveActionUrl);
	    $('#customerInfoRemoveForm').submit();
	});
</script>
</html>