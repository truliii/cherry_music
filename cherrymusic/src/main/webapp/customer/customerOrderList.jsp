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
		System.out.println(KMJ + "customerOrderList 로그인 필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	}
	System.out.println(KMJ + loginId + " <--customerOrderList loginId");
	
	//요청값 유효성 검사
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 10;
	int beginRow = (currentPage - 1)*rowPerPage;
	System.out.println(KMJ + currentPage + " <--customerOrderList currentPage" + RESET);
	System.out.println(KMJ + rowPerPage + " <--customerOrderList rowPerPage" + RESET);
	System.out.println(KMJ + beginRow + " <--customerOrderList beginRow" + RESET);
	
	//id에 따른 주문목록 출력
	OrdersDao oDao = new OrdersDao();
	ArrayList<HashMap<String, Object>> list = oDao.selectOrderById(loginId, beginRow, rowPerPage);
	System.out.println(KMJ + list.size() + " <--orderList list.size()" + RESET);
	String dir = request.getServletContext().getRealPath("/productImg");
	
	//주문번호별 리뷰 수 (리뷰는 한 주문(상품) 당 1개만 가능) 출력
	ReviewDao rDao = new ReviewDao();
	
	//페이지네이션에 필요한 변수 선언: ordersCnt, lastPage, pagePerPage, startPage, endPage
	int ordersCnt = oDao.selectOrderCntById(loginId);
	int lastPage = ordersCnt / rowPerPage;
	//ordersCnt를 rowPerPage로 나눈 나머지가 있으면 lastPage + 1
	if(ordersCnt % rowPerPage != 0){
		lastPage = lastPage + 1;
	}
	int pagePerPage = 10;
	int startPage = ((currentPage - 1)/pagePerPage)*pagePerPage + 1;
	int endPage = startPage + pagePerPage - 1;
	//endPage가 lastPage보다 크면 endPage = lastPage
	if(endPage > lastPage){
		endPage = lastPage; 
	}
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
                        고객 주문목록
                    </h1>
                    <p class="lead">
                    </p>
                </div>
            </div>
        </div>

        <section id="cart">
            <div class="container">
                <div class="row">
                    <div class="col-md-12">
                        <div class="table-responsive">
                            <table class="table text-center">
                                <thead>
                                    <tr>
                                        <th width="5%"></th>
                                        <th>주문번호</th>
                                        <th>주문상품</th>
                                        <th>주문수량</th>
                                        <th>주문일자</th>
                                        <th>결제금액</th>
                                        <th>결제상태</th>
                                        <th>배송상태</th>
                                        <th>상품후기</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                    	int num = 0;
				                   		for(HashMap<String, Object> m : list){
				                   			int reviewCnt = rDao.selectReviewCntByOrderNo((Integer)m.get("orderNo"));
				                   			num += 1;
				                   	%>
				                   			<tr>
				                   				<td><%=num%></td>
				                   				<td><%=m.get("orderNo")%></td>
				                   				<td>
													<!-- <img src="<%=request.getContextPath()%>/product/productImg/" alt="이미지준비중"> -->
													<%=(String)m.get("productName")%>
												</td>
												<td><%=(Integer)m.get("orderCnt")%></td>
				                   				<td><%=m.get("createdate").toString().substring(0, 11)%></td>
												<td><%=(Integer)m.get("orderPrice")%></td>
												<td><span id="paymentStatus" class="badge"><%=(String)m.get("paymentStatus")%></span></td>
												<td><span id="deliveryStatus" class="badge"><%=(String)m.get("deliveryStatus")%></span></td>
												<%
													if(reviewCnt == 0){ //해당 주문번호의 리뷰 수가 0일 경우에는 리뷰작성 출력
												%>
														<td><a class="btn btn-primary" href="<%=request.getContextPath()%>/review/addReview.jsp?orderNo=<%=(Integer)m.get("orderNo")%>">리뷰작성</a></td>
												<%
													} else {
														HashMap<String, Object> review = rDao.selectReviewByOrderNo((Integer)m.get("orderNo"));
														int reviewNo = (Integer)review.get("reviewNo");
												%>
														<td><a class="btn btn-default" href="<%=request.getContextPath()%>/review/reviewOne.jsp?reviewNo=<%=reviewNo%>&id=<%=loginId%>">리뷰보기</a></td>
												<%
													}
												%>
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
									<a class="page-link" href="<%=request.getContextPath()%>/customer/customerOrderList.jsp?id=<%=loginId%>&currentPage=1">&#60;&#60;</a>
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
											<a class="page-link" href="<%=request.getContextPath()%>/customer/customerOrderList.jsp?id=<%=loginId%>&currentPage=<%=startPage-1%>">&#60;</a>
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
											<a class="page-link" href="<%=request.getContextPath()%>/customer/customerOrderList.jsp?id=<%=loginId%>&currentPage=<%=i%>">
												<%=i%>
											</a>
										</li>
								<%
										} else {
								%>
										<li class="page-item">
											<a class="page-link" href="<%=request.getContextPath()%>/customer/customerOrderList.jsp?id=<%=loginId%>&currentPage=<%=i%>">
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
											<a class="page-link" href="<%=request.getContextPath()%>/customer/customerOrderList.jsp?id=<%=loginId%>&currentPage=<%=endPage+1%>">&#62;</a>
										</li>
								<%
									}
								%>
								
								<!-- 마지막페이지 -->
								<li class="page-item">
									<a class="page-link" href="<%=request.getContextPath()%>/customer/customerOrderList.jsp?id=<%=loginId%>&currentPage=<%=lastPage%>">&#62;&#62;</a>
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
    <script>
		//결제상태, 배송상태 색 바꾸기
		const payStat = document.querySelectorAll("#paymentStatus");
		const delStat = document.querySelectorAll("#deliveryStatus");
		payStat.forEach(function(item, index){
			if(item.innerHTML === '결제대기'){
				item.classList.add('badge-warning');
			} else if (item.innerHTML === '결제완료'){
				item.classList.add("badge-success");
			} else if (item.innerHTML === '취소'){
				item.classList.add('badge badge-danger');
			} else {
				item.classList.add('badge badge-info');
			}
		})
		
		delStat.forEach(function(item, index){
			if(item.innerHTML === '발송준비'){
				item.classList.add('badge-secondary');
			} else if (item.innerHTML === '발송완료'){
				item.classList.add('badge-primary');
			} else if (item.innerHTML === '배송중'){
				item.classList.add('badge-warning');
			} else if(item.innerHTML === '배송완료'){
				item.classList.add('badge-info');
			} else {
				item.classList.add('badge-success');
			}
		})
		
	</script>
</body>
</html>
