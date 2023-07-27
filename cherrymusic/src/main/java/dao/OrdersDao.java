package dao;

import java.util.*;
import java.sql.*;
import vo.*;
import util.*;

public class OrdersDao {
	
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
		
	//조회: (검색) 기간별, 결제상태별, 배송상태별, 상품별 (정렬) 생성일, 주문번호
	/*
	 SQL 검색분기
	 1. 검색조건이 모두 null인 경우 
	 2. 검색조건 1개가 null인 경우 
	 3. 검색조건이 모두 null이 아닌 경우 
	 */
	public ArrayList<HashMap<String, Object>> selectOrdersListBySearch(String[] payStat, String[] delStat, int beginRow, int rowPerPage) throws Exception {
		//DB접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "";
		PreparedStatement stmt = null;
		//PreparedStatement
		if(payStat == null && delStat == null) { //검색조건이 모두 null인 경우
			sql = "SELECT o.order_no orderNo, o.id, p.category_name categoryName, o.product_no productNo, p.product_name productName, o.order_cnt orderCnt, o.order_price orderPrice, o.payment_status paymentStatus, "
					+ "o.delivery_status deliveryStatus, o.createdate createdate, o.updatedate updatedate "
					+ "FROM orders o INNER JOIN product p "
					+ "ON o.product_no = p.product_no "
					+ "ORDER BY createdate DESC "
					+ "LIMIT ?, ?";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, beginRow);
			stmt.setInt(2, rowPerPage);
			
		} else if (delStat == null){ //payStat만 선택된 경우
			sql = "SELECT o.order_no orderNo, o.id, p.category_name categoryName, o.product_no productNo, p.product_name productName, o.order_cnt orderCnt, o.order_price orderPrice, o.payment_status paymentStatus, "
					+ "o.delivery_status deliveryStatus, o.createdate, o.updatedate "
					+ "FROM orders o INNER JOIN product p "
					+ "ON o.product_no = p.product_no "
					+ "WHERE o.payment_status IN(? ";
					for(int i=1; i<payStat.length; i++) { //payStat선택된 만큼 ?추가
						sql += ", ?";
					}
					sql += ") ORDER BY createdate DESC LIMIT ?, ?";
					stmt = conn.prepareStatement(sql);
					for(int i=0; i<payStat.length; i++) {
						stmt.setString(i+1, payStat[i]);
					}
					stmt.setInt(payStat.length + 1, beginRow);
					stmt.setInt(payStat.length + 2, rowPerPage);
		} else if (payStat == null) { //delStat만 선택된 경우
			sql = "SELECT o.order_no orderNo, o.id, p.category_name categoryName, o.product_no productNo, p.product_name productName, o.order_cnt orderCnt, o.order_price orderPrice, o.payment_status paymentStatus, "
					+ "o.delivery_status deliveryStatus, o.createdate, o.updatedate "
					+ "FROM orders o INNER JOIN product p "
					+ "ON o.product_no = p.product_no "
					+ "WHERE o.delivery_status IN(?";
					for(int i=1; i<delStat.length; i++) { //payStat선택된 만큼 ?추가
						sql += ", ?";
					}
					sql += ") ORDER BY createdate DESC LIMIT ?, ?";
					stmt = conn.prepareStatement(sql);
					for(int i=0; i<delStat.length; i++) {
						stmt.setString(i+1, delStat[i]);
					}
					stmt.setInt(delStat.length + 1, beginRow);
					stmt.setInt(delStat.length + 2, rowPerPage);
		} else { //검색조건이 모두 선택된 경우
			sql = "SELECT o.order_no orderNo, o.id, p.category_name categoryName, o.product_no productNo, p.product_name productName, o.order_cnt orderCnt, o.order_price orderPrice, o.payment_status paymentStatus, "
					+ "o.delivery_status deliveryStatus, o.createdate, o.updatedate "
					+ "FROM orders o INNER JOIN product p "
					+ "ON o.product_no = p.product_no "
					+ "WHERE o.payment_status IN(?";
					for(int i=1; i<payStat.length; i++) { //payStat선택된 만큼 ?추가
						sql += ", ?";
					}
					sql += ") AND o.delivery_status IN(?"; 
					for(int i=1; i<delStat.length; i++) { //delStat선택된 만큼 ?추가
						sql += ", ?";
					}
					sql += ") ORDER BY createdate DESC LIMIT ?, ?";
					stmt = conn.prepareStatement(sql);
					for(int i=0; i<payStat.length; i++) {
						stmt.setString(i+1, payStat[i]);
					}
					for(int j=0; j<delStat.length; j++) {
						stmt.setString((payStat.length+1)+j, delStat[j]);
					}
					stmt.setInt(payStat.length + delStat.length + 1, beginRow);
					stmt.setInt(payStat.length + delStat.length + 2, rowPerPage);
		}
		System.out.println(KMJ + stmt + " <--OrdersDao selectOrdersListBySearch stmt" + RESET);
		ResultSet rs = stmt.executeQuery();
		
