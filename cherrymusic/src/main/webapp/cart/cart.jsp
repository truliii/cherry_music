<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	ArrayList<HashMap<String, Object>> cartList = null;
	
	//view에서 출력할 변수 선언
	//이미지 저장경로
	String dir = request.getContextPath()+"/product/productImg";
	
	//장바구니 금액 합계
	int cartSum = 0;
	//상품재고량
	int productStock = 0;
	//할인률 출력
	DiscountDao disDao = new DiscountDao();
	Discount discount = null;
	double disRate = 0;
	int cartPrice = 0;
	int disPrice = 0;
	
	CartDao cDao = new CartDao();
	
	//로그아웃 상태 : 세션에서 장바구니 꺼내기
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/id_list/login.jsp");
		System.out.println(KMJ + "로그인 안되어 있어 cart에서 리다이렉션" + RESET);
		return;
	} else {
	
	//로그인 상태 : db에서 장바구니 정보 불러오기
	Object o = session.getAttribute("loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	} 
	System.out.println(KMJ + loginId + "<-- cart loginId" + RESET);
	cartList = cDao.selectCartListByPage(loginId);
	}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Freshcery | Groceries Organic Store</title>
    <jsp:include page="/inc/head.jsp"></jsp:include>

</head>
<body>
    <jsp:include page="/inc/header.jsp"></jsp:include>
    <div id="page-content" class="page-content">
        <div class="banner">
            <div class="jumbotron jumbotron-bg text-center rounded-0" style="background-image: url('assets/img/bg-header.jpg');">
                <div class="container">
                    <h1 class="pt-5">
                        장바구니
                    </h1>
                    <p class="lead">
                        Save time and leave the groceries to us.
                    </p>
                </div>
            </div>
        </div>

        <section id="cart">
            <div class="container">
                <div class="row">
					<form method="post" action="<%=request.getContextPath()%>/orders/orderSheet.jsp">
						<%
							if(cartList == null || cartList.size() < 1){
							System.out.println(KMJ + cartList.size() + " <--cart cartList.size()" + RESET);
						%>
								<div class="col text-center">장바구니가 비어있습니다.</div>
						<%
							} else {
						%>
	                    	<div class="col-md-12">
		                        <div class="table-responsive">
		                            <table class="table">
		                                <thead>
		                                    <tr>
		                                        <th width="10%"></th>
		                                        <th>제품</th>
		                                        <th>제품금액</th>
		                                        <th width="15%">수량</th>
		                                        <th>할인금액</th>
		                                        <th>합계</th>
		                                        <th></th>
		                                    </tr>
		                                </thead>
		                                <tbody>
				                  <%
			                      		for(HashMap<String, Object> m : cartList){
			                      			productStock = cDao.productCartStock((Integer)m.get("productNo"));
			                      			discount = disDao.selectProductCurrentDiscount((Integer)m.get("productNo"));
			                      			if(discount != null){
			                      				disRate = discount.getDiscountRate();
			                      			}
			                      			cartPrice = (Integer)m.get("productPrice") * (Integer)m.get("cartCnt");
			                      			disPrice = (int)Math.floor(cartPrice*disRate);
			                      			cartSum += (cartPrice - disPrice);
			                      	%>
		                                    <tr>
		                                        <td>
													<input id="cartNo" type="hidden" name="cartNo" value="<%=m.get("cartNo")%>" required>
		                                        	<img src="<%=dir%>/<%=m.get("productSaveFilename")%>" width="60" alt="이미지준비중">
		                                        </td>
		                                        <td>
		                                            <%=(String)m.get("productName")%>
		                                        </td>
		                                        <td>
		                                            <%=cartPrice%>
		                                        </td>
		                                        <td>
		                                            <input name="cartCnt" type="number" value="<%=(Integer)m.get("cartCnt")%>" class="form-control" min="1" max="<%=productStock%>" readonly>
		                                            <input class="vertical-spin" type="text" data-bts-button-down-class="btn btn-primary" data-bts-button-up-class="btn btn-primary" value="" name="vertical-spin">
		                                        </td>
		                                        <td>
		                                            <%=disPrice%>
		                                        </td>
		                                        <td>
		                                        	<%=cartPrice-disPrice%><input type="hidden" name="orderPrice" value="<%=cartPrice-disPrice%>">
		                                        </td>
		                                        <td>
		                                            <a href="javasript:void" class="text-danger"><i class="fa fa-times"></i></a>
		                                        </td>
		                                    </tr>
									<%
											}
									%>
		                                </tbody>
		                            </table>
		                        </div>
		                    </div>
		                    <div class="col">
		                        <a href="shop.html" class="btn btn-default">Continue Shopping</a>
		                    </div>
		                    <div class="col text-right">
		                        <div class="clearfix"></div>
		                        <h6 class="mt-3">합계: <%=cartSum%>원</h6>
		                        <button type="submit" class="btn btn-lg btn-primary">주문하기<i class="fa fa-long-arrow-right"></i></button>
		                    </div>
							<%
								}
							%>
                    </form>
                </div>
            </div>
        </section>
    </div>
    <footer>
		<jsp:include page="/inc/footer.jsp"></jsp:include>
    </footer>

    <jsp:include page="/inc/script.jsp"></jsp:include>
    <script>
    	
    </script>
</body>
</html>

