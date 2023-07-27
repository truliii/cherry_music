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

<body class="sub_page">

  <div class="hero_area">
    <div class="bg-box">
      <img src="<%=request.getContextPath()%>/resources/images/hero-bg.jpg" alt="">
    </div>
    <!-- header section strats -->
    <jsp:include page="/inc/header.jsp"></jsp:include>
    <!-- end header section -->
  </div>

  <!-- mypage section -->

  <section class="food_section layout_padding">
    <div class="container">
      <div class="heading_container heading_center">
        <h2>
          My page
        </h2>
      </div>

      <ul class="filters_menu">
        <li><a href="<%=request.getContextPath()%>/customer/customerOne.jsp">profile</a></li>
        <li class="active"><a href="<%=request.getContextPath()%>/customer/customerOrderList.jsp">Order List</a></li>
      </ul>

      <div class="filters-content">
        <div class="row grid">
        	<div class="col-sm-6 col-lg-12 all pizza">
	          <table class="table table-hover">
                    <thead>
                      <tr>
						<td colspan="2">주문상품</td>
						<td>주문수량</td>
						<td>주문금액</td>
						<td>결제상태</td>
						<td>배송상태</td>
						<td>주문일자</td>
						<td>리뷰작성</td>
                      </tr>
                    </thead>
                    <tbody>
                   	<%
                   		for(HashMap<String, Object> m : list){
                   			int orderNo = rDao.selectReviewCntByOrderNo((Integer)m.get("orderNo"));
                   	%>
                   			<tr>
								<td colspan="2">
									<!-- <img src="<%=request.getContextPath()%>/product/productImg/" alt="이미지준비중"> -->
									<%=(String)m.get("productName")%>
								</td>
								<td><%=(Integer)m.get("orderCnt")%></td>
								<td><%=(Integer)m.get("orderPrice")%></td>
								<td><span id="paymentStatus" class="badge"><%=(String)m.get("paymentStatus")%></span></td>
								<td><span id="deliveryStatus" class="badge"><%=(String)m.get("deliveryStatus")%></span></td>
								<td><%=m.get("createdate").toString().substring(0, 11)%></td>
								<%
									if(orderNo == 0){ //해당 주문번호의 리뷰 수가 0일 경우에는 리뷰작성 출력
								%>
										<td><a class="btn btn-primary" href="<%=request.getContextPath()%>/review/addReview.jsp?orderNo=<%=(Integer)m.get("orderNo")%>">리뷰작성</a></td>
								<%
									} else {
										HashMap<String, Object> review = rDao.selectReviewByOrderNo((Integer)m.get("orderNo"));
										int reviewNo = (Integer)review.get("reviewNo");
								%>
										<td><a class="btn btn-outline-primary" href="<%=request.getContextPath()%>/review/reviewOne.jsp?reviewNo=<%=reviewNo%>&id=<%=loginId%>">리뷰보기</a></td>
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
        </div>
      </div>
      <div>
      <!-- 페이지네이션 -->
		<ul class="pagination">
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
		</div>
		<!-- 페이지네이션 끝 -->
      </div>
  </section>

  <!-- end mypage section -->

  <!-- footer section -->
  <jsp:include page="/inc/footer.jsp"></jsp:include>
  <!-- footer section -->

<jsp:include page="/inc/script.jsp"></jsp:include>

</body>

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

</html>
