package dao;


import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

import util.DBUtil;
import vo.*;

public class ProductDao {
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	// 이름별 검색
	public ArrayList<Product> searchProduct(String search) throws Exception{
		if(search == null) {
			System.out.println(SJ +"잘못된 매개변수 search <-- ProductDao searchProduct메서드" + RE);
			return null;
		}
		
		ArrayList<Product> list = new ArrayList<>();
		Product product = null;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		/*
		SELECT p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_status productStatus, p.product_stock productStock, p.product_info productInfo, p.createdate, p.updatedate,
	    pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate
		FROM product p 
		INNER JOIN product_img pim
		ON p.product_no = pim.product_no
		WHERE p.product_name LIKE ?
		ORDER BY productNo ASC
		 */
		String sql = "SELECT p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_status productStatus, p.product_stock productStock, p.product_info productInfo, p.createdate, p.updatedate,\r\n"
				+ "	    pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate\r\n"
				+ "		FROM product p \r\n"
				+ "		INNER JOIN product_img pim\r\n"
				+ "		ON p.product_no = pim.product_no\r\n"
				+ "		WHERE p.product_name LIKE ?\r\n"
				+ "		ORDER BY productNo ASC\r\n";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+search+"%");
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			product = new Product();
			product.setProductNo(rs.getInt("productNo"));
			product.setCategoryName(rs.getString("categoryName"));
			product.setProductName(rs.getString("productName"));
			product.setProductPrice(rs.getInt("productPrice"));
			product.setProductStatus(rs.getString("productStatus"));
			product.setProductStock(rs.getInt("productStock"));
			product.setProductInfo(rs.getString("productInfo"));
			product.setCreatedate(rs.getString("createdate"));
			product.setUpdatedate(rs.getString("updatedate"));
			list.add(product);	
		}
		return list;
	}
	// 관리자 상품 삽입
	public int insertProduct(Product product, ProductImg productImg) throws Exception {
		if(product == null) {
		System.out.println(SJ +"잘못된 매개변수	<-- ProductDao insertProduct메서드"+RE);
		return 0;
		}
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		int row = 0;
		
		/* product 추가 쿼리
		 	INSERT INTO product(category_name, product_name, product_price, product_status, product_stock, product_info, createdate, updatedate) VALUES(?, ?, ?, ?, ?, ?, now(),now())
		
		 */
		String productSql="INSERT INTO product(category_name, product_name, product_price, product_status, product_stock, product_info, product_sum_cnt, createdate, updatedate) VALUES(?, ?, ?, ?, ?, ?, ?, now(),now())";
		PreparedStatement productStmt = conn.prepareStatement(productSql, PreparedStatement.RETURN_GENERATED_KEYS);
		productStmt.setString(1, product.getCategoryName());
		productStmt.setString(2, product.getProductName());
		productStmt.setInt(3, product.getProductPrice());
		productStmt.setString(4, product.getProductStatus());
		productStmt.setInt(5, product.getProductStock());
		productStmt.setString(6, product.getProductInfo());
		productStmt.setInt(7, 0);
		productStmt.executeUpdate();
		// 생성된 키값 자동으로받아옴
		ResultSet keyRs = productStmt.getGeneratedKeys();
		int productNo = 0;
		if(keyRs.next()) {
			productNo = keyRs.getInt(1);
		}
		
		System.out.println(SJ+ productStmt + "<-- ProductDao productStmt" + RE);
		
		/* productImg 추가 쿼리
		  INSERT INTO product_img(product_no, product_ori_filename, product_save_filename, product_filetype, createdate, updatedate)
		  VALUES(?, ?, ?, ?, now(), now())
		 */
		String productImgSql="INSERT INTO product_img(product_no, product_ori_filename, product_save_filename, product_filetype, createdate, updatedate) VALUES(?, ?, ?, ?, now(), now())";
		PreparedStatement productImgStmt = conn.prepareStatement(productImgSql);
		productImgStmt.setInt(1, productNo);
		productImgStmt.setString(2, productImg.getProductOriFilename());
		productImgStmt.setString(3, productImg.getProductSaveFileName());
		productImgStmt.setString(4, productImg.getProductFiletype());
		row = productImgStmt.executeUpdate();
		
		System.out.println(SJ+ productImgStmt + "<-- ProductDao productImgStmt"+RE);
		return row;
		
	}
	// 관리자 상품 수정
	public int updateProduct(HashMap<String, Object> map) throws Exception {
		// 매개변수값 유효성 검사
		if(map == null || map.get("product") == null) {
			System.out.println("입력값 확인");
			return 0;
		}
		
		//매개변수값 저장
		Product product = (Product)map.get("product");
			
		// 결과 값을 저장해줄 int타입 변수 선언
		int row = 0;
		
		// Connection 가져오기
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// product_no에 해당하는 product데이터를 수정하는 쿼리
		String productSql = "update product set category_name = ?, product_name = ?, product_price = ?, product_status = ?, product_info = ?, product_stock = ?, updatedate = now() where product_no = ?";
		PreparedStatement productStmt = conn.prepareStatement(productSql);
		
		// ?값 세팅
		productStmt.setString(1, product.getCategoryName());
		productStmt.setString(2, product.getProductName());
		productStmt.setInt(3, product.getProductPrice());
		productStmt.setString(4, product.getProductStatus());
		productStmt.setString(5, product.getProductInfo());
		productStmt.setInt(6, product.getProductStock());
		productStmt.setInt(7, product.getProductNo());
		
		// 쿼리 실행 후 영향받은 행 저장
		row = productStmt.executeUpdate();
		
		// productImg가 안들어왔으면 리턴
		if(map.get("productImg") == null) {
			return row;
		}
		

		ProductImg productImg = (ProductImg)map.get("productImg");
		
		// product_img를 수정하는 쿼리
		String productImgSql = "update product_img set product_ori_filename = ?, product_save_filename = ?, product_filetype = ?, updatedate = now() where product_no = ?";
		PreparedStatement productImgStmt = conn.prepareStatement(productImgSql);
		
		// ?값 세팅
		productImgStmt.setString(1, productImg.getProductOriFilename());
		productImgStmt.setString(2, productImg.getProductSaveFileName());
		productImgStmt.setString(3, productImg.getProductFiletype());
		productImgStmt.setInt(4, productImg.getProductNo());
		
		row += productImgStmt.executeUpdate();
		// productImg가 안들어왔으면 리턴
		if(map.get("discount") == null) {
			return row;
		}
		
		// 할인율
		Discount discount = (Discount)map.get("discount");
		
		String discountSql ="UPDATE discount SET  discount_start = ?, discount_end = ?, discount_rate = ?, updatedate = NOW() WHERE product_no = ?";
		PreparedStatement discountStmt = conn.prepareStatement(discountSql);
		discountStmt.setString(1, discount.getDiscountStart());
		discountStmt.setString(2, discount.getDiscountEnd());
		discountStmt.setDouble(3, discount.getDiscountRate());
		discountStmt.setInt(4, discount.getProductNo());
		row = discountStmt.executeUpdate();
		
		
		return row;
	}
	// 관리자 상품 이미지 삭제
	public int deleteProductImg(int productNo) throws Exception {
		if(productNo == 0) {
			System.out.println(SJ +"잘못된 매개변수	<-- ProductDao deleteProductImg메서드"+RE);
			return 0;
		}
		// sql 실행시 영향받은 행의 수 
		int row2 = 0;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		
		String delBoardSql = "DELETE FROM product_img WHERE product_no = ?";
	    PreparedStatement delBoardStmt = conn.prepareStatement(delBoardSql);
	    delBoardStmt.setInt(1, productNo);
		System.out.println(SJ +delBoardStmt + "<--- stmt deleteProductImg"+RE);
		
	   row2 = delBoardStmt.executeUpdate();
		return row2;
	}
	
	// 관리자 상품 삭제
	public int deleteProduct(int productNo) throws Exception {
		if(productNo == 0) {
			System.out.println(SJ +"잘못된 매개변수	<-- ProductDao deleteProduct메서드"+RE);
			return 0;
		}
		// sql 실행시 영향받은 행의 수 
		int row = 0;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();	    
	    System.out.println(SJ +"상품 삭제 시작 deleteProduct"+RE);
		// sql 전송 후 영향받은 행의 수 반환받아 저장
		String sql = "DELETE FROM product WHERE product_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, productNo);
		row = stmt.executeUpdate();
		System.out.println(SJ +stmt + "<--- stmt deleteProduct"+RE);
		return row;
	}
	// 상품 전체 row
	public int selectProductCnt() throws Exception {
		
		// 반환할 전체 행의 수
		int row = 0;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 값 저장
		PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM product");
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			row = rs.getInt(1);
		}
		return row;
	}
	// =========== product 상세, 수정 폼 ================
	public ArrayList<HashMap<String, Object>> selectProduct(int productNo) throws Exception {
		if(productNo == 0) {
			System.out.println(SJ +"잘못된 매개변수	<-- ProductDao selectProduct메서드"+RE);
			return null;
		}
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 저장
		/*
		SELECT DISTINCT p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_status productStatus, p.product_stock productStock, p.product_info productInfo, p.createdate, p.updatedate,  
		pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate,	
		NVL(discount_no, 0) discountNo,  NVL(d.product_no, 0) dProductNo, NVL(discount_start, "-") discountStart, NVL(discount_end, "-") discountEnd, NVL(discount_rate, 0.0) discountRate
		FROM product p
		INNER join product_img pim
		ON p.product_no = pim.product_no
		LEFT OUTER JOIN orders o 
		ON p.product_no = o.product_no
		LEFT OUTER JOIN discount d 
		ON p.product_no = d.product_no
		WHERE p.product_no = ?
		 */
		String sql = "SELECT DISTINCT p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_status productStatus, p.product_stock productStock, p.product_info productInfo, p.createdate, p.updatedate,  \r\n"
				+ "		pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate,	\r\n"
				+ "		NVL(discount_no, 0) discountNo,  NVL(d.product_no, 0) dProductNo, NVL(discount_start, \"-\") discountStart, NVL(discount_end, \"-\") discountEnd, NVL(discount_rate, 0.0) discountRate\r\n"
				+ "		FROM product p\r\n"
				+ "		INNER join product_img pim\r\n"
				+ "		ON p.product_no = pim.product_no\r\n"
				+ "		LEFT OUTER JOIN orders o \r\n"
				+ "		ON p.product_no = o.product_no\r\n"
				+ "		LEFT OUTER JOIN discount d \r\n"
				+ "		ON p.product_no = d.product_no\r\n"
				+ "		WHERE p.product_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, productNo);
		ResultSet rs = stmt.executeQuery();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			// product 테이블
			m.put("productNo", rs.getInt("productNo"));
			m.put("categoryName",rs.getString("categoryName"));
			m.put("productName",rs.getString("productName"));
			m.put("productPrice",rs.getInt("productPrice"));
			m.put("productStatus",rs.getString("productStatus"));
			m.put("productStock",rs.getInt("productStock"));
			m.put("productInfo",rs.getString("productInfo"));
			m.put("p.createdate",rs.getString("p.createdate"));
			m.put("p.updatedate",rs.getString("p.updatedate"));
			
			// product_img 테이블
			m.put("productOriFilename",rs.getString("productOriFilename"));
			m.put("productSaveFilename",rs.getString("productSaveFilename"));
			m.put("productFiletype",rs.getString("productFiletype"));
			m.put("pim.createdate",rs.getString("pim.createdate"));
			m.put("pim.updatedate",rs.getString("pim.updatedate"));
			// discount 
			m.put("discountNo",rs.getInt("discountNo"));
			m.put("dProductNo",rs.getInt("dProductNo"));
			m.put("discountStart",rs.getString("discountStart"));
			m.put("discountEnd",rs.getString("discountEnd"));
			m.put("discountRate",rs.getDouble("discountRate"));
			list.add(m);
		}
		return list;
	}
	//=================== 리스트 정렬 no, name, price, stock, status, sum_cnt ================
	// 상품 기본 정렬 : 판매량 순
	public  ArrayList<HashMap<String, Object>> selectSumCntByPage(boolean order, int beginRow, int rowPerPage) throws Exception {
		if(rowPerPage ==0) {
			System.out.println(SJ +"잘못된 매개변수	<-- ProductDao selectSumCntByPage메서드"+RE);
			return null;
		}
		String orderby = null;
		if(order = true) {
			orderby = "desc";
		} else {
			orderby = "asc";
		}
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT RANK() over(order BY productSumCnt"+" " + orderby + " " + ") ranking,  p.product_no productNo,  product_sum_cnt productSumCnt, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, p.createdate, p.updatedate,\r\n"
				+ "		 pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate\r\n"
				+ "		 FROM product p\r\n"
				+ "		 LEFT OUTER JOIN product_img pim\r\n"
				+ "	     ON p.product_no = pim.product_no\r\n"
				+ "		 LIMIT ?, ?";
		/*
		 SELECT RANK() over(order BY productSumCnt DESC) ranking,  p.product_no productNo,  product_sum_cnt productSumCnt, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, p.createdate, p.updatedate,
		 pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate
		 FROM product p
		 LEFT OUTER JOIN product_img pim
	     ON p.product_no = pim.product_no
		 LIMIT ?, ?
		 */
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
			
			m.put("productOriFilename",rs.getString("productOriFilename"));
			m.put("productSaveFilename",rs.getString("productSaveFilename"));
			m.put("productFiletype",rs.getString("productFiletype"));
			m.put("pim.createdate",rs.getString("pim.createdate"));
			m.put("pim.updatedate",rs.getString("pim.updatedate"));
			
			list.add(m);
		}
		return list;
	}
	// 상품 정렬 : No 순
	public  ArrayList<HashMap<String, Object>> selectProductNoByPage(boolean order, int beginRow, int rowPerPage) throws Exception {
		if(rowPerPage ==0) {
			System.out.println(SJ +"잘못된 매개변수	<-- ProductDao selectProductNoByPage메서드"+RE);
			return null;
		}
		String orderby = null;
		if(order = true) {
			orderby = "asc";
		} else {
			orderby = "desc";
		}
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT p.product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, p.createdate, p.updatedate,\r\n"
				+ "				pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate,\r\n"
				+ "				discount_no discountNo, d.product_no dProductNo, discount_start discountStart, discount_end discountEnd, discount_rate discountRate\r\n"
				+ "		FROM product p\r\n"
				+ "	 	LEFT OUTER JOIN product_img pim\r\n"
				+ "		ON p.product_no = pim.product_no\r\n"
				+ "		LEFT OUTER JOIN discount d \r\n"
				+ "	    ON p.product_no = d.product_no\r\n"
				+ "		ORDER BY productNo "+" " + orderby + " " + "\r\n"
				+ "		LIMIT ?, ? ";
		/*
		SELECT p.product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, p.createdate, p.updatedate,
				pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate,
				discount_no discountNo, d.product_no dProductNo, discount_start discountStart, discount_end discountEnd, discount_rate discountRate
		FROM product p
	 	LEFT OUTER JOIN product_img pim
		ON p.product_no = pim.product_no
		LEFT OUTER JOIN discount d 
	    ON p.product_no = d.product_no
		ORDER BY productNo "+" " + orderby + " " + "
		LIMIT ?, ? 
		 */
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
			m.put("p.createdate",rs.getString("p.createdate"));
			m.put("p.updatedate",rs.getString("p.updatedate"));
			
			m.put("productOriFilename",rs.getString("productOriFilename"));
			m.put("productSaveFilename",rs.getString("productSaveFilename"));
			m.put("productFiletype",rs.getString("productFiletype"));
			m.put("pim.createdate",rs.getString("pim.createdate"));
			m.put("pim.updatedate",rs.getString("pim.updatedate"));
			
			m.put("discountNo",rs.getInt("discountNo"));
			m.put("dProductNo",rs.getInt("dProductNo"));
			m.put("discountStart",rs.getString("discountStart"));
			m.put("discountEnd",rs.getString("discountEnd"));
			m.put("discountRate",rs.getDouble("discountRate"));
			list.add(m);
		}
		return list;
	}
	// 상품 정렬 : Name 순
	public ArrayList<HashMap<String, Object>> selectProductNameByPage(boolean order, int beginRow, int rowPerPage) throws Exception {
		if(rowPerPage ==0) {
			System.out.println(SJ +"잘못된 매개변수	<-- ProductDao selectProductNameByPage메서드"+RE);
			return null;
		}
		String orderby = null;
		if(order = true) {
			orderby = "asc";
		} else {
			orderby = "desc";
		}
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT p.product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, product_sum_cnt productSumCnt, p.createdate, p.updatedate,\r\n"
				+ "			pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate\r\n"
				+ "		 FROM product p\r\n"
				+ "		 LEFT OUTER JOIN product_img pim\r\n"
				+ "		 ON p.product_no = pim.product_no\r\n"
				+ "		 ORDER BY productName "+" " + orderby + " " + "\r\n"
				+ "		 LIMIT ?, ? ";
		/*
		 SELECT p.product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, p.createdate, p.updatedate,
			pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate
		 FROM product p
		 LEFT OUTER JOIN product_img pim
		 ON p.product_no = pim.product_no
		 ORDER BY productName asc
		 LIMIT ?, ? 
		 */
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
			
			m.put("productOriFilename",rs.getString("productOriFilename"));
			m.put("productSaveFilename",rs.getString("productSaveFilename"));
			m.put("productFiletype",rs.getString("productFiletype"));
			m.put("pim.createdate",rs.getString("pim.createdate"));
			m.put("pim.updatedate",rs.getString("pim.updatedate"));
			list.add(m);
		}
		return list;
	}
	// 상품 정렬 : Price 순
	public 	ArrayList<HashMap<String, Object>> selectProductPrictByPage(boolean order, int beginRow, int rowPerPage) throws Exception {
		if(rowPerPage ==0) {
			System.out.println(SJ +"잘못된 매개변수	<-- ProductDao selectProductPrictByPage메서드"+RE);
			return null;
		}
		String orderby = null;
		if(order = true) {
			orderby = "desc";
		} else {
			orderby = "asc";
		}
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT p.product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, product_sum_cnt productSumCnt, p.createdate, p.updatedate,\r\n"
				+ "				pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate\r\n"
				+ "		 FROM product p\r\n"
				+ "		 LEFT OUTER JOIN product_img pim\r\n"
				+ "		 ON p.product_no = pim.product_no\r\n"
				+ "		 ORDER BY productPrice "+" " + orderby + " " + "\r\n"
				+ "		 LIMIT ?, ? ";
		/*
		 SELECT p.product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, p.createdate, p.updatedate,
				pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate
		 FROM product p
		 LEFT OUTER JOIN product_img pim
		 ON p.product_no = pim.product_no
		 ORDER BY productPrice desc
		 LIMIT ?, ? 
		 */
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
			
			m.put("productOriFilename",rs.getString("productOriFilename"));
			m.put("productSaveFilename",rs.getString("productSaveFilename"));
			m.put("productFiletype",rs.getString("productFiletype"));
			m.put("pim.createdate",rs.getString("pim.createdate"));
			m.put("pim.updatedate",rs.getString("pim.updatedate"));
			list.add(m);
		}
		return list;
	}
	// 상품 정렬 : Stock 순
	public ArrayList<HashMap<String, Object>> selectProductStockByPage(boolean order, int beginRow, int rowPerPage) throws Exception {
		if(rowPerPage ==0) {
			System.out.println(SJ +"잘못된 매개변수	<-- ProductDao selectProductStockByPage메서드"+RE);
			return null;
		}
		String orderby = null;
		if(order = true) {
			orderby = "desc";
		} else {
			orderby = "asc";
		}
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT p.product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, product_sum_cnt productSumCnt, p.createdate, p.updatedate,\r\n"
				+ "				pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate\r\n"
				+ "		 FROM product p\r\n"
				+ "		 LEFT OUTER JOIN product_img pim\r\n"
				+ "		 ON p.product_no = pim.product_no\r\n"
				+ "		 ORDER BY productStock "+" " + orderby + " " + "\r\n"
				+ "		 LIMIT ?, ? ";
		/*
		 SELECT p.product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, p.createdate, p.updatedate,
				pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate
		 FROM product p
		 LEFT OUTER JOIN product_img pim
		 ON p.product_no = pim.product_no
		 ORDER BY productStock desc
		 LIMIT ?, ? 
		 */
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
			
			m.put("productOriFilename",rs.getString("productOriFilename"));
			m.put("productSaveFilename",rs.getString("productSaveFilename"));
			m.put("productFiletype",rs.getString("productFiletype"));
			m.put("pim.createdate",rs.getString("pim.createdate"));
			m.put("pim.updatedate",rs.getString("pim.updatedate"));
			list.add(m);
		}
		return list;
	}
	// 상품 정렬 : Status 순
	public ArrayList<HashMap<String, Object>> selectProductStatusByPage(boolean order, int beginRow, int rowPerPage) throws Exception {
		if(rowPerPage ==0) {
			System.out.println(SJ +"잘못된 매개변수	<-- ProductDao selectProductStatusByPage메서드"+RE);
			return null;
		}
		String orderby = null;
		if(order = true) {
			orderby = "asc";
		} else {
			orderby = "desc";
		}
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT p.product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, product_sum_cnt productSumCnt, p.createdate, p.updatedate,\r\n"
				+ "				pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate\r\n"
				+ "		 FROM product p\r\n"
				+ "		 LEFT OUTER JOIN product_img pim\r\n"
				+ "		 ON p.product_no = pim.product_no\r\n"
				+ "		 ORDER BY productStatus "+" " + orderby + " " + "\r\n"
				+ "		 LIMIT ?, ? ";
		/*
		 SELECT p.product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, p.createdate, p.updatedate,
				pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate
		 FROM product p
		 LEFT OUTER JOIN product_img pim
		 ON p.product_no = pim.product_no
		 ORDER BY productStatus asc
		 LIMIT ?, ?
		 */
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
			
			m.put("productOriFilename",rs.getString("productOriFilename"));
			m.put("productSaveFilename",rs.getString("productSaveFilename"));
			m.put("productFiletype",rs.getString("productFiletype"));
			m.put("pim.createdate",rs.getString("pim.createdate"));
			m.put("pim.updatedate",rs.getString("pim.updatedate"));
			list.add(m);
		}
		return list;
		
	}
	// =============== 전체, 팝, 가요, 클래식 개별 판매순위 desc 출력 ==================
	// 전체 출력
	public ArrayList<HashMap<String, Object>> selectTotalByPage(boolean order, int beginRow, int rowPerPage) throws Exception {
		if(rowPerPage ==0) {
			System.out.println(SJ +"잘못된 매개변수	<-- ProductDao selectTotalByPage메서드"+RE);
			return null;
		}
		String orderby = null;
		if(order = true) {
			orderby = "desc";
		} else {
			orderby = "asc";
		}
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT  RANK() over(order BY productSumCnt "+" " + orderby + " " + ") ranking, p.product_sum_cnt productSumCnt, p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_stock productStock, p.product_status productStatus, product_sum_cnt productSumCnt, p.createdate, p.updatedate,\r\n"
				+ "			pim.product_no, pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype\r\n"
				+ "		FROM product p\r\n"
				+ "		LEFT OUTER JOIN product_img pim\r\n"
				+ "		ON p.product_no = pim.product_no\r\n"
				+ "	 	LIMIT ?, ?";
		/*
		 SELECT  RANK() over(order BY productSumCnt DESC) ranking, p.product_sum_cnt productSumCnt, p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_stock productStock, p.product_status productStatus, p.createdate, p.updatedate,
			pim.product_no, pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype
		FROM product p
		LEFT OUTER JOIN product_img pim
		ON p.product_no = pim.product_no
	 	LIMIT 0, 3
		 */
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
			
			m.put("productOriFilename",rs.getString("productOriFilename"));
			m.put("productSaveFilename",rs.getString("productSaveFilename"));
			m.put("productFiletype",rs.getString("productFiletype"));
			list.add(m);
		}
		return list;
		
	}
	// pop 출력
	public ArrayList<HashMap<String, Object>> selectPopByPage(boolean order, int beginRow, int rowPerPage) throws Exception {
		if(rowPerPage ==0) {
			System.out.println(SJ +"잘못된 매개변수	<-- ProductDao selectPopByPage메서드"+RE);
			return null;
		}
		String orderby = null;
		if(order = true) {
			orderby = "desc";
		} else {
			orderby = "asc";
		}
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT  RANK() over(order BY productSumCnt "+" " + orderby + " " + ") ranking, p.product_sum_cnt productSumCnt, p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_stock productStock, p.product_status productStatus, product_sum_cnt productSumCnt, p.createdate, p.updatedate,\r\n"
				+ "			pim.product_no, pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype\r\n"
				+ "		FROM product p\r\n"
				+ "		LEFT OUTER JOIN product_img pim\r\n"
				+ "		ON p.product_no = pim.product_no\r\n"
				+ "		WHERE category_name = 'pop'\r\n"
				+ "	 	LIMIT ?, ?";
		/*
		SELECT  RANK() over(order BY productSumCnt DESC) ranking, p.product_sum_cnt productSumCnt, p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_stock productStock, p.product_status productStatus, p.createdate, p.updatedate,\r\n"
				+ "			pim.product_no, pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype\r\n"
				+ "		FROM product p\r\n"
				+ "		LEFT OUTER JOIN product_img pim\r\n"
				+ "		ON p.product_no = pim.product_no\r\n"
				+ "		WHERE category_name = 'pop'\r\n"
				+ "	 	LIMIT ?, ?
		 */
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
			
			m.put("productOriFilename",rs.getString("productOriFilename"));
			m.put("productSaveFilename",rs.getString("productSaveFilename"));
			m.put("productFiletype",rs.getString("productFiletype"));
			list.add(m);
		}
		return list;
		
	}
	// kpop 출력
	public ArrayList<HashMap<String, Object>> selectKpopByPage(boolean order, int beginRow, int rowPerPage) throws Exception {
		if(rowPerPage ==0) {
			System.out.println(SJ +"잘못된 매개변수	<-- ProductDao selectKpopByPage메서드"+RE);
			return null;
		}
		String orderby = null;
		if(order = true) {
			orderby = "desc";
		} else {
			orderby = "asc";
		}
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "select RANK() over(order BY productSumCnt "+" " + orderby + " " + ") ranking, p.product_sum_cnt productSumCnt, p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_stock productStock, p.product_status productStatus, product_sum_cnt productSumCnt, p.createdate, p.updatedate,\r\n"
				+ "			pim.product_no, pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype\r\n"
				+ "		FROM product p\r\n"
				+ "		LEFT OUTER JOIN product_img pim\r\n"
				+ "		ON p.product_no = pim.product_no\r\n"
				+ "		WHERE category_name = 'kpop'\r\n"
				+ "		LIMIT ?, ?";
		/*
		select RANK() over(order BY productSumCnt DESC) ranking, p.product_sum_cnt productSumCnt, p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_stock productStock, p.product_status productStatus, p.createdate, p.updatedate,
			pim.product_no, pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype
		FROM product p
		LEFT OUTER JOIN product_img pim
		ON p.product_no = pim.product_no
		WHERE category_name = 'kpop'
		LIMIT 0, 4
		 */
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
			
			m.put("productOriFilename",rs.getString("productOriFilename"));
			m.put("productSaveFilename",rs.getString("productSaveFilename"));
			m.put("productFiletype",rs.getString("productFiletype"));
			list.add(m);
		}
		return list;
		
	}
	// Classic 출력
	public ArrayList<HashMap<String, Object>> selectClassicByPage(boolean order, int beginRow, int rowPerPage) throws Exception {
		if(rowPerPage ==0) {
			System.out.println(SJ +"잘못된 매개변수	<-- ProductDao selectClassicByPage메서드"+RE);
			return null;
		}
		String orderby = null;
		if(order = true) {
			orderby = "desc";
		} else {
			orderby = "asc";
		}
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT  RANK() over(order BY productSumCnt "+" " + orderby + " " + ") ranking, p.product_sum_cnt productSumCnt, p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_stock productStock, p.product_status productStatus, product_sum_cnt productSumCnt, p.createdate, p.updatedate,\r\n"
				+ "			pim.product_no, pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype\r\n"
				+ "		FROM product p\r\n"
				+ "		LEFT OUTER JOIN product_img pim\r\n"
				+ "		ON p.product_no = pim.product_no\r\n"
				+ "		WHERE category_name = 'classic'\r\n"
				+ "	 	LIMIT ?, ?";
		/*
		 SELECT  RANK() over(order BY productSumCnt DESC) ranking, p.product_sum_cnt productSumCnt, p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_stock productStock, p.product_status productStatus, p.createdate, p.updatedate,
			pim.product_no, pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype
		FROM product p
		LEFT OUTER JOIN product_img pim
		ON p.product_no = pim.product_no
		WHERE category_name = 'classic'
	 	LIMIT 0, 3
		 */
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
			
			m.put("productOriFilename",rs.getString("productOriFilename"));
			m.put("productSaveFilename",rs.getString("productSaveFilename"));
			m.put("productFiletype",rs.getString("productFiletype"));
			list.add(m);
		}
		return list;
		
	}
	// =============== 정렬 끝 ====================
	
	// =============== 상품1개 조회 ====================
	public HashMap<String,Object> selectProductOne(int productNo) throws Exception {
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_status productStatus, "
				+ "p.product_stock productStock, p.product_info productInfo, p.product_sum_cnt productSumCnt, p.createdate, p.updatedate, "
				+ "pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype "
				+ "FROM product p LEFT OUTER JOIN product_img pim "
				+ "ON p.product_no = pim.product_no "
				+ "WHERE p.product_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, productNo);
		ResultSet rs = stmt.executeQuery();
		HashMap<String, Object> map = null;
		if(rs.next()) {
			map = new HashMap<String, Object>();
			map.put("productNo", rs.getInt("productNo"));
			map.put("categoryName", rs.getString("categoryName"));
			map.put("productName", rs.getString("productName"));
			map.put("productPrice", rs.getInt("productPrice"));
			map.put("productStatus", rs.getString("productStatus"));
			map.put("productStock",rs.getInt("productStock"));
			map.put("productInfo", rs.getString("productInfo"));
			map.put("productSumCnt", rs.getInt("productSumCnt"));
			map.put("createdate", rs.getString("createdate"));
			map.put("updatedate", rs.getString("updatedate"));
			map.put("productOriFilename", rs.getString("productOriFilename"));
			map.put("productSaveFilename", rs.getString("productSaveFilename"));
			map.put("productFiletype", rs.getString("productFiletype"));
		}
		return map;
	}
	
	// =============== 조회(category_name) ====================
	
	public boolean selectCategory(String categoryName) throws Exception {
		
		// 유효성 검사
		if(categoryName == null) {
			System.out.println("입력 error");
			return false;
		}
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT category_name FROM product WHERE category_name = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, categoryName);
		ResultSet rs = stmt.executeQuery();
		
		if(rs.next()) {
			return true;
		}
		return false;
	} 
}
