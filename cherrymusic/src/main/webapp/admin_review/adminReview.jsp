<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	//로그인 유효성 검사 : 로그아웃상태면 로그인창으로 리다이렉션
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/id_list/login.jsp");
		System.out.println(KMJ + "adminReview 로그인 필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	} 
	
	//id가 employees테이블에 없는 경우(관리자가 아닌 경우) 홈으로 리다이렉션
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
	System.out.println(KMJ + request.getParameter("beginRow") + " <--adminReview param beginRow" + RESET);
	System.out.println(KMJ + request.getParameter("rowPerPage") + " <--adminReview param rowPerPage" + RESET);
	System.out.println(KMJ + request.getParameter("answer") + " <--adminReview param answer" + RESET);
	
	//요청값 유효성 검사: currentPage, rowPerPage
	int currentPage = 1;
	int rowPerPage = 10;
	String answer = "all"; 
	//beginRow와 rowPerPage, answer가 null이 아닌 경우에 변수에 저장
	if(request.getParameter("currentPage") != null 
		&& request.getParameter("rowPerPage") != null){
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	} else if(request.getParameter("answer") != null){
		answer = request.getParameter("answer");
	}
	
	//변수 디버깅
	System.out.println(KMJ + currentPage + " <--adminReview currentPage" + RESET);
	System.out.println(KMJ + rowPerPage + " <--adminReview rowPerPage" + RESET);
	System.out.println(KMJ + answer + " <--adminReview answer" + RESET);

	int beginRow = (currentPage - 1)*rowPerPage;
	
	//리뷰목록 출력
	ReviewDao rDao = new ReviewDao();
	ArrayList<HashMap<String,Object>> list = rDao.selectReviewListByPage(beginRow, rowPerPage, answer);
	System.out.println(KMJ + list.size() + " <--adminReview list.size()" + RESET);

	//페이지네이션에 필요한 변수 선언
	int reviewCnt = rDao.selectReviewCnt(beginRow, rowPerPage, answer);
	int lastPage = reviewCnt / rowPerPage;
	//reviewCnt를 rowPerPage로 나눈 나머지가 있으면 lastPage + 1
	if(reviewCnt % rowPerPage != 0){
		lastPage = lastPage + 1;
	}
	int pagePerPage = 10;
	int startPage = ((currentPage - 1)/pagePerPage)*pagePerPage + 1;
	int endPage = startPage + pagePerPage - 1;
	//endPage가 lastPage보다 크면 endPage = lastPage
	if(endPage > lastPage){
		endPage = lastPage; 
	}
	
	//변수 디버깅
	System.out.println(KMJ + reviewCnt + " <--adminReview reviewCnt" + RESET);
	System.out.println(KMJ + lastPage + " <--adminReview lastPage" + RESET);
	System.out.println(KMJ + startPage + " <--adminReview startPage" + RESET);
	System.out.println(KMJ + lastPage + " <--adminReview endPage" + RESET);
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
            <div class="jumbotron jumbotron-bg text-center rounded-0" style="background-image: url('<%=request.getContextPath()%>/resources/assets/img/cherry_header.jpg');">
                <div class="container">
                    <h1 class="pt-5">
                        고객 리뷰목록
                    </h1>
                    <p class="lead">
                    </p>
                </div>
            </div>
        </div>

        <section id="cart">
            <div class="container">
            
            	<!-- 관리자메뉴 -->
            	<div class="row mb-5">
            		<div class="col-lg-12">
						<jsp:include page="/inc/adminNav.jsp"></jsp:include>
            		</div>
            	</div>
            
            	<div class="row justify-content-center"><!-- 검색조건 -->
            		<div class="col-md-12">
	            		<div class="card mb-5">
	                        <div class="card-body">
	                            <form class="form-horizontal" action="<%=request.getContextPath()%>/admin_review/adminReview.jsp" method="post">
	                                <div class="form-group row mt-3">
	                                	<div class="col-md-2 text-right">
	                                		<strong>답변여부</strong>
	                                	</div>
	                                    <div class="col-md-10">
	                                    	<div class="row">
	                                    		<%
													if(answer.equals("all")){
												%>
														<div class="col-2"><input class="mr-1" type="radio" name="answer" value="all" checked>전체</div>
														<div class="col-2"><input class="mr-1" type="radio" name="answer" value="true">답변대기</div>
														<div class="col-2"><input class="mr-1" type="radio" name="answer" value="false">답변완료</div>
												<%
													} else if (answer.equals("true")){
												%>
														<div class="col-2"><input class="mr-1" type="radio" name="answer" value="all">전체</div>
														<div class="col-2"><input class="mr-1" type="radio" name="answer" value="true" checked>답변대기</div>
														<div class="col-2"><input class="mr-1" type="radio" name="answer" value="false">답변완료</div>
												<%
													} else {
												%>
														<div class="col-2"><input class="mr-1" type="radio" name="answer" value="all">전체</div>
														<div class="col-2"><input class="mr-1" type="radio" name="answer" value="true">답변대기</div>
														<div class="col-2"><input class="mr-1" type="radio" name="answer" value="false" checked>답변완료</div>
												<%
													}
												%>
	                                    	</div>
	                                    </div>
	                                    
	                                </div>
	                                <div class="form-group text-center">
	                                    <button type="submit" class="btn btn-primary">검색</button>
	                                    <div class="clearfix"></div>
	                                </div>
	                            </form>
	                        </div>
	                    </div>
                    </div>
            	</div>
                <div class="row">
                    <div class="col-md-12">
                        <div class="table-responsive">
                            <table class="table text-center">
                                <thead>
                                    <tr>
                                        <th width="10%">후기번호</th>
										<th>주문번호</th>
										<th>제목</th>
										<th>조회수</th>
										<th>답변</th>
										<th>작성일시</th>
										<th>수정일시</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
										for(HashMap<String, Object> m : list){
									%>
											<tr>
												<td><%=(Integer)m.get("reviewNo")%></td>
												<td><%=(Integer)m.get("orderNo")%></td>
												<td><%=m.get("reviewTitle").toString().substring(0)%></td>
												<td><%=(Integer)m.get("reviewCheckCnt")%></td>
												<td>
													<% 
														if((Integer)m.get("cnt") > 0 ){
													%>
															<a class="btn btn-default btn-sm" href="<%=request.getContextPath()%>/admin_review/addReviewAnswer.jsp?reviewNo=<%=(Integer)m.get("reviewNo")%>">답변완료</a>
													<%
														} else {
													%>
															<a class="btn btn-primary btn-sm" href="<%=request.getContextPath()%>/admin_review/addReviewAnswer.jsp?reviewNo=<%=(Integer)m.get("reviewNo")%>">답변대기</a>
													<%
														}
													%>
												</td>
												<td><%=(String)m.get("createdate").toString().substring(0,10)%></td>
												<td><%=(String)m.get("updatedate").toString().substring(0,10)%></td>
											</tr>
									<%
										}
									%>
                                </tbody>
                            </table>
                        </div>

                        <nav aria-label="Page navigation">
                            <ul class="pagination justify-content-center">
								<!-- 첫페이지 -->
								<li class="page-item">
									<a class="page-link" href="<%=request.getContextPath()%>/admin_review/adminReview.jsp?currentPage=1">&#60;&#60;</a>
								</li>
								<!-- 이전 페이지블럭 (startPage - 1) -->
								<%
									if(startPage <= 1){ //startPage가 1인 페이지블럭에서는 '이전'버튼 비활성화
								%>
										<li class="page-item disabled"><a class="page-link" href="#">&#60;</a></li>
								<%	
									} else {
								%>
										<li class="page-item">
											<a class="page-link" href="<%=request.getContextPath()%>/admin_review/adminReview.jsp?currentPage=<%=startPage-1%>">&#60;</a>
										</li>
								<%
									}
								%>
								
								<!-- 현재페이지 -->
								<%
									for(int i=startPage; i<=endPage; i+=1){ //startPage~endPage 사이의 페이지i 출력하기
										if(currentPage == i){ //현재페이지와 i가 같은 경우에는 표시하기
								%>
										<li class="page-item active">
											<a class="page-link" href="<%=request.getContextPath()%>/admin_review/adminReview.jsp?currentPage=<%=i%>">
												<%=i%>
											</a>
										</li>
								<%
										} else {
								%>
										<li class="page-item">
											<a class="page-link" href="<%=request.getContextPath()%>/admin_review/adminReview.jsp?currentPage=<%=i%>">
												<%=i%>
											</a>
										</li>
								<%	
										}
									}
								%>
								<!-- 다음 페이지블럭 (endPage + 1) -->
								<%
									if(lastPage == endPage){ //마지막페이지에서는 '다음'버튼 비활성화
								%>
										<li class="page-item disabled"><a class="page-link" href="#">&#62;</a></li>
								<%	
									} else {
								%>
										<li class="page-item">
											<a class="page-link" href="<%=request.getContextPath()%>/admin_review/adminReview.jsp?currentPage=<%=endPage+1%>">&#62;</a>
										</li>
								<%
									}
								%>
								
								<!-- 마지막페이지 -->
								<li class="page-item">
									<a class="page-link" href="<%=request.getContextPath()%>/admin_review/adminReview.jsp?currentPage=<%=lastPage%>">&#62;&#62;</a>
								</li>
                            </ul>
                        </nav>
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
