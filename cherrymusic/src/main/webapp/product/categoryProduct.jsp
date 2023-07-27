<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>

<%	
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	System.out.println(SJ+ request.getParameter("category") + "<-radio category" +RE);
	// 아이디 레벨 검사 
	IdListDao iDao = new IdListDao();
	IdList idList = new IdList();
	int idLevel = idList.getIdLevel();
	System.out.println(SJ+idLevel + RE );
	
	if(request.getParameter("category") == null  
			|| request.getParameter("category").equals("")) {
			// subjectList.jsp으로
			response.sendRedirect(request.getContextPath() + "/product/productHome.jsp");
			return;
		}
	
	int productNo = 1;
	// sql 메서드들이 있는 클래스의 객체 생성
	ProductDao pDao = new ProductDao();
	DiscountDao dDao = new DiscountDao();
	
	int beginRow=0;
	int rowPerPage = 10;
	// 현재 페이지에 표시 할 리스트
	ArrayList<HashMap<String, Object>> list = pDao.selectProductNoByPage(true, beginRow, rowPerPage);
	ArrayList<HashMap<String, Object>> dList = dDao.selectDiscount(beginRow, rowPerPage);
	ArrayList<HashMap<String, Object>> dayList = pDao.selectProduct(productNo);	
	
	// 다양한 상품 출력을 위한 리스트
	// 카테고리 분류 변수 및 분기
	String category = request.getParameter("category");
	ArrayList<HashMap<String, Object>> cList = null;
	// 판매량 순
	ArrayList<HashMap<String, Object>> cntList = pDao.selectSumCntByPage(true, beginRow, rowPerPage);
	// pop
	ArrayList<HashMap<String, Object>> popList = pDao.selectPopByPage(true, beginRow, rowPerPage);
	// kpop
	ArrayList<HashMap<String, Object>> kpopList = pDao.selectKpopByPage(true, beginRow, rowPerPage);
	// classic
	ArrayList<HashMap<String, Object>> classicList = pDao.selectClassicByPage(true, beginRow, rowPerPage);
	if(category.equals("pop")) {
		cList = pDao.selectPopByPage(true, beginRow, rowPerPage);
	} else if(category.equals("kpop")){
		cList = pDao.selectKpopByPage(true, beginRow, rowPerPage);
	} else {
		cList = pDao.selectClassicByPage(true, beginRow, rowPerPage);
	}
	
	
	// 상품이미지 코드
	String productSaveFilename = null;
	String dir = request.getContextPath() + "/product/productImg/" + productSaveFilename;
	System.out.println(SJ+ dir + "<-dir" +RE);
	System.out.println(SJ+productSaveFilename + RE );
