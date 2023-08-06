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
	if(request.getParameter("productNo") == null  
		|| request.getParameter("productNo").equals("")) {
		// 값이 없으면 productList.jsp 리턴
		response.sendRedirect(request.getContextPath() + "/product/productList.jsp");
		return;
	}
	// 요청값 변수에 저장
	int productNo = Integer.parseInt(request.getParameter("productNo"));
	// 디버깅 코드
	System.out.println(productNo+"<-- modifyProduct.jsp productNo");
	
	// Dao 객체 생성
	ProductDao pDao = new ProductDao();
	DiscountDao dDao = new DiscountDao();
	CategoryDao categoryDao = new CategoryDao();
	
	// 상품 상세내용 조회 method
	HashMap<String, Object> p = pDao.selectProductOne(productNo);
	
	// CategoryList 조회 method
	ArrayList<Category> cList = categoryDao.selectCategoryList();
	
	// 상품가격 변수 초기화
	int productPrice = 0;
	
	// 상품 이미지 정보 변수 초기화
	String productSaveFilename = null;
	
	// 할인율 정보 변수 초기화
	int discountNo = 0; // 할인상품 번호
	double discountRate = 0.0; // 할인율
	String dStartYear = null; // 할인 시작 년
	String dStartMonth = null; // 할인 시작 월
	String dStartDay = null; // 할인 시작 일
	String [] dStartDateArr = null; // 할인 시작날짜 배열
	String dStartDate = null; // 할인 시작날짜
	
	String dEndYear = null; // 할인 종료 년
	String dEndMonth = null; // 할인 종료 월
	String dEndDay = null; // 할인 종료 일
	String dEndDateArr [] = null; // 할인 종료날짜 배열
	String dEndDate = null; // 할인 종료날짜
	
	double dProductPrice = 0; // 할인가격
	
	// 할인율 정보 담을 변수 초기화
	ArrayList<HashMap<String, Object>> d = null;
	
	// Discount vo (현재 할인율 저장)
	Discount dCurrentInfo = null;
	
	// p(상품 정보 저장 변수) 값의 따른 분기
	if(p != null){
		// 상품 파일명, 상품가격 저장
		productSaveFilename = (String)p.get("productSaveFilename");
		productPrice = (int)p.get("productPrice");
		
		// 상품에 적용된 할인 정보 조회 method
		d = dDao.selectDiscountProduct(productNo);
		
		/* 할인 정보 유무에 따른 분기
		 * 정보가 있으면 현재 할인율 정보 조회 method
		*/
		if (d != null && !d.isEmpty()) { // d(할인 정보 담은 변수)가 null이 아니고 비어있지 않을 때
		    // Discount vo에 현재 할인율 정보 값 저장
			dCurrentInfo = dDao.selectProductCurrentDiscount(productNo);
		    if(dCurrentInfo != null){ // dCurrentInfo 가 null이 아닐때
		    	dStartYear = dCurrentInfo.getDiscountStart().substring(0, 4);
			    dStartMonth = dCurrentInfo.getDiscountStart().substring(5, 7);
			    dStartDay = dCurrentInfo.getDiscountStart().substring(8, 10);
			    dEndYear = dCurrentInfo.getDiscountEnd().substring(0, 4);
			    dEndMonth = dCurrentInfo.getDiscountEnd().substring(5, 7);
			    dEndDay = dCurrentInfo.getDiscountEnd().substring(8, 10);
			    discountRate = dCurrentInfo.getDiscountRate();
			    discountNo = dCurrentInfo.getDiscountNo();
			 	
			    // 할인가격, 할인 시작일, 할인 종료일 
			 	dProductPrice = (int)productPrice * (1 - discountRate);
			    dStartDateArr = new String[]{dStartYear, dStartMonth, dStartDay};
			    dEndDateArr = new String[]{dEndYear, dEndMonth, dEndDay};
			 	dStartDate = String.join("-", dStartDateArr);
			    dEndDate = String.join("-", dEndDateArr);	
			    
		    } else{
		    	for(HashMap<String, Object> dInfo : d){ // dCurrentInfo 가 null
		    		dStartYear = ((String)dInfo.get("discountStart")).substring(0, 4);
				    dStartMonth = ((String)dInfo.get("discountStart")).substring(5, 7);
				    dStartDay = ((String)dInfo.get("discountStart")).substring(8, 10);
				    dEndYear = ((String)dInfo.get("discountEnd")).substring(0, 4);
				    dEndMonth = ((String)dInfo.get("discountEnd")).substring(5, 7);
				    dEndDay = ((String)dInfo.get("discountEnd")).substring(8, 10);
				    discountRate = (double)dInfo.get("discountRate");
				    discountNo = (Integer)dInfo.get("discountNo");
				    
				 	// 할인가격, 할인 시작일, 할인 종료일 
				 	dProductPrice = (int)productPrice * (1 - discountRate);
				    dStartDateArr = new String[]{dStartYear, dStartMonth, dStartDay};
				    dEndDateArr = new String[]{dEndYear, dEndMonth, dEndDay};
				 	dStartDate = String.join("-", dStartDateArr);
				    dEndDate = String.join("-", dEndDateArr);	
		    	}
		    }
		} 
		// 디버깅 코드
	    System.out.println(dProductPrice+"<--modifyProduct.jsp dProductPrice");
	    System.out.println(dStartYear+"<--modifyProduct.jsp dStartYear");
	    System.out.println(dStartMonth+"<--modifyProduct.jsp dStartMonth");
	    System.out.println(dStartDay+"<--modifyProduct.jsp dStartDay");
	    System.out.println(dEndYear+"<--modifyProduct.jsp dEndYear");
	    System.out.println(dEndMonth+"<--modifyProduct.jsp dEndMonth");
	    System.out.println(dEndDay+"<--modifyProduct.jsp dEndDay");
	    System.out.println(dStartDate+"<--modifyProduct.jsp dStartDate");
	    System.out.println(dEndDate+"<--modifyProduct.jsp dEndDate");
	    System.out.println(discountRate+"<--modifyProduct.jsp discountRate");
	}
	
	String dir = request.getContextPath() + "/product/productImg/" + productSaveFilename;
	System.out.println(SJ+ dir + "<-modifyProduct.jsp dir" +RE);
	
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
                        상품 수정
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
				<!-- 상품 상세정보 조회 -->
				<div class="col-lg-12" style="margin-top: 50px;">
					<form id="modifyProduct" method="post" encType="multipart/form-data">
						<div>
							<table class="table">
								<tr>
									<th>상품번호</th>
									<td>
										<input type="hidden" name="productNo" value="<%=productNo%>">
										<span><%=productNo%></span>
									</td>
								</tr>
								<tr>
									<th>카테고리</th>
									<td>
										<select id="categoryName" name="categoryName" class="form-control w-25">
											<%
												for (Category c : cList){
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
									<td>
										<input type="text" id="productName" name="productName" class="form-control" value="<%=p.get("productName")%>">
									</td>
								</tr>
								<tr>
									<th>상품 가격</th>
									<td><input type="number" id="productPrice" name="productPrice" class="form-control w-25" value="<%=p.get("productPrice")%>"></td>
								</tr>
								<!-- 할인율 정보 유무에 따른 분기 -->
								<%
									if(d != null && !d.isEmpty()){
								%>
										<tr>
											<th>할인율</th>
											<td>
												<%=(int)(discountRate*100)%>&#37; 
												<button type="button" class="btn btn-primary" style="margin-left: 30px;" id="modifyProductDiscountModalBtn">수정</button>
												<button type="button" onclick="location.href='<%=request.getContextPath()%>/product/removeDiscountAction.jsp?productNo=<%=productNo%>&discountNo=<%=discountNo%>'" class="btn btn-primary">삭제</button>
											</td>
										</tr>
										<tr>
											<th>할인가</th>
											<td><%=(int)dProductPrice%></td>
										</tr>
										<tr>
											<th>할인기간</th>
											<td>
												<%=dStartDate%>&#126;<%=dEndDate%> 
											</td>
										</tr>
								<%		
									} else{
								%>
										<tr>
											<th>할인율</th>
											<td>
												<%=(int)discountRate%>&#37;
											</td>
										</tr>
								<%		
									}
								%>
								<tr>
									<th>상품 상태</th>
									<td>
										<select name="productStatus" class="form-control w-25">
											<option value="예약판매">예약판매</option>
											<option value="판매중">판매중</option>
											<option value="품절">품절</option>
										</select>
									</td>
								</tr>
								<tr>
									<th>재고</th>
									<td><input type="number" id="productStock" name="productStock" class="form-control w-25" value="<%=p.get("productStock")%>"></td>
								</tr>
								<tr>
									<th>상세정보</th>
									<td>
										<textarea rows="5" id="productInfo" name="productInfo" class="form-control"><%=p.get("productInfo")%></textarea>
									</td>
								</tr>
								<tr>
									<th>상품 이미지</th>
									<td>
										<%
											if(productSaveFilename == null) {
										%>
												<span>상품 이미지 없음</span>
										<%
											} else {
										%>
												<img src="<%=dir%>" id="productImg" width="300px">
										<%
											}
										%>
										<div class="mt-3">
											<input type="file" name="productImg">
										</div>
									</td>
								</tr>
								<tr>
									<th>등록일</th>
									<td><%=p.get("createdate")%></td>
								</tr>
								<tr>
									<th>수정일</th>
									<td><%=p.get("updatedate")%></td>
								</tr>
							</table>
						</div>
						<!-- 상품 수정, 취소 버튼 -->
						<div class="text-right">
							<button type="button" id="modifyProductBtn" class="btn btn-primary">수정</button>
							<button type="button" onclick="location.href='<%=request.getContextPath()%>/product/productDetail.jsp?productNo=<%=productNo%>'" class="btn btn-primary">취소</button>
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

	<!-- 할인율 수정 모달창 -->
	<div id="modifyDiscountModal" class="modal">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">할인율 수정</h5>
				<span class="close">&times;</span>
			</div>
			<div class="modal-body">
				<form id="modifyProductDiscount" method="post">
					<input type="hidden" name="discountNo" value="<%=discountNo%>">
					<div class="form-group row mt-3">
	                    <div class="col-md-12">
	                       	<h6>상품번호 <%=productNo%></h6>
	                        <input type="hidden" id="productNo" name="productNo" value="<%=productNo%>">
	                    </div>
	                    <div class="col-md-12 mt-3">
	                        <label for="discountRate"><strong>할인율</strong></label>
	                        <input type="number" id="discountRate" name="discountRate" step="0.1" class="form-control" placeholder="ex) 0.1">
	                    </div>
	                    <div class="col-md-12 mt-3">
	                        <label for="discountRate"><strong>할인 시작일</strong></label>
	                        <input type="date" id="discountStart" name="discountStart" class="form-control">
	                    </div>
	                    <div class="col-md-12 mt-3">
	                        <label for="discountRate"><strong>할인 종료일</strong></label>
	                        <input type="date" id="discountEnd" name="discountEnd" class="form-control">
	                    </div>
	                </div>
	                <div class="text-center">
	                	<button type="button" id="modifyDiscountBtn" class="btn btn-primary">할인율 수정</button>
	                </div>
				</form>
			</div>
		</div>
	</div>
</body>
<script>
	
	//category selected
	let category = '<%=(String)p.get("categoryName")%>';
	$('select[name="categoryName"] option').each(function() {
	  if ($(this).val() == category) {
	    $(this).prop('selected', true);
	  }
	});
	
	// 할인율 수정 모달 창 열기
	$("#modifyProductDiscountModalBtn").click(function(){
		$("#modifyDiscountModal").css("display", "block"); 
	});
  
	// 모달 창 닫기
	$(".close").click(function () {
		$("#modifyDiscountModal").css("display", "none");
	});
	
	// modifyProductBtn click
	$("#modifyProductBtn").on('click', function(){
		
		// 값 저장
		let productName = $('#productName').val();
		let productPrice = $('#productPrice').val();
		let productStock = $('#productStock').val();
		let productInfo = $('#productInfo').val();
		
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
		}
		
		// 입력값이 있을 경우 modifyProductAction.jsp 이동
		let modifyProductUrl = '<%=request.getContextPath()%>/product/modifyProductAction.jsp'; 
		$('#modifyProduct').attr('action', modifyProductUrl);
		$('#modifyProduct').submit();
	});
	
	// 할인 시작일 유효성 검사
	function validateDStart(){
		let selectedDStart = $('#discountStart').val();
	    let today = new Date();
	    let selectedDate = new Date(selectedDStart);

	    if (selectedDate <= today) {
	        return true;
	    } else {
	        return false;
	    }
	}
	
	// 할인 시작일 입력란 변화 감지 이벤트
	$('#discountStart').on('input', function() {
	    if (!validateDStart()) {
	        alert('유효한 날짜를 입력해주세요.');
	        $(this).val('');
	        $(this).focus();
	    }
	});
	
	// modifyDiscountBtn click
	$("#modifyDiscountBtn").on('click', function(){
		
		// 값 저장
		let dRate = $('#discountRate').val();
		let dStart= $('#discountStart').val();
		let dEnd = $('#discountEnd').val();
		
		// 입력값이 비어있는지 확인
		if(dRate.trim() == ''){
			alert('할인율을 입력해주세요');
			 $('#discountRate').focus();
			return;
		} else if(dStart.trim() == ''){
			alert('할인 시작일을 입력해주세요');
			$('#discountStart').focus();
			return;
		} else if(dEnd.trim() == ''){
			alert('할인 종료일을 입력해주세요');
			$('#discountEnd').focus();
			return;
		}
		
		// 입력값이 있을 경우 addProductDiscountAction.jsp 이동
		let modifyProductDiscountUrl = '<%=request.getContextPath()%>/product/modifyProductDiscountAction.jsp';
		$('#modifyProductDiscount').attr('action', modifyProductDiscountUrl);
		$('#modifyProductDiscount').submit();
	});
</script>
</html>