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
	/*
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;	
	}
	
	// 현재 로그인 Id
	String loginId = null;
	if(session.getAttribute("loginId") != null){
		loginId = (String)session.getAttribute("loginId");
	}
	*/
	/* idLevel 유효성 검사
	 * idLevel == 0이면 redirection. return
	 * IdListDao selectIdListOne(loginId) method 호출
	*/
	/*
	IdListDao idListDao = new IdListDao();
	IdList idList = idListDao.selectIdListOne(loginId);
	int idLevel = idList.getIdLevel();
	
	if(idLevel == 0){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;	
	}
	*/
	//유효성검사
	if(request.getParameter("p.productNo") == null
		||request.getParameter("p.productNo").equals("")) {
		
		System.out.println(SJ+ "productNo 입력" +RE);
		response.sendRedirect(request.getContextPath() + "/product/customerProductDeatil.jsp?p.productNo="+request.getParameter("p.productNo"));
		return;
	}
	
	int productNo = Integer.parseInt(request.getParameter("p.productNo"));
	
	// 수정값 유효성 섬사
	if(request.getParameter("p.productNo") == null
		||request.getParameter("id") == null
		||request.getParameter("paymentStatus") == null
		||request.getParameter("discountRate").equals("")
		||request.getParameter("discountStart").equals("")
		||request.getParameter("discountEnd").equals("")) {
		
		System.out.println(SJ+"매개변수 요청"+RE); 
		response.sendRedirect(request.getContextPath() + "/product/addProductDiscount.jsp?p.productNo=" + productNo);
		return;
	}
	
	//DAO 받아오기
	DiscountDao dDao = new DiscountDao();
	
	//변수
	String discountStart = request.getParameter("discountStart");
	String discountEnd = request.getParameter("discountEnd");
	double discountRate = Double.parseDouble(request.getParameter("discountRate"));

	Discount discount = new Discount();
	discount.setProductNo(productNo);
	discount.setDiscountStart(discountStart);
	discount.setDiscountEnd(discountEnd);
	discount.setDiscountRate(discountRate);
	System.out.println(SJ+ productNo + "<-productNo");
	System.out.println(discountStart + "<-discountStart");
	System.out.println(discountEnd + "<-discountEnd");
	System.out.println(discountRate + "<-discountRate"+ RE);
	if(productNo != 0){
		if(discount.getProductNo() == (productNo)){
			response.sendRedirect(request.getContextPath() + "/product/productDetail.jsp");
			System.out.println(SJ+ "중복되는 할인"+RE);
			return;
		}
	}
	//row에 값 넣기
	int row = dDao.insertDiscount(discount);
		System.out.println(SJ+ row + "<--row"+RE);
	if(row == 1) {
		System.out.println(SJ+"할인율 삽입 성공"+RE);
		response.sendRedirect(request.getContextPath() + "/product/productList.jsp");
		return;
		
	} else {
		response.sendRedirect(request.getContextPath() + "/product/addProductDiscount.jsp?productNo=" + productNo);
		System.out.println(SJ+ "할인율 삽입 실패"+RE);
		return;
	}
%>