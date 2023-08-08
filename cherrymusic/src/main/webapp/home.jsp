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
	
	//카테고리 출력
	CategoryDao cDao = new CategoryDao();
	ArrayList<Category> cateList = cDao.selectCategoryList();
	int num = 0;
	
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
                        Good Music<br>
                        for a Good Moment
                    </h1>
                    <p class="lead">
                    </p>

                    <div class="row">
                        <div class="col-md-4">
                            <div class="card border-0 text-center">
                                <div class="card-icon">
                                    <div class="card-icon-i">
                                        <i class="fa fa-music"></i>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <h4 class="card-title">
                                        Music
                                    </h4>
                                    <p class="card-text">
                                        가요부터 클래식까지.<br>
                                        당신이 원하는 모든 음반은 체리뮤직에서 찾아볼 수 있습니다.
                                    </p>

                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card border-0 text-center">
                                <div class="card-icon">
                                    <div class="card-icon-i">
                                        <i class="fas fa-user"></i>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <h4 class="card-title">
                                        Point
                                    </h4>
                                    <p class="card-text">
                                        주문할 때마다 적립되는 포인트 혜택도 놓치지 마세요.
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
                                        Order
                                    </h4>
                                    <p class="card-text">
                                        체리뮤직의 무료 배송서비스를 이용하세요.<br>
                                        주문한 음반은 주문지까지 안전히 배송됩니다.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <section id="categories" class="pb-0 gray-bg">
            <h2 class="title">카테고리</h2>
            <div class="landing-categories owl-carousel">
               	<%
               		for(Category c : cateList){
               			num += 1;
               	%>
	                <div class="item">
		                    <div class="card rounded-0 border-0 text-center">
		                        <img src="<%=request.getContextPath()%>/resources/assets/img/category<%=num%>.jpg">
		                        <div class="card-img-overlay d-flex align-items-center justify-content-center">
		                            <!-- <h4 class="card-title">Vegetables</h4> -->
		                            <a href="<%=request.getContextPath()%>/product/categoryProduct.jsp?categoryName=<%=c.getCategoryName()%>" class="btn btn-primary btn-lg"><%=c.getCategoryName()%></a>
		                        </div>
		                    </div>
	                </div>
               	<%
               		}
               	%>
            </div>
        </section>
    </div>
    <footer>
        <jsp:include page="/inc/footer.jsp"></jsp:include>
    </footer>

    <jsp:include page="/inc/script.jsp"></jsp:include>
</body>
</html>