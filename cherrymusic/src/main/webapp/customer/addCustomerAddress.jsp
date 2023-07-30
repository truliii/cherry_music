<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	//로그인 세션 유효성 검사: 로그아웃상태면 로그인창으로 리다이렉션
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/id_list/login.jsp");
		System.out.println(KMJ + "addCustomerAddress 로그인필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	}
	
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
            <div class="jumbotron jumbotron-bg text-center rounded-0" style="background-image: url('<%=request.getContextPath()%>/resources/assets/img/bg-header.jpg');">
                <div class="container">
                    <h1 class="pt-5">
                        주소 추가
                    </h1>
                    <p class="lead">
                    </p>
                </div>
            </div>
        </div>

        <section id="checkout">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-xs-12 col-sm-8">
                        <h5 class="mb-3">주소 추가</h5>
                        <!-- 정보 수정폼 시작 -->
                        <form action="<%=request.getContextPath()%>/customer/addCustomerAddressAction.jsp" method="post" class="bill-detail">
                            <fieldset>
                                <div class="form-group row"><!-- 2행 -->
	                                <div class="col-2 text-right">
	                                    <label for="add-name"><strong>주소이름</strong></label>
	                                </div>
	                                <div class="col-10">
										<input id="add-name" class="form-control" type="text" name="addName">
	                                </div>
                                </div>
                                <div class="form-group row">
                                	<div class="col-2 text-right">
                                		<label for="add"><strong>주소</strong></label>
                                	</div>
                                	<div class="col-10">
                                		<div>
                                			<input type="text" name="zip" id="sample6_postcode" placeholder="우편번호" class="form-control mb-1" required>
											<input type="text" name="add1" id="sample6_address" placeholder="주소" class="form-control mb-1" required>
											<input type="text" name="add2" id="sample6_detailAddress" placeholder="상세주소" class="form-control mb-1" required>
											<input type="text" name="add3" id="sample6_extraAddress" placeholder="참고항목" class="form-control mb-1">
											<input type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기" class="btn btn-sm btn-primary">
                                		</div>
                                	</div>
                       			</div>
                                <div class="form-group row">
                                	<div class="col-2 text-right">
                                		<label for="add-default"><strong>기본주소설정</strong></label>
                                	</div>
                                	<div class="col-10">
                                		<input id="add-default" class="mr-1" type="checkbox" name="addDefault">
                                	</div>
                                </div>
                                <div class="form-group text-right">
                                    <button type="submit" class="btn btn-primary">추가하기</button>
                                    <div class="clearfix"></div>
                                </div>
                            </fieldset>
                        </form>
                        <!-- 정보 수정폼 끝 -->
                	</div>
            	</div>
            </div>
        </section>
    </div>
    <footer>
        <jsp:include page="/inc/footer.jsp"></jsp:include>
    </footer>

    <jsp:include page="/inc/script.jsp"></jsp:include>
    <script>
		//주소찾기 script: https://devofroad.tistory.com/42 참고
	    function sample6_execDaumPostcode() {
	        new daum.Postcode({
	            oncomplete: function(data) {
	                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
	
	                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
	                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
	                let addr = ''; // 주소 변수
	                let extraAddr = ''; // 참고항목 변수
	
	                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
	                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
	                    addr = data.roadAddress;
	                } else { // 사용자가 지번 주소를 선택했을 경우(J)
	                    addr = data.jibunAddress;
	                }
	
	                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
	                if(data.userSelectedType === 'R'){
	                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
	                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
	                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
	                        extraAddr += data.bname;
	                    }
	                    // 건물명이 있고, 공동주택일 경우 추가한다.
	                    if(data.buildingName !== '' && data.apartment === 'Y'){
	                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                    }
	                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
	                    if(extraAddr !== ''){
	                        extraAddr = ' (' + extraAddr + ')';
	                    }
	                    // 조합된 참고항목을 해당 필드에 넣는다.
	                    document.getElementById("sample6_extraAddress").value = extraAddr;
	                
	                } else {
	                    document.getElementById("sample6_extraAddress").value = '';
	                }
	
	                // 우편번호와 주소 정보를 해당 필드에 넣는다.
	                document.getElementById('sample6_postcode').value = data.zonecode;
	                document.getElementById("sample6_address").value = addr;
	                // 커서를 상세주소 필드로 이동한다.
	                document.getElementById("sample6_detailAddress").focus();
	            }
	        }).open();
	    }
	</script>
</body>
</html>
