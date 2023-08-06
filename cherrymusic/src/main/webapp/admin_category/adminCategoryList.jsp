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
	
	// CategoryDao
	CategoryDao categoryDao = new CategoryDao();
	
	// CategoryList 조회 method
	ArrayList<Category> list = categoryDao.selectCategoryList();
%>
<!DOCTYPE html>
<html>
<head>
<title>adminCategory</title>
<jsp:include page="/inc/head.jsp"></jsp:include>
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
                        카테고리 관리
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
				<!-- 카테고리 리스트 -->
				<div class="col-lg-12" style="margin-top: 50px;">
					<div class="box">
						<!-- 카테고리 등록 버튼 -->
						<div>
							<button type="button" id="addCategoryBtn" class="btn btn-primary">카테고리 등록</button>
						</div>
						<br>
						<!-- 리스트 출력 -->
						<div>
							<table class="table">
								<thead>
									<tr>
										<th>카테고리</th>
										<th>&nbsp;</th>
									</tr>
								</thead>
								<%
								    int num = 0;
									String categoryName = "";
								    for (Category c : list) {
								        num = num + 1;
								        categoryName = "categoryName" +num;
								%>
								<tbody>
								    <tr>
								        <td>
								            <form method="post" id="modifyCategoryForm">
									            <span data-category-name="<%=categoryName%>"><%=c.getCategoryName()%></span>
									            <input type="text" name="modifyCategoryName" id="<%=categoryName%>" class="form-control" value="<%=c.getCategoryName()%>" style="display:none">
									            <input type="hidden" name="categoryName" value="<%=c.getCategoryName()%>">
								            </form>
								        </td>
								        <td class="text-right">
								            <button type="button" class="modifyBtn btn btn-primary" data-modify="<%=categoryName%>">수정</button>
								            <button type="button" class="removeBtn btn btn-primary" data-modify="<%=categoryName%>" data-remove="<%=c.getCategoryName()%>">삭제</button>
								            <button type="button" class="confirmBtn btn btn-primary" data-modify="<%=c.getCategoryName()%>" data-modify-confirm="<%=categoryName%>" style="display:none">확인</button>
								            <button type="button" class="cancelBtn btn btn-primary" data-modify-cancel="<%=categoryName%>" style="display:none">취소</button>
								        </td>
								    </tr>    
									<%
									    }
									%>
									<tr id="addCategoryTr" style="display:none">
										<td>
											<form method="post" id="addCategoryForm">
												<input type="text" name="addCategoryName" class="form-control">
											</form>
										</td>
										<td class="text-right">
											<button type="button" id="addBtn" class="btn btn-primary">등록</button>
											<button type="button" class="cancelBtn btn btn-primary">취소</button>
										</td>
									</tr>
								</tbody>
							</table>
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
    
	// addCategoryBtn click
	$('#addCategoryBtn').on('click', function() {
		$('#addCategoryTr').show(); // id. addCategoryTr 보여주기
	    $(this).hide(); // addCategoryBtn(this) 숨기기 
	});
    
	// addBtn click 
	$('#addBtn').click(function() {
		// input 요소 중 name 속성이 "addCategoryName"인 요소의 값 저장	   
		let addCategoryName = $('input[name="addCategoryName"]').val();
	    
	    // 입력값이 비어있는지 확인
	    if(addCategoryName.trim() == '') {
		    alert('카테고리명을 입력해주세요.');
		    return;
		}
	    
	 	// 중복카테고리 확인
		$.ajax({
			url:'<%=request.getContextPath()%>/admin_category/selectCategory.jsp',
			data: {categoryName : addCategoryName},
			dataType: 'json',
			success : function(result){
		       
				if(result === true) {
					alert('중복된 카테고리입니다');
				} 
			},
			error : function(err) {
				alert('err');
				console.log(err);
			}
		});
	 	
	    // 입력값이 있을 경우, adminCategoryAddAction.jsp로 이동
	    let addCategoryFormUrl = '<%=request.getContextPath()%>/admin_category/adminCategoryAddAction.jsp';
	    $('#addCategoryForm').attr('action', addCategoryFormUrl);
	    $('#addCategoryForm').submit();
  	});
	
	/* modifyBtn click
	 * 선택한 수정폼, 확인, 취소 버튼 보이주기
	 * <span> 카테고리명, 수정, 삭제 버튼 숨기기
	*/
	$('.modifyBtn').on('click', function() {
	    let modifyCategoryName = $(this).data('modify');
	    $('#' + modifyCategoryName).show();
	    $(this).closest('tr').find('span[data-category-name]').hide();
	    $(this).closest('tr').find('button[data-modify]').hide();
	    $(this).closest('tr').find('button[data-modify-confirm]').show();
	    $(this).closest('tr').find('button[data-modify-cancel]').show();
	});
	
	// confirmBtn click
	$(document).on('click', '.confirmBtn', function(){
		
		// 해당 수정 카테고리 값 저장
		let categoryName = $(this).data('modify');
		
		// input 요소 중 name 속성이 "modifyCategoryName"인 요소의 값 저장
		let modifyCategoryName = $('input[name="modifyCategoryName"]').val();
		
		// 입력값이 비어있는지 확인
		if(modifyCategoryName.trim() == ''){
			alert('수정할 카테고리명을 입력해주세요');
			return;
		}
		
		// 참조카테고리 확인
		$.ajax({
			url:'<%=request.getContextPath()%>/admin_category/checkCategory.jsp',
			data: {categoryName : categoryName},
			dataType: 'json',
			success : function(result){
		        
				if(result === true) {
					alert('카테고리의 상품이 등록되어 있어 수정할 수 없습니다');
				}
			},
			error : function(err) {
				alert('err');
				console.log(err);
			}
		});
		
		// 중복카테고리 확인
		$.ajax({
			url:'<%=request.getContextPath()%>/admin_category/selectCategory.jsp',
			data: {categoryName : modifyCategoryName},
			dataType: 'json',
			success : function(result){
		       
				if(result === true) {
					alert('중복된 카테고리입니다');
				} 
			},
			error : function(err) {
				alert('err');
				console.log(err);
			}
		});
		
		// 입력값이 있을 경우, adminCategoryModifyAction.jsp로 이동
		let modifyCategoryFormUrl = '<%=request.getContextPath()%>/admin_category/adminCategoryModifyAction.jsp';
		$('#modifyCategoryForm').attr('action', modifyCategoryFormUrl);
	    $('#modifyCategoryForm').submit();
	});
	
	// cancelBtn click, adminCategoryList.jsp로 이동
	$(document).on('click', '.cancelBtn', function(){
		let cancelUrl = '<%=request.getContextPath()%>/admin_category/adminCategoryList.jsp';
		location.href = cancelUrl;
	})
	
	// removeBtn click, adminCategoryRemoveAction.jsp로 이동
	$(document).on('click', '.removeBtn', function() {
		
		let categoryName = $(this).data('remove');
		
		// 참조카테고리 확인
		$.ajax({
			url:'<%=request.getContextPath()%>/admin_category/checkCategory.jsp',
			data: {categoryName : categoryName},
			dataType: 'json',
			success : function(result){
				
				if(result === true) {
					alert('카테고리의 상품이 등록되어 있어 삭제할 수 없습니다')
				}
			},
			error : function(err) {
				alert('err');
				console.log(err);
			}
		});
		
		let removeUrl = '<%=request.getContextPath()%>/admin_category/adminCategoryRemoveAction.jsp?categoryName=' + categoryName;
		location.href = removeUrl;
		
	});

</script>
</html>