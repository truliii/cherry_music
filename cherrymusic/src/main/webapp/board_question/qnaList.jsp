<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="dao.*"%>
<%@page import="vo.*"%>
<%@page import="java.util.*"%>
<%
	//RESET ANST CODE 콘솔창 글자색, 배경색 지정
	final String RESET = "\u001B[0m";
	final String BLUE ="\u001B[34m";
	final String BG_YELLOW ="\u001B[43m";

	// request 인코딩
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
	
	// 요청 값 저장(searchWord, columnName)
	String searchWord = "";
	if(request.getParameter("searchWord") != null){
		searchWord = request.getParameter("searchWord");
	}
	String columnName = "";
	if(request.getParameter("columnName") != null){
		columnName = request.getParameter("columnName");
		
	}
	// 디버깅코드
	System.out.println(BG_YELLOW+BLUE+searchWord +"<--boardQuestionList.jsp searchWord"+RESET);
	System.out.println(BG_YELLOW+BLUE+columnName +"<--boardQuestionList.jsp columnName"+RESET);
	
	/* boardQuestionList 페이징
	* currentPage : 현재 페이지
	* rowPerPage : 페이지당 출력할 행의 수
	* beginRow : 시작 행번호
	* totalRow : 전체 행의 수
	* lastPage : 마지막 페이지를 담을 변수. totalRow(전체 행의 수) / rowPerPage(한 페이지에 출력되는 수)
	* totalRow % rowPerPage의 나머지가 0이 아닌경우 lastPage +1을 해야한다.
	*/
	
	int currentPage = 1;
	
	// currentPage 유효성 검사
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// BoardQuestionDao
	BoardQuestionDao boardQuestionDao = new BoardQuestionDao();
	
	int rowPerPage = 10;
	int beginRow = (currentPage-1)*rowPerPage;
	int totalRow = boardQuestionDao.selectBoardQuestionListCnt(searchWord, columnName);
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0){
		lastPage +=1;
	}
	System.out.println(BG_YELLOW+BLUE+currentPage + "<--adminCustomerList.jsp currentPage"+RESET);
	System.out.println(BG_YELLOW+BLUE+beginRow + "<--adminCustomerList.jsp beginRow"+RESET);
	System.out.println(BG_YELLOW+BLUE+totalRow + "<--adminCustomerList.jsp totalRow"+RESET);
	System.out.println(BG_YELLOW+BLUE+lastPage + "<--adminCustomerList.jsp lastPage"+RESET);
	
	/* 페이지 블럭
	* currentBlock : 현재 페이지 블럭(currentPage / pageLength)
	* currentPage % pageLength != 0, currentBlock +1
	* pageLength : 현제 페이지 블럭의 들어갈 페이지 수
	* startPage : 블럭의 시작 페이지 (currentBlock -1) * pageLength +1
	* endPage : 블럭의 마지막 페이지 startPage + pageLength -1
	* 맨 마지막 블럭에서는 끝지점에 도달하기 전에 페이지가 끝나기 때문에 아래와 같이 처리 
	* if(endPage > lastPage){endPage = lastPage;}
	*/
	
	int pageLength = 5;
	int currentBlock = currentPage / pageLength;
	if(currentPage % pageLength != 0){
		currentBlock += 1;	
	}
	int startPage = (currentBlock -1) * pageLength +1;
	int endPage = startPage + pageLength -1;
	if(endPage > lastPage){
		endPage = lastPage;
	}
	System.out.println(BG_YELLOW+BLUE+currentBlock+"<--adminCustomerList.jsp currentBlock"+RESET);
	System.out.println(BG_YELLOW+BLUE+startPage+"<--adminCustomerList.jsp startPage"+RESET);
	System.out.println(BG_YELLOW+BLUE+endPage+"<--adminCustomerList.jsp endPage"+RESET);
	
	// 1페이지당 boardQuestionList
	ArrayList<HashMap<String, Object>> list = boardQuestionDao.selectBoardQuestionByPage(beginRow, rowPerPage, searchWord, columnName);
%>
<!DOCTYPE html>
<html>
<head>
	<jsp:include page="/inc/head.jsp"></jsp:include>
