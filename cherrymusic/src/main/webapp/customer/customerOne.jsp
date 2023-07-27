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

<body class="sub_page">

  <div class="hero_area">
    <div class="bg-box">
      <img src="<%=request.getContextPath()%>/resources/images/hero-bg.jpg" alt="">
    </div>
    <!-- header section strats -->
    <jsp:include page="/inc/header.jsp"></jsp:include>
    <!-- end header section -->
  </div>

  <!-- mypage section -->

  <section class="food_section layout_padding">
    <div class="container">
      <div class="heading_container heading_center">
        <h2>
          My page
        </h2>
      </div>

      <ul class="filters_menu">
        <li class="active"><a href="<%=request.getContextPath()%>/customer/customerOne.jsp">profile</a></li>
        <li><a href="<%=request.getContextPath()%>/customer/customerOrderList.jsp">Order List</a></li>
      </ul>

      <div class="filters-content">
        <div class="row grid">
        	<div class="col-sm-6 col-lg-12 all pizza">
	          <table class="table">
					<tr><!-- 1행 -->
						<th>아이디</th>
						<td colspan="2"><%=customer.getId()%></td>
					</tr>
					<tr><!-- 2행 -->
						<th>이름</th>
						<td colspan="2"><%=customer.getCstmName()%></td>
					</tr>
					<tr><!-- 3행 -->
						<th>주소</th>
						<td><%=customer.getCstmAddress()%></td>
						<td>
							<a href="<%=request.getContextPath()%>/customer/addCustomerAddress.jsp?&currentPage=1">주소목록</a>
						</td>						
					</tr>
					<tr><!-- 4행 -->
						<th>이메일</th>
						<td colspan="2"><%=customer.getCstmEmail()%></td>
					</tr>
					<tr><!-- 5행 -->
						<th>생일</th>
						<td colspan="2"><%=customer.getCstmBirth()%></td>
					</tr>
					<tr><!-- 6행 -->
						<th>연락처</th>
						<td colspan="2"><%=customer.getCstmPhone()%></td>
					</tr>
					<tr><!-- 7행 -->
						<th>성별</th>
						<td colspan="2"><%=customer.getCstmGender()%></td>
					</tr>
					<tr><!-- 8행 -->
						<th>회원등급</th>
						<td colspan="2"><%=customer.getCstmRank()%></td>
					</tr>
					<tr><!-- 9행 -->
						<th>포인트</th>
						<td>
							<%=customer.getCstmPoint()%>
						</td>
						<td>
							<a href="<%=request.getContextPath()%>/customer/pointHistory.jsp?&currentPage=1">포인트이력확인</a> 
						</td>
					</tr>
				</table>
			</div>
        </div>
      </div>
      <div class="btn-box">
        <a href="<%=request.getContextPath()%>/customer/modifyCustomer.jsp?id=<%=customer.getId()%>" class="btn btn-primary">회원정보수정</a>
       	<a href="<%=request.getContextPath()%>/customer/modifyPassword.jsp?id=<%=customer.getId()%>" class="btn btn-primary">비밀번호변경</a>
       	<a href="#" class="btn btn-primary">회원탈퇴</a>
      </div>
    </div>
  </section>

  <!-- end mypage section -->

  <!-- footer section -->
  <jsp:include page="/inc/footer.jsp"></jsp:include>
  <!-- footer section -->

<jsp:include page="/inc/script.jsp"></jsp:include>

</body>

</html>