<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	/* //로그인 유효성 검사
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println(KMJ + "reviewList 로그인 필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId" + " <--ordersAction loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	} 

	*/
	String loginId = "user1"; //test용: 삭제예정
	System.out.println(KMJ + loginId + " <--ordersAction loginId");
	
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");
	
	int productNo = 1;
	int rCurrPage = 1;
	int rRowPerPage = 5;
	int rBeginRow = (rCurrPage - 1)*rRowPerPage;
	
	//요청값 유효성검사
	ReviewDao rDao = new ReviewDao();
	ArrayList<HashMap<String, Object>> list = rDao.selectReviewListByProduct(productNo, rBeginRow, rRowPerPage);
	System.out.println(KMJ + list.size() + " <--reviewList list.size()" + RESET);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>review list</title>
</head>
<body>
	<table>
		<tr>
			<th>제목</th>
			<th>작성일</th>
			<th>사진</th>
			<th>작성자</th>
		</tr>
		<%
			for(HashMap<String, Object> m : list){
		%>
				<tr>
					<td><a href="<%=request.getContextPath()%>/review/reviewOne.jsp?reviewNo=<%=(Integer)m.get("reviewNo")%>"><%=m.get("reviewTitle")%></a></td>
					<td><%=m.get("createdate").toString().substring(0, 11)%></td>
					<td><img src="<%=request.getContextPath()%>/review/reviewImg/<%=m.get("saveFilename")%>" alt="이미지준비중"></td>
					<td><%=m.get("id")%></td>
				</tr>
		<%
			}
		%>
	</table>
</body>
</html>