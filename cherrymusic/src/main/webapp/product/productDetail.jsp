<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<%
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	
	String productSaveFilename = null;
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
	
	// 요청값 유효성 검사
	if(request.getParameter("p.productNo") == null  
		|| request.getParameter("p.productNo").equals("")) {
		// subjectList.jsp으로
		response.sendRedirect(request.getContextPath() + "/product/productList.jsp");
		return;
	}
	// 요청값 변수에 저장
	int productNo = Integer.parseInt(request.getParameter("p.productNo"));
	
	String productStatus = request.getParameter("productStatus");
	// sql 메서드들이 있는 클래스의 객체 생성
	ProductDao pDao = new ProductDao();
	DiscountDao dDao = new DiscountDao();
	QuestionDao qDao = new QuestionDao();
	Product product = new Product();
	
	product.setProductNo(productNo);
	System.out.println(SJ+ productNo + "<-- productDetail productNo" + RE );
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
	System.out.println(todayDate + "<-- productDetail.jsp 오늘날짜 확인" + RE );
	
	System.out.print(SJ+ dEndYear + RE );
	System.out.print(SJ+ dEndMonth + RE );
	System.out.println(SJ+ dEndDay + "<-- productDetail.jsp 할인 종료 날짜 확인" + RE );
	
	// 상품문의 페이징 변수
	int beginRow = 0;
	int rowPerPage = 10;
	// 상품문의 출력을 위한 리스트
	ArrayList<Question> pList = qDao.selectQuestionListByPage(product, beginRow, rowPerPage);
	
	// 문의 객체 생성
	Question question = new Question();
	question.setProductNo(productNo);

	int discountNo = 1;
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
                	</ul>
                	
                </div>
              </div>
              <!-- /.col-lg-3-->
              <!-- 고객메뉴 끝 -->
            </div>
            <div class="col-lg-9">
              <div class="box">
              	<!-- 상세정보 -->
				<div>
		<h1> 상품 상세</h1>
		<div>
			<a href="<%=request.getContextPath()%>/product/productList.jsp">
				<button type="button">목록으로</button>
			</a>
		</div>
		<form action="<%=request.getContextPath()%>/product/modifyProduct.jsp?p.productNo=<%=productNo%>" method="post">
			<table>
			<%
				for(HashMap<String, Object> p : list) {
					// 할인 기간 확인을 위한 변수와 분기
					discountNo = Integer.parseInt(p.get("discountNo").toString());
					System.out.println(SJ+ discountNo + RE );
			%>
			<tr>
				<th >p no.</th>
				<td><%=productNo%></td>
				
			</tr>
			<tr>
				<th >카테고리</th>
				<td><%=p.get("categoryName")%></td>
			</tr>
			<tr>
				<th >이름</th>
				<td><%=p.get("productName")%></td>
			</tr>
			<tr>
				<th >가격</th>
				<td><%=p.get("productPrice")%></td>
			</tr>
			<tr>
				<th >할인율</th>
				<td><!-- 할인율 유무에 따른 분기 -->
					<%	// 할일율
						if(p.get("discountRate") == null) {
							
					%>		<%=0.0%>
					<%	} else {
							if(p.get("productNo") == p.get("dProductNo")) {
								 
									
					%>
								<%=discountRate*100%> %
					<%			
							}
						}
					%>
				</td>
			</tr>
			<tr>
				<th >할인가</th>
				<td> 
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
				</td>
			</tr>
			<tr>
				<th >할인 시작</th>
				<td><%=" " + dStartYear +"년 "+ dStartMonth +"월 "+ dStartDay + "일 " %></td>
			</tr>
			<tr>
				<th >할인 종료</th>
				<td><%=" " + dEndYear +"년 "+ dEndMonth+"월 "+ dEndDay+ "일 "%></td>
			</tr>
			<tr>
				<th >상태</th>
				<td><%=p.get("productStatus")%></td>
			</tr>
			<tr>
				<th >재고</th>
				<td><%=p.get("productStock")%></td>
			</tr>
			<tr>
				<th >정보</th>
				<td><%=p.get("productInfo")%></td>
			</tr>
			<tr>
				<th >등록일</th>
				<td><%=p.get("p.createdate")%></td>
			</tr>
			<tr>
				<th >수정일</th>
				<td><%=p.get("p.updatedate")%></td>
			</tr>
			<tr>
				<td>&nbsp</td>
				<td>&nbsp</td>
				<td>&nbsp</td>
				<td>
					<div>상품 이미지  
						<img src="<%=dir%>" id="preview" width="300px">
						<input type="hidden" name = "productImg" onchange="previewImage(event)">
						<input type = "hidden" name = "productSaveFilename" value="<%=productSaveFilename%>">
						<input type = "hidden" name = "discountRate" value="<%=discountRate%>">
					</div> 
				</td>
			</tr>
			<tr>
				<td>
				
					<div >
						<button type="submit">수정</button>
						<input type = "hidden" name = "dproductNo" value = "<%=p.get("dproductNo")%>">
						<input type = "hidden" name = "discountRate" value = "<%=p.get("discountRate")%>">
						<input type = "hidden" name = "discountStart" value = "<%=p.get("discountStart")%>">
						<input type = "hidden" name = "discountEnd" value = "<%=p.get("discountEnd")%>">
					
						
					</div>
				</td>
			</tr>
		</table>
	</form>
	<form action = "<%=request.getContextPath()%>/product/removeProductAction.jsp" method="post" encType="multipart/form-data">
		<table>
				<tr>
					<td>
						<div>
							<input type = "hidden" name = "p.productNo" value="<%=productNo%>">
							<input type = "hidden" name = "productSaveFilename" value="<%=productSaveFilename%>">
							<button type="submit">삭제</button>

						</div>
					</td>
				</tr>
			<%	
				}
			%>
			<tr>
				<td>
					<a href="<%=request.getContextPath()%>/product/addProductDiscount.jsp?p.productNo=<%=productNo%>">
						<button type="button">할인추가</button>
					</a>
				</td>
				<td>
					<a href="<%=request.getContextPath()%>/product/removeDiscountAction.jsp?discountNo=<%=discountNo%>">
						<button type="button">할인삭제</button>
					</a>
				</td>
			</tr>
			<tr>
			
				<td>
					<a href="<%=request.getContextPath()%>/question/removeQuestionAction.jsp?p.productNo=<%=productNo%>">
						<button type="button">문의삭제</button>
					</a>
				</td>
			</tr>
			
			</table>
		</form>
	</div>
	<form action="<%=request.getContextPath()%>/question/addQuestion.jsp?p.productNo=<%=productNo%>" method="post">
		<table>
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
			if(idLevel ==0 ) {
			%>
			<tr>
				<td>
					<a href="<%=request.getContextPath()%>/question/addQuestion.jsp?p.productNo=<%=productNo%>">
						<button type="button">문의 입력</button>
					</a>
				</td>
			</tr>
			<%
				}
			%>
		
					</table>
					</form>
					</div>
				</div>
              </div>
            </div>
          </div>
        </div>
</body>
</html>