</head>
<body>
	<!-- header -->
	<jsp:include page="/inc/header.jsp"></jsp:include>
	
	<!-- main -->
	<div id="page-content" class="page-content">
		<!-- banner -->
		<div class="banner">
			<div class="jumbotron jumbotron-bg text-center rounded-0" style="background-image: url('<%=request.getContextPath()%>/resources/assets/img/bg-header.jpg');">
				<div class="container">
					<h1 class="pt-5">
                        문의 게시판
                    </h1>
                    <p class="lead">
                        문의사항 작성
                    </p>
				</div>
			</div>
		</div>
		<!-- content -->
		<div class="container" style="margin-top: 100px;">
			<div class="row">
				<div class="col-lg-12">
					<!-- breadcrumb-->
					<nav aria-label="breadcrumb">
						<ol class="breadcrumb">
							<li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/home.jsp">홈</a></li>
							<li aria-current="page" class="breadcrumb-item active">Q&A</li>
						</ol>
					</nav>
				</div>
				<!-- Q&A 리스트-->
				<div class="col-lg-12">
					<div class="box">
						<!-- 문의 등록 버튼 -->
						<div class="text-right">
							<button type="button" class="btn btn-primary" onclick="location.href='<%=request.getContextPath()%>/board_question/qnaAdd.jsp'">문의작성</button>
						</div>
						<br>
						<!-- 리스트 출력 -->
						<div>
							<table class="table">
								<thead>
								<tr>
									<th>문의번호</th>
									<th>분류</th>
									<th>문의제목</th>
									<th>작성자</th>
									<th>작성일</th>
									<th>조회수</th>
									<th colspan="2">&nbsp;</th>
								</tr>
								</thead>
								<tbody>
								<%
									for(HashMap<String, Object> bq: list){
										if(loginId.equals((String) bq.get("id"))){
								%>
										<tr id="qnaDetailTr" onclick="location.href='<%=request.getContextPath()%>/board_question/qnaDetail.jsp?boardQNo=<%=(Integer) bq.get("boardQNo")%>'">
											<td><%=(Integer) bq.get("boardQNo")%></td>
											<td><%=(String) bq.get("boardQCategory")%></td>
											<td><%=(String) bq.get("boardQTitle")%></td>
											<td><%=(String) bq.get("cstmName")%></td>
											<td><%=((String) bq.get("createdate")).substring(0,10)%></td>
											<td><%=(Integer) bq.get("boardQCheckCnt")%></td>
										<%
											if((Integer) bq.get("boardANoCnt") > 0){
										%>
												<td>답변완료</td>
										<%		
											} else{
										%>
												<td>확인중</td>
										<%		
											}
										%>
												<td><i class="fa fa-unlock"></i></td>
										</tr>
								<%			
										} else{
								%>
											<tr>
												<td><%=(Integer) bq.get("boardQNo")%></td>
												<td><%=(String) bq.get("boardQCategory")%></td>
												<td><%=(String) bq.get("boardQTitle")%></td>
												<td><%=(String) bq.get("cstmName")%></td>
												<td><%=((String) bq.get("createdate")).substring(0,10)%></td>
												<td><%=(Integer) bq.get("boardQCheckCnt")%></td>
										<%
											if((Integer) bq.get("boardANoCnt") > 0){
										%>
												<td>답변완료</td>
										<%		
											} else{
										%>
												<td>확인중</td>
										<%		
											}
										%>
												<td><i class="fa fa-lock"></i></td>
										</tr>
									</tbody>
								<%			
										}
								%>
									
								<%		
									}
								%>
							</table>
						</div>
						<!-- 검색조회 폼 -->
						<div class="text-right">
							<form method="post" id="selectQnAForm">
								<select name="columnName">
									<option value="">전체</option>
									<option value="titleContent">제목+내용</option>
									<option value="title">제목</option>
									<option value="content">내용</option>
									<option value="cstmName">작성자</option>
								</select>
								<input type ="text" name="searchWord" value="<%=searchWord%>">
								<button type="button" id="selectQnABtn" class="btn btn-primary">검색</button>
							</form>
						</div>
						<!-- 페이지 네비게이션 -->
						<div class="d-flex justify-content-center">
							<ul class="pagination">
								<!-- 첫페이지 -->
								<li class="page-item">
									<a class="page-link" href="<%=request.getContextPath()%>/board_question/qnaList.jsp?currentPage=1&searchWord=<%=searchWord%>&columnName=<%=columnName%>">&#60;&#60;</a>
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
											<a class="page-link" href="<%=request.getContextPath()%>/board_question/qnaList.jsp?currentPage=<%=startPage-1%>&searchWord=<%=searchWord%>&columnName=<%=columnName%>">&#60;</a>
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
											<a class="page-link" href="<%=request.getContextPath()%>/board_question/qnaList.jsp?currentPage=<%=i%>&searchWord=<%=searchWord%>&columnName=<%=columnName%>">
												<%=i%>
											</a>
										</li>
								<%
										} else {
								%>
										<li class="page-item">
											<a class="page-link" href="<%=request.getContextPath()%>/board_question/qnaList.jsp?currentPage=<%=i%>&searchWord=<%=searchWord%>&columnName=<%=columnName%>">
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
											<a class="page-link" href="<%=request.getContextPath()%>/board_question/qnaList.jsp?currentPage=<%=endPage+1%>&searchWord=<%=searchWord%>&columnName=<%=columnName%>">&#62;</a>
										</li>
								<%
									}
								%>
								
								<!-- 마지막페이지 -->
								<li class="page-item">
									<a class="page-link" href="<%=request.getContextPath()%>/board_question/qnaList.jsp?currentPage=<%=lastPage%>&searchWord=<%=searchWord%>&columnName=<%=columnName%>">&#62;&#62;</a>
								</li>
							</ul>	
						</div> 
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- footer -->		
	 <footer>
        <jsp:include page="/inc/footer.jsp"></jsp:include>
    </footer>
	<!-- 자바스크립트 -->
	<jsp:include page="/inc/script.jsp"></jsp:include>
</body>

<script>
	// columnName selected
	let columnName = '<%=columnName%>';
	$('select[name="columnName"] option').each(function() {
	  if ($(this).val() == columnName) {
	    $(this).prop('selected', true);
	  }
	});
	
	// selectQnABtn click
	$('#selectQnABtn').on('click', function() {
	    let qnaListUrl = '<%=request.getContextPath()%>/board_question/qnaList.jsp';
	    $('#selectQnAForm').attr('action', qnaListUrl);
	    $('#selectQnAForm').submit();
	});
	
	// qnaDetailTr click
	$('#qnaDetailTr').click(function(){
		let boardQNoValue = $(this).find('td:first-child').text();
		
		$.ajax({
			url:'<%=request.getContextPath()%>/board_question/boardQCheckCnt.jsp',
			data: {boardQNo : boardQNoValue},
			dataType: 'json',
			success : function(param){
				console.log('조회수 증가');
			},
			error : function(err) {
				alert('err');
				console.log(err);
				}
			});
		});
	
</script>
</html>