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
	
	String dir = request.getServletContext().getRealPath("/product/productImg");
		System.out.println(dir);
	int max = 10 * 1024 * 1024; 
	// request객체를 MultipartRequest의 API를 사용할 수 있도록 랩핑
 	MultipartRequest mRequest = new MultipartRequest(request, dir, max, "utf-8");
	
	//유효성검사
	if(mRequest.getParameter("productNo") == null
		||mRequest.getParameter("productNo").equals("")) {
		
		System.out.println(SJ+ "productNo 입력" +RE);
		response.sendRedirect(request.getContextPath() + "/product/modifyProduct.jsp");
		return;
	}
	
	int productNo = Integer.parseInt(mRequest.getParameter("productNo"));
	System.out.println(SJ+ mRequest.getParameter("productName") + "productName" +RE);
	System.out.println(SJ+ mRequest.getParameter("productInfo") + "productInfo" +RE);
	System.out.println(SJ+ mRequest.getParameter("productPrice") + "productPrice" +RE);
	System.out.println(SJ+ mRequest.getParameter("productStock") + "productStock" +RE);
	System.out.println(SJ+ mRequest.getParameter("productStatus") + "productStatus" +RE);
	System.out.println(SJ+ mRequest.getParameter("discountRate") + "discountRate" +RE);
	System.out.println(SJ+ mRequest.getParameter("discountStart") + "discountStart" +RE);
	System.out.println(SJ+ mRequest.getParameter("discountEnd") + "discountEnd" +RE);
	System.out.println(SJ+ mRequest.getParameter("productImg") + "productImg" +RE);
	// 수정값 유효성 섬사
	if(mRequest.getParameter("productName") == null
		||mRequest.getParameter("productInfo") == null
		||mRequest.getParameter("productPrice") == null
		||mRequest.getParameter("productStock") == null
		||mRequest.getParameter("categoryName") == null
		||mRequest.getParameter("productStatus") == null
		||mRequest.getParameter("discountRate") == null
		||mRequest.getParameter("discountStart") == null
		||mRequest.getParameter("discountEnd") == null
		//||mRequest.getParameter("productImg") == null
		||mRequest.getParameter("productName").equals("")
		||mRequest.getParameter("productInfo").equals("")
		||mRequest.getParameter("productPrice").equals("")
		||mRequest.getParameter("productStock").equals("")
		||mRequest.getParameter("categoryName").equals("")
		||mRequest.getParameter("productStatus").equals("")
		||mRequest.getParameter("discountStart").equals("")
		||mRequest.getParameter("discountEnd").equals("")
		//||mRequest.getParameter("productImg").equals("")
		) {
		
		System.out.println(SJ+"매개변수 요청"+RE); 
		response.sendRedirect(request.getContextPath() + "/product/modifyProduct.jsp?p.productNo=" + productNo);
		return;
	}
	
	//DAO 받아오기
	ProductDao productdao = new ProductDao();
	DiscountDao dDao = new DiscountDao();
	HashMap<String, Object> map = new HashMap<>();
	ProductImg productImg = (ProductImg)map.get("productImg");
	// 이전 imgFile을 삭제 & 새로운 imgFile 추가 & 수정
	 if(mRequest.getOriginalFileName("productImg") != null) {
		//업로드 된 컨텐츠파일이 PNG, JPG, JEPG파일 아닐때
		if(mRequest.getContentType("productImg").equals("image/jpeg") == false){
				
				//이미 저장된 파일 삭제
				String productOriFilename = mRequest.getOriginalFileName("productImg");
					System.out.println(SJ+ "JEPG파일이 아닙니다."+ RE);

				//파일 경로 설정
				File f = new File(dir + "/" + productOriFilename);
				if(f.exists()) {
					f.delete();
						System.out.println(dir + "/" + productOriFilename + "파일삭제");
				}
				response.sendRedirect(request.getContextPath() + "/emp/modifyProduct.jsp?&productNo=" + productNo);
				return;
				
			} else { 
			// PNG, JPG, JEPG파일일때 --> productimg에 저장
				String productOriFilename = mRequest.getOriginalFileName("productImg");
				String productSaveFileName = mRequest.getOriginalFileName("productImg");
				String productFiletype = mRequest.getContentType("productImg");
				
					ProductImg productimg = new ProductImg();
					productimg.setProductNo(productNo);
					productimg.setProductOriFilename(productOriFilename);
					productimg.setProductSaveFileName(productSaveFileName);
					productimg.setProductFiletype(productFiletype);
						System.out.println(SJ+ productNo + "<-productNo");
						System.out.println(productOriFilename + "<-oriFilename");
						System.out.println(productSaveFileName + "<-saveFilename");
						System.out.println(productFiletype + "<-type"+RE);
					map.put("productImg", productimg);
					
			//기존 이미지이름과 새로 들어온 이미지 이름이 다를 경우 기존 이미지 삭제 
				String beforeOriFilename = mRequest.getParameter("beforeProductImg");
				System.out.println(SJ+ beforeOriFilename + "<--beforeOriFilename" + RE);

				if(!beforeOriFilename.equals(mRequest.getOriginalFileName("productSaveFileName"))){
					File f = new File(dir + "/" + beforeOriFilename);
					if(f.exists()) {
						f.delete();
							System.out.println(SJ+dir + "/" + beforeOriFilename + "beforeOriFilename 파일삭제"+RE);
					} 
				}
			}
	 }

	// input type = "text" --> product에 저장
	//변수
	String categoryName = mRequest.getParameter("categoryName");
	String productName = mRequest.getParameter("productName");
	String productInfo = mRequest.getParameter("productInfo");
	int productPrice = Integer.parseInt(mRequest.getParameter("productPrice"));
	int productStock = Integer.parseInt(mRequest.getParameter("productStock"));
	double discountRate = Double.parseDouble(mRequest.getParameter("discountRate"));
	String productStatus = mRequest.getParameter("productStatus");
	String discountStart = mRequest.getParameter("discountStart");
	String discountEnd = mRequest.getParameter("discountEnd");
	Product product = new Product();
	product.setCategoryName(categoryName);
	product.setProductName(productName);
	product.setProductPrice(productPrice);
	product.setProductStatus(productStatus);
	product.setProductInfo(productInfo);
	product.setProductStock(productStock);
	product.setProductNo(productNo);
	
	System.out.println(SJ+ categoryName + "<-categoryName");
	System.out.println(productName + "<-productName");
	System.out.println(productPrice + "<-productPrice");
	System.out.println(productStatus + "<-productStatus");
	System.out.println(productInfo + "<-productInfo");
	System.out.println(productStock + "<-productStock");
	System.out.println(productNo + "<-productNo"+RE);
	
	
	Discount discount = new Discount();
	discount.setProductNo(productNo);
	discount.setDiscountStart(discountStart);
	discount.setDiscountEnd(discountEnd);
	discount.setDiscountRate(discountRate);
	System.out.println(SJ+ productNo + "<-productNo");
	System.out.println(discountStart + "<-discountStart");
	System.out.println(discountEnd + "<-discountEnd");
	System.out.println(discountRate + "<-discountRate"+ RE);
	map.put("product", product);
	map.put("discount", discount);
	//row에 값 넣기
	int row = productdao.updateProduct(map);
		System.out.println(SJ+ row + "<--row"+RE);
	if(row == 1 || row == 2 || row == 3) {
		System.out.println(SJ+"상품 수정 성공"+RE);
		response.sendRedirect(request.getContextPath() + "/product/productList.jsp");
		return;
		
	} else {
		response.sendRedirect(request.getContextPath() + "/product/modifyProduct.jsp?productNo=" + productNo);
		System.out.println(SJ+ "상품 수정 실패"+RE);
		return;
	}
%>