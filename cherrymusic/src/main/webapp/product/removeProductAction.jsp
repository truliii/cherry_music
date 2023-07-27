<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<%@ page import = "java.io.*" %>
<%@ page import = "com.oreilly.servlet.MultipartRequest" %>
<%@ page import = "com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>

<% 	// 관리자 상품 삭제
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
	// 이미지 파일 삭제를 위한 코드
	String dir = request.getServletContext().getRealPath("/product/productImg");
	System.out.println(SJ+ dir +"<--dir deleteAction" + RE);
	int max = 10 * 1024 * 1024; 
	MultipartRequest mRequest = new MultipartRequest(request, dir, max, "utf-8", new DefaultFileRenamePolicy());
	
	// 파라미터 디버깅
	System.out.println(SJ+ "productRemoveAction 시작" + RE);
	System.out.println(SJ+ mRequest.getParameter("p.productNo") + RE);
	//요청값 유효성 검사
	if(mRequest.getParameter("p.productNo") == null  
		|| mRequest.getParameter("p.productNo").equals("")) {
		// 
		response.sendRedirect(request.getContextPath() + "/product/productList.jsp");
		return;
	}
	// 요청값 변수에 저장
	int productNo = Integer.parseInt(mRequest.getParameter("p.productNo"));
	String productSaveFilename = mRequest.getParameter("productSaveFilename");
	System.out.println(SJ+ productNo +"productNo" + RE);
	System.out.println(SJ+ productSaveFilename +"savefilename" + RE);
	// sql 메서드들이 있는 클래스의 객체 생성
	ProductDao pDao = new ProductDao();
	// 삭제 메서드 실행
	int row = pDao.deleteProduct(productNo);
	int row2 = pDao.deleteProductImg(productNo);
	File f = new File(dir+"/"+productSaveFilename); // new File("d:/abc/uploadsign.gif")
	if(f.exists()) {
		f.delete();
		System.out.println(SJ+ productSaveFilename+"파일삭제" + RE);
	}
	if(row == 1){
		System.out.println(SJ + "상품 삭제 성공" + RE);
	}
	// 
	response.sendRedirect(request.getContextPath() + "/product/productList.jsp");
%>