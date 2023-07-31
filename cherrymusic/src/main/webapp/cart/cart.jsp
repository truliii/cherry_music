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
	ProductDao pDao = new ProductDao();
	
	//로그아웃 상태 : 세션에서 장바구니 정보꺼내기
	if(session.getAttribute("loginId") == null && session.getAttribute("sessionCartList") != null){
		ArrayList<HashMap<String, Object>> sessionCartList = (ArrayList<HashMap<String, Object>>)session.getAttribute("sessionCartList");
		cartList = new ArrayList<>();
		for(HashMap<String, Object> m : sessionCartList){
			int sessionCartCnt = (Integer)m.get("cartCnt");
			int sessionPrdtNo = (Integer)m.get("productNo");
			HashMap<String, Object> prdtInfo = pDao.selectProductOne(sessionPrdtNo);
			
			HashMap<String, Object> c = new HashMap<String, Object>();
			c.put("cartProductNo", sessionPrdtNo);
			c.put("cartCnt", sessionCartCnt);
			c.put("productNo", sessionPrdtNo);
			c.put("productName", prdtInfo.get("productName"));
			c.put("productPrice", prdtInfo.get("productPrice"));
			c.put("productSaveFilename", prdtInfo.get("productSaveFilename"));
			cartList.add(c);
			
		}
	
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
	
	//수량변경 ajax를 위해 필요한 변수
	int num = 0;
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
            <div class="jumbotron jumbotron-bg text-center rounded-0" style="background-image: url('<%=request.getContextPath()%>/resources/assets/img/cherry_header.jpg');">
                <div class="container">
                    <h1 class="pt-5">
                        장바구니
                    </h1>
                    <p class="lead">
                    </p>
                </div>
            </div>
        </div>

        <section id="cart">
            <div class="container">
                <div class="row">
                  	<div class="col-md-12">
					<form method="post" action="<%=request.getContextPath()%>/orders/orderSheet.jsp">
						<%
							if(cartList == null || cartList.size() < 1){
							System.out.println(KMJ + cartList.size() + " <--cart cartList.size()" + RESET);
						%>
								<div class="col text-center">장바구니가 비어있습니다.</div>
						<%
							} else {
						%>
		                        <div class="table-responsive">
		                            <table class="table">
		                                <thead>
		                                    <tr class="text-center">
		                                    	<th></th>
		                                        <th width="10%"></th>
		                                        <th>제품</th>
		                                        <th>제품금액</th>
		                                        <th>할인금액</th>
		                                        <th width="15%">수량</th>
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
			                      			num += 1;
			                      	%>
		                                    <tr class="text-center">
		                                    	<td>
		                                    		<input id="checkbox-<%=num%>" class="checkbox" type="checkbox" name="cartNo" value="<%=(Integer)m.get("cartNo")%>">
		                                    	</td>
		                                        <td>
		                                        	<img src="<%=dir%>/<%=m.get("productSaveFilename")%>" width="60" alt="이미지준비중">
		                                        </td>
		                                        <td>
		                                            <%=(String)m.get("productName")%>
		                                        </td>
		                                        <td>
		                                            <%=m.get("productPrice")%>
		                                        </td>
		                                        <td>
		                                            <%=disPrice%>
		                                        </td>
		                                        <td>
		                                            <input id="cartCnt-<%=num%>" name="cartCnt" type="number" class="form-control" value="<%=(Integer)m.get("cartCnt")%>" class="form-control" min="1" max="<%=productStock%>">
		                                        </td>
		                                        <td>
		                                        	<%=cartPrice-disPrice%><input type="hidden" name="orderPrice" value="<%=cartPrice-disPrice%>">
		                                        </td>
		                                        <td>
		                                            <a href="<%=request.getContextPath()%>/cart/removeCartNoAction.jsp?cartNo=<%=(Integer)m.get("cartNo")%>" class="text-danger"><i class="fa fa-times"></i></a>
		                                        </td>
		                                    </tr>
									<%
											}
									%>
		                                </tbody>
		                            </table>
		                        </div>
			                    <div class="col">
			                        <a href="shop.html" class="btn btn-default">쇼핑계속하기</a>
			                    </div>
			                    <div class="col text-right">
			                        <div class="clearfix"></div>
			                        <h6 class="mt-3">합계: <%=cartSum%>원</h6>
			                        <button id="checkOutBtn" type="submit" class="btn btn-lg btn-primary">주문하기<i class="fa fa-long-arrow-right"></i></button>
			                    </div>
							<%
								}
							%>
                    </form>
                    </div>
                </div>
            </div>
        </section>
    </div>
    <footer>
		<jsp:include page="/inc/footer.jsp"></jsp:include>
    </footer>

    <jsp:include page="/inc/script.jsp"></jsp:include>
    <script>
    	//주문할 상품 선택
    	$('#checkOutBtn').prop('disabled', true);
    	$('.checkbox').change(function(){
   			if($('.checkbox').is(':checked')){
   				$('#checkOutBtn').prop('disabled', false);
   			} else {
   				$('#checkOutBtn').prop('disabled', true);
   			}
    	})
    	
    	//상품수량변경
    	$('input[id^="cartCnt"]').change(function(event){
    		let id = event.target.id; //이벤트가 발생한 요소의 id얻기
    		console.log(id);
    		let eventNo = id.substring(id.indexOf('-')+1); //이벤트가 발생한 요소 id의 번호
    		let cartNoId = 'checkbox-'+eventNo;
    		console.log(cartNoId);
    		
    		let cartNo = $('#'+cartNoId).val();
    		let cartCnt = $('#'+id).val();
    		console.log(cartNo);
    		console.log(cartCnt);
    		$.ajax({
    			url : './modifyCartCntAction.jsp',
    			type : 'post',
    			data : {
    				cartNo : cartNo,
    				cartCnt : cartCnt
    			},
    			success : function(param){
    				console.log(param);
    				console.log('ajax성공');
    			},
    			error : function(){
    				console.log('ajax실패');
    			}
    		})
    	})
    </script>
</body>
</html>

