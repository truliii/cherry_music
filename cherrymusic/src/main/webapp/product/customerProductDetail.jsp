 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	// 요청값 유효성 검사 : null이거나 공백이면 상품홈으로 리다이렉션
	if(request.getParameter("productNo") == null  
		|| request.getParameter("productNo").equals("")) {
		response.sendRedirect(request.getContextPath() + "/product/productHome.jsp");
		return;
	}
	// 요청값 변수에 저장
	int productNo = Integer.parseInt(request.getParameter("productNo"));
	
	//메서드 사용을 위한 객체 생성
	ProductDao pDao = new ProductDao();
	DiscountDao dDao = new DiscountDao();
	QuestionDao qDao = new QuestionDao();
	ReviewDao rDao = new ReviewDao();
	
	//상품내용 출력
	HashMap<String, Object> product = pDao.selectProductOne(productNo);
	
	//해당상품의 할인률 출력
	double discountRate = 0.0;
	Discount productDiscount = dDao.selectProductCurrentDiscount(productNo);
	if(productDiscount != null){
		discountRate = productDiscount.getDiscountRate();
	}
	
	//최종가격
	int finalPrice = (int)((Integer)product.get("productPrice")*(1-discountRate));
	
	// 상품문의 출력을 위한 리스트
	Product productNum = new Product();
	productNum.setProductNo(productNo);
	// 상품문의 페이징 변수
	int beginRow = 0;
	int rowPerPage = 10;
	ArrayList<Question> pList = qDao.selectQuestionListByPage(productNum, beginRow, rowPerPage);
	
	// 문의 객체 생성
	Question question = new Question();
	question.setProductNo(productNo);

	// 리뷰 출력을 위한 리스트
	int rBeginRow = 0;
	int rRowPerPage = 5;
	int reviewCnt = rDao.selectReviewCntByProduct(productNo);
	ArrayList<HashMap<String, Object>> rList = rDao.selectReviewListByProduct(productNo,rBeginRow, rRowPerPage);
	Review review = new Review();

%>

<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/inc/head.jsp"></jsp:include>

