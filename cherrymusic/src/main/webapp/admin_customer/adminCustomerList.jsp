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
<jsp:include page="/inc/head.jsp"></jsp:include>
<title>adminCustomerList</title>
</head>
<body>
	<!-- header -->
	<jsp:include page="/inc/header.jsp"></jsp:include>
	
	<!-- main -->
	<div id="page-content" class="page-content">
		<!-- banner -->
		<div class="banner">
			<div class="jumbotron jumbotron-bg text-center rounded-0" style="background-image: url('<%=request.getContextPath()%>/resources/assets/img/cherry_header.jpg');">
				<div class="container">
					<h1 class="pt-5">
                        회원 관리
                    </h1>
				</div>
			</div>
		</div>
		<!-- content -->
		<div class="container" style="margin-top: 100px;">
			<div class="row">
				<div class="col-lg-12">
					<!-- adminNav -->
					<jsp:include page="/inc/adminNav.jsp"></jsp:include>
				</div>
				<!-- 회원 리스트 -->
				<div class="col-lg-12" style="margin-top: 50px;">
					<div class="card mb-5">
						<!-- 선택 조회 체그박스 -->
						<div class="card-body">
							<form action="<%=request.getContextPath()%>/admin_customer/adminCustomerList.jsp" method="post">
								<div class="form-group row mt-3">
	                                	<div class="col-md-2 text-right">
	                                		<strong>회원</strong>
	                                	</div>
	                                    <div class="col-md-10">
	                                    	<div class="row">
	                                    		<div class="col-2">
	                                    			<input type ="checkbox" name="ckIdLevel" value="0"> <label for="wait">고객</label>
	                                    		</div>
	                                    		<div class="col-2">
			                                        <input type ="checkbox" name="ckIdLevel" value="1"> <label for="wait">사원</label>
	                                    		</div>
	                                    		<div class="col-2">
			                                        <input type ="checkbox" name="ckIdLevel" value="2"> <label for="wait">관리자</label>
	                                    		</div>
	                                    	</div>
	                                    </div>
	                                </div>
	                                <div class="form-group row mt-3">
	                                	<div class="col-md-2 text-right">
	                                		<strong>회원등급</strong>
	                                	</div>
	                                    <div class="col-md-10">
	                                    	<div class="row">
	                                    		<div class="col-2">
	                                    			<input type ="checkbox" name="ckCstmRank" value="gold"> <label for="wait">Gold</label>
	                                    		</div>
	                                    		<div class="col-2">
			                                        <input type ="checkbox" name="ckCstmRank" value="silver"> <label for="wait">Silver</label>
	                                    		</div>
	                                    		<div class="col-2">
			                                        <input type ="checkbox" name="ckCstmRank" value="bronze"> <label for="wait">Bronze</label>
	                                    		</div>
	                                    	</div>
	                                    </div>
	                                </div>
	                                <div class="form-group row mt-3">
	                                	<div class="col-md-2 text-right">
	                                		<strong>아이디 활성화</strong>
	                                	</div>
	                                    <div class="col-md-10">
	                                    	<div class="row">
	                                    		<div class="col-2">
	                                    			<input type ="checkbox" name="ckActive" value="Y"> <label for="wait">활성화</label>
	                                    		</div>
	                                    		<div class="col-2">
			                                        <input type ="checkbox" name="ckActive" value="N"> <label for="wait">비활성화</label>
	                                    		</div>
	                                    	</div>
	                                    </div>
	                                </div>
									<div class="text-center">
										<button type="submit" class="btn btn-primary">검색</button>
									</div>
							</form>
						</div>
					</div>
					<div style="margin-top: 50px;">
						<!-- Id 검색 폼 -->
						<div>
							<form id="idSelectForm" method="post" style="display: flex; justify-content: flex-end;">
								<input type ="text" name="id" id="id" style="margin-right: 5px;">
								<button type="button" class="btn btn-primary" id="idSelectBtn">아이디 조회</button> 
							</form>
						</div>
					</div>
					<!-- 회원 리스트, Id검색 분기하여 출력 -->
					<div style="margin-top: 20px">
						<table class="table">
							<thead>
								<tr>
									<th>ID</th>
									<th>성명</th>
									<th>회원등급</th>
									<th>활성화</th>
								</tr>
							</thead>
							<tbody>
							<%
								if(selectId == null){
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
								} else{
							%>
									<tr onclick="location.href='<%=request.getContextPath()%>/admin_customer/customerOne.jsp?id=<%=(String) selectId.get("id")%>'">
										<td><%=(String) selectId.get("id")%></td>
										<td><%=(String) selectId.get("cstmName")%></td>
										<td><%=(String) selectId.get("cstmRank")%></td>
										<td><%=(String) selectId.get("active")%></td>
									</tr>
							<%		
								}
							%>
							</tbody>
						</table>
					</div>
					<!-- 페이지 네비게이션 
					 * selectId가 null이 아닌경우만 페이지 네비게이션 출력
					-->
					<%
						if(selectId == null){ 
					%>
							<div class="d-flex justify-content-center">
								<ul class="pagination">
									<!-- 첫페이지 -->
									<li class="page-item">
										<a class="page-link" href="<%=request.getContextPath()%>/admin_customer/adminCustomerList.jsp?currentPage=1<%=ckIdLevelStr%><%=ckCstmRankStr%><%=ckActiveStr%>">&#60;&#60;</a>
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
												<a class="page-link" href="<%=request.getContextPath()%>/admin_customer/adminCustomerList.jsp?currentPage=<%=startPage-1%><%=ckIdLevelStr%><%=ckCstmRankStr%><%=ckActiveStr%>">&#60;</a>
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
												<a class="page-link" href="<%=request.getContextPath()%>/admin_customer/adminCustomerList.jsp?currentPage=<%=i%><%=ckIdLevelStr%><%=ckCstmRankStr%><%=ckActiveStr%>">
													<%=i%>
												</a>
											</li>
									<%
											} else {
									%>
											<li class="page-item">
												<a class="page-link" href="<%=request.getContextPath()%>/admin_customer/adminCustomerList.jsp?currentPage=<%=i%><%=ckIdLevelStr%><%=ckCstmRankStr%><%=ckActiveStr%>">
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
												<a class="page-link" href="<%=request.getContextPath()%>/admin_customer/adminCustomerList.jsp?currentPage=<%=endPage+1%><%=ckIdLevelStr%><%=ckCstmRankStr%><%=ckActiveStr%>">&#62;</a>
											</li>
									<%
										}
									%>
									
									<!-- 마지막페이지 -->
									<li class="page-item">
										<a class="page-link" href="<%=request.getContextPath()%>/admin_customer/adminCustomerList.jsp?currentPage=<%=lastPage%><%=ckIdLevelStr%><%=ckCstmRankStr%><%=ckActiveStr%>">&#62;&#62;</a>
									</li>
								</ul>	
							</div> 
					<%		
						}
					%>
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
	
	// 아이디 조회 버튼 클릭(idSelectBtn)
	$('#idSelectBtn').click(function(){
		if($('#id').val() == '') {
			alert('조회할 아이디를 입력해주세요');
		} else {
			$.ajax({
				url:'<%=request.getContextPath()%>/id_list/checkMemberId.jsp',
				data: {idCheck : $('#id').val()},
				dataType: 'json',
				success : function(param){
					console.log(param);
					if(param === true) {
						let idSelectUrl = '<%=request.getContextPath()%>/admin_customer/adminCustomerList.jsp';
						$('#idSelectForm').attr('action', idSelectUrl);
					    $('#idSelectForm').submit();	
					} else {
						alert('존재하지 않는 아이디 입니다.');
						$('#id').val('');
						$('#id').focus();
					}
				},
				error : function(err) {
					alert('err');
					console.log(err);
					}
				});
			}
		});
</script>

</html>