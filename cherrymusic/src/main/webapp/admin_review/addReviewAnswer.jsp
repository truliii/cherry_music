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
		response.sendRedirect(request.getContextPath()+"/id_list/login.jsp");
		System.out.println(KMJ + "addReviewAnswer 로그인 필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	} 
	
	//관리자가 아닌 경우 홈으로 리다이렉션
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
	System.out.println(KMJ + request.getParameter("reviewNo") + " <--addReviewAnswer param reviewNo" + RESET);
	
	//요청값 유효성 검사
	if(request.getParameter("reviewNo") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	int reviewNo = Integer.parseInt(request.getParameter("reviewNo"));
	System.out.println(KMJ + reviewNo + " <--addReviewAnswer reviewNo" + RESET);

	//리뷰상세정보 출력
	ReviewDao rDao = new ReviewDao();
	HashMap<String, Object> review = rDao.selectReviewByReviewNo(reviewNo);
	ReviewAnswerDao aDao = new ReviewAnswerDao();
	ArrayList<ReviewAnswer> aList = aDao.selectReviewAnswerList(reviewNo);
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
                        고객 리뷰 답변
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
                        <h5 class="mb-3">리뷰 답변 작성</h5>
                        <!-- 리뷰 상세정보 시작 -->
                        <div class="row mb-2">
                        	<div class="col-3 text-center">
                        		<strong>리뷰 제목</strong>
                        	</div>
                        	<div class="col-9 text-left">
                        		<%=review.get("reviewTitle")%>
                        	</div>
                        </div>
                        <div class="row mb-2"><!-- 2행 -->
                        	<div class="col-3 text-center">
                        		<strong>리뷰 내용</strong>
                        	</div>
                        	<div class="col-9 text-left">
                        		<%=review.get("reviewContent")%>
                        	</div>
                        </div>
                	</div>
                  <!-- 리뷰 상세정보 끝 -->
                   <div class="col-xs-12 col-sm-8">
                       <!-- 정보 수정폼 시작 -->
                       <form method="post" class="bill-detail">
                           <fieldset>
                           	<input type="hidden" name="reviewNo" value="<%=reviewNo%>">
                           	
                           	
                           	<%
								if(aList.size() < 1){
							%>
									<div class="form-group row">
		                                <div class="col-3 text-center">
			                                <label for="name"><strong>답변</strong></label>
		                                </div>
		                                <div class="col-7">
		                                	<div class="row">
		                                		<div class="col">
				                                    <textarea id="addAContent" name="addAContent" cols="100" rows="2" class="form-control"></textarea>
		                                		</div>
												<div class="text-right">
													(<span id="addACnt">0</span>자/150자)
												</div>
		                                	</div>
		                                </div>
		                                <div class="col-2">
		                                	<button class="btn btn-primary" type="submit" formaction="<%=request.getContextPath()%>/admin_review/addReviewAnswerAction.jsp">입력</button>
		                                </div>
	                                </div>
							<%
								} 
								for(ReviewAnswer a : aList){	
							%>
									<div class="form-group row" id="viewAnswer">
		                                <div class="col-3 text-center">
			                                <label for="name"><strong>답변</strong></label>
		                                </div>
		                                <div class="col-7">
		                                	<%=a.getReviewAContent()%> (<%=a.getCreatedate()%>)
		                                </div>
		                                <div class="col-1">
		                                	<button type="button" class="btn btn-primary" id="modBtn">수정</button>
		                                </div>
		                                <div class="col-1">
		                                	<button class="btn btn-primary" formaction="<%=request.getContextPath()%>/admin_review/deleteReviewAnswerAction.jsp?reviewNo=<%=reviewNo%>">삭제</button>
		                                </div>
	                                </div>
	                                <div class="hidden form-group row" id="modForm">
		                                <div class="col-3 text-center">
			                                <label for="name"><strong>답변수정</strong></label>
		                                </div>
		                                <div class="col-7">
		                                	<div class="row">
		                                		<div class="col">
				                                	<textarea id="modAContent" name="modAContent" class="form-control" cols="100" rows="2"><%=a.getReviewAContent()%></textarea>
		                                		</div>
		                                		<div class="text-right">
		                                			(<span id="modACnt">0</span>자/150자)
		                                		</div>
		                                	</div>
		                                </div>
		                                <div class="col-2">
		                                	<button type="submit" class="btn btn-primary" formaction="<%=request.getContextPath()%>/admin_review/modifyReviewAnswerAction.jsp">수정</button>
		                                </div>
	                                </div>
							<%
								}
							%>
                           </fieldset>
                       </form>
                       <!-- 리뷰 답변폼 끝 -->
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
		$(document).ready(function(){
			const MAX_COUNT = 150;
			
			//답변 입력 글자 수 제한 (150자)
			$("#addAContent").keyup(function(){
				let len = $("#addAContent").val().length;
				if(len > MAX_COUNT){
					let str = $("#addAContent").val().substring(0, MAX_COUNT);
					$("#addAContent").val(str);
					alert(MAX_COUNT+"자까지만 입력가능합니다");
				} else {
					$("#addACnt").text(len);
				}
			})
			
			//답변 수정 글자 수 제한
			$("#modAContent").keyup(function(){
				let len = $("#modAContent").val().length;
				if(len > MAX_COUNT){
					let str = $("#modAContent").val().substring(0, MAX_COUNT);
					$("#modAContent").val(str);
					alert(MAX_COUNT+"자까지만 입력가능합니다");
				} else {
					$("#modACnt").text(len);
				}
			})
			
			//수정버튼
			$('#modBtn').click(function(){
				$('#viewAnswer').addClass('hidden');
				$('#modForm').removeClass('hidden');
			})
		})
	</script>
</body>
</html>
