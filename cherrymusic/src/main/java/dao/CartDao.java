package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

import util.DBUtil;
import vo.Cart;

public class CartDao {
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	
	// cartList 고객 id 받아 장바구니 리스트 출력
	public ArrayList<HashMap<String, Object>> selectCartListByPage(String id) throws Exception {
		if(id == null) {
			System.out.println(SJ +"잘못된 매개변수	<-- cart selectCartListByPage메서드" + RE);
			return null;
		}
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		/*
		SELECT  RANK() over(order BY cartNo asc) 번호, cart_no cartNo, c.product_no cartProductNo, c.id cartId, cart_cnt cartCnt, c.createdate cartCreatedate, c.updatedate cartUpdatedate,
			p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_status productStatus, p.product_stock productStock, p.product_info productInfo, p.createdate proCreatedate, p.updatedate proUpdatedate,
			pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate pimCreatedate, pim.updatedate pimUpdatedate,
			cstm.id cstmId, cstm_name cstmName, cstm_address cstmAddress, cstm_point cstmPoint
		FROM cart c
		LEFT OUTER JOIN product p 
		ON p.product_no = c.product_no
		LEFT OUTER JOIN product_img pim
		ON p.product_no = pim.product_no
		LEFT OUTER JOIN customer cstm
		ON c.id = cstm.id
		WHERE c.id = ?
		ORDER BY c.cart_no ASC
		 */
		String sql = "SELECT  RANK() over(order BY cartNo asc) 번호, cart_no cartNo, c.product_no cartProductNo, c.id cartId, cart_cnt cartCnt, c.createdate cartCreatedate, c.updatedate cartUpdatedate,\r\n"
				+ "			p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_status productStatus, p.product_stock productStock, p.product_info productInfo, p.createdate proCreatedate, p.updatedate proUpdatedate,\r\n"
				+ "			pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate pimCreatedate, pim.updatedate pimUpdatedate,\r\n"
				+ "			cstm.id cstmId, cstm_name cstmName, cstm_address cstmAddress, cstm_point cstmPoint\r\n"
				+ "		FROM cart c\r\n"
				+ "		LEFT OUTER JOIN product p \r\n"
				+ "		ON p.product_no = c.product_no\r\n"
				+ "		LEFT OUTER JOIN product_img pim\r\n"
				+ "		ON p.product_no = pim.product_no\r\n"
				+ "		LEFT OUTER JOIN customer cstm\r\n"
				+ "		ON c.id = cstm.id\r\n"
				+ "		WHERE c.id = ?\r\n"
				+ "		ORDER BY c.cart_no ASC";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, id);
		ResultSet rs = stmt.executeQuery();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			// cart 테이블
			m.put("cartNo",rs.getInt("cartNo"));
			m.put("cartProductNo",rs.getInt("cartProductNo"));
			m.put("cartId",rs.getString("cartId"));
			m.put("cartCnt",rs.getInt("cartCnt"));
			m.put("cartCreatedate",rs.getString("cartCreatedate"));
			m.put("cartUpdatedate",rs.getString("cartUpdatedate"));
			
			// product 테이블
			m.put("productNo",rs.getInt("productNo"));
			m.put("categoryName",rs.getString("categoryName"));
			m.put("productName",rs.getString("productName"));
			m.put("productPrice",rs.getInt("productPrice"));
			m.put("productStatus",rs.getString("productStatus"));
			m.put("productStock",rs.getInt("productStock"));
			m.put("productInfo",rs.getString("productInfo"));
			m.put("proCreatedate",rs.getString("proCreatedate"));
			m.put("proUpdatedate",rs.getString("proUpdatedate"));
			
			// product_img 테이블
			m.put("productOriFilename",rs.getString("productOriFilename"));
			m.put("productSaveFilename",rs.getString("productSaveFilename"));
			m.put("productFiletype",rs.getString("productFiletype"));
			m.put("pimCreatedate",rs.getString("pimCreatedate"));
			m.put("pimUpdatedate",rs.getString("pimUpdatedate"));
			
