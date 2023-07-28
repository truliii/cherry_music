<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	//로그인 세션 유효성 검사: 로그인이 되어있지 않거나 로그인정보가 요청id와 다를 경우 리다이렉션
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(KMJ + request.getContextPath()+"/id_list/login.jsp" + RESET);
		System.out.println(KMJ + "customerOne 로그인되어있지 않아 리다이렉션" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
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
                        비밀번호 변경
                    </h1>
                    <p class="lead">
                        최근 사용된 3개의 비밀번호는 사용할 수 없습니다.
                    </p>
                </div>
            </div>
        </div>

        <section id="checkout">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-xs-12 col-sm-6">
                        <h5 class="mb-3">비밀번호 변경</h5>
                        <!-- 비밀번호 변경폼 시작 -->
                        <form action="<%=request.getContextPath()%>/customer/modifyPasswordAction.jsp" method="post" class="bill-detail">
                            <fieldset>
                                <div class="form-group row">
                                	<div class="col-3">
                                		<label for="password_2">새로운 비밀번호</label>
                                	</div>
                                	<div class="col-9">
                                		<div class="row">
                                			<input id="password_1" name="newPw" type="password" class="form-control" required>
                               			</div>
                               			<div class="row">
                        					<span class="msg" id="pw1Msg"></span>
                                		</div>
                                	</div>
                       			</div>
                                <div class="form-group row">
                                	<div class="col-3">
                                		<label for="add-default">비밀번호 확인</label>
                                	</div>
                                	<div class="col-9">
                                		<div class="row">
	                        				<input id="password_2" name="cnfmNewPw" type="password" class="form-control" required>
                                		</div>
                                		<div class="row">
	                        				<span class="msg" id="pw2Msg"></span>
                                		</div>
                                	</div>
                                </div>
                                <div class="form-group text-right">
                                    <button type="submit" class="btn btn-primary">비밀번호 변경</button>
                                    <div class="clearfix"></div>
                                </div>
                            </fieldset>
                        </form>
                        <!-- 비밀번호 변경폼 끝 -->
                	</div>
            	</div>
            </div>
        </section>
    </div>
    <footer>
        <jsp:include page="/inc/footer.jsp"></jsp:include>
    </footer>

    <jsp:include page="/inc/script.jsp"></jsp:include>
    <script>
		$("#password_1").blur(function(){
			if($("#password_1").val() == ""){
				$("#pw1Msg").text("비밀번호를 입력해주세요.");
			}
		})
		$("#password_2").blur(function(){
			if($("#password_2").val() == ""){
				$("#pw2Msg").text("비밀번호를 입력해주세요.");
			} else if($("#password_2").val() != $("#password_1").val()){
				$("#pw2Msg").text("입력된 비밀번호와 다릅니다.");
			}
		})
	</script>
</body>
</html>