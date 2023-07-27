<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>

<%	
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	request.setCharacterEncoding("utf-8");
	String search = null;
	if(request.getParameter("search") != null) {
		search = request.getParameter("search");
	} else {
		response.sendRedirect(request.getContextPath()+"/product/productHome.jsp");
		return;	
	}
	
	System.out.println(SJ+search + RE );
	// 객체 생성
	ProductDao pDao = new ProductDao();
	ArrayList<Product> sList = pDao.searchProduct(search);
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
	                  <a href="<%=request.getContextPath()%>/admin_customer/adminCustomerList.jsp?currentPage=1" class="nav-link"><i class="fa fa-list"></i>회원관리</a>
	                  <a href="<%=request.getContextPath()%>/admin_orders/adminOrders.jsp?currentPage=1" class="nav-link"><i class="fa fa-list"></i>주문관리</a>
	                  <a href="#" class="nav-link "><i class="fa fa-list"></i>문의관리</a>
	                  <a href="<%=request.getContextPath()%>/admin_review/adminReview.jsp?currentPage=1" class="nav-link "><i class="fa fa-list"></i>리뷰관리</a>
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
	<div>
		<a href="<%=request.getContextPath()%>/product/productHome.jsp">
			<button type="button">목록으로</button>
		</a>
	</div>
	<table >
	<h1>"<%=search %>" 검색결과</h1>
		<tr>
			<th >p no.</th>
			<th >카테고리</th>
			<th >이름</th>
			<th >가격</th>
			<th >상태</th>
			<th >재고</th>
			<th >등록일</th>
			<th >수정일</th>
		</tr>
		<%
			for(Product p : sList) {
				// 할인 기간 확인을 위한 변수와 분기
				
		%>
				<tr>
					<td>
						<a href="<%=request.getContextPath()%>/product/productDetail.jsp?p.productNo=<%=p.getProductNo()%>">
							<%=p.getProductNo()%>
						</a>
					</td>
					<td><%=p.getCategoryName()%></td>
					<td><%=p.getProductName()%></td>
					<td><%=p.getProductPrice()%></td>
					<td><%=p.getProductStatus()%></td>
					<td><%=p.getProductStock()%></td>
					<td><%=p.getCreatedate()%></td>
					<td><%=p.getUpdatedate()%></td>
				</tr>
		<%		
			}
		%>
					</table></table></div>
					</div>
				</div>
              </div>
            </div>
          </div>
        </div>
</body>
</html>