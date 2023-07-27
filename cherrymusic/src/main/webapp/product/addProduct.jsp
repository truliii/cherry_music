<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*"%>
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
	                  <a href="<%=request.getContextPath()%>/product/productList.jsp?id=<%=loginId%>" class="nav-link active "><i class="fa fa-list"></i>상품관리</a>
	                  <a href="<%=request.getContextPath()%>/admin_customer/adminCustomerList.jsp?id=<%=loginId%>&currentPage=1" class="nav-link"><i class="fa fa-list"></i>회원관리</a>
	                  <a href="<%=request.getContextPath()%>/admin_orders/adminOrders.jsp?id=<%=loginId%>&currentPage=1" class="nav-link"><i class="fa fa-list"></i>주문관리</a>
	                  <a href="#" class="nav-link "><i class="fa fa-list"></i>문의관리</a>
	                  <a href="<%=request.getContextPath()%>/admin_review/adminReview.jsp?id=<%=loginId%>&currentPage=1" class="nav-link "><i class="fa fa-list"></i>리뷰관리</a>
                </div>
              </div>
              <!-- /.col-lg-3-->
              <!-- 고객메뉴 끝 -->
            </div>
            <div class="col-lg-9">
              <div class="box">
              	<!-- 상세정보 -->
				<div>
<title>관리자 상품 추가 페이지</title>
</head>
<body>
	<div >
		<a href="<%=request.getContextPath()%>/product/productList.jsp">
			<button type="button">목록으로</button>
		</a>
	</div>
	<div class="container">
	<h1>관리자 페이지 : 상품추가</h1>
	<form action = "<%=request.getContextPath()%>/product/addProductAction.jsp" method="post" encType="multipart/form-data">
		<table>
			
			<tr>
				<th>카테고리</th>
				<td><input type="text" name="categoryName"></td>
			</tr>
			<tr>
				<th>상품 이름</th>
				<td><input type="text" name="productName"></td>
			</tr>
			<tr>
				<th>상품 가격</th>
				<td><input type="number" name="productPrice"></td>
			</tr>
			<tr>
				<th>상품 상태</th>
				<td>
					<select name = "productStatus">
						<option value = "예약판매">예약판매</option>
						<option value = "판매중">판매중</option>
						<option value = "품절">품절</option>
					</select>
				</td>
			</tr>
			<tr>
				<th>재고</th>
				<td><input type="number" name="productStock"></td>
			</tr>
			<tr>
				<th>내용</th>
				<td><input type="text" name="productInfo"></td>
			</tr>
			<tr>
				<th>상품이미지 업로드</th>
				<td>
					<input type="file" name="boardFile" required="required">
				</td>
			</tr>
		</table>
		<button type="submit">추가</button>
	</form></div>
					</div>
				</div>
              </div>
            </div>
          </div>
        </div>
      </div>
</body>
</html>