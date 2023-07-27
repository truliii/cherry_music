<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "com.oreilly.servlet.MultipartRequest" %>
<%@ page import = "com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import = "java.io.*" %>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<%
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	
	request.setCharacterEncoding("UTF-8");
	
	
	int max = 10 * 1024 * 1024; 
	String dir = request.getServletContext().getRealPath("/product/productImg");
	System.out.println(SJ+ dir +RE);
	// request객체를 MultipartRequest의 API를 사용할 수 있도록 랩핑
	MultipartRequest mRequest = new MultipartRequest(request, dir, max, "utf-8", new DefaultFileRenamePolicy());
	
	System.out.println(SJ + mRequest.getParameter("productName") + " <--addProductAction param productName" + RE);
	System.out.println(SJ + mRequest.getParameter("categoryName") + " <--addProductAction param categoryName" + RE);
	System.out.println(SJ + mRequest.getParameter("productPrice") + " <--addProductAction param productPrice" + RE);
	System.out.println(SJ + mRequest.getParameter("productStatus") + " <--addProductAction param productStatus" + RE);
	System.out.println(SJ + mRequest.getParameter("productStock") + " <--addProductAction param productStock" + RE);
	System.out.println(SJ + mRequest.getParameter("productInfo") + " <--addProductAction param productInfo" + RE);
	// 요청값 유효성 검사
	if(mRequest.getParameter("productName") == null 
		|| mRequest.getParameter("categoryName") == null
		||	mRequest.getParameter("productPrice") == null 
		||	mRequest.getParameter("productStatus") == null 
		||	mRequest.getParameter("productStock") == null 
		||	mRequest.getParameter("productInfo") == null 
		|| mRequest.getParameter("productInfo").equals("")
		|| mRequest.getParameter("productStock").equals("")
		|| mRequest.getParameter("productStatus").equals("")
		|| mRequest.getParameter("productPrice").equals("")
		|| mRequest.getParameter("productName").equals("")
		|| mRequest.getParameter("categoryName").equals("")) {
		// insertSubject.jsp으로
		response.sendRedirect(request.getContextPath() + "/product/addProduct.jsp");
		return;
	}
	//요청값이 넘어오는지 확인하기
	System.out.println(SJ + mRequest.getParameter("productName") + " <--addProductAction param productName" + RE);
	System.out.println(SJ + mRequest.getParameter("categoryName") + " <--addProductAction param categoryName" + RE);
	System.out.println(SJ + mRequest.getParameter("productPrice") + " <--addProductAction param productPrice" + RE);
	System.out.println(SJ + mRequest.getParameter("productStatus") + " <--addProductAction param productStatus" + RE);
	System.out.println(SJ + mRequest.getParameter("productStock") + " <--addProductAction param productStock" + RE);
	System.out.println(SJ + mRequest.getParameter("productInfo") + " <--addProductAction param productInfo" + RE);
	
	// 요청값 변수에 저장
	String productName = mRequest.getParameter("productName");
	String categoryName = mRequest.getParameter("categoryName");
	String productStatus = mRequest.getParameter("productStatus");
	String productInfo = mRequest.getParameter("productInfo");
	int productPrice = Integer.parseInt(mRequest.getParameter("productPrice"));
	int productStock = Integer.parseInt(mRequest.getParameter("productStock"));
	
	// MultipartRequest API를 사용하여 스트림내에서 문자값을 반환받을 수 있다
	
	// 업로드 파일이 PDF파일이 아니면
	if((mRequest.getContentType("boardFile").equals("image/jpeg") 
			||mRequest.getContentType("boardFile").equals("image/png"))
			== false) {
		// 이미 저장된 파일을 삭제
		System.out.println(mRequest.getContentType("boardFile"));
		System.out.println(SJ+"이미지파일이 아닙니다"+RE);
		String saveFilename = mRequest.getFilesystemName("boardFile");
		File f = new File(dir+"/"+saveFilename); // new File("d:/abc/uploadsign.gif")
		if(f.exists()) {
			f.delete();
			System.out.println(SJ+ saveFilename+"파일삭제" + RE);
		}
		response.sendRedirect(request.getContextPath()+"/product/addProduct.jsp");
		return;
	}
	
	// input type="file" 값(파일 메타 정보)반환 API(원본파일이름, 저장된파일이름, 컨텐츠타입)
	// --> board_file테이블 저장
	// 파일(바이너리)은 이미 MultipartRequest객체생성시(request랩핑시, 9라인) 먼저 저장
	String productFiletype = mRequest.getContentType("boardFile");
	String productOriFilename = mRequest.getOriginalFileName("boardFile");
	String productSaveFileName = mRequest.getFilesystemName("boardFile");
	
	System.out.println(SJ+productFiletype + " <-- productFiletype"+RE);
	System.out.println(SJ+productOriFilename + " <-- productOriFilename"+RE);
	System.out.println(SJ+productSaveFileName + " <-- productSaveFileName"+RE);
	
	ProductDao pDao = new ProductDao();
	ProductImg productImg = new ProductImg();
	
	productImg.setProductFiletype(productFiletype);
	productImg.setProductOriFilename(productOriFilename);
	productImg.setProductSaveFileName(productSaveFileName);
	
	// Product 객체 생성하여 요청값 저장
	Product product = new Product();
	product.setCategoryName(categoryName);
	product.setProductInfo(productInfo);
	product.setProductName(productName);
	product.setProductPrice(productPrice);
	product.setProductStatus(productStatus);
	product.setProductStock(productStock);
	// 실행 확인
	int row = pDao.insertProduct(product, productImg);
	
	if(row == 1){
		System.out.println(SJ+ "상품 추가 성공"+RE);
	}
	
	
	// 이미지 업로드 폼으로
	response.sendRedirect(request.getContextPath() + "/product/productDetail.jsp");
%>