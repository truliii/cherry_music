<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	//로그인 유효성 검사 : 로그아웃 상태면 로그인창으로 리다이렉션
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/id_list/login.jsp");
		System.out.println(KMJ + "admin_customer/customerOne 로그인 필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	} 
	
	//id가 employees테이블에 없는 경우(관리자가 아닌 경우) 홈으로 리다이렉션
	IdListDao iDao = new IdListDao();
	IdList loginLevel = iDao.selectIdListOne(loginId);
	int idLevel = loginLevel.getIdLevel();
	if(idLevel == 0){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");
	
	//요청값이 넘어오는지 확인하기
	System.out.println(KMJ + request.getParameter("id") + " <--admin_customer/customerOne param id" + RESET);
		
	//요청값 유효성 검사 : id가 넘어오지 않으면 회원리스트로 리다이렉션
	if(request.getParameter("id") == null){
		response.sendRedirect(request.getContextPath()+"/admin_customer/adminCustomerList.jsp");
		return;
	}
	String id = request.getParameter("id");
	System.out.println(KMJ + id + " <-admin_customer/customerOne id" + RESET);

	//id가 employees테이블에 있는 경우(관리자인 경우) 관리자 상세페이지로 리다이렉션
	EmployeesDao eDao = new EmployeesDao();
	Employees employee = eDao.selectEmployee(id);
	if(employee != null){ 
		response.sendRedirect(request.getContextPath()+"/admin_customer/adminOne.jsp?id="+id);
		return;
	}
	
	//회원정보 출력
	CustomerDao cDao = new CustomerDao();
	Customer customer = cDao.selectCustomer(id);
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
                        고객 상세정보
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
                        <h5 class="mb-3">고객 정보</h5>
                        <!-- 고객 상세정보 시작 -->
                        <div class="row mb-2"><!-- 1행 -->
                        	<div class="col-3">
                        		<strong>아이디</strong>
                        	</div>
                        	<div class="col-9">
                        		<%=id%>
                        	</div>
                        </div>
                        <div class="row mb-2"><!-- 2행 -->
                        	<div class="col-3">
                        		<strong>이름</strong>
                        	</div>
                        	<div class="col-9">
                        		<%=customer.getCstmName()%>
                        	</div>
                        </div>
                        <div class="row mb-2"><!-- 3행 -->
                        	<div class="col-3">
                        		<strong>주소</strong>
                        	</div>
                        	<div class="col-6">
                        		<%=customer.getCstmAddress()%>
                        	</div>
                        </div>
                        <div class="row mb-2"><!-- 4행 -->
                        	<div class="col-3">
                        		<strong>이메일</strong>
                        	</div>
                        	<div class="col-9">
                        		<%=customer.getCstmEmail()%>
                        	</div>
                        </div>
                        <div class="row mb-2"><!-- 5행 -->
                        	<div class="col-3">
                        		<strong>생일</strong>
                        	</div>
                        	<div class="col-9">
                        		<%=customer.getCstmBirth()%>
                        	</div>
                        </div>
                        <div class="row mb-2"><!-- 6행 -->
                        	<div class="col-3">
                        		<strong>성별</strong>
                        	</div>
                        	<div class="col-9">
                        		<%=customer.getCstmGender()%>
                        	</div>
                        </div>
                        <div class="row mb-2"><!-- 7행 -->
                        	<div class="col-3">
                        		<strong>연락처</strong>
                        	</div>
                        	<div class="col-9">
                        		<%=customer.getCstmPhone()%>
                        	</div>
                        </div>
                        <div class="row mb-2"><!-- 8행 -->
                        	<div class="col-3">
                        		<strong>회원등급</strong>
                        	</div>
                        	<div class="col-9">
                        		<%=customer.getCstmRank()%>
                        	</div>
                        </div>
                        <%
							//관리자등급이 2인 경우에만 회원등급 변경가능
							if(idLevel == 2){
						%>
								<div class="row mb-2">
									<div class="col-3">
										<strong>관리자권한 부여</strong>
									</div>
									<div class="col-9">
										<button type="submit" class="btn btn-primary">권한주기</button>
									</div>
								</div>
						<%
							}
						%>
                        <div class="row mb-2"><!-- 9행 -->
                        	<div class="col-3">
                        		<strong>포인트</strong>
                        	</div>
                        	<div class="col-6">
                        		<%=customer.getCstmPoint()%>
                        	</div>
                        </div>
                        <div class="row mb-2"><!-- 9행 -->
                        	<div class="col-3">
                        		<strong>총주문금액</strong>
                        	</div>
                        	<div class="col-6">
                        		<%=customer.getCstmSumPrice()%>
                        	</div>
                        </div>
                        <!-- 고객 상세정보 끝 -->
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