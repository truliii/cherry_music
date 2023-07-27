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
                <h1>비밀번호 변경</h1>
				<form action="<%=request.getContextPath()%>/customer/modifyPasswordAction.jsp" method="post">
                  <div class="row">
                    <div class="col-md-6">
                      <div class="form-group">
                        <label for="password_1">새로운 비밀번호</label>
                        <input id="password_1" name="newPw" type="password" class="form-control" required>
                        <span class="msg" id="pw1Msg"></span>
                      </div>
                    </div>
                    <div class="col-md-6">
                      <div class="form-group">
                        <label for="password_2">새로운 비밀번호 확인</label>
                        <input id="password_2" name="cnfmNewPw" type="password" class="form-control" required>
                        <span class="msg" id="pw2Msg"></span>
                      </div>
                    </div>
                  </div>
                  <!-- /.row-->
                  <div class="box-footer d-flex justify-content-center">
                    <button type="submit" class="btn btn-primary"><i class="fa fa-save"></i>비밀번호변경</button>
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