<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	//로그인 유효성 검사 : 로그아웃상태면 로그인창으로 리다이렉션
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/로그인.jsp");
		System.out.println(KMJ + "adminOne 로그인 필요" + RESET);
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
	System.out.println(KMJ + request.getParameter("id") + " <--adminOne param id" + RESET);
		
	//요청값 유효성 검사 : id가 넘어오지 않으면 회원리스트로 리다이렉션
	if(request.getParameter("id") == null){
		response.sendRedirect(request.getContextPath()+"/admin_customer/adminCustomerList.jsp");
		System.out.println(KMJ + "admin_customer/adminOne에서 리다이렉션" + RESET);
		return;
	}
	String id = request.getParameter("id");
	System.out.println(KMJ + id + " <-adminOne id" + RESET);
	
	//관리자정보 출력
	EmployeesDao eDao = new EmployeesDao();
	Employees employee = eDao.selectEmployee(id);
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
                        관리자 상세정보
                    </h1>
                    <p class="lead">
                    </p>
                </div>
            </div>
        </div>

        <section id="checkout">
            <div class="container">
            
            	<!-- 관리자메뉴 -->
            	<div class="row mb-5">
            		<div class="col-lg-12">
						<jsp:include page="/inc/adminNav.jsp"></jsp:include>
            		</div>
            	</div>
            	
                <div class="row justify-content-center">
                    <div class="col-xs-12 col-sm-8">
                        <h5 class="mb-3">관리자 정보</h5>
                        <!-- 계정 상세정보 시작 -->
                        <div class="row mb-2"><!-- 1행 -->
                        	<div class="col-3 text-right">
                        		<strong>아이디</strong>
                        	</div>
                        	<div class="col-9">
                        		<%=id%>
                        	</div>
                        </div>
                        <div class="row mb-2"><!-- 2행 -->
                        	<div class="col-3 text-right">
                        		<strong>이름</strong>
                        	</div>
                        	<div class="col-9">
                        		<%=employee.getEmpName()%>
                        	</div>
                        </div>
                        <div class="row mb-2"><!-- 3행 -->
                        	<div class="col-3 text-right">
                        		<strong>등급</strong>
                        	</div>
                        	<div class="col-6">
                        		<%=employee.getEmpLevel() %>
                        	</div>
                        </div>
                        <%
							//관리자등급이 2인 경우에만 관리자등급 변경 가능
							if(idLevel == 2){
						%>
								<div class="row mb-2">
									<div class="col-3 text-right">
										<strong>관리자 권한삭제</strong>
									</div>
									<div class="col-3">
										<!-- 관리자->회원 modifyAction으로 보내짐 -->
										<button type="submit" class="btn btn-primary">권한회수</button>
									</div>
								</div>
						<%
							}
						%>
                        <div class="row mb-2"><!-- 4행 -->
                        	<div class="col-3 text-right">
                        		<strong>가입일</strong>
                        	</div>
                        	<div class="col-9">
                        		<%=employee.getCreatedate()%>
                        	</div>
                        </div>
                        <div class="row mb-2"><!-- 5행 -->
                        	<div class="col-3 text-right">
                        		<strong>수정일</strong>
                        	</div>
                        	<div class="col-9">
                        		<%=employee.getUpdatedate()%>
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
