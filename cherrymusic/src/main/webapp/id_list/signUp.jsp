<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	/* session 유효성 검사
	* session 값이 null이 아니면 페이지 redirection. 리턴
	*/
	if(session.getAttribute("loginId") != null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;	
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
            <div class="jumbotron jumbotron-bg text-center rounded-0" style="background-color: #191919;">
                <div class="container">
                    <h1 class="pt-5">
                        회원가입
                    </h1>
                    <p class="lead">
                        Good music for Good moment!
                    </p>

                    <div class="card card-login mb-5" style="width: 500px">
                        <div class="card-body">
                            <form id="signUpForm">
                                <div class="form-group row mt-3">
                                    <div class="col-md-12 text-left">
                                    	<label for="id">아이디</label>
                                    </div>
                                    <div class="col-md-10">
                                        <input id="id" name="id" type="text" placeholder="아이디" class="form-control">
                                    </div>
                                    <div>
										<button id="idCheck" type="button" class="btn btn-primary">중복확인</button>
									</div>
                                </div>
                                <div class="form-group row mt-3">
                                	<div class="col-md-12 text-left">
                                       <label for="password">비밀번호</label>
                                    </div>
                                    <div class="col-md-12">
                                       <input id="password" name="pw" type="password" placeholder="비밀번호" class="form-control">
                                    </div>
                                </div>
                                <div class="form-group row mt-3">
                                	<div class="col-md-12 text-left">
                                       <label for="pwCheck">비밀번호 확인</label>
                                    </div>
                                    <div class="col-md-12">
                                        <input id="pwCheck" name="pwCheck" type="password" placeholder="비밀번호 확인" class="form-control">
                                    </div>
                                    <div class="form-group col-lg-6">
										<span id="passwordMatchMessage"></span>
									</div>
                                </div>
                                <div class="form-group row mt-3">
                                	<div class="col-md-12 text-left">
                                		<label for="cstmName">성명</label>
                                	</div>
                                    <div class="col-md-12">
                                        <input id="cstmName" name="cstmName"type="text" placeholder="성명" class="form-control">
                                    </div>
                                </div>
                                <div class="form-group row mt-3">
                                	<div class="col-md-12 text-left">
                                		<label for="cstmGender">성별</label>
                                	</div>
                                    <div class="col-md-12 text-left">
                                        <input type="radio" name="cstmGender" value="M"> 남
										<input type="radio" name="cstmGender" value="F"> 여
                                    </div>
                                </div>
                                <div class="form-group row mt-3">
                                	<div class="col-md-12 text-left">
                                		<label for="cstmBirth">생년월일</label>
                                	</div>
                                    <div class="col-md-12">
                                        <input id="cstmBirth" name="cstmBirth" type="date" class="form-control">
                                    </div>
                                </div>
                                <div class="form-group row mt-3">
                                	<div class="col-md-12 text-left">
                                		<label for="cstmPhone">연락처</label>
                                	</div>
                                    <div class="col-md-12">
                                    	<input id="cstmPhone" name="cstmPhone" type="tel" pattern="[0-9]{3}-[0-9]{3,4}-[0-9]{4}" placeholder="000-0000-0000" class="form-control">
                                    </div>	
                                   	<div>
                                   		<span id="phoneMessage"></span>
                                   	</div>
								</div>
                                <div class="form-group row mt-3">
                                	<div class="col-md-12 text-left">
                                		<label for="cstmEmail">E-mail</label>
                                	</div>
                                    <div class="col-md-12">
                                        <input id="cstmEmail" name="cstmEmail" type="email" placeholder="example@example.com" class="form-control">
                                    </div>
									<div>
										<span id="emailMessage"></span>
									</div>
                                </div>
                                <div class="form-group row mt-3">
                                	<div class="col-md-12 text-left">
                                		<label>주소</label>
                                	</div>
                                	<div class="form-group col-md-3">
                                		<input type="text" name="zip" id="sample6_postcode" placeholder="우편번호" class="form-control">
                                	</div>
                                    <div class="form-group col-md-12">
										<input type="text" name="add1" id="sample6_address" placeholder="주소" class="form-control">
										<input type="text" name="add2" id="sample6_detailAddress" placeholder="상세주소" class="form-control">
										<input type="text" name="add3" id="sample6_extraAddress" placeholder="참고항목" class="form-control">
									</div>
                                </div>
                                <div class="form-group row mt-3">
                                    <div class="col-md-12 text-left">
                                        <label for="cstmAgree">약관동의</label>
										<textarea rows="5" cols="" class="form-control" readonly="readonly"></textarea>
                                    </div>
                                    <div class="col-md-12 text-right">
										<input type="radio" name="cstmAgree" value ="Y"> 동의
										<input type="radio" name="cstmAgree" value ="N"> 비동의
									</div>
                                </div>
                                <div class="form-group row mt-3">
                                    <div class="col-md-12 text-center">
                                        <button id="signUpBtn" type="button" class="btn btn-primary">회원가입</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
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
		
		// 회원가입
		
	   	// 회원가입 버튼 상태 초기화
	  	$('#signUpBtn').prop('disabled', true);
		
	 	// 입력 필드 값 변경 감지
	    $('input, textarea').on('input', function() {
	      checkFormValidity();
	    });
	 	
	 	// 약관 동의 라디오 버튼 변경 이벤트
	    $('input[name="cstmAgree"]').on('change', function() {
	      checkFormValidity();
	    });
	 	
	 	// 회원가입 버튼 활성화 여부 확인 함수
	    function checkFormValidity() {
	     	// 값 저장
	    	let cstmAgree = $('input[name="cstmAgree"]:checked').val();
	 
	    	// 약관동의 검사
	        if (cstmAgree === 'Y') {
	          $('#signUpBtn').prop('disabled', false);
	        } else {
	          $('#signUpBtn').prop('disabled', true);
	        }
	      }
	 	
	 	// 아이디 중복검사
		$('#idCheck').click(function(){
		if($('#id').val() == '') {
			alert('중복검사할 아이디를 입력하세요');
		} else {
			$.ajax({
				url:'<%=request.getContextPath()%>/id_list/checkMemberId.jsp',
				data: {idCheck : $('#id').val()},
				dataType: 'json',
				success : function(param){
					console.log(param);
					if(param === true) {
						alert('이미 사용중인 아이디 입니다');
						$('#id').val('');
						$('#id').focus();
					} else {
						alert('사용가능한 아이디 입니다');
						$('#idCheck').prop('disabled', true);
					}
				},
				error : function(err) {
					alert('err');
					console.log(err);
					}
				});
			}
		});
	 	
	 	// 비밀번호, 비밀번호 확인 일치확인
	 	$('#pwCheck').on('keyup', function() {
		    let password = $('#password').val();
		    let pwCheck = $(this).val();
		    let message = $('#passwordMatchMessage');
		
		    if (password === pwCheck) {
		      message.text('비밀번호 일치');
		    } else {
		      message.text('비밀번호 불일치');
		    }
		  });
	 	
	 	// cstmPhone 유효성 검사
	 	$('#cstmPhone').on('input', function() {
			let phone = $(this).val(); 
			let pattern = new RegExp($(this).attr('pattern'));
	         if (!pattern.test(phone)) {
	             $('#phoneMessage').text('유효한 연락처를 입력해주세요');
	         } else {
	             $('#phoneMessage').text('유효한 연락처 입니다');
	         }
	     });
	 	
	 	// cstmEmail 유효성 검사
		$('#cstmEmail').on('input', function() {
			let email = $(this).val(); 
			let pattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
	         if (pattern.test(email)) {
	             $('#emailMessage').text('유효한 이메일 주소입니다.');
	         } else {
	             $('#emailMessage').text('유효하지 않은 이메일 주소입니다.');
	         }
	     });
	 	
		// 생년월일 유효성 검사 함수
		function validateBirth() {
		    let selectedBirth = $('#cstmBirth').val();
		    let today = new Date();
		    let selectedDate = new Date(selectedBirth);
	
		    if (selectedDate > today) {
		        return false;
		    } else {
		        return true;
		    }
		}
	
		// 생년월일 입력란 변화 감지 이벤트 처리
		$('#cstmBirth').on('input', function() {
		    if (!validateBirth()) {
		        alert('유효한 생년월일을 입력해주세요.');
		        $(this).focus();
		    }
		});
	 	
	 	// 회원가입 버튼 클릭
	 	$('#signUpBtn').on('click', function() {
	 		// 값 저장
	 		let id = $('#id').val();
	 	   	let pw = $('#password').val();
	 	   	let pwCheck = $('#pwCheck').val();
	 	   	let cstmName = $('#cstmName').val();
	 	   	let cstmBirth = $('#cstmBirth').val();
	 	   	let cstmPhone = $('#cstmPhone').val();
	 	   	let cstmEmail = $('#cstmEmail').val();
	 	   	let zip = $('#sample6_postcode').val();
	 	   	let add1 = $('#sample6_address').val();
	 	   	let add2 = $('#sample6_detailAddress').val();
	 	   	let gender = $('input[name="cstmGender"]:checked').val();
	 	   	
			// 값 유효성 검사
			if(id.trim() == ''){ // id 공백검사
				alert('아이디를 입력해주세요');
				$('#id').focus();
				return false;
			} else if(pw.trim() == ''){ // pw 공백검사
				alert('비밀번호를 입력해주세요');
				$('#password').focus();
				return false;
			} else if(pwCheck.trim() == ''){ // pwCheck 공백검사
				alert('비밀번호 확인을 입력해주세요');
				$('#pwCheck').focus();
				return false;
			} else if(pw != pwCheck){ // pw, pwCheck 일치 검사
				alert('비밀번호가 일치하지 않습니다');
				$('#pwCheck').focus();
				return false;
			} else if(cstmName.trim() == ''){ // cstmName 공백검사
				alert('성명을 입력해주세요');
				$('#cstmName').focus();
				return false;
			} else if (gender == undefined) { // gender 공백검사
		    	alert('성별을 선택해주세요.');
		    	$('input[name="cstmGender"]').focus();
		    	return false;
		  	} else if(cstmBirth.trim() == ''){ // cstmBirth 공백검사
				alert('생년월일을 입력해주세요');
				$('#cstmBirth').focus();
				return false;
			} else if (!validateBirth()) { // cstmBirth 유효성 검사
		        alert('유효한 생년월일을 입력해주세요.');
		        $('#cstmBirth').focus();
		        return false;
		    } else if(cstmPhone.trim() == ''){ // cstmPhone 공백검사
				alert('연락처를 입력해주세요');
				$('#cstmPhone').focus();
				return false;
			} else if(cstmEmail.trim() == ''){ // cstmEmail 공백검사
				alert('E-mail을 입력해주세요');
				$('#cstmEmail').focus();
				return false;
			} else if(zip.trim() == ''){ // zip 공백검사
				alert('우편번호를 입력해주세요');
				$('#sample6_postcode').focus();
				return false;
			} else if(add1.trim() == ''){ // add1 공백검사
				alert('주소를 입력해주세요');
				$('#sample6_address').focus();
				return false;
			} else if(add2.trim() == ''){ // add2 공백검사
				alert('상세주소를 입력해주세요');
				$('#sample6_detailAddress').focus();
				return false;
			}
	 	   	
	 	   	// cstmPhone 유효성 검사
	 	   	let phonePattern= /^(\d{3}-\d{3,4}-\d{4})?$/;
	 	   	if(!phonePattern.test(cstmPhone)){
		 	   	alert('유효한 연락처를 입력해주세요.');
		        $('#cstmPhone').focus();
		        return false;
	 	   	}
	 	   	
			// cstmEmail 유효성 검사
		    let emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
		    if (!emailPattern.test(cstmEmail)) {
		        alert('유효한 이메일 주소를 입력해주세요.');
		        $('#cstmEmail').focus();
		        return false;
		    }
		    
		 	// id 중복검사 수행 확인
	     	if($('#idCheck').prop('disabled', false)){
	     		alert('아이디 중복검사');
	     		$('#idCheck').focus();
	     		return false;
	     	}
		 
		    // 값 유효성 검사 후 signUpAction.jsp 이동
		    let signUpActionUrl = '<%=request.getContextPath()%>/id_list/signUpAction.jsp';
			$('#signUpForm').attr('action', signUpActionUrl);
		    $('#signUpForm').submit();
		    
		});
		
	</script>
</body>
</html>