		//리턴타입인 ArrayList<HashMap<String, Object>>에 저장한다
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("orderNo", rs.getInt("orderNo"));
			m.put("id", rs.getString("id"));
			m.put("categoryName",rs.getString("categoryName"));
			m.put("productNo", rs.getInt("productNo"));
			m.put("productName", rs.getString("productName"));
			m.put("orderCnt", rs.getInt("orderCnt"));
			m.put("orderPrice", rs.getInt("orderPrice"));
			m.put("paymentStatus", rs.getString("paymentStatus"));
			m.put("deliveryStatus", rs.getString("deliveryStatus"));
			m.put("createdate", rs.getString("createdate"));
			m.put("updatedate", rs.getString("updatedate"));
			list.add(m);
		}
		return list;
	}
	
	//조회: 데이터 행의 수
	public int selectOrdersListCnt(String[] payStat, String[] delStat) throws Exception {
		int row = 0;
		
		//DB접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "";
		PreparedStatement stmt = null;
		//PreparedStatement
		if(payStat == null && delStat == null) { //검색조건이 모두 null인 경우
			sql = "SELECT COUNT(*) cnt FROM orders";
			stmt = conn.prepareStatement(sql);
			
		} else if (delStat == null){ //payStat만 선택된 경우
			sql = "SELECT COUNT(*) cnt FROM orders WHERE payment_status IN(? ";
					for(int i=1; i<payStat.length; i++) { //payStat선택된 만큼 ?추가
						sql += ", ?";
					}
					sql += ")";
					stmt = conn.prepareStatement(sql);
					for(int i=0; i<payStat.length; i++) {
						stmt.setString(i+1, payStat[i]);
					}
		} else if (payStat == null) { //delStat만 선택된 경우
			sql = "SELECT COUNT(*) cnt FROM orders WHERE delivery_status IN(?";
					for(int i=1; i<delStat.length; i++) { //payStat선택된 만큼 ?추가
						sql += ", ?";
					}
					sql += ")";
					stmt = conn.prepareStatement(sql);
					for(int i=0; i<delStat.length; i++) {
						stmt.setString(i+1, delStat[i]);
					}
		} else { //검색조건이 모두 선택된 경우
			sql = "SELECT COUNT(*) cnt FROM orders WHERE payment_status IN(?";
					for(int i=1; i<payStat.length; i++) { //payStat선택된 만큼 ?추가
						sql += ", ?";
					}
					sql += ") AND delivery_status IN(?"; 
					for(int i=1; i<delStat.length; i++) { //delStat선택된 만큼 ?추가
						sql += ", ?";
					}
					sql += ")";
					stmt = conn.prepareStatement(sql);
					for(int i=0; i<payStat.length; i++) {
						stmt.setString(i+1, payStat[i]);
					}
					for(int j=0; j<delStat.length; j++) {
						stmt.setString((payStat.length+1)+j, delStat[j]);
					}
		}
		System.out.println(KMJ + stmt + " <--OrdersDao selectOrdersListCnt stmt" + RESET);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			row = rs.getInt("cnt");
		}
		return row;
	}
	
	//조회: 주문번호별 주문상태 출력
	public Orders selectOrderOne(int orderNo) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement 
		String sql = "SELECT order_no orderNo, product_no productNo, id, payment_status paymentStatus, delivery_status deliveryStatus, order_cnt orderCnt, "
						+"order_price orderPrice, createdate, updatedate FROM orders WHERE order_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, orderNo);
		System.out.println(KMJ + stmt + " <--OrderDao selectOrderOne" + RESET);
		ResultSet rs = stmt.executeQuery();
		Orders order = null;
		if(rs.next()) {
			order = new Orders();
			order.setOrderNo(rs.getInt("orderNo"));
			order.setProductNo(rs.getInt("productNo"));
			order.setId(rs.getString("id"));
			order.setPaymentStatus(rs.getString("paymentStatus"));
			order.setDeliveryStatus(rs.getString("deliveryStatus"));
			order.setOrderCnt(rs.getInt("orderCnt"));
			order.setOrderPrice(rs.getInt("orderPrice"));
			order.setCreatedate(rs.getString("createdate"));
			order.setUpdatedate(rs.getString("updatedate"));
		}
		return order;
	}
	
	//조회: id별 주문목록
	public ArrayList<HashMap<String, Object>> selectOrderById(String id, int beginRow, int rowPerPage) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement 
		String sql = "SELECT orderNo, productNo, productName, id, paymentStatus, deliveryStatus, orderCnt, orderPrice, t1.createdate, "
				+ "t2.product_ori_filename orgFilename, t2.product_save_filename saveFilename, t2.product_filetype filetype "
				+ "FROM (SELECT o.order_no orderNo, o.product_no productNo, p.product_name productName, o.id id, o.payment_status paymentStatus, "
				+ "o.delivery_status deliveryStatus, o.order_cnt orderCnt, o.order_price orderPrice, "
				+ "o.createdate "
				+ "FROM orders o INNER join product p "
				+ "ON o.product_no = p.product_no "
				+ "WHERE o.id = ?) t1 LEFT OUTER JOIN product_img t2 "
				+ "ON t1.productNo = t2.product_no ORDER BY createdate DESC LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, id);
		stmt.setInt(2, beginRow);
		stmt.setInt(3, rowPerPage);
		System.out.println(KMJ + stmt + " <--OrderDao selectOrderById" + RESET);
		ResultSet rs = stmt.executeQuery();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("orderNo", rs.getInt("orderNo"));
			m.put("productNo", rs.getInt("productNo"));
			m.put("productName", rs.getString("productName"));
			m.put("id", rs.getString("id"));
			m.put("paymentStatus", rs.getString("paymentStatus"));
			m.put("deliveryStatus", rs.getString("deliveryStatus"));
			m.put("orderCnt", rs.getInt("orderCnt"));
			m.put("orderPrice", rs.getInt("orderPrice"));
			m.put("createdate", rs.getString("createdate"));
			m.put("orgFileName", rs.getString("orgFilename"));
			m.put("saveFileName", rs.getString("saveFilename"));
			m.put("filetype", rs.getString("filetype"));
			list.add(m);
		}
		return list;
	}
	
	//조회: id별 주문목록의 수
	public int selectOrderCntById(String id) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement 
		String sql = "SELECT COUNT(*) "
				+ "FROM (SELECT o.order_no orderNo, o.product_no productNo, p.product_name productName, o.id id, o.payment_status paymentStatus, "
				+ "o.delivery_status deliveryStatus, o.order_cnt orderCnt, o.order_price orderPrice, "
				+ "o.createdate "
				+ "FROM orders o INNER join product p "
				+ "ON o.product_no = p.product_no "
				+ "WHERE o.id = ?) t1 LEFT OUTER JOIN product_img t2 "
				+ "ON t1.productNo = t2.product_no "
				+ "ORDER BY t1.createdate DESC";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, id);
		System.out.println(KMJ + stmt + " <--OrderDao selectOrderById" + RESET);
		ResultSet rs = stmt.executeQuery();
		int row = 0;
		if(rs.next()) {
			row = rs.getInt(1);
		}
		return row;
	}
	
	//삽입: 주문버튼 클릭시 주문번호 생성 후 주문번호 리턴
	public int insertOrder(Orders order) throws Exception {
		//매개변수 유효성 검사
		if(order == null) {
			System.out.println(KMJ + order + "<-- OrdersDao insertOrder param");
			return 0;
		}
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement 
		String sql = "INSERT INTO orders (product_no, id, payment_status, delivery_status, order_cnt, order_price, createdate, updatedate) "
				+ "VALUES (?, ?, ?, ?, ?, ?, NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
		stmt.setInt(1, order.getProductNo());
		stmt.setString(2, order.getId());
		stmt.setString(3, order.getPaymentStatus());
		stmt.setString(4, order.getDeliveryStatus());
		stmt.setInt(5, order.getOrderCnt());
		stmt.setInt(6, order.getOrderPrice());
		System.out.println(KMJ + stmt + " <--OrdersDao insertOrder stmt" + RESET);
		stmt.executeUpdate();
		ResultSet keyRs = stmt.getGeneratedKeys();
		int keyValue = 0;
		if(keyRs.next()) {
			keyValue = keyRs.getInt(1);
		}
		return keyValue;
	}
	
	//수정: 배송상태, 결제상태 수정
	public int updateOrder(Orders order) throws Exception {
		//매개변수 유효성 검사
		if(order == null) {
			System.out.println("잘못된 매개변수 <-- OrdersDao updateOrder메서드");
			return 0;
		}
		
		//DB접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "UPDATE orders SET payment_status = ?, delivery_status = ?, updatedate = NOW() WHERE order_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, order.getPaymentStatus());
		stmt.setString(2, order.getDeliveryStatus());
		stmt.setInt(3, order.getOrderNo());		
		System.out.println(KMJ + stmt + " <--OrdersDao deleteOrder stmt" + RESET);
		int row = stmt.executeUpdate();
		return row;
	}
	
	//상품 재고 수정: 주문하기 (주문시 재고 -1)
	public int updateProductStock (int productNo, int orderCnt) throws Exception {
		//DB접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String stockSql = "SELECT product_stock FROM product WHERE product_no = ?";
		PreparedStatement stockStmt = conn.prepareStatement(stockSql);
		stockStmt.setInt(1, productNo);
		ResultSet stockRs = stockStmt.executeQuery();
		int stock = 0;
		if(stockRs.next()) {
			stock = stockRs.getInt(1);
		}
		
		String sql = "UPDATE product SET product_stock = ? WHERE product_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, stock-orderCnt);
		stmt.setInt(2, productNo);
		System.out.println(KMJ + stmt + " <--OrdersDao updateProductStock stmt" + RESET);
		int row = stmt.executeUpdate();
		return row;
	}
}
