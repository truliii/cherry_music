<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.IdList"%>
<%
	//RESET ANST CODE 콘솔창 글자색, 배경색 지정
	final String RESET = "\u001B[0m";
	final String BLUE ="\u001B[34m";
	final String BG_YELLOW ="\u001B[43m";

	// request 인코딩
	request.setCharacterEncoding("utf-8");
	
	/* session 유효성 검사
	* session 값이 null이면 페이지 redirection. 리턴
	*/
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;	
	}
	
	/* 요청값 유효성 검사
	* 값이 null, ""이면 customerInfoRemove.jsp 페이지로 리턴
	*/
	
	if(request.getParameter("id") == null
		|| request.getParameter("password") == null
		|| request.getParameter("id").equals("")
		|| request.getParameter("password").equals("")){
		response.sendRedirect(request.getContextPath()+"/id_list/customerInfoRemove.jsp");
		return;	
	}
	
	// 값 저장
	String id = request.getParameter("id");
	String password = request.getParameter("password");
	// 디버깅코드
	System.out.println(BG_YELLOW+BLUE+id +"<--customerInfoRemoveAction.jsp id"+RESET);
	System.out.println(BG_YELLOW+BLUE+password +"<--customerInfoRemoveAction.jsp password"+RESET);
	
	// vo.idList 값 저장
	IdList paramIdList = new IdList();
	paramIdList.setId(id);
	paramIdList.setLastPw(password);
	
	// Dao
	IdListDao idListDao = new IdListDao();
	CustomerDao customerDao = new CustomerDao();
	EmployeesDao employeesDao = new EmployeesDao();
	
	/* 회원정보 확인 method
	 * idListCheck == true, IdList active값 변경 Y -> N, 고객정보, 사원정보 삭제
	 * idListcheck == false, customerInfoRemove.jsp return
	*/
	boolean idListCheck = idListDao.selectIdList(paramIdList);
	
	if(idListCheck == true){
		// 회원 정보 조회(idLevel, active)
		IdList idList = idListDao.selectIdListOne(id);
		int idLevel = idList.getIdLevel();
		String active = idList.getActive();
		
		// IdList active값 변경
		int modifyActiveRow = idListDao.updateIdListActive(id);
	
		// modifyActiveRow값 확인
		if(modifyActiveRow == 0){
			System.out.println(BG_YELLOW+BLUE+modifyActiveRow +"<-- signUpAction.jsp updateIdListActive 실패 modifyActiveRow"+RESET);
		} else if(modifyActiveRow == 1){
			System.out.println(BG_YELLOW+BLUE+modifyActiveRow +"<-- signUpAction.jsp updateIdListActive 성공 modifyActiveRow"+RESET);
		} else{
			System.out.println(BG_YELLOW+BLUE+modifyActiveRow +"<-- error modifyActiveRow"+RESET);
		}
		
		// 고객정보 삭제
		int custmoerRemoveRow = customerDao.deleteCustomer(id);
		
		// custmoerRemoveRow값 확인
		if(custmoerRemoveRow == 0){
			System.out.println(BG_YELLOW+BLUE+custmoerRemoveRow +"<-- signUpAction.jsp deleteCustomer 실패 custmoerRemoveRow"+RESET);
		} else if(modifyActiveRow == 1){
			System.out.println(BG_YELLOW+BLUE+custmoerRemoveRow +"<-- signUpAction.jsp deleteCustomer 성공 custmoerRemoveRow"+RESET);
		} else{
			System.out.println(BG_YELLOW+BLUE+custmoerRemoveRow +"<-- error custmoerRemoveRow"+RESET);
		}
		
		// 사원정보 삭제
		if(idLevel != 0){ // 사원
			int employeesRemoveRow = employeesDao.deleteEmployee(id);
			
			// employeesRemoveRow값 확인
			if(employeesRemoveRow == 0){
				System.out.println(BG_YELLOW+BLUE+employeesRemoveRow +"<-- signUpAction.jsp deleteEmployee 실패 employeesRemoveRow"+RESET);
			} else if(modifyActiveRow == 1){
				System.out.println(BG_YELLOW+BLUE+employeesRemoveRow +"<-- signUpAction.jsp deleteEmployee 성공 employeesRemoveRow"+RESET);
			} else{
				System.out.println(BG_YELLOW+BLUE+employeesRemoveRow +"<-- error employeesRemoveRow"+RESET);
			}
		}
		
		System.out.println(BG_YELLOW+BLUE+idListCheck +"<-- customerInfoRemoveAction.jsp Id 정보 확인 idListCheck"+RESET);
		session.invalidate(); 
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		
	} else{
		response.sendRedirect(request.getContextPath()+"/id_list/customerInfoRemove.jsp");
		System.out.println(BG_YELLOW+BLUE+idListCheck + "회원탈퇴 실패 : Id 정보 없음 idListCheck" +RESET);
	}
	
%>