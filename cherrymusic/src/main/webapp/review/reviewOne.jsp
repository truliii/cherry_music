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
    <jsp:include page="/inc/head.jsp"></jsp:include>

</head>
<body>
    <jsp:include page="/inc/header.jsp"></jsp:include>
    
    <div id="page-content" class="page-content">
        <div class="banner">
            <div class="jumbotron jumbotron-bg text-center rounded-0" style="background-image: url('<%=request.getContextPath()%>/resources/assets/img/bg-header.jpg');">
                <div class="container">
                    <h1 class="pt-5">
                        리뷰 상세보기
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
                        <h5 class="mb-3">리뷰 상세</h5>
                        <!-- 리뷰 상세정보 시작 -->
                        <div class="row mb-2"><!-- 1행 -->
                        	<div class="col-3">
                        		주문번호
                        	</div>
                        	<div class="col-9">
                        		<%=review.get("orderNo")%>
                        	</div>
                        </div>
                        <div class="row mb-2"><!-- 2행 -->
                        	<div class="col-3">
                        		리뷰사진
                        	</div>
                        	<div class="col-9">
                        		<img src="<%=request.getContextPath()%>/review/reviewImg/<%=(String)review.get("reviewSaveFilename")%>" alt="준비중" width="auto" height="100px">
                        	</div>
                        </div>
                        <div class="row mb-2"><!-- 3행 -->
                        	<div class="col-3">
                        		제목
                        	</div>
                        	<div class="col-6">
                        		<%=review.get("reviewTitle")%>
                        	</div>
                        </div>
                        <div class="row mb-2"><!-- 4행 -->
                        	<div class="col-3">
                        		내용
                        	</div>
                        	<div class="col-9">
                        		<%=review.get("reviewContent")%>
                        	</div>
                        </div>
                        <div class="row mb-2"><!-- 5행 -->
                        	<div class="col-3">
                        		작성일
                        	</div>
                        	<div class="col-9">
                        		<%=review.get("createdate").toString().substring(0, 10)%>
                        	</div>
                        </div>
                        <div class="row mb-2"><!-- 6행 -->
                        	<div class="col-3">
                        		수정일
                        	</div>
                        	<div class="col-9">
                        		<%=review.get("updatedate").toString().substring(0, 10)%>
                        	</div>
                        </div>
                        <%
                        	//관리자 답변이 있는 경우
                        	if(aList.size() != 0){
                        %>
                        <div class="row justify-content-center mt-3"><!-- 관리자 답변 -->
		            		<div class="col-md-12">
			            		<div class="card">
			                        <div class="card-body">
			                        	<div class="row">
			                        		<div class="col-3">답변</div>
			                        		<%
												for(ReviewAnswer a : aList){	
											%>
													<div class="col-6"><%=a.getReviewAContent()%></div>
													<div class="col-3"><%=a.getCreatedate().toString().substring(0,10)%></div>
											<%
												}
											%>
			                        	</div>
			                        </div>
			                    </div>
		                    </div>
		            	</div>
		            	<%
                        	}
		            	%>
                        <div class="row justify-content-center mt-3">
                        	<div class="col-6 text-center">
	                           	<a href="<%=request.getContextPath()%>/review/modifyReview.jsp?reviewNo=<%=reviewNo%>" class="btn btn-primary">리뷰수정</a>
	                           	<div class="clearfix"></div>
                        	</div>
                        	<div class="col-6 text-center">
	                           	<a href="<%=request.getContextPath()%>/review/removeReviewAction.jsp?reviewNo=<%=reviewNo%>" class="btn btn-primary">리뷰삭제</a>
	                           	<div class="clearfix"></div>
                        	</div>
                    	</div>
                        <!-- 리뷰 상세정보 끝 -->
                	</div>
            	</div>
            </div>
        </section>
       </div>
    <footer>
        <jsp:include page="/inc/footer.jsp"></jsp:include>
    </footer>

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
