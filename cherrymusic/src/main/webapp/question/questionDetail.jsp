<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>

<%
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	request.setCharacterEncoding("utf-8");
	
	
	// 현재 로그인 Id
	String loginId = null;
	if(session.getAttribute("loginId") != null){
		loginId = (String)session.getAttribute("loginId");
	}
	
	
	if(request.getParameter("qNo") == null  
			|| request.getParameter("qNo").equals("")) {
			response.sendRedirect(request.getContextPath() + "/product/customerProductDetail.jsp?p.productNo="+request.getParameter("p.productNo"));
			return;
		}
	
	IdListDao iDao = new IdListDao();
	QuestionDao qDao = new QuestionDao();
	Question question = new Question();
	int qNo = Integer.parseInt(request.getParameter("qNo"));
	Question qList = qDao.selectQuestion(qNo);
	question.setqNo(qNo);
	System.out.println(SJ+qNo +"questionDetail qNo"+ RE );
	int qCheckCnt = qList.getqCheckCnt();
	int productNo = qList.getProductNo();
	String id = qList.getId();
	String qCategory = qList.getqCategory();
	String qTitle = qList.getqTitle();
	String qContent = qList.getqContent();
	// 조회수 1 증가
	qCheckCnt += 1;
	Question qCnt = qDao.selectQCheckCnt(qCheckCnt, qNo);
	qList.setId(id);
	qList.setProductNo(productNo);
	qList.setqCategory(qCategory);
	qList.setqCheckCnt(qCheckCnt);
	qList.setqContent(qContent);
	qList.setqTitle(qTitle);
	
	System.out.println(SJ+id +"questionDetail id"+ RE );
	System.out.println(SJ+productNo +"questionDetail productNo"+ RE );
	System.out.println(SJ+qCategory +"questionDetail qCategory"+ RE );
	System.out.println(SJ+qCheckCnt +"questionDetail qCheckCnt"+ RE );
	System.out.println(SJ+qContent +"questionDetail qContent"+ RE );
	System.out.println(SJ+qTitle +"questionDetail qTitle"+ RE );
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div >
		<h1>문의 페이지 : 문의 상세</h1>
		<div >
			<a href="<%=request.getContextPath()%>/product/customerProductDetail.jsp?p.productNo=<%=productNo%>">
				<button type="button">상품상세페이지</button>
			</a>
		</div>
		<form action="<%=request.getContextPath()%>/question/modifyQuestion.jsp?qNo=<%=qNo%>" method="post">
			<table >
			<tr>
				<th >p no.</th>
				<td><%=productNo%></td>
			</tr>
			<tr>
				<th >q no.</th>
				<td><%=qNo%></td>
			</tr>
			<tr>
				<th >문의 카테고리</th>
				<td><%=qCategory%></td>
			</tr>
			<tr>
				<th >문의 제목</th>
				<td><%=qTitle%></td>
			</tr>
			<tr>
				<th >id</th>
				<td><%=id%></td>
			</tr>
			<tr>
				<th >문의 내용</th>
				<td><%=qContent%></td>
			</tr>
			
			<tr>
				<th >등록일</th>
				<td><%=qList.getCreatedate()%></td>
			</tr>
			<tr>
				<th >수정일</th>
				<td><%=qList.getUpdatedate()%></td>
			</tr>
			<tr>
			<tr>
			<%
				if(loginId == id) {
			%>
				<td>
					<button type = "submit">문의 수정</button>
					<a href="<%=request.getContextPath()%>/question/removeQuestionAction.jsp?qNo=<%=qNo%>">
						<button type="button">삭제</button>
					</a>
				</td>
			<%
				}
			%>
			</tr>
		</table>
		</form>
	</div>
</body>
</html>