%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Home</title>
    <jsp:include page="/inc/link.jsp"></jsp:include>
  </head>
  <body>
    <!-- navbar-->
    <jsp:include page="/inc/menu.jsp"></jsp:include>
    <!-- navbar-->
    <!-- 헤드 부분 링크 달기 -->
    <div id="all">
      <div id="content">
        <div class="container">
          <div class="row">
            <div class="col-lg-12">
              <!-- breadcrumb-->
              <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                  <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/home.jsp">Home</a></li>
                  <li aria-current="page" class="breadcrumb-item active">전체 목록</li>
                </ol>
              </nav>
            </div>
            <div class="col-lg-3">
              <!--
              *** MENUS AND FILTERS ***
              _________________________________________________________
              -->
              <div class="card sidebar-menu mb-4">
                <div class="card-header">
                  <h3 class="h4 card-title">Categories</h3>
                </div>
                <div class="card-body">
                  <ul class="nav nav-pills flex-column category-menu">
                  <li><a href="<%=request.getContextPath()%>/product/productHome.jsp" class="nav-link">전체 목록  <span class="badge badge-secondary"></span></a>
                      <ul class="list-unstyled">
                      </ul>
                    </li>
                    <li><a href="<%=request.getContextPath()%>/product/categoryProduct.jsp?category=pop" class="nav-link">POP <span class="badge badge-secondary"></span></a>
                    </li>
                    <li><a href="<%=request.getContextPath()%>/product/categoryProduct.jsp?category=kpop" class="nav-link">K-POP  <span class="badge badge-light"></span></a>
                      <ul class="list-unstyled">
                      </ul>
                    </li>
                    <li><a href="<%=request.getContextPath()%>/product/categoryProduct.jsp?category=classic" class="nav-link">CLASSIC  <span class="badge badge-secondary"></span></a>
                      <ul class="list-unstyled">
                      </ul>
                    </li>
                    
                  </ul>
                </div>
              </div>
             
              <!-- *** MENUS AND FILTERS END ***-->
              
            </div>
            <div class="col-lg-9">
              <div class="box">
                <h1><%=category%> 목록</h1>
                <form action="<%=request.getContextPath()%>/product/searchProduct.jsp" method="post">
					<input type="text" name = "search">
					<button type="submit" >검색</button>
				</form>
              </div>
              
              <div class="row products">
				<%
					for(HashMap<String, Object> p : cList) {
							// 할인 기간 확인을 위한 변수와 분기
				%>
				
				<div class="col-lg-4 col-md-6">
                  <div class="product">
                    <div class="flip-container">
                      <div class="flipper">
                        <div class="front"><a href="<%=request.getContextPath()%>/product/customerProductDetail.jsp?p.productNo=<%=p.get("p.productNo")%>&dproductNo=<%=p.get("dProductNo")%>&discountRate=<%=p.get("discountRate")%>"><img src="<%=dir = request.getContextPath() + "/product/productImg/" + p.get("productSaveFilename")%>" id="preview" style="width: 300px; height: 200px;" alt="" class="img-fluid"></a></div>
                        <div class="back"><a href="<%=request.getContextPath()%>/product/customerProductDetail.jsp?p.productNo=<%=p.get("p.productNo")%>&dproductNo=<%=p.get("dProductNo")%>&discountRate=<%=p.get("discountRate")%>"><img src="<%=dir = request.getContextPath() + "/product/productImg/" + p.get("productSaveFilename")%>" style="width: 300px; height: 200px;" alt="" class="img-fluid"></a></div>
                        <input type="hidden" name = "beforeProductImg" value="<%=productSaveFilename%>">
						<input type="hidden" name = "productImg" onchange="previewImage(event)">
						<input type = "hidden" name = "productSaveFilename" value="<%=productSaveFilename%>">
                      </div>
                    </div><a href="<%=request.getContextPath()%>/product/customerProductDetail.jsp?p.productNo=<%=p.get("p.productNo")%>&dproductNo=<%=p.get("dProductNo")%>&discountRate=<%=p.get("discountRate")%>" class="invisible"><img src="<%=dir = request.getContextPath() + "/product/productImg/" + p.get("productSaveFilename")%>" style="width: 300px; height: 200px;" alt="" class="img-fluid"></a>
                    <div class="text">
                      <h3><a href="<%=request.getContextPath()%>/product/customerProductDetail.jsp?p.productNo=<%=p.get("p.productNo")%>&dproductNo=<%=p.get("dProductNo")%>&discountRate=<%=p.get("discountRate")%>"><%=p.get("productName")%></a></h3>
                      <p class="price"> 
                        <del></del><%=p.get("productPrice")%>원
                      </p>
                      <p class="price"> 
                        <del></del><%=p.get("productStatus")%>
                      </p>
                      <p class="buttons"><a href="<%=request.getContextPath()%>/product/customerProductDetail.jsp?p.productNo=<%=p.get("p.productNo")%>&dproductNo=<%=p.get("dProductNo")%>&discountRate=<%=p.get("discountRate")%>" class="btn btn-outline-secondary"><%=p.get("categoryName")%></a><a href="basket.html" class="btn btn-primary"><i class="fa fa-shopping-cart"></i>Add to cart</a></p>
                    </div>
                    <!-- /.text-->
                  </div>
                  <!-- /.product            -->
                </div>
                
                <%		
						}
				%>
          
                <!-- /.products-->
              </div>
             
            </div>
            <!-- /.col-lg-9-->
          </div>
        </div>
      </div>
    </div>
    <!--
    *** FOOTER ***
    _________________________________________________________
    -->
    <div id="footer">
      <div class="container">
        <div class="row">
          <div class="col-lg-3 col-md-6">
            <h4 class="mb-3">Pages</h4>
            <ul class="list-unstyled">
              <li><a href="text.html">About us</a></li>
              <li><a href="text.html">Terms and conditions</a></li>
              <li><a href="faq.html">FAQ</a></li>
              <li><a href="contact.html">Contact us</a></li>
            </ul>
            <hr>
            <h4 class="mb-3">User section</h4>
            <ul class="list-unstyled">
              <li><a href="#" data-toggle="modal" data-target="#login-modal">Login</a></li>
              <li><a href="register.html">Regiter</a></li>
            </ul>
          </div>
          <!-- /.col-lg-3-->
          <div class="col-lg-3 col-md-6">
            <h4 class="mb-3">Top categories</h4>
            <h5>Men</h5>
            <ul class="list-unstyled">
              <li><a href="category.html">T-shirts</a></li>
              <li><a href="category.html">Shirts</a></li>
              <li><a href="category.html">Accessories</a></li>
            </ul>
            <h5>Ladies</h5>
            <ul class="list-unstyled">
              <li><a href="category.html">T-shirts</a></li>
              <li><a href="category.html">Skirts</a></li>
              <li><a href="category.html">Pants</a></li>
              <li><a href="category.html">Accessories</a></li>
            </ul>
          </div>
          <!-- /.col-lg-3-->
          <div class="col-lg-3 col-md-6">
            <h4 class="mb-3">Where to find us</h4>
            <p><strong>Obaju Ltd.</strong><br>13/25 New Avenue<br>New Heaven<br>45Y 73J<br>England<br><strong>Great Britain</strong></p><a href="contact.html">Go to contact page</a>
            <hr class="d-block d-md-none">
          </div>
          <!-- /.col-lg-3-->
          <div class="col-lg-3 col-md-6">
            <h4 class="mb-3">Get the news</h4>
            <p class="text-muted">Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.</p>
            <form>
              <div class="input-group">
                <input type="text" class="form-control"><span class="input-group-append">
                  <button type="button" class="btn btn-outline-secondary">Subscribe!</button></span>
              </div>
              <!-- /input-group-->
            </form>
            <hr>
            <h4 class="mb-3">Stay in touch</h4>
            <p class="social"><a href="#" class="facebook external"><i class="fa fa-facebook"></i></a><a href="#" class="twitter external"><i class="fa fa-twitter"></i></a><a href="#" class="instagram external"><i class="fa fa-instagram"></i></a><a href="#" class="gplus external"><i class="fa fa-google-plus"></i></a><a href="#" class="email external"><i class="fa fa-envelope"></i></a></p>
          </div>
          <!-- /.col-lg-3-->
        </div>
        <!-- /.row-->
      </div>
      <!-- /.container-->
    </div>
    <!-- /#footer-->
    <!-- *** FOOTER END ***-->
    
    
    <!--
    *** COPYRIGHT ***
    _________________________________________________________
    -->
    <div id="copyright">
      <div class="container">
        <div class="row">
          <div class="col-lg-6 mb-2 mb-lg-0">
            <p class="text-center text-lg-left">©2019 Your name goes here.</p>
          </div>
          <div class="col-lg-6">
            <p class="text-center text-lg-right">Template design by <a href="https://bootstrapious.com/">Bootstrapious</a>
              <!-- If you want to remove this backlink, pls purchase an Attribution-free License @ https://bootstrapious.com/p/obaju-e-commerce-template. Big thanks!-->
            </p>
          </div>
        </div>
      </div>
    </div>
    <!-- *** COPYRIGHT END ***-->
    <!-- JavaScript files-->
    
    
    <!--
    *** COPYRIGHT ***
    _________________________________________________________
    -->
	<jsp:include page="/inc/copy.jsp"></jsp:include>
    <!-- JavaScript files-->
    <jsp:include page="/inc/script.jsp"></jsp:include>
  </body>
</html>