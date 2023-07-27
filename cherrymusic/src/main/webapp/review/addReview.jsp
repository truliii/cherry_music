<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	//로그인 유효성 검사
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println(KMJ + "addReview 로그인 필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	} 
	System.out.println(KMJ + loginId + " <--addReview loginId" + RESET);
	
	//요청값 유효성 검사
	if(request.getParameter("orderNo") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	int orderNo = Integer.parseInt(request.getParameter("orderNo")); 
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Add Review</title>
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
                  <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/customer/customerOne.jsp">마이페이지</a></li>
                  <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/customer/customerOrderList.jsp">주문목록</a></li>
                  <li aria-current="page" class="breadcrumb-item active">리뷰작성</li>
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
                <h1>리뷰 작성하기</h1>
                <p class="msg" id="reviewMsg"></p>
                <hr>
                	<form action="<%=request.getContextPath()%>/review/addReviewAction.jsp" method="post" enctype="multipart/form-data">
						<input type="hidden" name="orderNo" value="<%=orderNo%>">
							<table class="table">
								<tr>
									<th>제목</th>
									<td><input id="reviewTitle" class="form-control" type="text" name="title" size="80" required></td>
								</tr>
								<tr>
									<th>내용</th>
									<td><textarea id="reviewContent" class="form-control" name="content" cols="80" rows="10" required></textarea></td>
								</tr>
								<tr>
									<th>작성자</th>
									<td><input class="form-control" type="text" name="id" value="<%=loginId%>" readonly required></td>
								</tr>
								<tr>
									<th>이미지첨부</th>
									<td><input type="file" name="img" required></td>
								</tr>
							</table>
							<div class="box-footer d-flex justify-content-center">
								<button class="btn btn-primary" type="submit"><i class="fa fa-save"></i>작성하기</button>
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
	//리뷰 입력폼 유효성 검사
	$("#reviewTitle").blur(function(){
		if($("#reviewTitle").val() == ""){
			$("#reviewMsg").text("리뷰제목을 입력하세요.");
		}
	})
	$("#reviewContent").blur(function(){
		if($("#reviewContent").val() == ""){
			$("#reviewMsg").text("리뷰내용을 입력하세요.");
		}
	})
</script>
</body>
</html>