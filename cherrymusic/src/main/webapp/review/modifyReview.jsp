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
    <jsp:include page="/inc/head.jsp"></jsp:include>

</head>
<body>
    <jsp:include page="/inc/header.jsp"></jsp:include>
    
    <div id="page-content" class="page-content">
        <div class="banner">
            <div class="jumbotron jumbotron-bg text-center rounded-0" style="background-image: url('<%=request.getContextPath()%>/resources/assets/img/bg-header.jpg');">
                <div class="container">
                    <h1 class="pt-5">
                        리뷰 수정
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
                        <h5 class="mb-3">리뷰 수정</h5>
                        <!-- 정보 수정폼 시작 -->
                        <form action="<%=request.getContextPath()%>/review/modifyReviewAction.jsp" method="post" enctype="multipart/form-data" class="bill-detail">
                            <fieldset>
                            	<input type="hidden" name="reviewNo" value="<%=reviewNo%>">
                                <div class="form-group row"><!-- 2행 -->
	                                <div class="col-2 text-right">
		                                <label for="name"><strong>주문번호</strong></label>
	                                </div>
	                                <div class="col-10">
	                                	<div>
		                                    <input type="text" class="form-control" name="orderNo" value="<%=review.get("orderNo")%>" size="80" required readonly>
	                                	</div>
	                                </div>
                                </div>
                                <div class="form-group row">
                                	<div class="col-2 text-right">
                                		<label for="address"><strong>제목</strong></label>
                                	</div>
                                	<div class="col-10">
                                		<input type="text" class="form-control" name="title" value="<%=review.get("reviewTitle")%>" size="80" required>
                                	</div>
                       			</div>
                                <div class="form-group row">
                                	<div class="col-2 text-right">
                                		<label for="email"><strong>내용</strong></label>
                                	</div>
                                	<div class="col-10">
                                		<div>
					                        <textarea class="form-control" name="content" cols="80" rows="10" required><%=review.get("reviewContent")%></textarea>
                                		</div>
                                	</div>
                                </div>
                                <div class="form-group row">
                                	<div class="col-2 text-right">
		                                <label for="birth"><strong>작성자</strong></label>
                                	</div>
									<div class="col-10">
										<div>
				                        	<input type="text" class="form-control" name="id" value="<%=loginId%>" readonly required>
				                        </div>
									</div>
                                </div>
                                <div class="form-group row">
                                <div class="col-2 text-right">
	                                <label for="phone"><strong>등록이미지</strong></label>
                                </div>
								<div class="col-10">
									<div>
				                        <img src="<%=request.getContextPath()%>/review/reviewImg/<%=review.get("reviewSaveFilename")%>" width="auto" height="100px">
			                        </div>
								</div>
                                </div>
                                <div class="form-group row">
                                    <div class="col-2 text-right">
                                    	<label for="gender"><strong>사진 첨부</strong></label>
                                    </div>
                                    <div class="col-10">
                                    	<input type="file" name="img" class="form-control">
                                    </div>
                                </div>
                                <div class="form-group text-right">
                                    <button type="submit" class="btn btn-primary">수정하기</button>
                                    <div class="clearfix"></div>
                                </div>
                            </fieldset>
                        </form>
                        <!-- 정보 수정폼 끝 -->
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