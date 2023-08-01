<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%@ page import="dao.*"%>
<%@ page import="java.util.*"%>

<%
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	
	//request 인코딩
	request.setCharacterEncoding("utf-8");
	
	/* session 유효성 검사
	* session 값이 null이면 redirection. return.
	*/
	
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;	
	}
	
	// 현재 로그인 Id
	String loginId = null;
	if(session.getAttribute("loginId") != null){
		loginId = (String)session.getAttribute("loginId");
	}
	
	/* idLevel 유효성 검사
	 * idLevel == 0이면 redirection. return
	 * IdListDao selectIdListOne(loginId) method 호출
	*/
	
	IdListDao idListDao = new IdListDao();
	IdList idList = idListDao.selectIdListOne(loginId);
	int idLevel = idList.getIdLevel();
	
	if(idLevel == 0){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;	
	}
	
	// 요청값 유효성 검사
	if(request.getParameter("productNo") == null
		||request.getParameter("productNo").equals("")) {
		
		response.sendRedirect(request.getContextPath() + "/product/productList.jsp");
		return;
	}
	// 값 저장
	int productNo = Integer.parseInt(request.getParameter("productNo"));
	System.out.println(productNo+"<-- addProductDiscountAction.jsp");
	
	// 요청값 유효성 검사 
	if(request.getParameter("discountRate") == null
		||request.getParameter("discountStart") == null
		||request.getParameter("discountEnd") == null
		||request.getParameter("discountRate").equals("")
		||request.getParameter("discountStart").equals("")
		||request.getParameter("discountEnd").equals("")) {
		
		response.sendRedirect(request.getContextPath() + "/product/productDetail.jsp?productNo=" + productNo);
		return;
	}
	
	// dao
	DiscountDao dDao = new DiscountDao();
	
	// 요청값 저장
	String discountStart = request.getParameter("discountStart");
	String discountEnd = request.getParameter("discountEnd");
	double discountRate = Double.parseDouble(request.getParameter("discountRate"));
	
	// vo 값 저장
	Discount discount = new Discount();
	discount.setProductNo(productNo);
	discount.setDiscountStart(discountStart);
	discount.setDiscountEnd(discountEnd);
	discount.setDiscountRate(discountRate);
	
	// 디버깅 코드
	System.out.println(SJ+ discount.getProductNo() + "<-productNo");
	System.out.println(SJ+ productNo + "<-productNo");
	System.out.println(discountStart + "<-discountStart");
	System.out.println(discountEnd + "<-discountEnd");
	System.out.println(discountRate + "<-discountRate"+ RE);
	
	// 할인율 삽입 method 반환 값 row에 저장
	int row = dDao.insertDiscount(discount);
	
	// row값의 따른 분기
	if(row == 1) {
		System.out.println(SJ+ row +"<-- addProductDiscountAction.jsp 할인율 삽입 성공 row"+RE);
		response.sendRedirect(request.getContextPath() + "/product/productDetail.jsp?productNo="+productNo);
	} else if (row == 0){
		response.sendRedirect(request.getContextPath() + "/product/productDetail.jsp?productNo=" + productNo);
		System.out.println(SJ+ row + "<-- addProductDiscountAction.jsp 할인율 삽입 실패"+RE);
	} else{
		System.out.println(SJ+ row + "<-- addProductDiscountAction.jsp error row"+RE);
	}
%>