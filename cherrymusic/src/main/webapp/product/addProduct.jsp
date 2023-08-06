<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*"%>
<%@ page import="java.util.*"%>
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
	
	// CategoryDao
	CategoryDao categoryDao = new CategoryDao();
	
	// CategoryList 조회 method
	ArrayList<Category> list = categoryDao.selectCategoryList();
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
				<!-- 상품등록 폼 -->
					<div class="col-lg-12" style="margin-top: 50px;">
						<form id="addProduct" method="post" encType="multipart/form-data">
						<div>
							<table class="table">
								<tr>
									<th>카테고리</th>
									<td>
										<select id ="category" name="categoryName" class="form-control w-25">
											<%
												for (Category c : list){
											%>
													<option value="<%=c.getCategoryName()%>"><%=c.getCategoryName()%></option>
											<%	
												}
											%>
										</select>
									</td>
								</tr>
								<tr>
									<th>상품명</th>
									<td><input type="text" id="productName" name="productName" class="form-control"></td>
								</tr>
								<tr>
									<th>상품 가격</th>
									<td><input type="number" id="productPrice" name="productPrice" class="form-control w-25"></td>
								</tr>
								<tr>
									<th>상품 상태</th>
									<td>
										<select id="productStatus" name="productStatus" class="form-control w-25">
											<option value = "예약판매">예약판매</option>
											<option value = "판매중">판매중</option>
											<option value = "품절">품절</option>
										</select>
									</td>
								</tr>
								<tr>
									<th>재고</th>
									<td><input type="number" id="productStock" name="productStock" class="form-control w-25"></td>
								</tr>
								<tr>
									<th>상세정보</th>
									<td>
										<textarea rows="5" id="productInfo" name="productInfo" class="form-control"></textarea>
									</td>
								</tr>
								<tr>
									<th>상품 이미지</th>
									<td>
										<input type="file" id="boardFile" name="boardFile" required="required">
									</td>
								</tr>
							</table>
						</div>
						<div class="text-right">
							<button type="button" id="addProductBtn" class="btn btn-primary">상품등록</button>
							<button onclick="location.href='<%=request.getContextPath()%>/product/productList.jsp'" class="btn btn-primary">목록</button>
						</div>
					</form>
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
<script>
	// addProductBtn click
	$("#addProductBtn").on('click', function(){
		
		// 값 저장
		let productName = $('#productName').val();
		let productPrice = $('#productPrice').val();
		let productStock = $('#productStock').val();
		let productInfo = $('#productInfo').val();
		let boardFile = $('#boardFile').val();
		
		// 입력값이 비어있는지 확인
		if(productName.trim() == ''){
			alert('상품명을 입력해주세요');
			 $('#productName').focus();
			return;
		} else if(productPrice.trim() == ''){
			alert('상품가격을 입력해주세요');
			$('#productPrice').focus();
			return;
		} else if(productStock.trim() == ''){
			alert('재고량을 입력해주세요');
			$('#productStock').focus();
			return;
		} else if(productInfo.trim() == ''){
			alert('상품 상세정보를 입력해주세요');
			$('#productInfo').focus();
			return;
		} else if(boardFile.trim() == ''){
			alert('상품 이미지를 등록해주세요');
			$('#boardFile').focus();
			return;
		}
		
		// 입력값이 있을 경우 addProductDiscountAction.jsp 이동
		let addProductUrl = '<%=request.getContextPath()%>/product/addProductAction.jsp';
		$('#addProduct').attr('action', addProductUrl);
		$('#addProduct').submit();
	});
</script>
</html>