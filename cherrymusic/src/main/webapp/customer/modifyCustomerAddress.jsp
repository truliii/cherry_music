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
		response.sendRedirect(request.getContextPath()+"/id_list/login.jsp");
		System.out.println(KMJ + "modifyCustomer 로그인필요" + RESET);
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
	System.out.println(KMJ + request.getParameter("addNo") + " <--modifyCustomerAddress param addNo" + RESET);

	//요청값 유효성 검사: 요청값이 null인 경우 메인화면으로 리다이렉션
	if(request.getParameter("addNo") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	int addNo = Integer.parseInt(request.getParameter("addNo"));
	System.out.println(KMJ + addNo + " <--modifyCustomerAddress addNo" + RESET); 
	
	//주소정보 출력을 위한 dao생성
	//주소는 10개까지만 추가가 가능하고, 기본 주소는 삭제 불가
	AddressDao aDao = new AddressDao();
	Address address = aDao.selectAddressByOrderNo(addNo);
	String add = address.getAddress();
	//주소 4개로 나누기
	String[] addArr = add.split("-");
	String zip = addArr[0];
	String add1 = addArr[1];
	String add2 = addArr[3];
	String add3 = addArr[2];

%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Modify Customer Address</title>
	<jsp:include page="/inc/link.jsp"></jsp:include>
</head>
<body>
<!-- 메뉴 -->
<jsp:include page="/inc/menu.jsp"></jsp:include>
	<div id="all">
      <div id="content">
        <div class="container">
          <div class="row">
            <div class="col-lg-12">
              <!-- breadcrumb-->
              <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                  <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/customer/customerOne.jsp?id=<%=loginId%>">마이페이지</a></li>
                  <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/customer/customerOne.jsp?id=<%=loginId%>">프로필</a></li>
                  <li aria-current="page" class="breadcrumb-item active">주소목록</li>
                </ol>
              </nav>
            </div>
            <div class="col-lg-3">
              <!-- 고객메뉴 시작 -->
              <jsp:include page="/inc/customerSideMenu.jsp"></jsp:include>
            <!-- 고객메뉴 끝 -->
            </div>
            <div id="customer-orders" class="col-lg-9">
              <div class="box">
                <h1>주소수정</h1>
                <hr>
                <hr>
                <div>
                  <form action="<%=request.getContextPath()%>/customer/modifyCustomerAddressAction.jsp" method="post">
						<input type=hidden name="id" value="<%=loginId%>">
						<input type=hidden name="addNo" value="<%=addNo%>">
						
						<div class="row">
							<div class="col-3">
								<label for="add-name">주소이름</label>
								<input id="add-name" class="form-control" type="text" name="addName" value="<%=address.getAddressName()%>">
							</div>
							<div class="col-6">
								<label for="add">주소</label>
								<div id="add">
									<div>
										<input type="text" name="zip" id="sample6_postcode" placeholder="우편번호" class="form-control" value="<%=zip%>" required>
										<input type="text" name="add1" id="sample6_address" placeholder="주소" class="form-control" value="<%=add1%>" required>
										<input type="text" name="add2" id="sample6_detailAddress" placeholder="상세주소" class="form-control" value="<%=add2%>" required>
										<input type="text" name="add3" id="sample6_extraAddress" placeholder="참고항목" class="form-control" value="<%=add3%>">
										<input type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기" class="btn btn-sm btn-primary">
									</div>
								</div>
							</div>
							<div class="col-3">
								<label for="add-default">기본주소설정</label>
								<%
									if(address.getAddressDefault().equals("Y")){
								%>
										<input id="add-default" type="radio" name="addDefault" value="<%=address.getAddressDefault()%>" checked readonly>
								<%
									} else {
								%>
										<input id="add-default" class="form-check" type="radio" name="addDefault" value="<%=address.getAddressDefault()%>">
								<%
									}
								%>
							</div>
						</div>
						<hr>
						<div class="text-center">
							<button type="submit" class="btn btn-primary">
	                    	<i class="fa fa-save"></i>
							수정하기</button>
						</div>
					</form>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

	
	<!-- -----------------------------메인 끝----------------------------------------------- -->
<!-- copy -->
<jsp:include page="/inc/copy.jsp"></jsp:include>
<!-- 자바스크립트 -->
<jsp:include page="/inc/script.jsp"></jsp:include>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
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