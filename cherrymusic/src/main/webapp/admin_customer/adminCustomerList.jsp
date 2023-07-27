<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*"%>
<%@ page import="java.util.*"%>
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
	
	/* request.getParameter("id")값이 null이 아닐경우 값 저장, 
	 * IdListCustomerDao selectId(id) method 호출
	 * String id : request.getParameter("id") 값 저장 변수
	 * HashMap<String, Object> selectId : idListCustomerDao.selectId(id) 값 저장 변수
	*/
	IdListCustomerDao idListCustomerDao = new IdListCustomerDao();
	String id = "";
	HashMap<String, Object> selectId = null;
	if(request.getParameter("id") != null){
		id = request.getParameter("id");
		System.out.println(id+"<--adminCustomerList.jsp id");
		selectId = idListCustomerDao.selectId(id);
		if(selectId != null){
			System.out.println(selectId+"<--adminCustomerList.jsp selectId");
		} else{
			System.out.println(selectId+"<--adminCustomerList.jsp 검색 Id 없음");
		}
	}
	
	// IdListCustonmeDao selectIdCstmListByPage Method 입력값 분기
	// checkbox value 값 받을 배열 생성
	String [] ckIdLevel = null; // 회원 IdLevel
	int [] intCkIdLevel = null; // String [] ckIdLevel의 값을 int로 받을 배열 
	String [] ckCstmRank = null; // 고객 등급
	String [] ckActive = null; // Id 활성화 여부
		
	// checkbox value 값에 따른 분기
	// ckIdLevel
	if(request.getParameter("ckIdLevel") != null){
		ckIdLevel = request.getParameterValues("ckIdLevel");
		intCkIdLevel = new int[ckIdLevel.length];
		
		for(int i=0; i<intCkIdLevel.length; i+=1){ 
			intCkIdLevel[i] = Integer.parseInt(ckIdLevel[i]);
		}
	}
	
	// ckCstmRank
	if(request.getParameter("ckCstmRank") != null){
		ckCstmRank = request.getParameterValues("ckCstmRank");
	}
	
	// ckActive
	if(request.getParameterValues("ckActive") != null){
		ckActive = request.getParameterValues("ckActive");
	}
	
	// 페이지 이동시 checkbox 값이 문자열로 넘어오지 않아 문자열로 변경
	String ckIdLevelStr = "";
	String ckCstmRankStr = "";
	String ckActiveStr = "";
	
	if(ckIdLevel != null){
		for(String s : ckIdLevel){
			ckIdLevelStr += "&ckIdLevel="+s;
		}
	} else if(ckCstmRank != null){
		for(String s : ckCstmRank){
			ckCstmRankStr += "&ckCstmrank="+s;
		}
	} else if(ckActive != null){
		for(String s : ckActive){
			ckActiveStr += "&ckActive="+s;
		}
	}
	// 디버깅코드
	System.out.println(BG_YELLOW+BLUE+ckIdLevelStr+"<-- ckIdLevelStr"+RESET);
	System.out.println(BG_YELLOW+BLUE+ckCstmRankStr+"<-- ckCstmRankStr"+RESET);
	System.out.println(BG_YELLOW+BLUE+ckActiveStr+"<-- ckActiveStr"+RESET);
	
	/* adminCustomerList 페이징
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
	
	int rowPerPage = 10;
	int beginRow = (currentPage-1)*rowPerPage;
	int totalRow = idListCustomerDao.selectIdCstmListCnt(intCkIdLevel, ckCstmRank, ckActive);
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
	
	/* 1페이지당 adminCustomerList
	 * AdminQuestionDao adminQuestionListByPage(beginRow, rowPerPage, categoryName) method 
	*/
	ArrayList<HashMap<String,Object>> adminCustomerList = idListCustomerDao.selectIdCstmListByPage(beginRow, rowPerPage, intCkIdLevel, ckCstmRank, ckActive);
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>adminCustomerList</title>
<jsp:include page="/inc/link.jsp"></jsp:include>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>

