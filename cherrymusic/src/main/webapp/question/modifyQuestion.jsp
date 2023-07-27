<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
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
	// 요청값 변수에 저장
	int qNo = Integer.parseInt(request.getParameter("qNo"));
	System.out.println(SJ+ "modifyQuestion 시작" + RE);
	// 객체 생성
	QuestionDao qDao = new QuestionDao();
	Question qList = qDao.selectQuestion(qNo);
	int productNo = qList.getProductNo();
	System.out.println(SJ + productNo +"<--modifyQuestion productNo" + RE);
	System.out.println(SJ + qNo +"<--modifyQuestion qNo" + RE);
	// 요청값 유효성 검사
	if(request.getParameter("qNo") == null 
		|| request.getParameter("qNo").equals("")) {
		// 
		response.sendRedirect(request.getContextPath() + "/question/questionDetail.jsp?p.productNo="+productNo+"&qNo="+qNo);
		return;
	}
	// sql 메서드들이 있는 클래스의 객체 생성
	ProductDao pDao = new ProductDao();
	IdListDao iDao = new IdListDao();
	Question question = new Question();
	Product product = new Product();
	
	question.setqNo(qNo);
	System.out.println(SJ+qNo +"questionDetail qNo"+ RE );
	int qCheckCnt = 0;
	String id = qList.getId();
	String qCategory = qList.getqCategory();
	String qTitle = qList.getqTitle();
	String qContent = qList.getqContent();

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	
	<h1>문의 페이지 : 문의 수정</h1>
	<div >
		<a href="<%=request.getContextPath()%>/product/productDetail.jsp?p.productNo=<%=productNo%>">
			<button type="button">상품상세페이지</button>
		</a>
	</div>
	<form action = "<%=request.getContextPath()%>/question/modifyQuestionAction.jsp" method="post">
		<div> 상품 번호 
			<input type="number" readonly="readonly" name = "productNo" value = "<%=productNo%>"></div>
		<div> 문의 번호
			<input type="text" readonly="readonly" name = "qNo" value = "<%=qNo%>">
		</div>
		
		<div>문의 카테고리 
			<input type="text" name = "qCategory" value = "<%=qCategory%>">
		</div>
		
		<div>문의 제목
			<input type="text" name = "qTitle" value="<%=qTitle%>">
		</div>
		
		<div>id
			<input type="text" name = "id" readonly="readonly" value="<%=id%>">
		</div>
		
		<div>문의 내용
			<textarea rows="3" cols="100" name = "qContent"><%=qContent%></textarea>
		</div> 
		<div>
			<button type="submit">수정</button>
			<button type="submit" formaction="<%=request.getContextPath()%>/question/questionDetail.jsp">이전</button>
		</div>
	</form>
</body>
</html>