</head>
<body>
    <jsp:include page="/inc/header.jsp"></jsp:include>
    
    <div id="page-content" class="page-content">
    	<!-- 배너 시작 -->
        <div class="banner">
            <div class="jumbotron jumbotron-bg text-center rounded-0" style="background-image: url('assets/img/bg-header.jpg');">
                <div class="container">
                    <h1 class="pt-5">
                        <%=product.get("productName")%>
                    </h1>
                    <p class="lead">
                        Save time and leave the groceries to us.
                    </p>
                </div>
            </div>
        </div>
        <!-- 배너 끝 -->
        
        <!-- 상품상세보기 시작-->
        <div class="product-detail">
            <div class="container">
                <div class="row">
                    <div class="col-sm-6">
                        <div class="slider-zoom">
                            <%-- <a href="<%request.getContextPath()%>/review/reviewImg/<%=product.get("saveFilename")%>" class="cloud-zoom" rel="transparentImage: 'data:image/gif;base64,R0lGODlhAQABAID/AMDAwAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==', useWrapper: false, showTitle: false, zoomWidth:'500', zoomHeight:'500', adjustY:0, adjustX:10" id="cloudZoom">
                                <img alt="Detail Zoom thumbs image" src="<%request.getContextPath()%>/review/reviewImg/<%=product.get("saveFilename")%>" style="width: 100%;">
                            </a> --%>
                        </div>
                    </div>
                    <form action="<%=request.getContextPath()%>/cart/addToCartAction.jsp" method="post">
                    	<input type="hidden" name="productNo" value="<%=productNo%>">
	                    <div class="col-sm-6">
	                        <p>
	                            <strong>상세보기</strong><br>
	                            	<%=product.get("productInfo")%></br>
		                            <strong>한정 / 수입상품 안내</strong></br>
									한정 상품이나 수입상품인 경우 수량 부족 시 취소될 수 있습니다.</br>
		                            <strong>군부대 배송 여부 안내</strong></br>
									본상품은 군부대배송 불가상품입니다. 배송불가지역은 주문 취소 처리 될 수 있는 점 양해 부탁드립니다.</br>
		                            <strong>도서 산간 지역 추가 운임 안내</strong></br>
									제주지,도서 산간 지역 추가 배송비가 발생하니 주문시 확인 부탁드립니다.
	                        </p>
	                        <div class="row">
	                            <div class="col-sm-6">
	                                <p>
	                                    <strong></strong>가격(/개)<br>
	                                    <span class="price"><%=finalPrice%>원</span>
	                                    <span class="old-price"><%=product.get("productPrice")%>원</span>
	                                </p>
	                            </div>
	                            <div class="col-sm-6 text-right">
	                                <p>
	                                    <span class="stock available">재고량 : <span id="stock"><%=(Integer)product.get("productStock")%></span>개</span>
	                                </p>
	                            </div>
	                        </div>
	                        <p class="mb-1">
	                            <strong>수량</strong>
	                        </p>
	                        <div class="row">
	                        
	                            <div class="col-sm-5">
									<input type="number" id="cartCnt" name="cartCnt" class="form-control" value="1" min="1" max="<%=(Integer)product.get("productStock")%>">
	                            </div>
	                            <div class="col-sm-6"><span class="pt-1 d-inline-block">개</span></div>
	                        </div>
	
	                        <button class="mt-3 btn btn-primary btn-lg">
	                            <i class="fa fa-shopping-basket"></i> 장바구니에 담기
	                        </button>
	                    </div>
                    </form>
                </div>
                
                <!-- 문의 및 리뷰 시작 -->
				<div class="row mt-5">
		          <div class="col-md-12 nav-link-wrap">
		            <div class="nav nav-pills d-flex text-center" id="v-pills-tab" role="tablist" aria-orientation="vertical">
		              <a class="nav-link ftco-animate active mr-lg-1" id="v-pills-1-tab" data-toggle="pill" href="#v-pills-1" role="tab" aria-controls="v-pills-1" aria-selected="true">문의하기</a>
		              <a class="nav-link ftco-animate mr-lg-1" id="v-pills-2-tab" data-toggle="pill" href="#v-pills-2" role="tab" aria-controls="v-pills-2" aria-selected="false">후기</a>
		            </div>
		          </div>
		          <div class="col-md-12 tab-wrap">
		            <div class="tab-content bg-light" id="v-pills-tabContent">
		              <div class="tab-pane fade show active" id="v-pills-1" role="tabpanel" aria-labelledby="day-1-tab">
		              	<div class="p-4">
							<form action="<%=request.getContextPath()%>/question/addQuestion.jsp?p.productNo=<%=productNo%>" method="post">
			       				<div class="table-resposive">
			       					<table class="table">
			       						<thead>
				       						<tr>
				       							<th >p no.</th>
				       							<th >q no.</th>
				       							<th >id</th>
				       							<th >문의 카테고리</th>
				       							<th >문의 제목</th>
				       							<th >문의 내용</th>
				       							<th >등록일</th>
				       							<th >수정일</th>
				       							<th >조회수</th>
				       						</tr>
			       						</thead>
			       						<tbody>
			       						<%
			       							for(Question q : pList) {
			       								// 할인 기간 확인을 위한 변수와 분기
			       						%>
			       						<tr>
			       							<td><%=productNo%></td>
			       							<td>
			       								<a href="<%=request.getContextPath()%>/question/questionDetail.jsp?qNo=<%=q.getqNo()%>">
			       									<%=q.getqNo()%>
			       								</a>
			       							</td>
			       							<td><%=q.getId()%></td>
			       							<td><%=q.getqCategory()%></td>
			       							<td><%=q.getqTitle()%></td>
			       							<td><%=q.getqContent()%></td>
			       							<td><%=q.getCreatedate()%></td>
			       							<td><%=q.getUpdatedate()%></td>
			       							<td><%=q.getqCheckCnt()%></td>
			       						</tr>
			       						<%	
			       							}
			       						%>
			       						</tbody>
			       					</table>
			       				  </div>
			       				  <div class="text-right">
			       					<a href="<%=request.getContextPath()%>/question/addQuestion.jsp?p.productNo=<%=productNo%>">
			       						<button class="btn btn-primary" type="button">문의입력</button>
									</a>
						  		</div>
							</form>
		              	</div>
		              </div>
		
		              <div class="tab-pane fade" id="v-pills-2" role="tabpanel" aria-labelledby="v-pills-day-2-tab">
		              	<div class="row p-4">
					   		<div class="col-md-12">
					   			<h3 class="mb-4"><%=reviewCnt%>개의 후기</h3>
					   			<div class="review">
						   			<%
		       							for(HashMap<String, Object> r : rList) {
		       						%>
								   		<div class="user-img" style="background-image: url(<%=request.getContextPath()%>/review/reviewImg/<%=(String)r.get("reviewSaveFilename")%>)"></div>
								   		<div class="desc">
										<h4>
							   				<span class="text-left"><%=r.get("id")%></span>
							   				<span class="text-right"><%=r.get("createdate").toString().substring(0, 10)%></span>
						   				</h4>
						   					<p>
							   					<a href="<%=request.getContextPath()%>/review/reviewOne.jsp?reviewNo=<%=r.get("reviewNo")%>">
			       									<%=r.get("orderNo")%>
			       								</a>
		       								</p>
								   			<p>
								   				<strong><%=r.get("reviewTitle")%></strong><br>
								   				<%=r.get("reviewContent")%></p>
								   		</div>
								  </div>
								   	<%	
		       							}
						   			%>
				              </div>
				            </div>
				          </div>
				        </div>
	            	</div>
	        	</div>
	        <!-- 문의 및 리뷰 끝 -->
    		</div>
    	</div>
		<!-- 상품상세보기 끝 -->
	</div>
    
    <footer>
        <jsp:include page="/inc/footer.jsp"></jsp:include>
    </footer>

    <jsp:include page="/inc/script.jsp"></jsp:include>
    <script>
    //cartCnt입력값 유효성 검사
    let stock = parseInt($('#stock').text());
    console.log(stock);
    console.log(typeof(stock));
    $('#cartCnt').blur(function(){
    	if($('#cartCnt').val() < 1){
    		$('#cartCnt').val(1);
    	} else if($('#cartCnt').val() > stock){
    		$('#cartCnt').val(stock);
    	}
    })
    </script>
</body>
</html>
