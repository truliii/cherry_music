 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<%
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	
	String productSaveFilename = null;
	// idLevel 분기에 따라 문의 입력 추가를 위한 코드
	String loginId = null;
	IdListDao idListDao = new IdListDao();
	IdList idList = idListDao.selectIdListOne(loginId);
	//int idLevel = idList.getIdLevel();
	//System.out.println(SJ+idLevel +"<-- productDetail idLevel"+ RE );
	
	// 요청값 유효성 검사
	if(request.getParameter("p.productNo") == null  
		|| request.getParameter("p.productNo").equals("")) {
		// subjectList.jsp으로
		response.sendRedirect(request.getContextPath() + "/product/productHome.jsp");
		return;
	}
	// 요청값 변수에 저장
	int productNo = Integer.parseInt(request.getParameter("p.productNo"));
	
	String productStatus = request.getParameter("productStatus");
	// sql 메서드들이 있는 클래스의 객체 생성
	ProductDao pDao = new ProductDao();
	DiscountDao dDao = new DiscountDao();
	QuestionDao qDao = new QuestionDao();
	ReviewDao rDao = new ReviewDao();
	Product product = new Product();
	
	product.setProductNo(productNo);
	System.out.println(SJ+ productNo + "<-- customerProductDeatil productNo" + RE );
	// 상세 페이지에 표시할 subject 객체
	ArrayList<HashMap<String, Object>> list = pDao.selectProduct(productNo);
	double discountRate = 0.0;
	for(HashMap<String, Object> p : list) {
		if(p.get("p.productNo") == p.get("dproductNo")){
			productSaveFilename = p.get("productSaveFilename").toString();
		}
	}
	String dir = request.getContextPath() + "/product/productImg/" + productSaveFilename;
	System.out.println(SJ+ dir + "<-dir" +RE);
	ArrayList<HashMap<String, Object>> dList = dDao.selectDiscountProduct(productNo);
	// 할인 적용을 위한 오늘 날짜 계산
	Calendar today = Calendar.getInstance();
	int todayYear = today.get(Calendar.YEAR);
	int todayMonth = today.get(Calendar.MONTH);
	int todayDate = today.get(Calendar.DATE);
	// 할인율, 날짜 적용을 위한 ArrayList 값 가져오기
	// 수정 필요 분기 필요 
	
	int dStartYear = 0;
	int dStartMonth = 0;
	int dStartDay =0;
	int dEndYear = 0;
	int	dEndMonth = 0;
	int	dEndDay = 0;
	
	for(HashMap<String, Object> d : dList) {
		if(d.get("dProductNo") != null) {
			dStartYear = Integer.parseInt((d.get("discountStart").toString()).substring(0, 4));
			dStartMonth = Integer.parseInt((d.get("discountStart").toString()).substring(5, 7));
			dStartDay = Integer.parseInt((d.get("discountStart").toString()).substring(8, 10));
			dEndYear = Integer.parseInt((d.get("discountEnd").toString()).substring(0, 4));
			dEndMonth = Integer.parseInt((d.get("discountEnd").toString()).substring(5, 7));
			dEndDay = Integer.parseInt((d.get("discountEnd").toString()).substring(8, 10));
			discountRate = Double.parseDouble(d.get("discountRate").toString());
			
			if((dStartYear >= todayYear && dStartMonth >= todayMonth && dStartDay >= todayDate)
					|| (dEndYear >= todayYear && dEndMonth >= todayMonth && dEndDay >= todayDate)) {
				dStartYear = Integer.parseInt((d.get("discountStart").toString()).substring(0, 4));
				dStartMonth = Integer.parseInt((d.get("discountStart").toString()).substring(5, 7));
				dStartDay = Integer.parseInt((d.get("discountStart").toString()).substring(8, 10));
				dEndYear = Integer.parseInt((d.get("discountEnd").toString()).substring(0, 4));
				dEndMonth = Integer.parseInt((d.get("discountEnd").toString()).substring(5, 7));
				dEndDay = Integer.parseInt((d.get("discountEnd").toString()).substring(8, 10));
				discountRate = Double.parseDouble(d.get("discountRate").toString());
				
			} else { 
				dStartYear = 0;
				dStartMonth = 0;
				dStartDay = 0;
				dEndYear = 0;
				dEndMonth = 0;
				dEndDay = 0;
				discountRate = 0.0;
			}
		}
	}
	
	System.out.println(SJ+productSaveFilename + RE );
	System.out.print(SJ+todayYear );
	System.out.print(todayMonth+1);
	System.out.println(todayDate + "<-- customerProductDeatil 오늘날짜 확인" + RE );
	
	System.out.print(SJ+ dEndYear + RE );
	System.out.print(SJ+ dEndMonth + RE );
	System.out.println(SJ+ dEndDay + "<-- customerProductDeatil 할인 종료 날짜 확인" + RE );
	
	// 상품문의 페이징 변수
	int beginRow = 0;
	int rowPerPage = 10;
	// 상품문의 출력을 위한 리스트
	ArrayList<Question> pList = qDao.selectQuestionListByPage(product, beginRow, rowPerPage);
	
	// 문의 객체 생성
	Question question = new Question();
	question.setProductNo(productNo);

	int discountNo = 1;
	
	// 리뷰 출력을 위한 리스트
	// 페이징 상수로 고정 해놨음
	ArrayList<HashMap<String, Object>> rList = rDao.selectReviewListByProduct(productNo,0,10);
	Review review = new Review();

	//리뷰이미지 저장위치
	String reviewDir = request.getServletContext().getRealPath("/review/reviewImg");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Customer Product Detail</title>
