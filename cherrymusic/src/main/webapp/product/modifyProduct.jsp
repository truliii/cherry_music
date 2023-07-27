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
	
	// 현재 로그인 I
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
	
	int idLevel = 1;
	
	if(idLevel == 0){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;	
	}
	// 요청값 유효성 검사
	if(request.getParameter("p.productNo") == null  
		|| request.getParameter("p.productNo").equals("")) {
		
		response.sendRedirect(request.getContextPath() + "/product/productList.jsp");
		return;
	}
	// 요청값 변수에 저장
	int productNo = Integer.parseInt(request.getParameter("p.productNo"));
	int beginRow = 1;
	int rowPerPage = 10;
	// sql 메서드들이 있는 클래스의 객체 생성
	ProductDao pDao = new ProductDao();
	DiscountDao dDao = new DiscountDao();
	
	ArrayList<HashMap<String, Object>> list = pDao.selectProduct(productNo);
	ArrayList<HashMap<String, Object>> dList = dDao.selectDiscount(beginRow, rowPerPage);
	Product product = new Product();
	ProductImg productImg = new ProductImg();
	Discount discount = new Discount();
	
	// product 정보 변수에 저장
	String productStatus = null;
	String categoryName = null;
	String productName = null;
	int productPrice = 0;
	int productStock = 0;
	double discountRate = 0.0;
	String productInfo = null;
	String productSaveFilename = null;
	String discountStart = null;
	String discountEnd = null;
	for(HashMap<String, Object> p : list) {
		productStatus = p.get("productStatus").toString();
		categoryName = p.get("categoryName").toString();
		productName = p.get("productName").toString();
		productPrice = Integer.parseInt(p.get("productPrice").toString());
		productStock = Integer.parseInt(p.get("productStock").toString());
		productInfo = p.get("productInfo").toString();
		productSaveFilename = p.get("productSaveFilename").toString();
	}
	// discount 정보 변수에 저장
	if(request.getParameter("discountRate") != null) {
		discountRate = Double.parseDouble(request.getParameter("discountRate").toString());
	} else {
		discountRate = 0.0;
	}
	if(request.getParameter("discountStart") != null) {
		discountStart = request.getParameter("discountStart").toString();
	} else {
		discountStart = null;
	}
	if(request.getParameter("discountEnd") != null) {
		discountEnd = request.getParameter("discountEnd").toString();
	} else {
		discountEnd = null;
	}
	String dir = request.getContextPath() + "/product/productImg/" + productSaveFilename;
	System.out.println(SJ+ dir + "<-dir" +RE);
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
               </ul> </div>
              </div>
              <!-- /.col-lg-3-->
              <!-- 고객메뉴 끝 -->
            </div>
            <div class="col-lg-9">
              <div class="box">
              	<!-- 상세정보 -->
				<div>
	<form action = "<%=request.getContextPath()%>/product/modifyProductAction.jsp" method="post" encType="multipart/form-data">
		<div> 상품 번호 <input type="number" readonly="readonly" name = "productNo" value = "<%=productNo%>"></div>
		<div> 상품 카테고리
			<input type="text" name = "categoryName" value = "<%=categoryName%>">
		</div>
		
		<div>상품명 
			<input type="text" name = "productName" value = "<%=productName%>">
		</div>
		
		<div>상품 설명 
			<textarea rows="3" cols="100" name = "productInfo"><%=productInfo%></textarea>
		</div>
		
		<div>상품 가격 
			<input type="number" name = "productPrice" value="<%=productPrice%>">
		</div>
		<div>상품 상태
			<select name="productStatus">
				<option <%if(productStatus.equals("판매중")){ %> selected <% } %>>판매중</option>
				<option <%if(productStatus.equals("품절")){ %> selected <% } %>>품절</option>
				<option <%if(productStatus.equals("예약판매")){ %> selected <% } %>>예약판매</option>
			</select>
		</div>
		
		<div>재고량 
			<input type="number" name = "productStock" value="<%=productStock%>">
		</div> 
		<div>할인율
			<input type="text" name = "discountRate" value="<%=discountRate%>">
		</div>
		<div>할인 시작 
			<input type="date" name = "discountStart" value="<%=discountStart%>">
		</div>
		<div>할인 종료
			<input type="date" name = "discountEnd" value="<%=discountEnd%>">
		</div>
		<div>상품 이미지  
			<img src="<%=dir%>" id="preview" width="300px">
			<input type="hidden" name = "beforeProductImg" value="<%=productSaveFilename%>">
			<input type="file" name = "productImg" onchange="previewImage(event)">
		</div> 
		
		<div>
			<button type="submit">수정</button>
			<button type="submit" formaction="<%=request.getContextPath()%>/product/productList.jsp">이전</button>
</div></form></div>
					</div>
				</div>
              </div>
            </div>
          </div>
        </div>
      </div>
</body>
</html>