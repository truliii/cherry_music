<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	//로그인 세션 유효성 검사: 로그인이 되어있지 않거나 로그인정보가 요청id와 다를 경우 리다이렉션
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(KMJ + request.getContextPath()+"/id_list/login.jsp" + RESET);
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
	System.out.println(KMJ + request.getParameter("newPw") + " <--modifyPasswordAction param newPw" + RESET);
	System.out.println(KMJ + request.getParameter("cnfmNewPw") + " <--modifyPasswordAction param cnfmNewPw" + RESET);
	
	//요청값 유효성 검사: 요청값이 null이거나 입력값이 공백이거나 새로운비밀번호와 확인비밀번호가 다른 경우 리다이렉션
	if(request.getParameter("newPw") == null 
		|| request.getParameter("cnfmNewPw") == null
		|| request.getParameter("newPw").equals("") 
		|| request.getParameter("cnfmNewPw").equals("")){
		response.sendRedirect(request.getContextPath()+"/modifyPassword.jsp");
		return;
	} else if(!request.getParameter("newPw").equals(request.getParameter("cnfmNewPw"))) {
		response.sendRedirect(request.getContextPath()+"/customer/modifyPassword.jsp");
		return;
	}
	String newPw = request.getParameter("newPw");
	String cnfmNewPw = request.getParameter("cnfmNewPw");
	System.out.println(KMJ + newPw + " <--modifyPasswordAction newPw" + RESET); 
	System.out.println(KMJ + cnfmNewPw + " <--modifyPasswordAction cnfmNewPw" + RESET); 
	
	//변수를 PwHistory타입으로 묶기
	PwHistory pwHistory = new PwHistory();
	pwHistory.setId(loginId);
	pwHistory.setPw(newPw);
		
	//새로운 비밀번호를 id_list와 pw_history테이블에 저장
	IdListDao iDao = new IdListDao();
	PwHistoryDao pDao = new PwHistoryDao();
	ArrayList<PwHistory> list = pDao.selectPwHistory(loginId);
	int pwHistoryCnt = pDao.selectPwHistoryCnt(loginId); //id로 저장된 pw이력의 수
	
	//바꿀 비밀번호가 최근 3개의 비밀번호와 비교
	boolean usedId = pDao.selectPwHistoryCompare(loginId, newPw);
	if(usedId == true){ //새로운 비밀번호가 이력에 존재하는 경우
		System.out.println(KMJ + "modifyPasswordAction 이미 사용된 비밀번호" + RESET);
		response.sendRedirect(request.getContextPath()+"/customer/modifyPassword.jsp?id="+loginId);
		return;
	}
	
	if(pwHistoryCnt < 3){ //비밀번호 이력이 3개 미만인 경우
		int historyRow = pDao.insertPwHistory(pwHistory); //pw_history 테이블에 추가
		int idListRow = iDao.updateIdlistLastPw(loginId, newPw); //id_list테이블에 추가
		System.out.println(KMJ + historyRow + " <--modifyPasswordAction historyRow 변경여부" + RESET);
		System.out.println(KMJ + idListRow + " <--modifyPasswordAction idListRow 변경여부" + RESET);
	} else {
		int dltHistoryRow = pDao.deletePwHistory(loginId); //가장 오래된 이력 삭제
		int historyRow = pDao.insertPwHistory(pwHistory);
		int idListRow = iDao.updateIdlistLastPw(loginId, newPw);
		System.out.println(KMJ + historyRow + " <--modifyPasswordAction historyRow 변경여부" + RESET);
		System.out.println(KMJ + idListRow + " <--modifyPasswordAction idListRow 변경여부" + RESET);
	}
	
	response.sendRedirect(request.getContextPath()+"/customer/customerOne.jsp?id="+loginId);

%>