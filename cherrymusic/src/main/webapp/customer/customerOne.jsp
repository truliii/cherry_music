<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	//로그인 세션 유효성 검사: 로그아웃상태면 로그인창으로 리다이렉션
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/id_list/login.jsp");
		System.out.println(KMJ + "customerOne 로그인필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
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
            <div class="jumbotron jumbotron-bg text-center rounded-0" style="background-image: url('<%=request.getContextPath()%>/resources/assets/img/cherry_header.jpg');">
                <div class="container">
                    <h1 class="pt-5">
                        마이페이지
                    </h1>
                    <p class="lead">
                        
                    </p>
                </div>
            </div>
        </div>

        <section id="checkout">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-xs-12 col-sm-8">
                        <h5 class="mb-3">계정 정보</h5>
                        <!-- 계정 상세정보 시작 -->
                        <div class="row mb-2"><!-- 1행 -->
                        	<div class="col-3 text-right">
                        		<strong>아이디</strong>
                        	</div>
                        	<div class="col-9">
                        		<%=customer.getId()%>
                        	</div>
                        </div>
                        <div class="row mb-2"><!-- 2행 -->
                        	<div class="col-3 text-right">
                        		<strong>이름</strong>
                        	</div>
                        	<div class="col-9">
                        		<%=customer.getCstmName()%>
                        	</div>
                        </div>
                        <div class="row mb-2"><!-- 3행 -->
                        	<div class="col-3 text-right align-middle">
                        		<strong>주소</strong>
                        	</div>
                        	<div class="col-6">
                        		<%=customer.getCstmAddress()%>
                        	</div>
                        	<div class="col-3">
                        		<a class="btn btn-default" href="<%=request.getContextPath()%>/customer/customerAddress.jsp">주소목록</a>
                        	</div>
                        </div>
                        <div class="row mb-2"><!-- 4행 -->
                        	<div class="col-3 text-right">
                        		<strong>이메일</strong>
                        	</div>
                        	<div class="col-9">
                        		<%=customer.getCstmEmail()%>
                        	</div>
                        </div>
                        <div class="row mb-2"><!-- 5행 -->
                        	<div class="col-3 text-right">
                        		<strong>생일</strong>
                        	</div>
                        	<div class="col-9">
                        		<%=customer.getCstmBirth()%>
                        	</div>
                        </div>
                        <div class="row mb-2"><!-- 6행 -->
                        	<div class="col-3 text-right">
                        		<strong>성별</strong>
                        	</div>
                        	<div class="col-9">
                        		<%=customer.getId()%>
                        	</div>
                        </div>
                        <div class="row mb-2"><!-- 7행 -->
                        	<div class="col-3 text-right">
                        		<strong>연락처</strong>
                        	</div>
                        	<div class="col-9">
                        		<%=customer.getCstmPhone()%>
                        	</div>
                        </div>
                        <div class="row mb-2"><!-- 8행 -->
                        	<div class="col-3 text-right">
                        		<strong>회원등급</strong>
                        	</div>
                        	<div class="col-9">
                        		<%=customer.getCstmRank()%>
                        	</div>
                        </div>
                        <div class="row mb-4"><!-- 9행 -->
                        	<div class="col-3 text-right">
                        		<strong>포인트</strong>
                        	</div>
                        	<div class="col-6">
                        		<%=customer.getCstmPoint()%>p
                        	</div>
                        	<div class="col-3">
                        		<a class="btn btn-default" href="<%=request.getContextPath()%>/customer/pointHistory.jsp?currentPage=1">포인트확인</a> 
                        	</div>
                        </div>
                        <div class="row">
                        	<div class="col-4">
	                           	<a href="<%=request.getContextPath()%>/customer/modifyCustomer.jsp?id=<%=customer.getId()%>" class="btn btn-primary">정보수정</a>
	                           	<div class="clearfix"></div>
                        	</div>
                        	<div class="col-4">
	                           	<a href="<%=request.getContextPath()%>/customer/modifyPassword.jsp?id=<%=customer.getId()%>" class="btn btn-primary">비밀번호변경</a>
	                           	<div class="clearfix"></div>
                        	</div>
                        	<div class="col-4">
	                           	<a href="<%=request.getContextPath()%>/id_list/customerInfoRemove.jsp" class="btn btn-primary">회원탈퇴</a>
	                           	<div class="clearfix"></div>
                        	</div>
                    	</div>
                        <!-- 계정 상세정보 끝 -->
                	</div>
            	</div>
            </div>
        </section>
    </div>
    <footer>
        <jsp:include page="/inc/footer.jsp"></jsp:include>
    </footer>

    <jsp:include page="/inc/script.jsp"></jsp:include>
</body>
</html>
