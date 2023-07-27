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
		System.out.println(KMJ + "ordersAction 로그인 필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	}
	System.out.println(KMJ + loginId + " <--ordersAction loginId" + RESET);
	
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");

	//요청값 유효성 검사
	if(request.getParameter("cartNo") == null
		|| request.getParameter("productNo") == null
		|| request.getParameter("orderCnt") == null 
		|| request.getParameter("finalPrice") == null
		|| request.getParameter("payment") == null 
		|| request.getParameter("usePoint") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	int cartNo = Integer.parseInt(request.getParameter("cartNo"));
	int productNo = Integer.parseInt(request.getParameter("productNo"));
	int orderCnt = Integer.parseInt(request.getParameter("orderCnt"));
	int orderPrice = Integer.parseInt(request.getParameter("finalPrice"));
	String payment = request.getParameter("payment");
	int usePoint = Integer.parseInt(request.getParameter("usePoint"));
	String paymentStatus = "결제완료";
	if(payment.equals("무통장입금")){
		paymentStatus = "결제대기";
	}
	String deliveryStatus = "발송준비";
	
	//orders DB에 저장하기 위하여 Orders타입으로 묶기
	Orders order = new Orders();
	order.setProductNo(productNo);
	order.setId(loginId);
	order.setPaymentStatus(paymentStatus); //무통장입금 선택시에는 결제대기로 바꾸기
	order.setDeliveryStatus(deliveryStatus);
	order.setOrderCnt(orderCnt);
	order.setOrderPrice(orderPrice);
	
	//주문DB 저장 후 orderNo받아오기
	OrdersDao oDao = new OrdersDao();
	int orderNo = oDao.insertOrder(order);
	System.out.println(KMJ + orderNo + " <--ordersAction orderNo" + RESET);
	
	//포인트이력DB 업데이트
	PointHistoryDao pDao = new PointHistoryDao();
	
	//사용한 포인트가 0보다 클 경우에는 포인트 -로 삽입
	if(usePoint > 0){
		PointHistory pMinus = new PointHistory();
		String pointPm = "-";
		pMinus.setOrderNo(orderNo);
		pMinus.setPoint(usePoint);
		pMinus.setPointPm(pointPm);
		int pMinusRow = pDao.insertPointHistory(pMinus);
		if(pMinusRow != 1){
			System.out.println(KMJ + pMinusRow + " <--ordersAction pMinusRow 입력실패" + RESET);
		} else {
			System.out.println(KMJ + pMinusRow + " <--ordersAction pMinusRow 입력성공" + RESET);
		}
	}
	
	//id의 등급에 따라 주문금액의 3%, 5%, 10% 적립 
	CustomerDao cDao = new CustomerDao();
	String rank = cDao.selectCustomer(loginId).getCstmRank();
	int point = 0;
	if(rank.equals("bronze")){
		point = (int)(orderPrice * 0.03);
	} else if(rank.equals("silver")){
		point = (int)(orderPrice * 0.05);
	} else {
		point = (int)(orderPrice * 0.1);
	}
	
	PointHistory pPlus = new PointHistory();
	String pointPm = "+";
	pPlus.setOrderNo(orderNo);
	pPlus.setPoint(point);
	pPlus.setPointPm(pointPm);
	int pPlusRow = pDao.insertPointHistory(pPlus);
	System.out.println(KMJ + pPlusRow + " <--ordersAction pMinusRow" + RESET);
	if(pPlusRow != 1){
		System.out.println(KMJ + pPlusRow + " <--ordersAction pPlusRow 입력실패" + RESET);
	} else {
		System.out.println(KMJ + pPlusRow + " <--ordersAction pPlusRow 입력성공" + RESET);
	}
	
	//고객 포인트 합계 업데이트
	int sumPointRow = cDao.updatePoint(loginId);
	if(sumPointRow != 1){
		System.out.println(KMJ + sumPointRow + " <--ordersAction sumPointRow 입력실패" + RESET);
	} else {
		System.out.println(KMJ + sumPointRow + " <--ordersAction sumPointRow 입력성공" + RESET);
	}
	
	//고객 주문금액 합계 업데이트
	int sumPriceRow = cDao.updateSumPrice(loginId);
	if(sumPriceRow != 1){
		System.out.println(KMJ + sumPriceRow + " <--ordersAction sumPriceRow 입력실패" + RESET);
	} else {
		System.out.println(KMJ + sumPriceRow + " <--ordersAction sumPriceRow 입력성공" + RESET);
	}
	
	//상품재고량 업데이트(기존 재고량 - orderCnt)
	int stockRow = oDao.updateProductStock(productNo, orderCnt);
	if(stockRow != 1){
		System.out.println(KMJ + stockRow + " <--ordersAction stockRow 입력실패" + RESET);
	} else {
		System.out.println(KMJ + stockRow + " <--ordersAction stockRow 입력성공" + RESET);
	}
	
	//주문완료 후 장바구니에서 삭제
	CartDao cartDao = new CartDao();
	int dltCtRow = cartDao.deletecart(cartNo);
	if(dltCtRow != 1){
		System.out.println(KMJ + dltCtRow + " <--ordersAction dltCtRow 입력실패" + RESET);
	} else {
		System.out.println(KMJ + dltCtRow + " <--ordersAction dltCtRow 입력성공" + RESET);
	}
	
	//주문action 완료 후 주문확인페이지로 리다이렉션 
	response.sendRedirect(request.getContextPath()+"/orders/orderConfirm.jsp?orderNo="+orderNo);

%>