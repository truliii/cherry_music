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
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println(KMJ + "modifyReviewAction 로그인 필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId" + " <--modifyReviewAction loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	}
	System.out.println(KMJ + loginId + " <--modifyReviewAction loginId" + RESET);
	
	//mRequest맵핑
	String dir = request.getServletContext().getRealPath("/review/reviewImg");
	System.out.println(KMJ + dir + " <--modifyReviewAction dir" + RESET);
	int max = 10 * 1024 * 1024; //파일의 최대 크기: 10MB
	MultipartRequest mRequest = new MultipartRequest(request, dir, max, "utf-8", new DefaultFileRenamePolicy());
	
	//요청값 유효성 검사
	System.out.println(mRequest.getParameter("img"));
	if(mRequest.getParameter("reviewNo") == null
		|| mRequest.getParameter("title") == null
		|| mRequest.getParameter("content") == null
		|| mRequest.getParameter("title").equals("")
		|| mRequest.getParameter("content").equals("")){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	int reviewNo = Integer.parseInt(mRequest.getParameter("reviewNo"));
	String title = mRequest.getParameter("title");
	String content = mRequest.getParameter("content");
	System.out.println(KMJ + reviewNo + " <--modifyReviewAction reviewNo" + RESET);
	System.out.println(KMJ + title + " <--modifyReviewAction title" + RESET);
	System.out.println(KMJ + content + " <--modifyReviewAction content" + RESET);
	
	//Review 객체에 변수 저장
	Review review = new Review();
	review.setReviewNo(reviewNo);
	review.setReviewTitle(title);
	review.setReviewContent(content);
	
	//리뷰수정
	ReviewDao rDao = new ReviewDao();
	int rRow = rDao.updateReview(review);
	if(rRow == 1){
		System.out.println(KMJ + rRow + " <--modifyReviewAction rRow 리뷰수정성공" + RESET);
	} else {
		System.out.println(KMJ + rRow + " <--modifyReviewAction rRow 리뷰수정실패" + RESET);
		response.sendRedirect(request.getContextPath()+"/modifyReview.jsp?reviewNo="+reviewNo);
		return;
	}
		
	//review이미지 유효성 검사
	// 이미지가 null이 아닌 경우 기존이미지 삭제 및 이미지삽입
	if(mRequest.getFile("img") != null){
		// 업로드 파일이 이미지 파일이 아닌 경우 해당 파일 삭제
		if(!mRequest.getContentType("img").contains("image/")){ //파일타입이 image/를 포함하지 않는 경우
			System.out.println("review이미지 파일이 아닙니다");
			String saveFilename = mRequest.getFilesystemName("img");
			File f = new File(dir+"/"+saveFilename);
			if(f.exists()){ //이미 저장된 파일 삭제
				f.delete();
				System.out.println(KMJ + saveFilename + "파일삭제" + RESET); 
			}
			//리다이렉션
			response.sendRedirect(request.getContextPath()+"/review/modifyReview.jsp?reviewNo="+reviewNo);
			return;
		}
		
		String saveFilename = mRequest.getFilesystemName("img");
		String orgFilename = mRequest.getOriginalFileName("img");
		String filetype = mRequest.getContentType("img");
		System.out.println(KMJ + saveFilename + " <--modifyReviewAction saveFilename" + RESET);
		System.out.println(KMJ + orgFilename + " <--modifyReviewAction orgFilename" + RESET);
		System.out.println(KMJ + filetype + " <--modifyReviewAction filetype" + RESET);

		//ReviewImg 객체에 저장
		int orderNo = (Integer)rDao.selectReviewByReviewNo(reviewNo).get("orderNo");
		ReviewImg rImg = new ReviewImg();
		rImg.setOrderNo(orderNo);
		rImg.setReviewOriFilename(orgFilename);
		rImg.setReviewSaveFilename(saveFilename);
		rImg.setReviewFiletype(filetype);
	
		//리뷰이미지 파일 삭제,DB수정
		ReviewImgDao rImgDao = new ReviewImgDao();
		//기존파일정보 불러오기
		String oldSaveFilename = rImgDao.selectReviewImg(orderNo).getReviewSaveFilename();
		System.out.println(oldSaveFilename);
		File f = new File(dir+"/"+oldSaveFilename);
		if(f.exists()){ //이미 저장된 파일 삭제
			f.delete();
			System.out.println(KMJ + saveFilename + "modifyReviewAction 기존이미지파일삭제" + RESET); 
		}
		//reviewImg테이블 업데이트
		int udtImgRow = rImgDao.updateReviewImg(rImg);
		if(udtImgRow == 1){
			System.out.println(KMJ + udtImgRow + " <--modifyReviewAction udtImgRow 이미지수정성공" + RESET);
		} else {
			System.out.println(KMJ + udtImgRow + " <--modifyReviewAction udtImgRow 이미지수정실패" + RESET);
		}
	}
	//수정완료 후 리다이렉션
	response.sendRedirect(request.getContextPath()+"/review/reviewOne.jsp?reviewNo="+reviewNo+"&id="+loginId);
	
%>