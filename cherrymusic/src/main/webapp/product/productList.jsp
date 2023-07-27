<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>

<%	
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	
	
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
	// 현재페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}

	
	int productNo = 1;
	// sql 메서드들이 있는 클래스의 객체 생성
	ProductDao pDao = new ProductDao();
	DiscountDao dDao = new DiscountDao();
	
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
	
	
	// 현재 페이지에 표시 할 리스트
	ArrayList<HashMap<String, Object>> list = pDao.selectProductNoByPage(true, beginRow, rowPerPage);
	ArrayList<HashMap<String, Object>> dList = dDao.selectDiscount(beginRow, rowPerPage);
	ArrayList<HashMap<String, Object>> dayList = pDao.selectProduct(productNo);
	
	// 다양한 상품 출력을 위한 리스트
	// 판매량 순
	ArrayList<HashMap<String, Object>> cntList = pDao.selectSumCntByPage(true, beginRow, rowPerPage);
	// pop
	ArrayList<HashMap<String, Object>> popList = pDao.selectPopByPage(true, beginRow, rowPerPage);
	// kpop
	ArrayList<HashMap<String, Object>> kpopList = pDao.selectKpopByPage(true, beginRow, rowPerPage);
	// classic
	ArrayList<HashMap<String, Object>> classicList = pDao.selectClassicByPage(true, beginRow, rowPerPage);
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Admin Customer One</title>
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
                  <li aria-current="page" class="breadcrumb-item active">마이페이지</li>
                </ol>
              </nav>
            </div>
            <div class="col-lg-3">
              <!-- 고객메뉴 시작 -->
              <div class="card sidebar-menu">
                <div class="card-header">
                  <h3 class="h4 card-title">관리자 메뉴</h3>
                </div>
                <div class="card-body">
                  <ul class="nav nav-pills flex-column">
	                  <a href="#" class="nav-link "><i class="fa fa-list"></i>통계</a>
	                  <a href="#" class="nav-link "><i class="fa fa-list"></i>카테고리관리</a>
	                  <a href="<%=request.getContextPath()%>/product/productList.jsp" class="nav-link active "><i class="fa fa-list"></i>상품관리</a>
	                  <a href="<%=request.getContextPath()%>/admin_customer/adminCustomerList.jsp?id=<%=loginId%>&currentPage=1" class="nav-link"><i class="fa fa-list"></i>회원관리</a>
	                  <a href="<%=request.getContextPath()%>/admin_orders/adminOrders.jsp?id=<%=loginId%>&currentPage=1" class="nav-link"><i class="fa fa-list"></i>주문관리</a>
	                  <a href="#" class="nav-link "><i class="fa fa-list"></i>문의관리</a>
	                  <a href="<%=request.getContextPath()%>/admin_review/adminReview.jsp?id=<%=loginId%>&currentPage=1" class="nav-link "><i class="fa fa-list"></i>리뷰관리</a>
                </ul></div>
              </div>
              <!-- /.col-lg-3-->
              <!-- 고객메뉴 끝 -->
            </div>
            <div class="col-lg-9">
              <div class="box">
              	<!-- 상세정보 -->
				<div>
								<table class="table table-borderless">
	<h1>관리페이지 : 상품 리스트</h1>
	<div>
		<a href="<%=request.getContextPath()%>/product/addProduct.jsp">
			<button type="button" >추가</button>
		</a>
	</div>
	<form action="<%=request.getContextPath()%>/product/searchProduct.jsp" method="post">
		<input type="text" name = "search">
		<button type="submit" >검색</button>
	</form>
	<h1>판매량순 전체 리스트</h1>
		<table >
			<tr>
				<th >p no.</th>
				<th >판매량</th>
				<th >카테고리</th>
				<th >이름</th>
				<th >가격</th>
				<th >상태</th>
				<th >재고</th>
				<th >등록일</th>
				<th >수정일</th>
				
			</tr>
			<%
				for(HashMap<String, Object> p : cntList) {
			%>
					<tr>
						<td>
							<a href="<%=request.getContextPath()%>/product/productDetail.jsp?p.productNo=<%=p.get("p.productNo")%>&dproductNo=<%=p.get("dProductNo")%>&discountRate=<%=p.get("discountRate")%>">
								<%=p.get("p.productNo")%>
							</a>
						</td>
						<td><%=p.get("productSumCnt")%></td>
						<td><%=p.get("categoryName")%></td>
						<td><%=p.get("productName")%></td>
						<td><%=p.get("productPrice")%></td>
						<td><%=p.get("productStatus")%></td>
						<td><%=p.get("productStock")%></td>
						<td><%=p.get("p.createdate")%></td>
						<td><%=p.get("p.updatedate")%></td>
						<td>
						
						</td>
					</tr>
			<%		
				}
			%>
			
		</table>
		
	<%
		// 페이징 수
		int pagePerPage = 10;
		// 최소 페이지
		int minPage = (currentPage-1) / pagePerPage * pagePerPage + 1;
		// 최대 페이지
		int maxPage = minPage + pagePerPage - 1;
		// 최대 페이지가 마지막 페이지 보다 크면 최대 페이지 = 마지막 페이지
		if(maxPage > lastPage) {
			maxPage = lastPage;
		}
		// 이전 페이지
		// 최소 페이지가 1보타 클 경우 이전 페이지 표시
		if(minPage>1) {
	%>
			<a href="<%=request.getContextPath()%>/product/productList.jsp?currentPage=<%=minPage-pagePerPage%>">이전</a>
	<%			
		}
		// 최소 페이지부터 최대 페이지까지 표시
		for(int i = minPage; i<=maxPage; i=i+1) {
			if(i == currentPage) {	// 현재페이지는 링크 비활성화
	%>	
			<%=i%>
	<%			
			}else {					// 현재페이지가 아닌 페이지는 링크 활성화
	%>	
				<a href="<%=request.getContextPath()%>/product/productList.jsp?currentPage=<%=i%>"><%=i%></a>
	<%				
			}
		}
		// 다음 페이지
		// 최대 페이지가 마지막 페이지와 다를 경우 다음 페이지 표시
		if(maxPage != lastPage) {
	%>
			<a href="<%=request.getContextPath()%>/product/productList.jsp?currentPage=<%=minPage+pagePerPage%>">다음</a>
	<%	
		}
	%>
					</table></div>
					</div>
				</div>
              </div>
            </div>
          </div>
        </div>
</body>
</html>