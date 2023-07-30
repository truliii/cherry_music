<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";

	int cartNum = 0;
	CartDao cDao = new CartDao();
	
	//로그인 세션 유효성 검사
	Object o = null;
	String loginId = "";
	Employees emp = null;
	if(session.getAttribute("loginId") != null){
		o = session.getAttribute("loginId");
		if(o instanceof String){
			loginId = (String)o;
			
			//관리자여부 확인
			EmployeesDao eDao = new EmployeesDao();
			emp = eDao.selectEmployee(loginId);
			
			cartNum = cDao.selectCartCnt(loginId);
		}
	}
	
	
	//장바구니 개수
	//로그아웃 상태 : 세션에서 장바구니 정보꺼내기
	ArrayList<HashMap<String, Object>> cartList = null;
	if(session.getAttribute("loginId") == null && session.getAttribute("sessionCartList") != null){
		ArrayList<HashMap<String, Object>> sessionCartList = (ArrayList<HashMap<String, Object>>)session.getAttribute("sessionCartList");
		for(HashMap<String, Object> m : sessionCartList){
			cartNum += 1;
		}
	}
	
	//수량변경 ajax를 위해 필요한 변수
	int num = 0;
	
	
%>
<div class="page-header">
    <!--=============== Navbar ===============-->
    <nav class="navbar fixed-top navbar-expand-md navbar-dark bg-transparent" id="page-navigation">
        <div class="container">
            <!-- Navbar Brand -->
            <a href="<%=request.getContextPath()%>/home.jsp" class="navbar-brand">
                <img src="<%=request.getContextPath()%>/resources/assets/img/logo/cherrymusic_logo2.png" alt="">
            </a>

            <!-- Toggle Button -->
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarcollapse" aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarcollapse">
                <!-- Navbar Menu -->
                <ul class="navbar-nav ml-auto">
                    <li class="nav-item">
                        <a href="<%=request.getContextPath()%>/home.jsp" class="nav-link">상품보기</a>
                    </li>
                    <%
                    	//로그인이 되어있지 않은 경우
                    	if(loginId == ""){
                    %>
	                    <li class="nav-item">
	                        <a href="<%=request.getContextPath()%>/id_list/signUp.jsp" class="nav-link">회원가입</a>
	                    </li>
	                    <li class="nav-item">
	                        <a href="<%=request.getContextPath()%>/id_list/login.jsp" class="nav-link">로그인</a>
	                    </li>
                    <%
                    	}
                    	//로그인이 되어 있는 경우
                    	if(loginId != ""){
                  	%>
	                    <li class="nav-item">
	                        <a href="<%=request.getContextPath()%>/id_list/logoutAction.jsp" class="nav-link">로그아웃</a>
	                    </li>
	                <%
		        			if(emp != null){
                    %>
			                    <li class="nav-item">
			                        <a href="<%=request.getContextPath()%>/admin_customer/adminCustomerList.jsp" class="nav-link">관리페이지</a>
			                    </li>
	                <%
                    		}
	                %>
	                	<li class="nav-item">
	                        <a href="<%=request.getContextPath()%>/board_question/qnaList.jsp" class="nav-link">Q&A</a>
	                    </li>
	                    <li class="nav-item dropdown">
	                        <a class="nav-link dropdown-toggle" href="javascript:void(0)" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
	                            <div class="avatar-header"><img src="<%=request.getContextPath()%>/resources/assets/img/logo/avatar.jpg"></div> <%=loginId%>
	                        </a>
	                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
	                            <a class="dropdown-item" href="<%=request.getContextPath()%>/customer/customerOne.jsp">마이페이지</a>
	                            <a class="dropdown-item" href="<%=request.getContextPath()%>/customer/customerOrderList.jsp">주문목록</a>
	                        </div>
	                    </li>
	                <%
                    	}
	                %>
	                <li class="nav-item">
	                    <a href="<%=request.getContextPath()%>/cart/cart.jsp" class="nav-link">
	                    	<i class="fa fa-shopping-basket"></i> 
	                    	<%
	                    		if(cartNum != 0){
	                    	%>
		                    	<sup><span class="badge badge-primary"><%=cartNum%></span></sup>
	                    	<%
	                    		}
	                    	%>
	                    </a>
	                </li>
                </ul>
            </div>

        </div>
    </nav>
</div>