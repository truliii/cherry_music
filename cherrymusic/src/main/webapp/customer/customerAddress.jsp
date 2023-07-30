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
		System.out.println(KMJ + "customerAddress 로그인필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	}
	
	//주소목록 번호
	int num = 0;
	
	//주소정보 출력
	//주소는 10개까지만 추가가 가능하고, 기본 주소는 삭제 불가
	AddressDao aDao = new AddressDao();
	ArrayList<Address> addList = aDao.selectAddressList(loginId);
	
	//현재 id의 주소개수 저장
	int addCnt = aDao.selectAddressCnt(loginId);
	
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
                        나의 주소목록
                    </h1>
                    <p class="lead">
                    </p>
                </div>
            </div>
        </div>

        <section id="cart">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-md-9">
                        <div class="table-responsive">
                            <table class="table">
                                <thead class="text-center">
                                    <tr>
                                        <th width="5%"></th>
                                        <th>주소명</th>
                                        <th></th>
                                        <th>주소</th>
                                        <th></th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
										for(Address a : addList){
											num += 1;
									%>
											<tr>
												<td><%=num%></td>
												<!-- 주소명 -->
												<td>
													<strong class="mr-1"><%=a.getAddressName()%></strong>
									<%
												if(a.getAddressDefault().equals("Y")){
									%>
													<span class="badge badge-primary">기본주소</span>
									<%
												} else {
									%>
													&nbsp;
									<%
												}
									%>
												</td>
												<td></td>
												<!-- 주소 -->
												<td><%=a.getAddress()%></td>
												<!-- 수정 -->
												<td><a class="btn btn-sm btn-primary" href="<%=request.getContextPath()%>/customer/modifyCustomerAddress.jsp?addNo=<%=a.getAddressNo()%>">수정</a></td>
												<!-- 삭제 -->
									<%
												if(a.getAddressDefault().equals("N")){ //기본주소가 아닌 경우에만 삭제 가능
									%>
													<td>
														<a class="btn btn-sm btn-primary" href="<%=request.getContextPath()%>/customer/removeCustomerAddressAction.jsp?addNo=<%=a.getAddressNo()%>">삭제</a>
													</td>
									<%
												} else {
									%>
													<td>&nbsp;</td>
									<%
												}
										}
									%>
											</tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="row">
                        	<div class="col-12 text-center mt-3">
	                           	<a href="<%=request.getContextPath()%>/customer/addCustomerAddress.jsp" class="btn btn-primary">주소추가</a>
	                           	<div class="clearfix"></div>
                        	</div>
                    	</div>
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