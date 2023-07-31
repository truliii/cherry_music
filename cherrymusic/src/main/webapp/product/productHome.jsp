<%@page import="java.util.Base64.Encoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>

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
	
	//카테고리 출력
	CategoryDao cDao = new CategoryDao();
	ArrayList<Category> cateList = cDao.selectCategoryList();
	
	//카테고리별 상품출력을 위한 객체생성
	ProductDao pDao = new ProductDao();
	ArrayList<HashMap<String, Object>> pList = new ArrayList<>();
	ArrayList<HashMap<String, Object>> dList = new ArrayList<>();
	
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

        <!-- 카테고리별 바로가기 -->
        <div class="container">
            <div class="row">
                <div class="col-md-12">
                    <div class="shop-categories owl-carousel mt-5">
                    	<%
                    		for(Category c : cateList){
                    	%>
	                        <div class="item">
	                            <a href="<%=request.getContextPath()%>/product/categoryProduct.jsp?categoryName=<%=c.getCategoryName()%>">
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

		<!-- 할인 중 시작 -->
        <section id="most-wanted">
            <div class="container">
                <div class="row">
                    <div class="col-md-12">
                        <h2 class="title">할인중</h2>
                        <div class="product-carousel owl-carousel">
                        <%
                        	dList = pDao.selectProductsByCategory(0, 8, "", "최신순");
                        	for(HashMap<String, Object> m : dList){
                        		//해당상품의 할인률 출력
                        		double discountRate = (Double)m.get("discountRate");
                        		//최종가격
                        		int finalPrice = (int)((Integer)m.get("productPrice")*(1-discountRate));
                        		if(discountRate != 0){
                        %>
                            <div class="item">
                                <div class="card card-product">
                                    <div class="card-ribbon">
                                        <div class="card-ribbon-container right">
                                            <span class="ribbon ribbon-primary">할인중</span>
                                        </div>
                                    </div>
                                    <div class="card-badge">
                                        <div class="card-badge-container left">
                                            <span class="badge badge-default">
                                                <%=(String)m.get("discountEnd") %>
                                            </span>
                                            <span class="badge badge-primary">
                                                <%=(Double)m.get("discountRate")*100 %>% 할인중
                                            </span>
                                        </div>
                                        <img src="<%=request.getContextPath() %>/product/productImg/<%=m.get("productSaveFilename") %>" alt="Card image 2" class="card-img-top">
                                    </div>
                                    <div class="card-body">
                                        <h4 class="card-title">
                                            <a href="<%=request.getContextPath()%>/product/customerProductDetail.jsp?productNo=<%=m.get("productNo")%>"><%=(String)m.get("productName") %></a>
                                        </h4>
                                        <div class="card-price">
                                            <span class="discount"><%=finalPrice%>원</span>
                                            <span class="reguler"><%=(Integer)m.get("productPrice")%>원</span>
                                        </div>
                                        <a href="<%=request.getContextPath()%>/product/customerProductDetail.jsp?productNo=<%=m.get("productNo")%>&cartCnt=1" class="btn btn-block btn-primary">
                                            장바구니에 담기
                                        </a>

                                    </div>
                                </div>
                            </div>
                         <%
                        		}
                        	}
                         %>
                        </div>
                    </div>
                </div>
            </div>
        </section>
		
		<!-- 카테고리별 상품 미리보기 시작 -->
		<%
			for (Category c : cateList){
            	pList = pDao.selectProductsByCategory(0, 8, (String)c.getCategoryName(), "최신순");
            	System.out.println(KMJ +  pList.size()+"<-- productHome pListsize" + RESET);
		%>
        <section id="vegetables" class="gray-bg">
            <div class="container">
                <div class="row">
                    <div class="col-md-12">
                        <h2 class="title"><%=c.getCategoryName()%></h2>
                        <div class="product-carousel owl-carousel">
                        <%
                        	for(HashMap<String, Object> m : pList){
                        		//해당상품의 할인률 출력
                        		double discountRate = (Double)m.get("discountRate");
                        		//최종가격
                        		int finalPrice = (int)((Integer)m.get("productPrice")*(1-discountRate));
                        %>
                            <div class="item">
                                <div class="card card-product">
                                    <div class="card-ribbon">
                                        <div class="card-ribbon-container right">
                                            <span class="ribbon ribbon-primary"><%=(String)c.getCategoryName()%></span>
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
                                        <img src="assets/img/meats.jpg" alt="Card image 2" class="card-img-top">
                                    </div>
                                    <div class="card-body">
                                        <h4 class="card-title">
                                            <a href="<%=request.getContextPath()%>/product/customerProductDetail.jsp?productNo=<%=m.get("productNo")%>"><%=(String)m.get("productName") %></a>
                                        </h4>
                                        <div class="card-price">
                                            <span class="discount"><%=(Integer)m.get("productPrice")%>원</span>
                                            <span class="reguler"><%=finalPrice%>원</span>
                                        </div>
                                        <a href="<%=request.getContextPath()%>/product/customerProductDetail.jsp?productNo=<%=m.get("productNo")%>&cartCnt=1" class="btn btn-block btn-primary">
                                            장바구니에 담기
                                        </a>

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
        <%
			}
        %>
		<!-- 카테고리별 상품 미리보기 끝 -->
    </div>
    <footer>
        <jsp:include page="/inc/footer.jsp"></jsp:include>
    </footer>

    <jsp:include page="/inc/script.jsp"></jsp:include>
</body>