<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%@ page import="dao.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.File"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	
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
	
	/* MultipartRequest API 
	* new MultipartRequest(원본request, 업로드폴더, 최대파일사이즈byte, 인코딩, 중복이름정책)
	* new DefaultFileRenamePolicy() : 업로드 폴더내 동일한 이름이 있으면 뒤에 숫자를 추가
	* dir : 프로젝트안 upload폴더의 실제 물리적 위치를 반환
	* max : 최대 파일사이즈byte
	*/
	
	String dir = request.getServletContext().getRealPath("/product/productImg");
	int max = 10 * 1024 * 1024; 
	MultipartRequest mRequest = new MultipartRequest(request, dir, max, "utf-8", new DefaultFileRenamePolicy());
	
	// 요청값(productNo) 유효성 검사
	if(mRequest.getParameter("productNo") == null
		||mRequest.getParameter("productNo").equals("")) {
		
		response.sendRedirect(request.getContextPath() + "/product/productList.jsp");
		return;
	}
	// 요청값 저장
	int productNo = Integer.parseInt(mRequest.getParameter("productNo"));
	// 디버깅 코드
	System.out.println(productNo+"<-- modifyProductAction.jsp productNo");
	
	// 요청값 유효성 검사
	if(mRequest.getParameter("categoryName") == null
		||mRequest.getParameter("productName") == null
		||mRequest.getParameter("productPrice") == null
		||mRequest.getParameter("productStatus") == null
		||mRequest.getParameter("productStock") == null
		||mRequest.getParameter("productInfo") == null
		
		||mRequest.getParameter("categoryName").equals("")
		||mRequest.getParameter("productName").equals("")
		||mRequest.getParameter("productPrice").equals("")
		||mRequest.getParameter("productStatus").equals("")
		||mRequest.getParameter("productStock").equals("")
		||mRequest.getParameter("productInfo").equals("")){
		
		response.sendRedirect(request.getContextPath() + "/product/modifyProduct.jsp?productNo=" + productNo);
		return;
	}
	
	// 요청값 저장
	String categoryName = mRequest.getParameter("categoryName");
	String productName = mRequest.getParameter("productName");
	int productPrice = Integer.parseInt(mRequest.getParameter("productPrice"));
	String productStatus = mRequest.getParameter("productStatus");
	int productStock = Integer.parseInt(mRequest.getParameter("productStock"));
	String productInfo = mRequest.getParameter("productInfo");
	
	// 디버깅 코드
	System.out.println(categoryName+"<-- modifyProductAction.jsp categoryName");
	System.out.println(productName+"<-- modifyProductAction.jsp productName");
	System.out.println(productPrice+"<-- modifyProductAction.jsp productPrice");
	System.out.println(productStatus+"<-- modifyProductAction.jsp productStatus");
	System.out.println(productStock+"<-- modifyProductAction.jsp productStock");
	System.out.println(productInfo+"<-- modifyProductAction.jsp productInfo");
 	
	// Product vo 값 저장
	Product product = new Product();
	product.setProductNo(productNo);
	product.setCategoryName(categoryName);
	product.setProductName(productName);
	product.setProductPrice(productPrice);
	product.setProductStatus(productStatus);
	product.setProductInfo(productInfo);
	product.setProductStock(productStock);
	
	// DAO
	ProductDao productDao = new ProductDao();
	
	// update method 저장 변수 초기화
	int updatePRow = 1; // 상품 수정
	int updatePImgRow = 1; // 상품 이미지 수정
	
	// 1) 상품정보 수정
	updatePRow = productDao.modifyProduct(product);
	System.out.println(updatePRow+"<--modifyProductAction.jsp updateProductRow");
	
	// 2) 이전 productImg 삭제, 새로운 productImg추가
	// mRequest.getOriginalFileName("productImg") == null이면 상품정보만 수정
	if(mRequest.getOriginalFileName("productImg") !=null){
		
		// 수정할 파일이 있으면 image(jpeg, png) 파일 유효성 검사
		// image 파일이 아니면 저장된 파일 삭제
		if(!(mRequest.getContentType("productImg").equals("image/jpeg") 
			|| mRequest.getContentType("productImg").equals("image/png"))){
			System.out.println(mRequest.getContentType("productImg")+"<--productImg type");
			System.out.println("image파일이 아닙니다");
			
			String saveFilename = mRequest.getOriginalFileName("productImg");
			File f = new File(dir+"/"+saveFilename);
			
			if(f.exists()){
				f.delete();
				System.out.println(saveFilename+"<--modifyBoardAction.jsp 파일삭제");
			}
		} else { // image파일이면 1) 이전 파일 삭제 2) DB update
			 
			// 값 저장
			String productFiletype = mRequest.getContentType("productImg");
			String productOriginFilename = mRequest.getOriginalFileName("productImg");
			String productSaveFilename = mRequest.getFilesystemName("productImg");
			
			// 디버깅 코드
			System.out.println(productFiletype + "<-- modifyProductAction.jsp productFiletype");
			System.out.println(productOriginFilename + "<-- modifyProductAction.jsp productOriginFilename");
			System.out.println(productSaveFilename + "<-- modifyProductAction.jsp productSaveFilename");
			
			// ProductImg vo 값 저장
			ProductImg productImg = new ProductImg();
			productImg.setProductNo(productNo);
			productImg.setProductOriFilename(productOriginFilename);
			productImg.setProductSaveFileName(productSaveFilename);
			productImg.setProductFiletype(productFiletype);
			
			// 1) 이전 파일 삭제
			HashMap<String, Object> pImgFile = productDao.selectProductOne(productNo);
			
			String saveFilename = "";
			if(saveFilename != null) {
				saveFilename = (String)pImgFile.get("productSaveFilename");
			}
			File f = new File(dir+"/"+saveFilename);
			if(f.exists()) {
				f.delete();
				System.out.println("modifyBoardAction.jsp 파일삭제");
			}
			
			// 2) DB updateProductImg
			updatePImgRow = productDao.modifyProductImg(productImg);
			System.out.println(updatePImgRow+"<-- modifyProductAction.jsp updateProductImgRow");
			
		}
	}
	
	/* redirection 상품 수정 성공
	* updatePRow, updatePImgRow 값 확인
	* updatePRow, updatePImgRow == 0 : modifyProduct.jsp 페이지 이동.
	* updatePRow, updatePImgRow == 1 : productDetail.jsp 페이지 이동.
	*/
	if(updatePRow == 0 || updatePImgRow == 0){
		response.sendRedirect(request.getContextPath()+"/product/modifyProduct.jsp?productNo="+productNo);
		System.out.println("modifyProductAction.jsp 수정 실패");
	} else if(updatePRow == 1 && updatePImgRow == 1){ 
		response.sendRedirect(request.getContextPath()+"/product/productDetail.jsp?productNo="+productNo);
		System.out.println("modifyProductAction.jsp 수정 성공");
	} else {
		System.out.println("error updatePRow값 : "+updatePRow);
	}
	
%>