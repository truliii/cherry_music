<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import ="vo.*" %>
<%@ page import = "com.oreilly.servlet.MultipartRequest" %>
<%@ page import = "com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	//로그인 유효성 검사
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/id_list/login.jsp");
		System.out.println(KMJ + "addReviewAction 로그인 필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	}
	System.out.println(KMJ + loginId + " <--addReviewAction loginId");
	
	//mRequest맵핑
	String dir = request.getServletContext().getRealPath("/review/reviewImg");
	System.out.println(KMJ + dir + " <--addReviewAction dir" + RESET);
	int max = 10 * 1024 * 1024; //파일의 최대 크기: 10MB
	MultipartRequest mRequest = new MultipartRequest(request, dir, max, "utf-8", new DefaultFileRenamePolicy());
	
	//요청값 유효성 검사
	if(mRequest.getParameter("id") == null
		|| mRequest.getParameter("orderNo") == null
		|| mRequest.getParameter("title") == null
		|| mRequest.getParameter("content") == null
		|| mRequest.getParameter("title").equals("")
		|| mRequest.getParameter("content").equals("")){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	int orderNo = Integer.parseInt(mRequest.getParameter("orderNo"));
	String id = mRequest.getParameter("id");
	String title = mRequest.getParameter("title");
	String content = mRequest.getParameter("content");
	
	//Review 객체에 저장
	Review review = new Review();
	review.setOrderNo(orderNo);
	review.setReviewTitle(title);
	review.setReviewContent(content);
	review.setReviewCheckCnt(0);
	
	// 업로드 파일이 이미지 파일이 아닌 경우 해당 파일 삭제
	if(!mRequest.getContentType("img").contains("image/")){ //파일타입이 image/를 포함하는 경우
		System.out.println("review이미지 파일이 아닙니다");
		String saveFilename = mRequest.getFilesystemName("img");
		File f = new File(dir+"/"+saveFilename);
		if(f.exists()){
			f.delete();
			System.out.println(saveFilename + "파일삭제");
		}
		//리다이렉션
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	String saveFilename = mRequest.getFilesystemName("img");
	String orgFilename = mRequest.getOriginalFileName("img");
	String filetype = mRequest.getContentType("img");
	
	//변수 디버깅
	System.out.println(KMJ + orderNo + " <--addReviewAction orderNo" + RESET);
	System.out.println(KMJ + id + " <--addReviewAction id" + RESET);
	System.out.println(KMJ + title + " <--addReviewAction title" + RESET);
	System.out.println(KMJ + content + " <--addReviewAction content" + RESET);
	System.out.println(KMJ + saveFilename + " <--addReviewAction saveFilename" + RESET);
	System.out.println(KMJ + orgFilename + " <--addReviewAction orgFilename" + RESET);
	System.out.println(KMJ + filetype + " <--addReviewAction filetype" + RESET);
	
	//ReviewImg 객체에 저장
	ReviewImg rImg = new ReviewImg();
	rImg.setOrderNo(orderNo);
	rImg.setReviewOriFilename(orgFilename);
	rImg.setReviewSaveFilename(saveFilename);
	rImg.setReviewFiletype(filetype);
	
	//리뷰이미지와 리뷰 저장
	ReviewDao rDao = new ReviewDao();
	ReviewImgDao rImgDao = new ReviewImgDao();
	
	int rRow = rDao.insertReview(review);
	int imgRow = rImgDao.insertReviewImg(rImg);
	System.out.println(KMJ + rRow + " <--addReviewAction rRow " + RESET);
	System.out.println(KMJ + rRow + " <--addReviewAction imgRow " + RESET);
	
	//리뷰입력완료 후 상품상세페이지로 리다이렉션
	OrdersDao oDao = new OrdersDao();
	int productNo = oDao.selectOrderOne(orderNo).getProductNo();
	response.sendRedirect(request.getContextPath()+"/customer/customerOrderList.jsp?id="+loginId);
	
%>