</head>
<body>
	<!-- 메뉴 -->
	<jsp:include page="/inc/menu.jsp"></jsp:include>
	
	<!-- 메인 -->
	<div id="all">
		<div id="content">
			<div class="container">
				<div class="row">
					<div class="col-lg-12">
						<!-- breadcrumb -->
						<nav aria-label="breadcrumb">
							<ol class="breadcrumb">
								<li aria-current="page" class="breadcrumb-item active">관리자페이지</li>
								<li aria-current="page" class="breadcrumb-item active">회원관리</li>
							</ol>
						</nav>
					</div>
					<!-- 관리자메뉴 시작 -->
					<div class="col-lg-3">
						<jsp:include page="/inc/adminSideMenu.jsp"></jsp:include>
					</div>
					<!-- 관리자메뉴 끝 -->
					<div class="col-lg-9">
              			<div class="box">
              				<div class="box">
	              				<!-- 리스트 조회 폼 -->
								<div>
									<form action="<%=request.getContextPath()%>/admin_customer/adminCustomerList.jsp" method="post">
										<div>
											<table class="table-sm">
												<tr>
													<th>회원</th>
													<td>
														&nbsp;<input type ="checkbox" name="ckIdLevel" value="0"> 고객
														&nbsp;<input type ="checkbox" name="ckIdLevel" value="1"> 사원
														&nbsp;<input type ="checkbox" name="ckIdLevel" value="2"> 관리자
													</td>
												</tr>
												<tr>
													<th>회원등급</th>
													<td>
														&nbsp;<input type ="checkbox" name="ckCstmRank" value="gold"> Gold
														&nbsp;<input type ="checkbox" name="ckCstmRank" value="silver"> Silver
														&nbsp;<input type ="checkbox" name="ckCstmRank" value="bronze"> Bronze 
													</td>
												</tr>
												<tr>
													<th>아이디 활성화</th>
													<td>
														&nbsp;<input type ="checkbox" name="ckActive" value="Y"> 활성화
														&nbsp;<input type ="checkbox" name="ckActive" value="N"> 비활성화
													</td>
												</tr>
											</table>
										</div>
										<div class="text-right">
											<button type="submit" class="btn btn-primary">검색</button>
										</div>
									</form>
								</div>
							</div>
							<div class="col-lg-12">
								<!-- Id 검색 폼 -->
								<div class="text-right">
									<form action="<%=request.getContextPath()%>/admin_customer/adminCustomerList.jsp" method="post">
										<input type ="text" name="id">
										<button type="submit" class="btn btn-primary">아이디 조회</button> 
									</form>
								</div>
								<br>
							</div>
							<!-- 조회 리스트, Id검색 분기하여 출력 -->
							<%
								if(selectId == null){ // 조회 리스트 출력
							%>
									<div>
										<table class="table">
											<tr>
												<th>ID</th>
												<th>성명</th>
												<th>회원등급</th>
												<th>활성화</th>
											</tr>
											<%
												for(HashMap<String, Object> m : adminCustomerList){
											%>
												<tr onclick="location.href='<%=request.getContextPath()%>/admin_customer/customerOne.jsp?id=<%=(String) m.get("id")%>'">
													<td><%=(String) m.get("id")%></td>
													<td><%=(String) m.get("cstmName")%></td>
													<td><%=(String) m.get("cstmRank")%></td>
													<td><%=(String) m.get("active")%></td>
												</tr>
											<%		
												}
											%>
										</table>
									</div>
							<%		
								} else{ // 검색 Id 출력
							%>
									<div>
										<table class="table">
											<tr>
												<th>ID</th>
												<th>성명</th>
												<th>회원등급</th>
												<th>활성화</th>
											</tr>
											<tr onclick="location.href='<%=request.getContextPath()%>/admin_customer/customerOne.jsp?id=<%=(String) selectId.get("id")%>'">
												<td><%=(String) selectId.get("id")%></td>
												<td><%=(String) selectId.get("cstmName")%></td>
												<td><%=(String) selectId.get("cstmRank")%></td>
												<td><%=(String) selectId.get("active")%></td>
											</tr>
										</table>
									</div>
							<%		
								}
							%>
							<!-- 페이지 네비게이션 
							 * selectId가 null이 아닌경우만 페이지 네비게이션 출력
							-->
							<%
								if(selectId == null){ 
							%>
									<div class="pageNav">
										<ul class="list-group list-group-horizontal">
											<%
												if(startPage > 1){
											%>
													<li class="list-group-item pageNavLi" onclick="location.href='<%=request.getContextPath()%>
													/admin_customer/adminCustomerList.jsp?currentPage=<%=startPage-pageLength%><%=ckIdLevelStr%><%=ckCstmRankStr%><%=ckActiveStr%>'">
														<span>이전</span>
													</li>
											<%		
												}
													for(int i = startPage; i <= endPage; i++){
														if(i == currentPage){
											%>
															<li class="list-group-item currentPageNav">
																<span><%=i%></span>
															</li>
											<%
														} else{
											%>
													<li class="list-group-item pageNavLi" onclick="location.href='<%=request.getContextPath()%>/admin_customer/adminCustomerList.jsp?currentPage=<%=i%><%=ckIdLevelStr%><%=ckCstmRankStr%><%=ckActiveStr%>'">
														<span><%=i%></span>
													</li>
											<%			
													}
												}
													if(endPage != lastPage){
											%>
														<li class="list-group-item pageNavLi" onclick="location.href='<%=request.getContextPath()%>/admin_customer/adminCustomerList.jsp?currentPage=<%=startPage+pageLength%><%=ckIdLevelStr%><%=ckCstmRankStr%><%=ckActiveStr%>'">
															<span>다음</span>
														</li>	
											<%			
													}
											%>
										</ul>
									</div>
							<%		
								}
							%>
              			</div>
              		</div>	
				</div>
			</div>
		</div>
	</div>
	
	<!-- copy -->
	<jsp:include page="/inc/copy.jsp"></jsp:include>
	<!-- 자바스크립트 -->
	<jsp:include page="/inc/script.jsp"></jsp:include>
</body>
<script>
	// checkbox 선택 유지(ChatGPT 참고)
	// 페이지 로드 시 저장된 checkbox 상태 복원
	restoreCheckboxState();
	  
	// checkbox가 변경될 때마다 상태 저장
	$("input[type='checkbox']").on("change", function() {
		saveCheckboxState();
	});
	
	function saveCheckboxState() {
	// checkbox 상태를 저장하기 위해 localStorage 사용
	$("input[type='checkbox']").each(function() {
		let name = $(this).attr("name");
		let value = $(this).val();
		let isChecked = $(this).is(":checked");
		
		localStorage.setItem(name + "_" + value, isChecked);
		});
	}
	
	function restoreCheckboxState() {
	// 저장된 checkbox 상태 복원
	$("input[type='checkbox']").each(function() {
		let name = $(this).attr("name");
	  	let value = $(this).val();
	  	let isChecked = localStorage.getItem(name + "_" + value);
	  
	 	 if (isChecked === "true") {
	    	$(this).prop("checked", true);
	  	} else {
	    	$(this).prop("checked", false);
	  	}
		});
	}
</script>
</html>