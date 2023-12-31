<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	//로그인 세션 유효성 검사: 로그아웃 상태면 로그인창으로 리다이렉션
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"id_list/login.jsp");
		System.out.println(KMJ + "customerOne 로그인되어있지 않아 리다이렉션" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	}
	
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");
	
	//요청값이 넘어오는지 확인하기
	System.out.println(KMJ + request.getParameter("id") + " <--pointHistory param id" + RESET);
	System.out.println(KMJ + request.getParameter("currentPage") + " <--pointHistory param currentPage" + RESET);
	
	int currentPage = 1;
	int rowPerPage = 10;
	//요청값 유효성 검사
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int beginRow = ((currentPage-1)*rowPerPage);
	
	//포인트 이력 조회를 위한 dao객체 생성
	PointHistoryDao pDao = new PointHistoryDao();
	ArrayList<HashMap<String, Object>> list = pDao.SelectIdPointHistoryByPage(loginId, beginRow, rowPerPage);

	//페이지네이션에 필요한 변수 선언: ordersCnt, lastPage, pagePerPage, startPage, endPage
	int pointCnt = pDao.SelectIdPointHistoryCnt(loginId);
	int lastPage = pointCnt / rowPerPage;
	//ordersCnt를 rowPerPage로 나눈 나머지가 있으면 lastPage + 1
	if (pointCnt % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
	int pagePerPage = 10;
	int startPage = ((currentPage - 1) / pagePerPage) * pagePerPage + 1;
	int endPage = startPage + pagePerPage - 1;
	//endPage가 lastPage보다 크면 endPage = lastPage
	if (endPage > lastPage) {
		endPage = lastPage;
	}

	//변수 디버깅
	System.out.println(KMJ + pointCnt + " <--pointHistory pointCnt" + RESET);
	System.out.println(KMJ + lastPage + " <--pointHistory lastPage" + RESET);
	System.out.println(KMJ + startPage + " <--pointHistory startPage" + RESET);
	System.out.println(KMJ + lastPage + " <--pointHistory endPage" + RESET);
%>

<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/inc/head.jsp"></jsp:include>

</head>
<body>
    <jsp:include page="/inc/header.jsp"></jsp:include>
    
    <div id="page-content" class="page-content">
        <div class="banner">
            <div class="jumbotron jumbotron-bg text-center rounded-0" style="background-image: url('<%=request.getContextPath()%>/resources/assets/img/cherry_header.jpg');">
                <div class="container">
                    <h1 class="pt-5">
                        나의 포인트
                    </h1>
                    <p class="lead">
                        포인트 이력을 확인하세요!
                    </p>
                </div>
            </div>
        </div>

        <section id="cart">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-md-9">
                        <div class="table-responsive">
                            <table class="table text-center">
                                <thead>
                                    <tr>
                                    	<th width="5%"></th>
                                        <th>주문번호</th>
                                        <th>포인트</th>
                                        <th>날짜</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
										int num=0;
                                    	for(HashMap<String, Object> m : list){
											num+=1;
									%>
										<tr>
											<td><%=num%></td>
											<td><%=(Integer)m.get("orderNo")%></td>
											<td><%=(String)m.get("point")%></td>
											<td><%=(String)m.get("createdate")%></td>
										</tr>
									<%
										}
									%>
                                </tbody>
                            </table>
                        </div>

                        <nav aria-label="Page navigation">
                            <ul class="pagination justify-content-center">
                                <!-- 첫페이지 -->
								<li class="page-item">
									<a class="page-link" href="<%=request.getContextPath()%>/customer/pointHistory.jsp?currentPage=1">&#60;&#60;</a>
								</li>
								<!-- 이전 페이지블럭 (startPage - 1) -->
								<%
									if(startPage <= 1){ //startPage가 1인 페이지블럭에서는 '이전'버튼 비활성화
								%>
										<li class="page-item disabled"><a class="page-link" href="#">&#60;</a></li>
								<%	
									} else {
								%>
										<li class="page-item">
											<a class="page-link" href="<%=request.getContextPath()%>/customer/pointHistory.jsp?currentPage=<%=startPage-1%>">&#60;</a>
										</li>
								<%
									}
								%>
								
								<!-- 현재페이지 -->
								<%
									for(int i=startPage; i<=endPage; i+=1){ //startPage~endPage 사이의 페이지i 출력하기
										if(currentPage == i){ //현재페이지와 i가 같은 경우에는 표시하기
								%>
										<li class="page-item active">
											<a class="page-link" href="<%=request.getContextPath()%>/customer/pointHistory.jsp?currentPage=<%=i%>">
												<%=i%>
											</a>
										</li>
								<%
										} else {
								%>
										<li class="page-item">
											<a class="page-link" href="<%=request.getContextPath()%>/customer/pointHistory.jsp?currentPage=<%=i%>">
												<%=i%>
											</a>
										</li>
								<%	
										}
									}
								%>
								<!-- 다음 페이지블럭 (endPage + 1) -->
								<%
									if(lastPage == endPage){ //마지막페이지에서는 '다음'버튼 비활성화
								%>
										<li class="page-item disabled"><a class="page-link" href="#">&#62;</a></li>
								<%	
									} else {
								%>
										<li class="page-item">
											<a class="page-link" href="<%=request.getContextPath()%>/customer/pointHistory.jsp?currentPage=<%=endPage+1%>">&#62;</a>
										</li>
								<%
									}
								%>
								
								<!-- 마지막페이지 -->
								<li class="page-item">
									<a class="page-link" href="<%=request.getContextPath()%>/customer/pointHistory.jsp?currentPage=<%=lastPage%>">&#62;&#62;</a>
								</li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </section>
    </div>
    <footer>
        <jsp:include page="/inc/footer.jsp"></jsp:include>
    </footer>

	<jsp:include page="/inc/script.jsp"></jsp:include>
</body>
</html>