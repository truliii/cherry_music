<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	/* session 유효성 검사
	* session의 값이 null이 아니면 home.jsp 페이지로 리턴
	*/
	if(session.getAttribute("loginId") != null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
%>

<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/inc/head.jsp"></jsp:include>

</head>
<body>
    <jsp:include page="/inc/header.jsp"></jsp:include>
    
    <div id="page-content" class="page-content">
        <div class="banner">
            <div class="jumbotron jumbotron-bg text-center rounded-0" style="background-image: url('<%=request.getContextPath()%>/resources/assets/img/bg-header.jpg');">
                <div class="container">
                    <h1 class="pt-5">
                        Login Page
                    </h1>
                    <p class="lead">
                        Good music for Good moment!
                    </p>

                    <div class="card card-login mb-5">
                        <div class="card-body">
                            <form id="loginForm" class="form-horizontal" action="<%=request.getContextPath()%>/id_list/loginAction.jsp">
                                <div class="form-group row mt-3">
                                    <div class="col-md-12">
                                        <input id="id" name="id" class="form-control" type="text" placeholder="Username">
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <div class="col-md-12">
                                        <input id="password" name="pw" class="form-control" type="password" placeholder="Password">
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <div class="col-md-12 d-flex justify-content-between align-items-center">
                                        <div class="checkbox">
                                            <input id="checkbox0" type="checkbox" name="remember">
                                            <label for="checkbox0" class="mb-0"> Remember Me? </label>
                                        </div>
                                        <a href="login.html" class="text-light"><i class="fa fa-bell"></i> Forgot password?</a>
                                    </div>
                                </div>
                                <div class="form-group row text-center mt-4">
                                    <div class="col-md-12">
                                        <button id="loginBtn" type="button" class="btn btn-primary btn-block text-uppercase">Log In</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <footer>
        <jsp:include page="/inc/footer.jsp"></jsp:include>
    </footer>

    <jsp:include page="/inc/script.jsp"></jsp:include>
    <script>
		// loginBtn click
		$('#loginBtn').on('click', function(){
			
			// id, password 값 저장
			let id = $('#id').val();
			let password = $('#password').val();
			
			// 입력값이 비어있는지 확인
			if(id.trim() == ''){
				alert('아이디를 입력해주세요');
				 $('#id').focus();
				return;
			} else if(password.trim() == ''){
				alert('비밀번호를 입력해주세요');
				$('#password').focus();
				return;
			}
			
			// 아이디, 비밀번호 일치 확인
			$.ajax({
				url:'<%=request.getContextPath()%>/id_list/checkIdPw.jsp',
				data: {id : $('#id').val(),
					   password : $('#password').val()},
				dataType: 'json',
				success : function(param){
					console.log(param);
					if(param === false) {
						alert('아이디, 비밀번호가 일치하지 않습니다');
						$('#id').val('');
						$('#password').val('');
						$('#id').focus();
					}
				},
				error : function(err) {
					alert('err');
					console.log(err);
					}
			});
			
			// 입력값이 있을 경우, loginAction.jsp로 이동
			let loginActionFormUrl = '<%=request.getContextPath()%>/id_list/loginAction.jsp';
			$('#loginForm').attr('action', loginActionFormUrl);
		    $('#loginForm').submit();
		});
		
	</script>
</body>
</html>
