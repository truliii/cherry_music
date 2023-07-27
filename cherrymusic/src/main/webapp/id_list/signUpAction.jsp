<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*"%>
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
	
	/* 요청값 유효성 검사
	* 값이 null, ""이면 signUp.jsp 페이지로 리턴
	*/
	if(request.getParameter("id") == null
		|| request.getParameter("pw") == null
		|| request.getParameter("pwCheck") == null
		|| request.getParameter("cstmName") == null
		|| request.getParameter("cstmGender") == null
		|| request.getParameter("cstmBirth") == null
		|| request.getParameter("cstmPhone") == null
		|| request.getParameter("cstmEmail") == null
		|| request.getParameter("zip") == null
		|| request.getParameter("add1") == null
		|| request.getParameter("add2") == null
		|| request.getParameter("cstmAgree") == null
		|| request.getParameter("cstmAgree") == null
		|| request.getParameter("id").equals("")
		|| request.getParameter("pw").equals("")
		|| request.getParameter("pwCheck").equals("")
		|| request.getParameter("cstmName").equals("")
		|| request.getParameter("cstmGender").equals("")
		|| request.getParameter("cstmBirth").equals("")
		|| request.getParameter("cstmPhone").equals("")
		|| request.getParameter("cstmEmail").equals("")
		|| request.getParameter("zip").equals("")
		|| request.getParameter("add1").equals("")
		|| request.getParameter("add2").equals("")
		|| request.getParameter("cstmAgree").equals("")){
		
		response.sendRedirect(request.getContextPath()+"/id_list/signUp.jsp");
		return;	
	}

	// 요청값 저장
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	String cstmName = request.getParameter("cstmName");
	String cstmGender = request.getParameter("cstmGender");
	String cstmBirth = request.getParameter("cstmBirth");
	String cstmPhone = request.getParameter("cstmPhone");
	String cstmEmail = request.getParameter("cstmEmail");
	String cstmAgree = request.getParameter("cstmAgree");
	int cstmPoint = Integer.parseInt(request.getParameter("cstmPoint"));
	int cstmSumPrice = Integer.parseInt(request.getParameter("cstmSumPrice"));
	String addressDefault = request.getParameter("addressDefault");
	String addressName = request.getParameter("addressName");
	
	// zip, add1, add2, add3 합쳐서 주소 저장. 
	// add3은 null값이 올 수 있어 null 값이 아닌 경우에만 합쳐서 주소에 저장한다.
	String zip = request.getParameter("zip");
	String add1 = request.getParameter("add1");
	String add2 = request.getParameter("add2");
	String add3 = "*";
	
	if(request.getParameter("add3") != null
			&& !request.getParameter("add3").equals("")){
		add3 = request.getParameter("add3");
	}
	
	String[] addressArr = {zip, add1, add2, add3};
	String cstmAddress = String.join("-", addressArr);
	
	// 디버깅코드
	System.out.println(BG_YELLOW+BLUE+id +"<--signUpAction.jsp id"+RESET);
	System.out.println(BG_YELLOW+BLUE+pw +"<--signUpAction.jsp pw"+RESET);
	System.out.println(BG_YELLOW+BLUE+cstmName +"<--signUpAction.jsp cstmName"+RESET);
	System.out.println(BG_YELLOW+BLUE+cstmGender +"<--signUpAction.jsp cstmGender"+RESET);
	System.out.println(BG_YELLOW+BLUE+cstmBirth +"<--signUpAction.jsp cstmBirth"+RESET);
	System.out.println(BG_YELLOW+BLUE+cstmPhone +"<--signUpAction.jsp cstmPhone"+RESET);
	System.out.println(BG_YELLOW+BLUE+cstmEmail +"<--signUpAction.jsp cstmEmail"+RESET);
	System.out.println(BG_YELLOW+BLUE+cstmAddress +"<--signUpAction.jsp cstmAddress"+RESET);
	System.out.println(BG_YELLOW+BLUE+cstmAgree +"<--signUpAction.jsp cstmAgree"+RESET);
	System.out.println(BG_YELLOW+BLUE+cstmPoint +"<--signUpAction.jsp cstmPoint"+RESET);
	System.out.println(BG_YELLOW+BLUE+cstmSumPrice +"<--signUpAction.jsp cstmSumPrice"+RESET);
	System.out.println(BG_YELLOW+BLUE+addressDefault +"<--signUpAction.jsp addressDefault"+RESET);
	System.out.println(BG_YELLOW+BLUE+addressName +"<--signUpAction.jsp addressName"+RESET);
	
	/* id 중복검사
	 * 중복되는 id가 있으면 signUp.html redirection. return.
	*/
	// IdListDao selectIdListOne(id) Method
	IdListDao idListDao = new IdListDao();
	IdList duplicateId = idListDao.selectIdListOne(id);
	
	if(duplicateId != null){
		if(duplicateId.getId().equals(id)){
			response.sendRedirect(request.getContextPath() + "/id_list/signUp.jsp");
			System.out.println("중복되는 ID");
			return;
		}
	}
	
	/* password값 일치 확인
	 * pw, pwCheck 값이 일치 하지 않으면 signUp.html redirection. return.
	*/
	if(!request.getParameter("pw").equals(request.getParameter("pwCheck"))){
		response.sendRedirect(request.getContextPath() + "/id_list/signUp.jsp");
		System.out.println("Password 불일치");
		return;
	}
	
	// vo.IdList 값 저장
	IdList idList = new IdList();
	idList.setId(id);
	idList.setLastPw(pw);
			
	/* idListRow : idListDao.insertIdList(idList) 리턴값 저장 변수
	 * customerRow : customerDao.insertCustomer(customer) 리턴값 저장 변수
	 * pwHistoryRow : pwHistoryDao.insertPwHistory(pwHistory) 리턴값 저장 변수
	 * addressRow : addressDao.insertAddress(address) 리턴값 저장 변수
	 
	 * idListRow 값에 따른 redirection
	 * idListRow == 0, signUp.html redirection. return.
			 
	 * idListRow == 1,
	 * login.html redirection. 
	 * vo.Customer, vo.PwHistory, vo.Address에 각 Dao Method 호출하여 값 저장. 
	*/
	
	// IdListDao insertIdList(idList) Method
	int idListRow = idListDao.insertIdList(idList);
	
	if(idListRow == 0){
		System.out.println(BG_YELLOW+BLUE+idListRow +"<-- signUpAction.jsp insertIdList 실패 idListRow"+RESET);
		response.sendRedirect(request.getContextPath()+"/id_list/signUp.jsp");
		return;	
		
	} else if(idListRow == 1){
		System.out.println(BG_YELLOW+BLUE+idListRow +"<-- signUpAction.jsp insertIdList 성공 idListRow"+RESET);
		response.sendRedirect(request.getContextPath()+"/id_list/login.jsp");
		
		// vo.Customer 값 저장
		Customer customer = new Customer();
		customer.setId(id);
		customer.setCstmName(cstmName);
		customer.setCstmGender(cstmGender);
		customer.setCstmBirth(cstmBirth);
		customer.setCstmPhone(cstmPhone);
		customer.setCstmEmail(cstmEmail);
		customer.setCstmAddress(cstmAddress);
		customer.setCstmAgree(cstmAgree);
		customer.setCstmPoint(cstmPoint);
		customer.setCstmSumPrice(cstmSumPrice);
		
		// CustomerDao insertCustomer(customer) Method
		CustomerDao customerDao = new CustomerDao();
		int customerRow = customerDao.insertCustomer(customer);
		
		if(customerRow == 0){
			System.out.println(BG_YELLOW+BLUE+customerRow +"<-- signUpAction.jsp insertCustomer 실패 customerRow"+RESET);
		} else if(idListRow == 1){
			System.out.println(BG_YELLOW+BLUE+customerRow +"<-- signUpAction.jsp insertCustomer 성공 customerRow"+RESET);
		} else{
			System.out.println(BG_YELLOW+BLUE+customerRow +"<-- error customerRow"+RESET);
		}
		
		// vo.PwHistory 값 저장
		PwHistory pwHistory = new PwHistory();
		pwHistory.setId(id);
		pwHistory.setPw(pw);
		
		// PwHistoryDao insertEmployee Method
		PwHistoryDao pwHistoryDao = new PwHistoryDao();
		int pwHistoryRow = pwHistoryDao.insertPwHistory(pwHistory);
		if(pwHistoryRow == 0){
			System.out.println(BG_YELLOW+BLUE+pwHistoryRow +"<-- signUpAction.jsp insertPwHistory 실패 pwHistoryRow"+RESET);
		} else if(pwHistoryRow == 1){
			System.out.println(BG_YELLOW+BLUE+pwHistoryRow +"<-- signUpAction.jsp insertPwHistory 성공 pwHistoryRow"+RESET);
		} else{
			System.out.println(BG_YELLOW+BLUE+pwHistoryRow +"<-- error pwHistoryRow"+RESET);
		}
		
		// vo.Address 값 저장
		Address address = new Address();
		address.setId(id);
		address.setAddressName(addressName);
		address.setAddress(cstmAddress);
		address.setAddressDefault(addressDefault);
		
		// AddressDao
		AddressDao addressDao = new AddressDao();
		int addressRow = addressDao.insertAddress(address);
		if(addressRow == 0){
			System.out.println(BG_YELLOW+BLUE+pwHistoryRow +"<-- signUpAction.jsp insertAddress 실패 addressRow"+RESET);
		} else if(addressRow == 1){
			System.out.println(BG_YELLOW+BLUE+pwHistoryRow +"<-- signUpAction.jsp insertAddress 성공 addressRow"+RESET);
		} else{
			System.out.println(BG_YELLOW+BLUE+pwHistoryRow +"<-- error addressRow"+RESET);
		}
		
	} else{
		System.out.println(BG_YELLOW+BLUE+idListRow +"<-- error idListRow"+RESET);
	}

%>