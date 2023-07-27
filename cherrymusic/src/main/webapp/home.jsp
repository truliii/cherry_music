<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>

<%
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	
	// 아이디 레벨 검사 
	IdListDao iDao = new IdListDao();
	IdList idList = new IdList();
	int idLevel = idList.getIdLevel();
	System.out.println(SJ+idLevel + RE );
	
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
	int startNum = 0;
	ArrayList<HashMap<String, Object>> cntList = pDao.selectSumCntByPage(true, beginRow, rowPerPage);
	ArrayList<HashMap<String, Object>> cntList1 = pDao.selectSumCntByPage(true, startNum, 1);
	

	// 상품이미지 코드
	String productSaveFilename = null;
	String dir = request.getContextPath() + "/product/productImg/" + productSaveFilename;
	System.out.println(SJ+ dir + "<-dir" +RE);
	System.out.println(SJ+productSaveFilename + RE );
%>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/inc/head.jsp"></jsp:include>

</head>
<body>
    <jsp:include page="/inc/header.jsp"></jsp:include>
    <div id="page-content" class="page-content">
        <div class="banner">
            <div class="jumbotron jumbotron-video text-center bg-dark mb-0 rounded-0">
                <video width="100%" preload="auto" loop autoplay muted>
                    <source src='<%=request.getContextPath()%>/resources/assets/media/explore.mp4' type='video/mp4' />
                    <source src='<%=request.getContextPath()%>/resources/assets/media/explore.webm' type='video/webm' />
                </video>
                <div class="container">
                    <h1 class="pt-5">
                        Save time and leave the<br>
                        groceries to us.
                    </h1>
                    <p class="lead">
                        Always Fresh Everyday.
                    </p>

                    <div class="row">
                        <div class="col-md-4">
                            <div class="card border-0 text-center">
                                <div class="card-icon">
                                    <div class="card-icon-i">
                                        <i class="fa fa-shopping-basket"></i>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <h4 class="card-title">
                                        Buy
                                    </h4>
                                    <p class="card-text">
                                        Simply click-to-buy on the product you want and submit your order when you're done.
                                    </p>

                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card border-0 text-center">
                                <div class="card-icon">
                                    <div class="card-icon-i">
                                        <i class="fas fa-leaf"></i>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <h4 class="card-title">
                                        Harvest
                                    </h4>
                                    <p class="card-text">
                                        Our team ensures the produce quality is up to our standard and delivers to your door within 24 hours of harvest day.
                                    </p>

                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card border-0 text-center">
                                <div class="card-icon">
                                    <div class="card-icon-i">
                                        <i class="fa fa-truck"></i>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <h4 class="card-title">
                                        Delivery
                                    </h4>
                                    <p class="card-text">
                                        Farmers receive your orders two days in advance so they can prepare for harvest exactly as your orders – no wasted produce.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <section id="categories" class="pb-0 gray-bg">
            <h2 class="title">Categories</h2>
            <div class="landing-categories owl-carousel">
                <div class="item">
                    <div class="card rounded-0 border-0 text-center">
                        <img src="<%=request.getContextPath()%>/resources/assets/img/vegetables.jpg">
                        <div class="card-img-overlay d-flex align-items-center justify-content-center">
                            <!-- <h4 class="card-title">Vegetables</h4> -->
                            <a href="<%=request.getContextPath()%>/resources/shop.html" class="btn btn-primary btn-lg">Vegetables</a>
                        </div>
                    </div>
                </div>
                <div class="item">
                    <div class="card rounded-0 border-0 text-center">
                        <img src="<%=request.getContextPath()%>/resources/assets/img/fruits.jpg">
                        <div class="card-img-overlay d-flex align-items-center justify-content-center">
                            <!-- <h4 class="card-title">Fruits</h4> -->
                            <a href="<%=request.getContextPath()%>/resources/shop.html" class="btn btn-primary btn-lg">Fruits</a>
                        </div>
                    </div>
                </div>
                <div class="item">
                    <div class="card rounded-0 border-0 text-center">
                        <img src="<%=request.getContextPath()%>/resources/assets/img/meats.jpg">
                        <div class="card-img-overlay d-flex align-items-center justify-content-center">
                            <!-- <h4 class="card-title">Meats</h4> -->
                            <a href="<%=request.getContextPath()%>/resources/shop.html" class="btn btn-primary btn-lg">Meats</a>
                        </div>
                    </div>
                </div>
                <div class="item">
                    <div class="card rounded-0 border-0 text-center">
                        <img src="<%=request.getContextPath()%>/resources/assets/img/fish.jpg">
                        <div class="card-img-overlay d-flex align-items-center justify-content-center">
                            <!-- <h4 class="card-title">Fishes</h4> -->
                            <a href="<%=request.getContextPath()%>/resources/shop.html" class="btn btn-primary btn-lg">Fishes</a>
                        </div>
                    </div>
                </div>
                <div class="item">
                    <div class="card rounded-0 border-0 text-center">
                        <img src="<%=request.getContextPath()%>/resources/assets/img/frozen.jpg">
                        <div class="card-img-overlay d-flex align-items-center justify-content-center">
                            <!-- <h4 class="card-title">Frozen Foods</h4> -->
                            <a href="<%=request.getContextPath()%>/resources/shop.html" class="btn btn-primary btn-lg">Frozen Foods</a>
                        </div>
                    </div>
                </div>
                <div class="item">
                    <div class="card rounded-0 border-0 text-center">
                        <img src="<%=request.getContextPath()%>/resources/assets/img/package.jpg">
                        <div class="card-img-overlay d-flex align-items-center justify-content-center">
                            <!-- <h4 class="card-title">Package</h4> -->
                            <a href="<%=request.getContextPath()%>/resources/shop.html" class="btn btn-primary btn-lg">Package</a>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>
    <footer>
        <jsp:include page="/inc/footer.jsp"></jsp:include>
    </footer>

    <jsp:include page="/inc/script.jsp"></jsp:include>
</body>
</html>