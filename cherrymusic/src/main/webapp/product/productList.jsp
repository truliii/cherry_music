<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>

<%	
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	
	//request 인코딩
	request.setCharacterEncoding("utf-8");
	
	/* session 유효성 검사
	* session 값이 null이면 redirection. return.
	*/
	
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;	
	}
	
	// 현재 로그인 Id
	String loginId = null;
	if(session.getAttribute("loginId") != null){
		loginId = (String)session.getAttribute("loginId");
	}
	
	/* idLevel 유효성 검사
	 * idLevel == 0이면 redirection. return
	 * IdListDao selectIdListOne(loginId) method 호출
	*/
	
	IdListDao idListDao = new IdListDao();
	IdList idList = idListDao.selectIdListOne(loginId);
	int idLevel = idList.getIdLevel();
	
	if(idLevel == 0){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;	
	}
	// 아이디 레벨 검사 
	System.out.println(SJ+idLevel +"<-- idLevel" +RE );
	
	// dao 객체 생성
	ProductDao pDao = new ProductDao();
	
	// 상품 리스트 페이징
	// 현재페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 전체 행의 수
	int totalRow = pDao.selectProductCnt();
	// 페이지 당 행의 수
	int rowPerPage = 10;
	// 시작 행 번호
	int beginRow = (currentPage-1) * rowPerPage;
	// 마지막 페이지 번호
	int lastPage = totalRow / rowPerPage;
	// 표시하지 못한 행이 있을 경우 페이지 + 1
	if(totalRow % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
	// 현제 페이징 블럭의 들어갈 페이지 수
	int pagePerPage = 10;
	// 최소 페이지
	int minPage = (currentPage-1) / pagePerPage * pagePerPage + 1;
	// 최대 페이지
	int maxPage = minPage + pagePerPage - 1;
	// 최대 페이지가 마지막 페이지 보다 크면 최대 페이지 = 마지막 페이지
	if(maxPage > lastPage) {
		maxPage = lastPage;
	}
	
	// 상품조회 method(판매량 순)
	ArrayList<HashMap<String, Object>> cntList = pDao.selectSumCntByPage(true, beginRow, rowPerPage);
	
	// param("search") 값 저장 변수
	String search = "";
	// 검색된 값 저장 변수 초기화
	ArrayList<Product> sList = null;
	
	// 요청값(search) 유효성 검사
	if(request.getParameter("search") != null) {
		search = request.getParameter("search");
		System.out.println(search +"<--productList.jsp search");
		// 상품명 검색 method
		sList = pDao.searchProduct(search);
		
		if(sList != null){
			System.out.println(sList+"<--productList.jsp sList");
		} else{
			System.out.println(sList+"<--productList.jsp 검색된 상품명 없음");
		}
	} 
%>
<!DOCTYPE html>
<html>
<head>
	<jsp:include page="/inc/head.jsp"></jsp:include>
</head>
<body>
	<!-- header -->
	<jsp:include page="/inc/header.jsp"></jsp:include>
	
	<!-- main -->
	<div id="page-content" class="page-content">
		<!-- banner -->
		<div class="banner">
			<div class="jumbotron jumbotron-bg text-center rounded-0" style="background-image: url('<%=request.getContextPath()%>/resources/assets/img/cherry_header.jpg');">
				<div class="container">
					<h1 class="pt-5">
                        상품 관리
                    </h1>
				</div>
			</div>
		</div>
		<!-- content -->
		<div class="container" style="margin-top: 100px;">
			<div class="row">
				<div class="col-lg-12">
					<!-- adminNav -->
					<jsp:include page="/inc/adminNav.jsp"></jsp:include>
				</div>
				<div class="col-lg-12" style="margin-top: 50px;">
			    	<div style="display: flex; justify-content: space-between;">
					    <!-- 상품 등록 버튼 -->
					    <div>
					      	<button type="button" onclick="location.href='<%=request.getContextPath()%>/product/addProduct.jsp'" class="btn btn-primary">상품 등록</button>
					    </div>
					    <!-- 상품검색 폼 -->
					    <div>
					    	<form action="<%=request.getContextPath()%>/product/productList.jsp" method="post" style="display: flex;">
					        	<input type="text" name="search" class="form-control" style="margin-right: 5px;">
					        	<button type="submit" class="btn btn-primary">상품검색</button>
					      	</form>
					    </div>
			  		</div>
				</div>
				
				<!-- 상품 리스트, 상품명 검색 분기하여 출력 -->
				<div class="col-lg-12" style="margin-top: 20px;">
					<div>
						<table class="table">
							<thead>
								<tr>
									<th>상품번호</th>
									<th>카테고리</th>
									<th>상품명</th>
									<th>가격</th>
									<th>상태</th>
									<th>재고</th>
									<th>판매량</th>
								</tr>
							</thead>
							<tbody>
								<%
									if(sList == null){
										for(HashMap<String, Object> p : cntList) {
								%>
											<tr onclick="location.href='<%=request.getContextPath()%>/product/productDetail.jsp?productNo=<%=p.get("p.productNo")%>'" class="selectTr">
												<td><%=p.get("p.productNo")%></td>
												<td><%=p.get("categoryName")%></td>
												<td class="titleTd"><%=p.get("productName")%></td>
												<td><%=p.get("productPrice")%></td>
												<td><%=p.get("productStatus")%></td>
												<td><%=p.get("productStock")%></td>
												<td><%=p.get("productSumCnt")%></td>
											</tr>
								<%		
										}
									} else{
										for(Product p : sList){
								%>
											<tr onclick="location.href='<%=request.getContextPath()%>/product/productDetail.jsp?productNo=<%=p.getProductNo()%>'" class="selectTr">
												<td><%=p.getProductNo()%></td>
												<td><%=p.getCategoryName()%></td>
												<td class="titleTd"><%=p.getProductName()%></td>
												<td><%=p.getProductPrice()%></td>
												<td><%=p.getProductStatus()%></td>
												<td><%=p.getProductStock()%></td>
												<td><%=p.getProductSumCnt()%></td>
											</tr>
								<%		
										}
									}
								%>
							</tbody>
						</table>
					</div>
					<!-- 페이지 네비게이션 
						* sList가 null이 아닌경우만 페이지 네비게이션 출력
					-->
					<%
						if(sList == null){ 
					%>
				    <div class="d-flex justify-content-center">
						<ul class="pagination">
							<!-- 첫페이지 -->
							<li class="page-item">
								<a class="page-link" href="<%=request.getContextPath()%>/product/productList.jsp?currentPage=1">&#60;&#60;</a>
							</li>
							<!-- 이전 페이지블럭 (startPage - 1) -->
							<%
								if(minPage <= 1){ //startPage가 1인 페이지블럭에서는 '이전'버튼 비활성화
							%>
									<li class="page-item disabled"><a class="page-link" href="#">&#60;</a></li>
							<%	
								} else {
							%>
									<li class="page-item">
										<a class="page-link" href="<%=request.getContextPath()%>/product/productList.jsp?currentPage=<%=minPage-1%>">&#60;</a>
									</li>
							<%
								}
							%>
							
							<!-- 현재페이지 -->
							<%
								for(int i=minPage; i<=maxPage; i+=1){ //startPage~endPage 사이의 페이지i 출력하기
									if(currentPage == i){ //현재페이지와 i가 같은 경우에는 표시하기
							%>
									<li class="page-item active">
										<a class="page-link" href="<%=request.getContextPath()%>/product/productList.jsp?currentPage=<%=i%>">
											<%=i%>
										</a>
									</li>
							<%
									} else {
							%>
									<li class="page-item">
										<a class="page-link" href="<%=request.getContextPath()%>/product/productList.jsp?currentPage=<%=i%>">
											<%=i%>
										</a>
									</li>
							<%	
									}
								}
							%>
							<!-- 다음 페이지블럭 (endPage + 1) -->
							<%
								if(lastPage == maxPage){ //마지막페이지에서는 '다음'버튼 비활성화
							%>
									<li class="page-item disabled"><a class="page-link" href="#">&#62;</a></li>
							<%	
								} else {
							%>
									<li class="page-item">
										<a class="page-link" href="<%=request.getContextPath()%>/product/productList.jsp?currentPage=<%=maxPage+1%>">&#62;</a>
									</li>
							<%
								}
							%>
							
							<!-- 마지막페이지 -->
							<li class="page-item">
								<a class="page-link" href="<%=request.getContextPath()%>/product/productList.jsp?currentPage=<%=lastPage%>">&#62;&#62;</a>
							</li>
						</ul>	
					</div>
					<%		
						}
					%> 
				</div>
			</div>
		</div>
	</div>
	<!-- footer -->		
	 <footer>
        <jsp:include page="/inc/footer.jsp"></jsp:include>
    </footer>	
	<!-- 자바스크립트 -->
	<jsp:include page="/inc/script.jsp"></jsp:include>
</body>
</html>