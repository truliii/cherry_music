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
	<meta charset="UTF-8">
	<title>customerOne</title>
	<jsp:include page="/inc/link.jsp"></jsp:include>
</head>
<body>
<!-- 메뉴 -->
<jsp:include page="/inc/menu.jsp"></jsp:include>

<!-- -----------------------------메인 시작----------------------------------------------- -->
<div id="all">
      <div id="content">
        <div class="container">
          <div class="row">
            <div class="col-lg-12">
              <!-- 마이페이지 -->
              <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                  <li aria-current="page" class="breadcrumb-item active">마이페이지</li>
                </ol>
              </nav>
            </div>
            <div class="col-lg-3">
              <!-- 고객메뉴 시작 -->
              <jsp:include page="/inc/customerSideMenu.jsp"></jsp:include>
            <!-- 고객메뉴 끝 -->
            </div>
            <div class="col-lg-9">
              <div class="box">
                <h1>My Account</h1>
                	<form action="<%=request.getContextPath()%>/customer/modifyCustomerAction.jsp" method="post">
                  <div class="row">
                    <div class="col-md-12">
                      <div class="form-group">
                        <label for="id">아이디</label>
                        <input id="id"  name="id" value="<%=customer.getId()%>" readonly type="text" class="form-control">
                      </div>
                    </div>
                  </div>
                    <div class="row">
                    <div class="col-md-12">
                      <div class="form-group">
                        <label for="name">이름&nbsp;<span class="msg" id="nameMsg"></span></label>
                        <input id="name" name="name" value="<%=customer.getCstmName()%>" type="text" class="form-control">
                      </div>
                    </div>
                   </div>
                    <div class="row">
                    <div class="col-md-12">
                      <div class="form-group">
                        <label for="address">주소&nbsp;<span class="msg" id="addMsg"></span></label>
                        <input id="address" name="address" value="<%=customer.getCstmAddress()%>" type="text" class="form-control"><p>
                        <a class="btn btn-primary" id="addrPopup" href="<%=request.getContextPath()%>/customer/addCustomerAddress.jsp"><i class="fa fa-save"></i>주소추가</a>
                    </div>
                   </div>
                   </div>
                    <div class="row">
                    <div class="col-md-12">
                      <div class="form-group">
                        <label for="email">이메일&nbsp;<span class="msg" id="emailMsg"></span></label>
                        <input id="email" name="email" value="<%=customer.getCstmEmail()%>" type="email" class="form-control">
                      </div>
                    </div>
                   </div>
                    <div class="row">
                    <div class="col-md-12">
                      <div class="form-group">
                        <label for="birth">생일&nbsp;<span class="msg" id="birthMsg"></span></label>
                        <input id="birth" name="birth" value="<%=customer.getCstmBirth()%>" type="date" class="form-control">
                      </div>
                    </div>
                   </div>
                    <div class="row">
                    <div class="col-md-12">
                      <div class="form-group">
                        <label for="phone">연락처&nbsp;<span class="msg" id="phoneMsg"></span></label>
                        <input id="phone" name="phone" value="<%=customer.getCstmPhone()%>" type="text" class="form-control">
                      </div>
                    </div>
                   </div>
                    <div class="row">
                    <div class="col-md-12">
                      <div>
                        <label for="gender">성별</label>
                        <%
                        	if(customer.getCstmGender().equals("M")){
                        %>
                        		<input id="gender" name="gender" value="M" type="radio" checked>남
                       			<input id="gender" name="gender" value="F" type="radio">여
                       			&nbsp;<span class="msg" id="genderMsg"></span>
                        <%
                        	} else {
                        %>
                        		<input id="gender" name="gender" value="M" type="radio">남
                        		<input id="gender" name="gender" value="F" type="radio" checked>여
                        		&nbsp;<span class="msg" id="genderMsg"></span>
                        <%
                        	}
                        %>
                        
                      </div>
                    </div>
                   </div>
                    <div class="box-footer d-flex justify-content-center">
                     	<button class="btn btn-primary" type="submit"><i class="fa fa-save"></i>수정하기</button>
                    </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
	
	<!-- -----------------------------메인 끝----------------------------------------------- -->
<!-- copy -->
<jsp:include page="/inc/copy.jsp"></jsp:include>
<!-- 자바스크립트 -->
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