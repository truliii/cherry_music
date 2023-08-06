<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="vo.*"%>
<%@page import="dao.*"%>
<%
	//인코딩
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
	
	// 요청값(productNo) 유효성 검사
	if(request.getParameter("productNo") == null
		||request.getParameter("productNo").equals("")) {
		
		response.sendRedirect(request.getContextPath() + "/product/productList.jsp");
		return;
	}
	// 요청값 저장
	int productNo = Integer.parseInt(request.getParameter("productNo"));
	// 디버깅 코드
	System.out.println(productNo+"<-- modifyProductDiscountAction.jsp productNo");
	
	// 요청값 유효성 검사 
	if(request.getParameter("discountNo") == null
		||request.getParameter("discountRate") == null
		||request.getParameter("discountStart") == null
		||request.getParameter("discountEnd") == null
		||request.getParameter("discountNo").equals("")
		||request.getParameter("discountRate").equals("")
		||request.getParameter("discountStart").equals("")
		||request.getParameter("discountEnd").equals("")) {
		
		response.sendRedirect(request.getContextPath() + "/product/modifyProduct.jsp?productNo=" + productNo);
		return;
	}
	
	// dao
	DiscountDao dDao = new DiscountDao();
	
	// 요청값 저장
	int discountNo = Integer.parseInt(request.getParameter("discountNo"));
	String discountStart = request.getParameter("discountStart");
	String discountEnd = request.getParameter("discountEnd");
	double discountRate = Double.parseDouble(request.getParameter("discountRate"));
	
	// vo 값 저장
	Discount discount = new Discount();
	discount.setProductNo(productNo);
	discount.setDiscountNo(discountNo);
	discount.setDiscountStart(discountStart);
	discount.setDiscountEnd(discountEnd);
	discount.setDiscountRate(discountRate);
	
	// 디버깅 코드
	System.out.println(discountStart + "<-- modifyProductDiscountAction.jsp discountStart");
	System.out.println(discountEnd + "<-- modifyProductDiscountAction.jsp discountEnd");
	System.out.println(discountRate + "<-- modifyProductDiscountAction.jsp discountRate");
	
	// 할인율 수정  method 반환 값 저장
	int row = dDao.updateDiscount(discount);
	System.out.println(row +"modifyProductDiscountAction.jsp row");
	// row 값의 따른 분기
	if(row == 0) {
		response.sendRedirect(request.getContextPath() + "/product/productDetail.jsp?productNo=" + productNo);
		System.out.println(row + "<-- modifyProductDiscountAction.jsp 할인율 수정 실패 row");
	} else if (row == 1){
		System.out.println(row +"<-- modifyProductDiscountAction.jsp 할인율 수정 성공 row");
		response.sendRedirect(request.getContextPath() + "/product/productDetail.jsp?productNo="+productNo);
	} else{
		System.out.println(row + "<-- modifyProductDiscountAction.jsp error row");
	}
%>	