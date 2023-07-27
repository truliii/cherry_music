package dao;

import java.sql.Connection;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

import util.DBUtil;
import vo.Discount;

public class DiscountDao {
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	
	// 할인율 리스트 
	public  ArrayList<HashMap<String, Object>> selectDiscount(int beginRow, int rowPerPage) throws Exception {
		if(rowPerPage == 0) {
			System.out.println(SJ +"잘못된 매개변수	<-- DiscountDao selectDiscount메서드" + RE);
			return null;
		}
	// db 접속
	DBUtil dbUtil = new DBUtil();
	Connection conn = dbUtil.getConnection();
	// sql 전송 후 결과셋 반환받아 저장
	/*
	SELECT NVL(discount_no, 0) discountNo,  NVL(d.product_no, 0) dProductNo, NVL(discount_start, "-") discountStart, NVL(discount_end, "-") discountEnd, NVL(discount_rate, 0.0) discountRate,
	p.product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_status productStatus, product_stock productStock, product_info productInfo, product_sum_cnt productSumCnt, p.createdate, p.updatedate
	FROM product p
	LEFT OUTER JOIN discount d 
	ON p.product_no = d.product_no
	ORDER BY p.product_no asc
	LIMIT ?, ?
	 */
	String sql = "SELECT NVL(discount_no, 0) discountNo,  NVL(d.product_no, 0) dProductNo, NVL(discount_start, \"-\") discountStart, NVL(discount_end, \"-\") discountEnd, NVL(discount_rate, 0.0) discountRate,\r\n"
			+ "	p.product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_status productStatus, product_stock productStock, product_info productInfo, product_sum_cnt productSumCnt, p.createdate, p.updatedate\r\n"
			+ "	FROM product p\r\n"
			+ "	LEFT OUTER JOIN discount d \r\n"
			+ "	ON p.product_no = d.product_no\r\n"
			+ "	ORDER BY p.product_no asc\r\n"
			+ "	LIMIT ?, ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, beginRow);
	stmt.setInt(2, rowPerPage);
	ResultSet rs = stmt.executeQuery();
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("p.productNo",rs.getInt("p.productNo"));
		m.put("categoryName",rs.getString("categoryName"));
		m.put("productName",rs.getString("productName"));
		m.put("productPrice",rs.getInt("productPrice"));
		m.put("productStock",rs.getInt("productStock"));
		m.put("productStatus",rs.getString("productStatus"));
		m.put("productSumCnt",rs.getInt("productSumCnt"));
		m.put("p.createdate",rs.getString("p.createdate"));
		m.put("p.updatedate",rs.getString("p.updatedate"));
		
		m.put("discountNo",rs.getInt("discountNo"));
		m.put("dProductNo",rs.getInt("dProductNo"));
		m.put("discountStart",rs.getString("discountStart"));
		m.put("discountEnd",rs.getString("discountEnd"));
		m.put("discountRate",rs.getDouble("discountRate"));
		list.add(m);
	}
	return list;
	}
	// 할인 적용된 product 조회
	public  ArrayList<HashMap<String, Object>> selectDiscountProduct(int productNo) throws Exception {
		if(productNo == 0) {
			System.out.println(SJ +"잘못된 매개변수	<-- DiscountDao selectDiscountProduct메서드" + RE);
			return null;
		}
	// db 접속
	DBUtil dbUtil = new DBUtil();
	Connection conn = dbUtil.getConnection();
	// sql 전송 후 결과셋 반환받아 저장
	/*
	SELECT discount_no discountNo, d.product_no dProductNo, discount_start discountStart, discount_end discountEnd, discount_rate discountRate,
	p.product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_status productStatus, product_stock productStock, product_info productInfo, product_sum_cnt productSumCnt, p.createdate, p.updatedate
	FROM discount d
	INNER JOIN product p
	ON p.product_no = d.product_no
	WHERE p.product_no = ?
	 */
	String sql = "SELECT discount_no discountNo, d.product_no dProductNo, discount_start discountStart, discount_end discountEnd, discount_rate discountRate,\r\n"
			+ "		p.product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_status productStatus, product_stock productStock, product_info productInfo, product_sum_cnt productSumCnt, p.createdate, p.updatedate\r\n"
			+ "FROM discount d\r\n"
			+ "INNER JOIN product p\r\n"
			+ "ON p.product_no = d.product_no\r\n"
			+ "WHERE p.product_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, productNo);
	ResultSet rs = stmt.executeQuery();
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("p.productNo",rs.getInt("p.productNo"));
		m.put("categoryName",rs.getString("categoryName"));
		m.put("productName",rs.getString("productName"));
		m.put("productPrice",rs.getInt("productPrice"));
		m.put("productStock",rs.getInt("productStock"));
		m.put("productStatus",rs.getString("productStatus"));
		m.put("productSumCnt",rs.getInt("productSumCnt"));
		m.put("p.createdate",rs.getString("p.createdate"));
		m.put("p.updatedate",rs.getString("p.updatedate"));
		
		m.put("discountNo",rs.getInt("discountNo"));
		m.put("dProductNo",rs.getInt("dProductNo"));
		m.put("discountStart",rs.getString("discountStart"));
		m.put("discountEnd",rs.getString("discountEnd"));
		m.put("discountRate",rs.getDouble("discountRate"));
		list.add(m);
	}
	return list;
	}

	// 할인율 삽입
	public int insertDiscount(Discount discount) throws Exception {
		if(discount == null) {
			System.out.println(SJ +"잘못된 매개변수	<-- DiscountDao insertDiscount메서드" + RE);
			return 0;
		}
		// sql 실행시 영향받은 행의 수 
		int row = 0;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String checkSql = "SELECT COUNT(*) FROM discount WHERE product_no = ?";
		PreparedStatement checkStmt = conn.prepareStatement(checkSql);
		checkStmt.setInt(1, discount.getProductNo());
		ResultSet rs = checkStmt.executeQuery();
		if(rs.next()) {
			row = rs.getInt(1);
		}
		if (row > 0) {
		    // 중복된 데이터가 있음
		    System.out.println("중복된 데이터가 있습니다.");
		    return row;
		} else {
		    // 중복된 데이터가 없음
		    System.out.println("중복된 데이터가 없습니다.");
		}
		String sql = "INSERT INTO discount(product_no, discount_start, discount_end, discount_rate, createdate, updatedate) VALUES(?,?,?,?, NOW(),NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, discount.getProductNo());
		stmt.setString(2, discount.getDiscountStart());
		stmt.setString(3, discount.getDiscountEnd());
		stmt.setDouble(4, discount.getDiscountRate());
		row = stmt.executeUpdate();
		return row;
	}
	// 할인율 수정
	public int updateDiscount(Discount discount) throws Exception {
		if(discount == null) {
			System.out.println(SJ +"잘못된 매개변수	<-- DiscountDao updateDiscount메서드" + RE);
			return 0;
		}
		// sql 실행시 영향받은 행의 수 
		int row = 0;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql ="UPDATE discount SET product_no = ?, discount_start = ?, discount_end = ?, discount_rate = ?, updatedate = NOW() WHERE discount_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, discount.getProductNo());
		stmt.setString(2, discount.getDiscountStart());
		stmt.setString(3, discount.getDiscountEnd());
		stmt.setDouble(4, discount.getDiscountRate());
		stmt.setInt(5, discount.getDiscountNo());
		row = stmt.executeUpdate();
		return row;
	}
	// 할인율 삭제
	public int deleteDiscount(int discountNo) throws Exception {
		if(discountNo == 0) {
			System.out.println(SJ +"잘못된 매개변수	<-- DiscountDao deleteDiscount메서드" + RE);
			return 0;
		}
		// sql 실행시 영향받은 행의 수 
		int row = 0;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 영향받은 행의 수 반환받아 저장
		PreparedStatement stmt = conn.prepareStatement("DELETE FROM discount WHERE discount_no = ?");
		stmt.setInt(1, discountNo);
		row = stmt.executeUpdate();
		return row;
	}
	
	// 상품에 현재 적용되는 할인률 가져오기
	public Discount selectProductCurrentDiscount(int productNo) throws Exception {
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT discount_no discountNo, product_no productNo, discount_start discountStart, discount_end discountEnd, discount_rate discountRate, "
					+ "createdate, updatedate "
					+ "FROM discount "
					+ "WHERE product_no = ? "
					+ "AND NOW() > discount_start AND NOW() < discount_end "
					+ "ORDER BY discount_end DESC LIMIT 0, 1";
		// sql 전송 후 영향받은 행의 수 반환받아 저장
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, productNo);
		ResultSet rs = stmt.executeQuery();
		Discount discount = null;
		if(rs.next()) {
			discount = new Discount();
			discount.setDiscountNo(rs.getInt("discountNo"));
			discount.setProductNo(rs.getInt("productNo"));
			discount.setDiscountStart(rs.getString("discountStart"));
			discount.setDiscountEnd(rs.getString("discountEnd"));
			discount.setDiscountRate(rs.getDouble("discountRate"));
			discount.setCreatedate(rs.getString("createdate"));
			discount.setUpdatedate(rs.getString("updatedate"));
		}
		return discount;
	}
}
