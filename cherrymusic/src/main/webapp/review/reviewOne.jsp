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
		System.out.println(KMJ + "reviewOne 로그인 필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	} 
	System.out.println(KMJ + loginId + " <--reviewOne loginId" + RESET);
	
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");
	
	//요청값 유효성 검사
	if(request.getParameter("reviewNo") == null
		|| request.getParameter("id") == null){
		response.sendRedirect(request.getContextPath()+"/orderList.jsp?id="+loginId);
		return;
	}
	int reviewNo = Integer.parseInt(request.getParameter("reviewNo"));
	
	//리뷰번호별 리뷰 출력
	ReviewDao rDao = new ReviewDao();
	HashMap<String, Object> review = rDao.selectReviewByReviewNo(reviewNo);
	
	//리뷰번호별 답변 출력
	ReviewAnswerDao aDao = new ReviewAnswerDao();
	ArrayList<ReviewAnswer> aList = aDao.selectReviewAnswerList(reviewNo);
	
	//리뷰이미지 저장위치
	String dir = request.getServletContext().getRealPath("/review/reviewImg");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Review One</title>
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
                  <li aria-current="page" class="breadcrumb-item active">리뷰보기</li>
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
              	<table class="table">
              	<h1>나의 리뷰</h1>
                	<hr>
              		<thead>
              			<tr>
              				<th>주문번호</th>
              				<th>리뷰사진</th>
              				<th>제목</th>
              				<th>내용</th>
              				<th>작성일</th>
              				<th>수정일</th>
              			</tr>
              		</thead>
              		<tbody>
              			<tr>
              				<td><%=review.get("orderNo")%></td>
              				<td><img src="<%=request.getContextPath()%>/review/reviewImg/<%=(String)review.get("reviewSaveFilename")%>" alt="준비중" width="auto" height="100px"></td>
              				<td><%=review.get("reviewTitle")%></td>
              				<td><%=review.get("reviewContent")%></td>
              				<td><%=review.get("createdate").toString().substring(0, 10)%></td>
              				<td><%=review.get("updatedate").toString().substring(0, 10)%></td>
              			</tr>
              		</tbody>
              	</table>
              	<br>
                 <table class="table"><!-- 관리자답변 -->
                 	<thead>
                 		<tr>
							<th>관리자답변</th>
	                 		<th>답변일</th>
                 		</tr>
                 	</thead>
                 	<tbody>
						<%
							for(ReviewAnswer a : aList){	
						%>
								<tr>
									<td><%=a.getReviewAContent()%></td>
									<td><%=a.getCreatedate().toString().substring(0,10)%></td>
								</tr>
						<%
							}
						%>
					</tbody>
				  </table>
				  <!-- 수정, 삭제, 돌아가기 버튼 -->
				  <div class="box-footer d-flex justify-content-between">
                    <div class="col-md-6 text-center">
                     	<a class="btn btn-primary" href="<%=request.getContextPath()%>/review/modifyReview.jsp?reviewNo=<%=reviewNo%>"><i class="fa fa-save"></i>수정하기</a> 
                    </div>
                    <div class="col-md-6 text-center">
                     	<a class="btn btn-primary" href="<%=request.getContextPath()%>/review/removeReviewAction.jsp?reviewNo=<%=reviewNo%>"><i class="fa fa-save"></i>삭제하기</a>
                  </div>
                 </div>
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