			// customer 테이블
			m.put("cstmId",rs.getString("cstmId"));
			m.put("cstmName",rs.getString("cstmName"));
			m.put("cstmAddress",rs.getString("cstmAddress"));
			m.put("cstmPoint",rs.getString("cstmPoint"));
			list.add(m);
		}
		return list;
	}
	
	// 장바구니 상세내용 출력
	public HashMap<String, Object> selectCartOne(int cartNo) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT c.product_no productNo, p.product_name productName, p.product_price productPrice, id, cart_cnt cartCnt, cart_check cartCheck, c.createdate createdate, c.updatedate updatedate\r\n"
				+ "FROM cart c INNER JOIN product p\r\n"
				+ "ON c.product_no = p.product_no\r\n"
				+ "WHERE c.cart_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, cartNo);
		ResultSet rs = stmt.executeQuery();
		HashMap<String, Object> map = null;
		if(rs.next()) {
			map = new HashMap<String, Object>();
			map.put("productNo", rs.getInt("productNo"));
			map.put("productName", rs.getString("productName"));
			map.put("productPrice", rs.getInt("productPrice"));
			map.put("id", rs.getString("id"));
			map.put("cartCnt", rs.getInt("cartCnt"));
			map.put("cartCheck", rs.getString("cartCheck"));
			map.put("createdate", rs.getString("createdate"));
			map.put("updatedate", rs.getString("updatedate"));
		}
		return map;
	}
	
	// 장바구니에 추가 
	public int insertCart(Cart cart) throws Exception {
		
		// sql 실행시 영향받은 행의 수 
		int row = 0;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "INSERT INTO cart(product_no, id, cart_cnt, createdate, updatedate) VALUES(?,?,?, NOW(),NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, cart.getProductNo());
		stmt.setString(2, cart.getId());
		stmt.setInt(3, cart.getCartCnt());
		row = stmt.executeUpdate();
		return row;
	}
	// 장바구니 하나 삭제
	public int deletecart(int cartNo) throws Exception {
		if(cartNo == 0) {
			System.out.println(SJ +"잘못된 매개변수	<-- cart deletecart메서드" + RE);
			return 0;
		}
		int row = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "DELETE\r\n"
				+ "FROM cart\r\n"
				+ "WHERE cart_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1,cartNo);
		row = stmt.executeUpdate();
		return row;
	}

	// 선택된 상품 카운트 -- 체크된 상품 주문 내역으로 보기기 위함
	public int selCntcart(String id) throws Exception {
		int row = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT c.cart_check\r\n"
				+ "FROM cart c \r\n"
				+ "LEFT OUTER JOIN product p ON c.product_no = p.product_no \r\n"
				+ "LEFT OUTER JOIN customer cstm ON c.id = cstm.id \r\n"
				+ "WHERE cstm.id = ? AND c.cart_check='Y'";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1,id);
		row = stmt.executeUpdate();
		return row;
	}
	// product 재고량 확인하여 row로 반환 장바구니 수량 max 맞추기 위한 메서드
	public int productCartStock(int productNo) throws Exception {
		int row = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT product_stock\r\n"
				+ "FROM product\r\n"
				+ "WHERE product_no=?";
		//product_stock
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1,productNo);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			row = rs.getInt("product_stock");
		}
		return row;
	}
	// cart에서 product 수량 변경
	public int updateCartCnt(Cart cart) throws Exception {
		int row = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "UPDATE cart SET cart_cnt = ? WHERE cart_no = ?";
		//product_stock
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, cart.getCartCnt());
		stmt.setInt(2, cart.getCartNo());
		row = stmt.executeUpdate();
		return row;
	}
	// 동일 id내 동일 상품을 찾는 메서드 
	public int checkCart(Cart cart) throws Exception {
		int row = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT COUNT(*)\r\n"
				+ "FROM cart\r\n"
				+ "GROUP BY product_no, id\r\n"
				+ "HAVING COUNT(*) > 1;";
		//product_stock
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			row = rs.getInt("COUNT(*)");
		}
		if(row > 1) {
			System.out.println(SJ +"장바구니 내 동일 상품	<-- cart checkCart메서드" + RE);
			return 0;
		}
		return row;
	}
	// 주문 완료 후 장바구니내 항목 삭제
	public int removeCart(int cartNo) throws Exception {
		int row = 0;
		DBUtil DBUtil = new DBUtil();
		Connection conn = DBUtil.getConnection();
		String sql = "DELETE FROM cart WHERE cart_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, cartNo);
		row = stmt.executeUpdate();
		return row;
	}
}
