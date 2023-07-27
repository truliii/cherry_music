<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	//1. 로그아웃상태 -> 세션 장바구니액션으로 리다이렉션
	if(session.getAttribute("loginId") == null){ 
		response.sendRedirect(request.getContextPath()+"/cart/addToCartSessionAction.jsp");
		System.out.println(KMJ + "로그인이 안되어 있어 넘어감");
		return;
	}
	String loginId = "";
	Object o = session.getAttribute("loginId");
	if(o instanceof String){
		loginId = (String)o;
	}
	
	//요청값 인코딩
	request.setCharacterEncoding("utf-8");
	
	//요청값 잘 넘어오는지 확인
	System.out.println(KMJ + request.getParameter("productNo") + " <--addToCartAction param productNo" + RESET);
	System.out.println(KMJ + request.getParameter("cartCnt") + " <--addToCartAction param cartCnt" + RESET);
	
	if(request.getParameter("productNo") == null){
		response.sendRedirect(request.getContextPath()+"home.jsp?");
		System.out.println("addToCartAction에서 리다이렉션");
		return;
	} else if(request.getParameter("cartCnt") == null){
		response.sendRedirect(request.getContextPath()+"/product/productOne.jsp?productNo="+request.getParameter("productNo"));
		System.out.println(KMJ + "addToCartAction에서 리다이렉션" + RESET);
		return;
	}
	
	int productNo = Integer.parseInt(request.getParameter("productNo"));
	int cartCnt = Integer.parseInt(request.getParameter("cartCnt"));
	//해당 상품 재고가 주문수보다 적을 시 재고만큼만 장바구니로 들어감
	CartDao cDao = new CartDao();
	int productStock = cDao.productCartStock(productNo);
	if(productStock < cartCnt){
		cartCnt = productStock;
	}
	
	//장바구니에 동일한 상품이 이미 있는 경우 기존 수량과 새로 담은 수량 합쳐서 저장
	ArrayList<HashMap<String, Object>> oldCartList = cDao.selectCartListByPage(loginId);
	for(HashMap<String, Object> m : oldCartList){
		if((Integer)m.get("productNo") == productNo){
			int oldCartCnt = (Integer)m.get("cartCnt");
			cartCnt = oldCartCnt + cartCnt;
		}
	}
	
	//cart DB에 저장
	Cart cart = new Cart();
	cart.setId(loginId);
	cart.setProductNo(productNo);
	cart.setCartCnt(cartCnt);
	
	int row = cDao.insertCart(cart); //카트db에 저장
	if(row == 1){
		System.out.println(KMJ + row + " <--addToCartAction row 카트db에 저장성공");
	} else {
		System.out.println(KMJ + row + " <--addToCartAction row 카트db에 저장실패");
	}
	
	response.sendRedirect(request.getContextPath()+"/cart/cart.jsp");
	
%>