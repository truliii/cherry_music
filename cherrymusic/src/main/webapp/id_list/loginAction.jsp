<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*"%>
<%
	//RESET ANST CODE 콘솔창 글자색, 배경색 지정
	final String RESET = "\u001B[0m";
	final String BLUE ="\u001B[34m";
	final String BG_YELLOW ="\u001B[43m";
	
	// request 인코딩
	request.setCharacterEncoding("utf-8");

	/* session 유효성 검사
	* session 값이 null이 아니면 페이지 redirection. 리턴
	*/
	if(session.getAttribute("loginId") != null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;	
	}

	/* 요청값 유효성 검사(id, pw)
	* 값이 null, ""이면 login.jsp 페이지로 리턴
	*/
	if(request.getParameter("id") == null
		|| request.getParameter("pw") == null
		|| request.getParameter("id").equals("")
		|| request.getParameter("pw").equals("")){
		response.sendRedirect(request.getContextPath()+"/id_list/login.jsp");
		return;
	}
	// 값 저장
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	System.out.println(BG_YELLOW+BLUE+id + "<-- loginAction.jsp id" +RESET);
	System.out.println(BG_YELLOW+BLUE+pw + "<-- loginAction.jsp pw" +RESET);
	
	// vo.IdList 객체 생성하여 값 저장
	IdList paramIdList = new IdList();
	paramIdList.setId(id);
	paramIdList.setLastPw(pw);
	
	// IdListDao
	IdListDao idListDao = new IdListDao();
	
	/* loginCheck : idListDao.selectIdList(paramIdList) 리턴값 저장 변수
	* idListCheck : idListDao.selectIdListOne(id) 리턴값 저장 변수
	* loginCheck 값에 따른 redirection, session.setAttribute 유무 분기
	* loginCheck == true 일 때 idListCheck.getActive()값에 따른 redirection 분기
	* 로그인 후 마지막 로그인 날짜 update
	*/ 
	
	boolean loginCheck = idListDao.selectIdList(paramIdList);
	System.out.println(BG_YELLOW+BLUE+loginCheck +"<-- loginAction.jsp loginCheck" +RESET);
	
	if(loginCheck == true){
		IdList idListCheck = idListDao.selectIdListOne(id);
		
		if(idListCheck.getActive().equals("Y")){
			session.setAttribute("loginId", id);
			response.sendRedirect(request.getContextPath()+"/home.jsp");
			System.out.println(BG_YELLOW+BLUE+id+" 로그인 성공, 세션 정보 :" +session.getAttribute("loginId") +RESET);
			
			// CustomerDao
			CustomerDao customerDao = new CustomerDao();
			int row = customerDao.updateLastLogin(id);
			if(row == 0){
				System.out.println(BG_YELLOW+BLUE+row + "<--loginAction.jsp updateLastLogin 실패 row" +RESET);
			} else if(row == 1){
				System.out.println(BG_YELLOW+BLUE+row + "<--loginAction.jsp updateLastLogin 성공 row" +RESET);
			} else {
				System.out.println(BG_YELLOW+BLUE+row +"loginAction.jsp error row" +RESET);
			}
			
		} else {
			response.sendRedirect(request.getContextPath()+"/id_list/login.jsp");
			System.out.println(BG_YELLOW+BLUE+id + "로그인 실패 : Id Active N" +RESET);
		} 	
	} else {
		response.sendRedirect(request.getContextPath()+"/id_list/login.jsp");
		System.out.println(BG_YELLOW+BLUE+id + "로그인 실패 : Id 정보 없음" +RESET);
	}	
	
%>