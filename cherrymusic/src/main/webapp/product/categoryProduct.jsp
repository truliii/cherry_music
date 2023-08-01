<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>

<%	
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	//로그인 세션 유효성 검사
	Object o = null;
	String loginId = "";
	if(session.getAttribute("loginId") != null){
		o = session.getAttribute("loginId");
		if(o instanceof String){
			loginId = (String)o;
		}
	}
	
	//요청값 유효성 검사 : beginRow, rowPerPage, categoryName, desc
	request.setCharacterEncoding("utf-8");
	
	int beginRow = request.getParameter("beginRow") != null ? Integer.parseInt(request.getParameter("beginRow")) : 0;
	int rowPerPage = request.getParameter("rowPerPage") != null ? Integer.parseInt(request.getParameter("rowPerPage")) : 10;
	String categoryName = request.getParameter("categoryName") != null ? request.getParameter("categoryName") : "";
	String desc = request.getParameter("desc") != null ? request.getParameter("desc") : "최신순";
	
	//카테고리 출력
	CategoryDao cDao = new CategoryDao();
	ArrayList<Category> cateList = cDao.selectCategoryList();
	
	//카테고리별 상품출력을 위한 객체생성
	ProductDao pDao = new ProductDao();
	ArrayList<HashMap<String, Object>> pList = pDao.selectProductsByCategory(beginRow, rowPerPage, categoryName, desc);
	
	//상품별 할인출력을 위한 객체생성
	DiscountDao dDao = new DiscountDao();
%>

<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/inc/head.jsp"></jsp:include>

</head>
<body>
    <jsp:include page="/inc/header.jsp"></jsp:include>
    
    <div id="page-content" class="page-content">
    	<!-- 배너시작 -->
        <div class="banner">
            <div class="jumbotron jumbotron-bg text-center rounded-0" style="background-image: url('<%=request.getContextPath()%>/resources/assets/img/cherry_header.jpg');">
                <div class="container">
                    <h1 class="pt-5">
                        상품보기
                    </h1>
                    <p class="lead">
                    </p>
                </div>
            </div>
        </div>
        <!-- 배너 끝 -->

        <!-- 카테고리별 바로가기 -->
        <div class="container">
            <div class="row mt-5">
                <div class="col-md-12">
                    <div class="shop-categories owl-carousel">
                    	<%
                    		for(Category c : cateList){
                    	%>
	                        <div class="item">
	                            <a href="<%=request.getContextPath() %>/product/categoryProduct.jsp?categoryName=<%=c.getCategoryName()%>&beginRow=0&rowPerPage=10&desc=최신순">
	                                <div class="media d-flex align-items-center justify-content-center">
	                                    <span class="d-flex mr-2"><i class=""></i></span>
	                                    <div class="media-body text-center">
	                                        <h5><%=c.getCategoryName()%></h5>
	                                    </div>
	                                </div>
	                            </a>
	                        </div>
                    	<%
                    		}
                    	%>
                    </div>
                </div>
            </div>
        </div>
        <!-- 카테고리별 바로가기 끝 -->
        
        <!-- 상품 시작 -->
        <section id="most-wanted">
            <div class="container">
                <div class="row">
                    <div class="col-md-12">
                        <h2 class="title"><%=categoryName%></h2>
                        <div class="row">
                        <%
                       		for(HashMap<String, Object> m : pList){
	                    		//해당상품의 할인률 출력
	                    		double discountRate = (Double)m.get("discountRate");
	                    		//최종가격
	                    		int finalPrice = (int)((Integer)m.get("productPrice")*(1-discountRate));
                        %>	
	                        <div class="col-3 mb-5">
	                            <div class="item">
	                                <div class="card card-product">
	                                    <div class="card-ribbon">
	                                        <div class="card-ribbon-container right">
	                                            <span class="ribbon ribbon-primary"><%=categoryName%></span>
	                                        </div>
	                                    </div>
	                                    <div class="card-badge">
	                                        <div class="card-badge-container left">
	                                            <%
	                                           		if(discountRate != 0.0){
	                                           	%>
		                                            <span class="badge badge-primary">
	                                               <%=discountRate*100%>% 할인중
		                                            </span>
	                                            <%
	                                        		}
	                                            %>
	                                        </div>
	                                        <img src="<%=request.getContextPath()%>/product/productImg/<%=m.get("productSaveFilename")%>" alt="Card image 2" class="card-img-top">
	                                    </div>
	                                    <div class="card-body">
	                                        <h4 class="card-title">
	                                            <a href="<%=request.getContextPath()%>/product/customerProductDetail.jsp?productNo=<%=m.get("productNo")%>"><%=m.get("productName")%></a>
	                                        </h4>
	                                        <div class="card-price">
	                                            <span class="discount"><%=m.get("productPrice")%>원</span>
	                                            <span class="reguler"><%=finalPrice%>원</span>
	                                        </div>
	                                        <a href="<%=request.getContextPath()%>/product/customerProductDetail.jsp?productNo=<%=m.get("productNo")%>&cartCnt=1" class="btn btn-block btn-primary">
	                                            장바구니에 담기
	                                        </a>
	
	                                    </div>
	                                </div>
	                            </div>
	                         </div>
                         <%
							}
                         %>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- 상품 끝 -->
    </div>
    
    <footer>
        <jsp:include page="/inc/footer.jsp"></jsp:include>
    </footer>

    <jsp:include page="/inc/script.jsp"></jsp:include>
</body>