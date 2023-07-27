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
	<meta charset="UTF-8">
	<title>Add Review Answer</title>
	<style>
		.hidden {
			display: none;
		}
	</style>
	<jsp:include page="/inc/link.jsp"></jsp:include>
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
			
		})
	</script>
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
                  <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/admin_category/adminCategoryList.jsp">관리페이지</a></li>
                  <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/admin_review/adminReview.jsp">리뷰관리</a></li>
                  <li aria-current="page" class="breadcrumb-item active">답변하기</li>
                </ol>
              </nav>
            </div>
            <div class="col-lg-3">
              <!-- 관리자메뉴 시작 -->
              <jsp:include page="/inc/adminSideMenu.jsp"></jsp:include>
              <!-- /.col-lg-3-->
              <!-- 관리자메뉴 끝 -->
            </div>
            <div class="col-lg-9">
              <div class="box">
              	<!-- 상세정보 -->
				<div>
					<form method="post">
					<input type="hidden" name="reviewNo" value="<%=reviewNo%>">
					<h1>리뷰 답변하기</h1>
					<hr>
						<table class="table">
							<tr>
								<th>리뷰제목</th>
								<td colspan="3"><%=review.get("reviewTitle")%></td>
							</tr>
							<tr>
								<th>리뷰내용</th>
								<td colspan="3"><%=review.get("reviewContent")%></td>
							</tr>
							<%
								if(aList.size() < 1){
							%>
									<tr>
										<th>답변입력</th>
										<td>
											<textarea id="addAContent" name="addAContent" cols="70" rows="2" class="form-control"></textarea>
											<div class="text-right">(<span id="addACnt">0</span>자/150자)</div>
										</td>
										<td colspan="2">
											<button class="btn btn-primary" type="submit" formaction="<%=request.getContextPath()%>/admin_review/addReviewAnswerAction.jsp">입력</button>
										</td>
									</tr>
							<%
								} 
								for(ReviewAnswer a : aList){	
							%>
									<tr id="viewAnswer">
										<th>답변</th>
										<td><%=a.getReviewAContent()%></td>
										<td><%=a.getCreatedate()%></td>
										<td>
											<button type="button" class="btn btn-primary" id="modBtn">수정</button>
											<button class="btn btn-primary" formaction="<%=request.getContextPath()%>/admin_review/deleteReviewAnswerAction.jsp?reviewNo=<%=reviewNo%>">삭제</button>
										</td>
									</tr>
									<tr id="modForm" class="hidden">
										<th>답변수정</th>
										<td>
											<textarea id="modAContent" name="modAContent" class="form-control" cols="70" rows="2"><%=a.getReviewAContent()%></textarea>
											<div class="text-right">(<span id="modACnt">0</span>자/150자)</div>
										</td>
										<td>
											<button type="submit" class="btn btn-primary" formaction="<%=request.getContextPath()%>/admin_review/modifyReviewAnswerAction.jsp">수정</button>
										</td>
									</tr>
							<%
								}
							%>
						</table>
						</form>
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
<script>
	const modBtn = document.querySelector("#modBtn");
	const modForm = document.querySelector("#modForm");
	const viewAnswer = document.querySelector("#viewAnswer");
	
	function handleClickMod(event){
		event.preventDefault();
		viewAnswer.classList.add("hidden");
		modForm.classList.remove("hidden");
	
	}
	
	modBtn.addEventListener("click", handleClickMod);
</script>
</html>	