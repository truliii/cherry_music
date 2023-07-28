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
		response.sendRedirect(KMJ + request.getContextPath()+"/login.jsp" + RESET);
		System.out.println(KMJ + "modifyCustomer 로그인되어있지 않아 리다이렉션" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	}
	
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");
	
	//요청값 유효성 검사: 요청값이 null인 경우 메인화면으로 리다이렉션
	if(!loginId.equals(request.getParameter("id"))){
		response.sendRedirect(KMJ + request.getContextPath()+"/home.jsp" + RESET);
		return;
	}

	//고객정보 출력을 위한 dao생성
	CustomerDao cDao = new CustomerDao();
	Customer customer = cDao.selectCustomer(loginId);

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
                        Settings
                    </h1>
                    <p class="lead">
                        Update Your Account Info
                    </p>
                </div>
            </div>
        </div>

        <section id="checkout">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-xs-12 col-sm-8">
                        <h5 class="mb-3">정보 수정</h5>
                        <!-- 정보 수정폼 시작 -->
                        <form action="<%=request.getContextPath()%>/customer/modifyCustomerAction.jsp" method="post" class="bill-detail">
                            <fieldset>
                                <div class="form-group row"><!-- 1행 -->
                                	<input id="id" name="id" value="<%=customer.getId()%>" readonly type="hidden" class="form-control">
                                </div>
                                <div class="form-group row"><!-- 2행 -->
	                                <div class="col-2">
		                                <label for="name">이름&nbsp;</label>
	                                </div>
	                                <div class="col-10">
	                                	<div>
		                                    <input id="name" name="name" type="text" value="<%=customer.getCstmName()%>" type="text" class="form-control">
		                                    <span class="msg" id="nameMsg"></span>
	                                	</div>
	                                </div>
                                </div>
                                <div class="form-group row">
                                	<div class="col-2">
                                		<label for="address">주소&nbsp;</label>
                                	</div>
                                	<div class="col-8">
                                		<input id="address" name="address" value="<%=customer.getCstmAddress()%>" type="text" class="form-control">
                                	</div>
                                	<div class="col-2">
                                		<div>
                                			<a class="btn btn-default" id="addrPopup" href="<%=request.getContextPath()%>/customer/addCustomerAddress.jsp">주소 추가</a>
                                			<span class="msg" id="addMsg"></span>
                                		</div>
                                	</div>
                       			</div>
                                <div class="form-group row">
                                	<div class="col-2">
                                		<label for="email">이메일&nbsp;</label>
                                	</div>
                                	<div class="col-10">
                                		<div>
					                        <input id="email" name="email" value="<%=customer.getCstmEmail()%>" type="email" class="form-control">
											<span class="msg" id="emailMsg"></span>
                                		</div>
                                	</div>
                                </div>
                                <div class="form-group row">
                                	<div class="col-2">
		                                <label for="birth">생일&nbsp;</label>
                                	</div>
									<div class="col-10">
										<div>
				                        	<input id="birth" name="birth" value="<%=customer.getCstmBirth()%>" type="date" class="form-control">
				                        	<span class="msg" id="birthMsg"></span>
				                        </div>
									</div>
                                </div>
                                <div class="form-group row">
                                <div class="col-2">
	                                <label for="phone">연락처&nbsp;</label>
                                </div>
								<div class="col-10">
									<div>
				                        <input id="phone" name="phone" value="<%=customer.getCstmPhone()%>" type="text" class="form-control">
				                        <span class="msg" id="phoneMsg"></span>
			                        </div>
								</div>
                                </div>
                                <div class="form-group row">
                                    <div class="col-2">
                                    	<label for="gender">성별</label>
                                    </div>
                                    <div class="col-10">
			                        <%
			                        	if(customer.getCstmGender().equals("M")){
			                        %>
			                        		<div class="row">
				                        		<div class="col-2"><input id="gender" name="gender" value="M" type="radio" checked class="form-control">&nbsp;남</div>
				                       			<div class="col-2"><input id="gender" name="gender" value="F" type="radio">&nbsp;여</div>
				                       			<div class="col-8"><span class="msg" id="genderMsg"></span></div>
			                       			</div>
			                        <%
			                        	} else {
			                        %>
			                        		<div class="row">
				                        		<div class="col-2"><input id="gender" name="gender" value="M" type="radio">&nbsp;남</div>
				                       			<div class="col-2"><input id="gender" name="gender" value="F" type="radio" checked>&nbsp;여</div>
				                       			<div class="col-8"><span class="msg" id="genderMsg"></span></div>
			                       			</div>
			                        <%
			                        	}
			                        %>
                                    </div>
                                </div>
                                <div class="form-group text-right">
                                    <button type="submit" class="btn btn-primary">수정하기</button>
                                    <div class="clearfix"></div>
                                </div>
                            </fieldset>
                        </form>
                        <!-- 정보 수정폼 끝 -->
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
		//입력값 유효성 검사
		$("#name").blur(function(){
			if($("#name").val()==""){
				$("#nameMsg").text("이름을 입력하세요");
			}
		})
		$("#address").blur(function(){
			if($("#address").val()==""){
				$("#addMsg").text("주소를 입력하세요");
			}
		})
		$("#email").blur(function(){
			if($("#email").val()==""){
				$("#emailMsg").text("이메일을 입력하세요");
			}
		})
		$("#birth").blur(function(){
			if($("#birth").val()==""){
				$("#birthMsg").text("생일을 입력하세요");
			}
		})
		$("#phone").blur(function(){
			if($("#phone").val()==""){
				$("#phoneMsg").text("연락처를 입력하세요");
			}
		})
		$("#gender").blur(function(){
			if(!$("#gender").checked){
				$("#genderMsg").text("성별을 선택하세요");
			}
		})
	</script>
</body>
</html>
