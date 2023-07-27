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
	if(request.getParameter("cartNo") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	} 
	int disPrice = 0;
	if(request.getParameter("disPrice") != null){
		disPrice = Integer.parseInt(request.getParameter("disPrice"));
	}
	
	int cartNo = Integer.parseInt(request.getParameter("cartNo"));
	System.out.println(KMJ + cartNo + " <--orderSheet cartNo" + RESET);
	System.out.println(KMJ + disPrice + " <--orderSheet disPrice" + RESET);
		
	//주문정보 출력
	CartDao cDao = new CartDao();
	HashMap<String, Object> cart = cDao.selectCartOne(cartNo);
	int totalPrice = ((Integer)cart.get("cartCnt") * (Integer)cart.get("productPrice")) - disPrice;
	
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
	<meta charset="UTF-8">
	<title>Customer One</title>
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
              <!-- breadcrumb-->
              <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                  <li class="breadcrumb-item"><a href="#">장바구니/주문</a></li>
                  <li aria-current="page" class="breadcrumb-item active">주문하기</li>
                </ol>
              </nav>
            </div>
            <div id="checkout" class="col-lg-12">
              <div class="box">
                <form action="<%=request.getContextPath()%>/orders/ordersAction.jsp" method="post">
					<input type="hidden" name="cartNo" value="<%=cartNo%>">
					<input type="hidden" name="productNo" value="<%=cart.get("productNo")%>">
					<input type="hidden" name="orderCnt" value="<%=cart.get("cartCnt")%>">
                  <h1>주문하기</h1>
                  <div class="nav flex-column flex-md-row nav-pills text-center">
                  	<a href="checkout1.html" class="nav-link flex-sm-fill text-sm-center active"><i class="fa fa-map-marker"></i>주문하기</a>
                  	<a href="#" class="nav-link flex-sm-fill text-sm-center disabled"> <i class="fa fa-eye"></i>주문확인</a>
                  </div>
                 <div class="content py-3">
	                 <h3>주문상품정보</h3>
	                    <div class="row">
	                     <div class="col-md-12">
	                      <table class="table table-bordered">
	                      	<tr>
	                      		<th>주문상품</th>
	                      		<th>상품금액</th>
	                      		<th>수량</th>
	                      		<th>할인액</th>
	                      	</tr>
	                      	<tr>
	                      		<td>
	                      			<img src="<%=request.getContextPath()%>/product/productImg/<%=cart.get("productSaveFilename")%>" alt="이미지 준비중" height="10" width="auto">
									<%=cart.get("productName")%>
	                      		</td>
	                      		<td><%=cart.get("productPrice")%>원</td>
	                      		<td><%=cart.get("cartCnt")%>개</td>
	                      		<td><%=disPrice%>원</td>
	                      	</tr>
	                       </table>
	                      </div>
	                    </div>
	                    <!-- /.row-->
	                 <br>
	                 <br>
                 	<h3>주문자 정보</h3>
                    <div class="row">
                      <div class="col-md-6">
                        <div class="form-group">
                          <label for="firstname">이름</label>
                          <input id="name" type="text" class="form-control" value="<%=customer.getCstmName()%>" required>
                        </div>
                      </div>
                      <div class="col-md-6">
                        <div class="form-group">
                          <label for="lastname">연락처</label>
                          <input id="phone" type="text" class="form-control" value="<%=customer.getCstmPhone()%>" required>
                        </div>
                      </div>
                    </div>
                    <!-- /.row-->
                    <div class="row">
                      <div class="col-md-12">
                        <div class="form-group">
                          <label for="address">주소</label>
                          <select id="address" class="form-control">
                          <%
                          	for(Address a : addList){
                          		String addSelect = a.getAddressDefault().equals("Y") ? "selected": "";
                          %>
                          		<option value="<%=a.getAddress()%>" <%=addSelect%>><%=a.getAddress()%></option>
                          <%
                          	}
                          %>
                          </select>
                        </div>
                      </div>
                    </div>
                    <!-- /.row-->
                    
                    <br>
                    <br>
                    <h3>포인트(P)</h3>
                    <p>포인트는 최소 <span id="min"></span>p부터 <span id="unit"></span>p단위로 사용 가능합니다.</p>
                    <div class="row">
                      <div class="col-md-6">
                        <div class="form-group">
                          <label for="currPoint">가용포인트</label>
                          <input id="currPoint" name="currPoint" type="number" class="form-control" value="<%=customer.getCstmPoint()%>" readonly>
                          <div class="text-right"><input type="checkbox" id="useAllPoint">포인트 전체 사용</div>
                        </div>
                      </div>
                      <div class="col-md-6">
                        <div class="form-group">
                          <label for="usePoint">사용포인트</label>
                          <input id="usePoint" name="usePoint" type="number" class="form-control" value="0" min="0" required>
                        </div>
                      </div>
                    </div>
                    <!-- /.row-->
                   <br>
                   <br>
                   <h3>결제금액(원)</h3>
                    <div class="row">
                    	<div class="col-md-3">
                      		<input id="finalPrice" name="finalPrice" type="number" class="form-control" value="<%=totalPrice%>" readonly>
                      	</div>
                    </div>
                    <!-- /.row-->
                   
                    <br>
                    <br>
                    <h3>결제방법</h3>
                    <div class="row">
                      <div class="col-md-12">
                        <select name="payment" class="form-control">
                        	<option value="무통장입금">무통장입금</option>
                        	<option value="카드결제">카드결제</option>
                        </select>
                      </div>
                    </div>
                    <!-- /.row-->
                  </div>
                  <div class="box-footer d-flex justify-content-between"><a href="<%=request.getContextPath()%>/cart/cart.jsp" class="btn btn-outline-secondary"><i class="fa fa-chevron-left"></i>장바구니</a>
                    <button type="submit" class="btn btn-primary">주문하기<i class="fa fa-chevron-right"></i></button>
                  </div>
            	</form>
              </div>
              <!-- /.box-->
            </div>
            <!-- /.col-lg-12-->
          </div>
        </div>
      </div>
    </div>
    <!-- copy -->
   <jsp:include page="/inc/copy.jsp"></jsp:include>
	<!-- script -->
    <jsp:include page="/inc/script.jsp"></jsp:include>
    <script>
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
    </script>
</body>
</html>