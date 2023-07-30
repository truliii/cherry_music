<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	//로그인 유효성 검사 : 로그아웃 상태면 로그인창으로 리다이렉션
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/id_list/login.jsp");
		System.out.println(KMJ + "orderSheet 로그인 필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	}
	System.out.println(KMJ + loginId + " <--orderSheet loginId");
	
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");
	
	//요청값 유효성 검사
	if(request.getParameterValues("cartNo") == null
		|| request.getParameterValues("cartNo").length == 0){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	} 
	
	CartDao cDao = new CartDao();
	DiscountDao dDao = new DiscountDao();
	ArrayList<HashMap<String, Object>> cartList = new ArrayList<>(); //view출력할 정보를 담은 list
	
	//checkbox에 체크한 상품의 cartNo가 넘어온다
	int totalPrice = 0;
	String[] cartNoStr = request.getParameterValues("cartNo"); 
	System.out.println(KMJ + cartNoStr.length + "<--orderSheet.jsp cartNoStr.length" + RESET);
	for(String s : cartNoStr){
		HashMap<String, Object> cart = cDao.selectCartOne(Integer.parseInt(s));
		HashMap<String, Object> m = new HashMap<String, Object>(); //cartList에 저장할 map
		m.put("cartNo", Integer.parseInt(s));
		m.put("productNo", (Integer)cart.get("productNo"));
		m.put("productName", (String)cart.get("productName"));
		m.put("cartCnt", (Integer)cart.get("cartCnt"));
		m.put("productPrice", (Integer)cart.get("productPrice"));
		
		//할인금액 구하기
		Discount cartDis = dDao.selectProductCurrentDiscount((Integer)cart.get("productNo")); //해당상품의 discount정보를 Discount 타입으로 반환
		double disRate = 0;
		int disPrice = 0;
		if(cartDis != null){
			disRate = cartDis.getDiscountRate();
		}
		disPrice = (int)((Integer)cart.get("productPrice")*(1 - disRate)); //상품별 할인된 금액
		int orderPrice = (Integer)cart.get("cartCnt") * disPrice; 
		System.out.println(KMJ + orderPrice + "<--orderSheet.jsp orderPrice" + RESET);
		m.put("orderPrice", orderPrice);
		
		cartList.add(m);
		
		totalPrice += orderPrice;
	}
	
	//id별 주소목록 출력
	AddressDao addDao = new AddressDao();
	ArrayList<Address> addList = addDao.selectAddressList(loginId);
	
	//포인트정보 출력
	CustomerDao cstmDao = new CustomerDao();
	Customer customer = cstmDao.selectCustomer(loginId);
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
            <div class="jumbotron jumbotron-bg text-center rounded-0" style="background-image: url('assets/img/bg-header.jpg');">
                <div class="container">
                    <h1 class="pt-5">
                        주문하기
                    </h1>
                    <p class="lead">
                    </p>
                </div>
            </div>
        </div>

        <section id="checkout">
            <div class="container">
                <form action="<%=request.getContextPath()%>/orders/ordersAction.jsp" method="post" class="bill-detail">
	                <div class="row">
	                    <div class="col-xs-12 col-sm-7">
	                        <h5 class="mb-3">주문자 정보</h5>
	                        <!-- 주문자정보 시작 -->
	                            <fieldset>
	                                <div class="form-group row">
	                                	<div class="col-2 text-right">
	                                		<input type="hidden" id="loginId" value="<%=loginId%>">
	                                		<strong><label for="name">이름</label></strong>
	                                	</div>
	                                	<div class="col-10">
		                                    <input id="name" type="text" class="form-control" value="<%=customer.getCstmName()%>" required>
	                                	</div>
	                                </div>
	                                <div class="form-group row">
	                                	<div class="col-2 text-right">
	                                		<strong><label for="phone">연락처</label></strong>
	                                	</div>
	                                	<div class="col-10">
		                                    <input id="phone" type="text" class="form-control" value="<%=customer.getCstmPhone()%>" required>
	                                	</div>
	                                </div>
	                                <div class="form-group row">
	                                	<div class="col-2 text-right">
	                                		<strong><label for="address">주소</label></strong>
	                                	</div>
	                                	<div class="col-10">
	                                		<div class="row mb-1">
	                                			<div class="col-12">
			                                		<select id="address" class="form-control">
													<%
														for(Address a : addList){
														String addSelect = a.getAddressDefault().equals("Y") ? "selected": "";
													%>
														<option value="<%=a.getAddress()%>" <%=addSelect%>><%=a.getAddressName()%></option>
													<%
														}
													%>
													</select>
	                                			</div>
	                                		</div>
	                                		<div class="row">
	                                			<div class="col-12">
		                                			<input id="addtext" type="text" class="form-control" value="" readonly>
	                                			</div>
	                                		</div>
	                                	</div>
	                                </div>
	                                <div class="form-group row">
	                                	<div class="col-2 text-right">
	                                		<strong><label for="">포인트</label></strong>
	                                	</div>
	                                	<div class="col-10">
	                                		<div class="row mb-1">
	                                			<div class="col-6">
				                                    <input id="currPoint" name="currPoint" type="number" class="form-control" placeholder="가용포인트" value="<%=customer.getCstmPoint()%>" readonly>
	                                			</div>
												<div class="col-6">
													<input class="mr-1" type="checkbox" id="useAllPoint">포인트 전체 사용
												</div>	                                		
	                                		</div>
	                                		<div class="row">
	                                			<div class="col-6">
		                                			<input id="usePoint" name="usePoint" type="number" class="form-control" placeholder="사용포인트" value="0" min="0" required>
	                                			</div>
	                                			<div class="col-6">
	                                				<span id="min"></span>p부터 사용가능(<span id="unit"></span>p단위)
	                                			</div>
	                                		</div>
	                                	</div>
	                                </div>
	                                <div class="form-group row">
	                                	<div class="col-2 text-right">
	                                		<strong><label for="orderNotes">배송요청사항</label></strong>
	                                	</div>
	                                	<div class="col-10">
		                                    <textarea id="orderNotes" class="form-control"></textarea>
	                                	</div>
	                                </div>
	                            </fieldset>
	                        <!-- 주문자정보 끝 -->
	                    </div>
	                    <div class="col-xs-12 col-sm-5">
	                        <div class="holder">
	                            <h5 class="mb-3">주문 확인</h5>
	                            <div class="table-responsive">
	                                <table class="table">
	                                    <thead>
	                                        <tr>
	                                            <th>상품</th>
	                                            <th class="text-right">소계</th>
	                                        </tr>
	                                    </thead>
	                                    <tbody>
	                                    	<%
	                                    		for(HashMap<String, Object> m : cartList){
	                                    	%>
	                                        <tr>
	                                            <td>
			                                    	<input type="hidden" name="cartNo" value="<%=(Integer)m.get("cartNo")%>">
			                                    	<input type="hidden" name="orderCnt" value="<%=(Integer)m.get("cartCnt")%>">
			                                    	<input type="hidden" name="productNo" value="<%=(Integer)m.get("productNo")%>">
	                                                <input id="orderPrice" name="orderPrice" type="hidden" class="form-control" value="<%=(Integer)m.get("orderPrice")%>">
	                                                <%=m.get("productName")%> x <%=m.get("cartCnt")%>개
	                                            </td>
	                                            <td class="text-right">
	                                                <%=(Integer)m.get("orderPrice")%>원
	                                            </td>
	                                        </tr>
	                                        <%
	                                    		}
	                                        %>
	                                    </tbody>
	                                    <tfoot>
	                                        <tr>
	                                            <td>
	                                                <strong>총 주문금액</strong>
	                                            </td>
	                                            <td class="text-right">
	                                                <%=totalPrice%>원
	                                            </td>
	                                        </tr>
	                                        <tr>
	                                            <td>
	                                                <strong>배송비</strong>
	                                            </td>
	                                            <td class="text-right">
	                                                0원
	                                            </td>
	                                        </tr>
	                                        <tr>
	                                            <td>
	                                                <strong>총 결제금액</strong>
	                                            </td>
	                                            <td class="text-right">
	                                                <%=totalPrice%>원</strong>
	                                            </td>
	                                        </tr>
	                                    </tfoot>
	                                </table>
	                            </div>
	
	                            <h5 class="mb-3"><label for="payment">결제방법</label></h5>
	                            <div class="form-check-inline">
	                                <label class="form-check-label">
	                                    <input class="form-check-input" type="radio" name="payment" id="payment" value="무통장입금" checked>
	                                    무통장입금
	                                </label>
	                            </div>
	                            <div class="form-check-inline">
	                                <label class="form-check-label">
	                                    <input class="form-check-input" type="radio" name="payment" id="payment" value="카드결제">
	                                    카드결제
	                                </label>
	                            </div>
	                        </div>
	                        <p class="text-right mt-3">
	                            <input id="terms" type="checkbox"> <a href="#">주문 유의사항</a>을 모두 확인하였으면 이에 동의합니다.
	                        </p>
	                        <button id="checkoutBtn" type="submit" class="btn btn-primary float-right">주문 진행하기<i class="fa fa-check"></i></button>
	                        <div class="clearfix"></div>
	                	</div>
	            	</div>
              </form>
            </div>
        </section>
    </div>
    <footer>
		<jsp:include page="/inc/footer.jsp"></jsp:include>
    </footer>

    <jsp:include page="/inc/script.jsp"></jsp:include>
    <script>
    	//주소선택
		function handleAdd(){
			let addressName = $('#address option:selected').text();
	    	let loginId = $('#loginId').val();
	    	console.log(addressName);
	    	console.log(loginId);
   			console.log('handleAddress함수실행');
	    	$.ajax({
	   			url : './modifyOrderAddressAction.jsp',
	   			type : 'post',
	   			data : {
	   				addressName : addressName,
	   				loginId : loginId},
	   			success : function(param){
	   				$('#addtext').val(param);
	   			},
	   			error : function(){
	   				console.log('ajax실패');
	   			}
	   		})
    	};
    	handleAdd();
    	$('#address').change(handleAdd);
    	
    	//포인트 사용
    	const MIN = 1000;
    	const UNIT = 10;
    	let price = <%=totalPrice%>;
    	console.log(price);
    	$("#min").text(MIN);
    	$("#unit").text(UNIT);
    	
    	//전체포인트 사용이 체크된 경우
    	$("#useAllPoint").change(function(){
    		if($("#useAllPoint").is(":checked")){
    			console.log("전체포인트 사용 체크");
    			if($("#currPoint").val() > price){ //가용포인트가 결제금액보다 클 때
    				$("#usePoint").val(price - price%UNIT);
        		} else { //가용포인트가 결제금액보다 적을 때
        			$("#usePoint").val($("#currPoint").val() - $("#currPoint").val()%UNIT);
        		}
    			console.log($("#usePoint").val());
    		} else {
    			$("#usePoint").val(0);
    			console.log($("#usePoint").val());
    		}
    		
    		$("#finalPrice").val(price - $("#usePoint").val());
    	})
		
    	$("#usePoint").blur(function(){
    		$("#useAllPoint").prop("checked", false);
    		console.log($("#usePoint").val());
    		//가용포인트가 결제금액보다 클 때
    		if($("#currPoint") > price){
    			if($("#currPoint").val() < MIN){ //가용포인트가 최소금액보다 적은 경우
    				$("#usePoint").val(0);
    			} else {
    				if($("#usePoint").val() < MIN){ //사용포인트가 최소포인트보다 적으면 0 
    					$("#usePoint").val(0);
    				} else if ($("#usePoint").val() > $("#currPoint").val()){ //현재포인트보다 많으면 결제금액
    					$("#usePoint").val(price);
    				} else { //둘다 아닌 경우(최소포인트<사용포인트<현재포인트) 입력포인트 단위에 맞는 값
    					$("#usePoint").val($("#usePoint").val() - $("#usePoint").val()%UNIT);
    				}
    			}
    		} else { //가용포인트가 결제금액보다 적을 때
    			//사용포인트가 최소포인트보다 적으면 0 
    	    	if($("#currPoint").val() < MIN){
    				$("#usePoint").val(0);
    			} else {
    				if($("#usePoint").val() < MIN){ //사용포인트가 최소포인트보다 적으면 0 
    					$("#usePoint").val(0);
    				} else if ($("#usePoint").val() > $("#currPoint").val()){ //현재포인트보다 많으면 Math.floor(현재포인트/10)*10
    					$("#usePoint").val($("#currPoint").val());
    				} else { //둘다 아닌 경우(최소포인트<사용포인트<현재포인트) Math.floor(usePoint/10)*10 
    					$("#usePoint").val($("#usePoint").val() - $("#usePoint").val()%UNIT);
    				}
    			}
    		}
    		
    		$("#finalPrice").val(price - $("#usePoint").val());
    	})
    	
    	//주문 동의 진행
    	$('#checkoutBtn').prop('disabled', true);
    	$('input[id="terms"]').change(function(){
	    	if($('#terms').is(':checked') == true){
	    		$('#checkoutBtn').prop('disabled', false);
	    	} else {
	    		$('#checkoutBtn').prop('disabled', true);
	    	}
    	})
    </script>
</body>
</html>