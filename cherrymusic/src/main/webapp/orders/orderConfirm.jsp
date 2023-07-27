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
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println(KMJ + "orderConfirm 로그인 필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	}
	System.out.println(KMJ + loginId + " <--orderConfirm loginId");
	
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");
	
	//요청값 유효성 검사: orderNo가 null인 경우 메인페이지로 리다이렉션
	if(request.getParameter("orderNo") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	int orderNo = Integer.parseInt(request.getParameter("orderNo"));
	
	//orders 정보 불러오기
	OrdersDao oDao = new OrdersDao();
	Orders order = oDao.selectOrderOne(orderNo);
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Customer One</title>
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
              <!-- breadcrumb-->
              <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                  <li class="breadcrumb-item"><a href="#">장바구니/주문</a></li>
                  <li aria-current="page" class="breadcrumb-item active">주문하기</li>
                </ol>
              </nav>
            </div>
            <div id="checkout" class="col-lg-12">
              <div class="box">
                  <h1>주문확인</h1>
                 <div class="content py-3">
                 	<p>주문번호 <%=order.getOrderNo()%>번의 주문이 완료되었습니다</p>
                  </div>
                  <div class="box-footer d-flex justify-content-center">
                    <a href="<%=request.getContextPath()%>/customer/customerOrderList.jsp?id=<%=loginId%>&currentPage=1" class="btn btn-primary">주문내역확인<i class="fa fa-chevron-right"></i></a>
                  </div>
              </div>
              <!-- /.box-->
            </div>
            <!-- /.col-lg-9-->
          </div>
        </div>
      </div>
    </div>
    <!-- copy -->
   <jsp:include page="/inc/copy.jsp"></jsp:include>
    <!-- 자바스크립트 -->
    <jsp:include page="/inc/script.jsp"></jsp:include>
</body>
</html>