<jsp:include page="/inc/link.jsp"></jsp:include>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
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
              <!-- breadcrumb-->
              <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                  <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/home.jsp">홈</a></li>
                  <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/product/productHome.jsp">상품목록</a></li>
                  <li aria-current="page" class="breadcrumb-item active">상품상세보기</li>
                </ol>
              </nav>
            </div>
            <!--------------------------------------------------------- 상품상세 시작 ------------------------------------------------------------------>
            <!--  상품 설명 시작 -->
            <div class="col-lg-12 order-1 order-lg-2">
            <form action="<%=request.getContextPath()%>/cart/addToCartAction.jsp?p.productNo=<%=productNo%>" method="post">
            <input type="hidden" name="productNo" value="<%=productNo%>">
            <input type="hidden" name = "beforeProductImg" value="<%=productSaveFilename%>">
			<input type="hidden" name = "productImg" onchange="previewImage(event)">
			<input type = "hidden" name = "productSaveFilename" value="<%=productSaveFilename%>">
			<input type = "hidden" name = "discountRate" value="<%=discountRate%>">
           	<%
				for(HashMap<String, Object> p : list) {
					// 할인 기간 확인을 위한 변수와 분기
					discountNo = Integer.parseInt(p.get("discountNo").toString());
					System.out.println(SJ+ discountNo +"customerProductDetail discountNo"+ RE );
			%>
              <div id="productMain" class="row">
                <div class="col-md-6">
                  <div data-slider-id="1" class="owl-carousel shop-detail-carousel">
                    <div class="item"><img src="<%=dir%>" alt="준비중" class="img-fluid"></div>
                    <div class="item"> <img src="<%=dir%>" alt="준비중" class="img-fluid"></div>
                    <div class="item"> <img src="<%=dir%>" alt="준비중" class="img-fluid"></div>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="box">
                    <p class="badge badge-danger"><%=p.get("productStatus")%></p>
                  	<!-- <p><%=p.get("categoryName")%>&nbsp;<%=productNo%></p>  -->
                    <h1 class="text-center"><%=p.get("productName")%></h1>
                    <p class="price"><%=p.get("productPrice")%>원</p>
                    <p class="text-center">할인율
                   	<%	// 할일율
						if(p.get("discountRate") == null) {
					%>		
							<%=0.0%>
					<%	} else {
							if(p.get("productNo") == p.get("dProductNo")) {
					%>
								<%=discountRate*100%> %
					<%			
							}
						}
                   	%>
                    </p>
                    <p class="text-center">할인가
                    	<%	//할인가
							if(p.get("discountRate") == null) {
						%>	
								<%=p.get("productPrice")%> 
						<%	} else {
								if(p.get("productNo") == p.get("dProductNo")) {
						%>		
									<%=Math.round(Double.parseDouble(p.get("productPrice").toString())*(1-discountRate))%>
						<%
								}
							}
                    	%>
                    </p>
                    <!-- <p>재고 <%=p.get("productStock")%></p> -->
                    <p class="text-center">할인기간 <%=" " + dStartYear +"년 "+ dStartMonth +"월 "+ dStartDay + "일 " %> ~ <%=" " + dEndYear +"년 "+ dEndMonth+"월 "+ dEndDay+ "일 "%></p>
                    <p><input id="cartCnt" class="form-control" type="number" name="cartCnt" min="1" placeholder="구매수량" required></p>
                    <p class="text-center buttons"><button type="submit" class="btn btn-primary"><i class="fa fa-shopping-cart"></i> 장바구니 담기</button></p>
                  </div>
                  <div data-slider-id="1" class="owl-thumbs">
                    <button class="owl-thumb-item"><img src="<%=dir%>" alt="" class="img-fluid"></button>
                    <button class="owl-thumb-item"><img src="<%=dir%>" alt="" class="img-fluid"></button>
                    <button class="owl-thumb-item"><img src="<%=dir%>" alt="" class="img-fluid"></button>
                  </div>
                </div>
              </div>
              <div id="details" class="box">
              <p></p>
                <h4>상세 정보</h4>
                <p><%=p.get("productInfo")%></p>
              </div>
			<%	
				}
			%>
			</form>
                <!--  상품 설명 끝 -->
                     <!-- 리뷰 시작 -->
                     <div class="box">
                     <form action="<%=request.getContextPath()%>/question/addQuestion.jsp?p.productNo=<%=productNo%>" method="post">
       					<table class="table">
       						<tr>
       			   				<th>주문번호</th>
       			   				<th>리뷰사진</th>
       			   				<th>제목</th>
       			   				<th>내용</th>
       			   				<th>작성일</th>
       			   				<th>수정일</th>
       			   			</tr>
       						<%
       							for(HashMap<String, Object> r : rList) {
       								// 할인 기간 확인을 위한 변수와 분기
       						%>
       						<tr>
       							<td>
       								<a href="<%=request.getContextPath()%>/review/reviewOne.jsp?reviewNo=<%=r.get("reviewNo")%>">
       									<%=r.get("orderNo")%>
       								</a>
       							</td>
       							<td><img src="<%=request.getContextPath()%>/review/reviewImg/<%=(String)r.get("reviewSaveFilename")%>" alt="준비중" width="auto" height="100px"></td>
       							<td><%=r.get("reviewTitle")%></td>
       			   				<td><%=r.get("reviewContent")%></td>
       			   				<td><%=r.get("createdate").toString().substring(0, 10)%></td>
       			   				<td><%=r.get("updatedate").toString().substring(0, 10)%></td>
       						</tr>
       						<%	
       							}
       						//	if(idLevel ==0 ) {
       						%>
       						<%
       						//	}
       						%>
       					</table>
       				</form>
                     </div>
                     <!-- 리뷰 끝 -->
                     <!-- 문의 시작 -->
                     <div class="box">
                     <form action="<%=request.getContextPath()%>/question/addQuestion.jsp?p.productNo=<%=productNo%>" method="post">
       				<div>
       					<table class="table">
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
       					</table>
       				  </div>
       				  <div class="text-right">
       				  	<%
       					//	if(idLevel ==0 ) {
       					%>
       					<a href="<%=request.getContextPath()%>/question/addQuestion.jsp?p.productNo=<%=productNo%>">
       						<button class="btn btn-primary" type="button">문의 입력</button>
						</a>
						<%
						//	}
						%>
			  		</div>
				</form>
              </div>
             	<!-- 문의 끝 -->
           </div>
           <!-- /.col-md-12-->
           <!--------------------------------------------------------- 상품상세 끝 ------------------------------------------------------------------>
         </div>
       </div>
     </div>
   </div>
<!-- copy -->
<jsp:include page="/inc/copy.jsp"></jsp:include>
<!-- 자바스크립트 -->
<jsp:include page="/inc/script.jsp"></jsp:include>
</body>
</html>