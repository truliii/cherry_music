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
		response.sendRedirect(request.getContextPath()+"/id_list/login.jsp");
		System.out.println(KMJ + "modifyReview 로그인 필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	}
	System.out.println(KMJ + loginId + " <--modifyReview loginId" + RESET);
	
	//요청값 유효성 검사
	if(request.getParameter("reviewNo") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	int reviewNo = Integer.parseInt(request.getParameter("reviewNo")); 
	
	//현재 리뷰정보 출력
	ReviewDao rDao = new ReviewDao();
	HashMap<String, Object> review = rDao.selectReviewByReviewNo(reviewNo);
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Modify Review</title>
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
                <h1>리뷰 수정하기</h1>
                <hr>
                	<form action="<%=request.getContextPath()%>/review/modifyReviewAction.jsp" method="post" enctype="multipart/form-data">
				<input type="hidden" name="reviewNo" value="<%=reviewNo%>">
					<table class="table">
						<tr>
							<th>주문번호</th>
							<td><input type="text" class="form-control" name="orderNo" value="<%=review.get("orderNo")%>" size="80" required readonly></td>
						</tr>
						<tr>
							<th>제목</th>
							<td><input type="text" class="form-control" name="title" value="<%=review.get("reviewTitle")%>" size="80" required></td>
						</tr>
						<tr>
							<th>내용</th>
							<td><textarea class="form-control" name="content" cols="80" rows="10" required><%=review.get("reviewContent")%></textarea></td>
						</tr>
						<tr>
							<th>작성자</th>
							<td><input type="text" class="form-control" name="id" value="<%=loginId%>" readonly required></td>
						</tr>
						<tr>
							<th>등록이미지</th>
							<td><img src="<%=request.getContextPath()%>/review/reviewImg/<%=review.get("reviewSaveFilename")%>" width="auto" height="100px"></td>
						</tr>
						<tr>
							<th>이미지변경</th>
							<td><input type="file" name="img"></td>
						</tr>
					</table>
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
</body>
</html>