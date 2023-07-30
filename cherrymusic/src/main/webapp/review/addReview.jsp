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
    <jsp:include page="/inc/head.jsp"></jsp:include>

</head>
<body>
    <jsp:include page="/inc/header.jsp"></jsp:include>
    
    <div id="page-content" class="page-content">
        <div class="banner">
            <div class="jumbotron jumbotron-bg text-center rounded-0" style="background-image: url('<%=request.getContextPath()%>/resources/assets/img/bg-header.jpg');">
                <div class="container">
                    <h1 class="pt-5">
                        리뷰 작성
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
                        <h5 class="mb-3">리뷰 작성</h5>
                        <!-- 정보 수정폼 시작 -->
                        <form action="<%=request.getContextPath()%>/review/addReviewAction.jsp" method="post" enctype="multipart/form-data" class="bill-detail">
                            <fieldset>
                            	<!-- hidden으로 넘기는 값 -->
                            	<input type="hidden" name="orderNo" value="<%=orderNo%>">
                                <div class="form-group row">
	                                <div class="col-2 text-right">
		                                <label for="reiviewTitle"><strong>제목</strong></label>
	                                </div>
	                                <div class="col-10">
	                                	<div>
		                                    <input id="reviewTitle" class="form-control" type="text" name="title" size="80" required>
	                                	</div>
	                                </div>
                                </div>
                                <div class="form-group row">
                                	<div class="col-2 text-right">
                                		<label for="reviewContent"><strong>내용</strong></label>
                                	</div>
                                	<div class="col-2">
                                		<div>
                                			<textarea id="reviewContent" class="form-control" name="content" required></textarea>
                                		</div>
                                	</div>
                       			</div>
                                <div class="form-group row">
                                	<div class="col-2 text-right">
                                		<label for="id"><strong>작성자</strong></label>
                                	</div>
                                	<div class="col-10">
                                		<div>
					                        <input class="form-control" type="text" name="id" value="<%=loginId%>" readonly required>
                                		</div>
                                	</div>
                                </div>
                                <div class="form-group row">
                                	<div class="col-2 text-right">
		                                <label for="file"><strong>사진 첨부</strong></label>
                                	</div>
									<div class="col-10">
										<div>
				                        	<input id="file" type="file" name="img" required>
				                        </div>
									</div>
                                </div>
                                <div class="form-group text-right">
                                    <button type="submit" class="btn btn-primary">리뷰작성</button>
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
