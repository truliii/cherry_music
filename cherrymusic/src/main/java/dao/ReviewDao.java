package dao;

import java.util.*;
import java.sql.*;
import vo.*;
import util.*;

public class ReviewDao {
	//조회: 리뷰리스트(관리자) - 답변여부에 따라 분기
	public ArrayList<HashMap<String, Object>> selectReviewListByPage(int beginRow, int rowPerPage, String answer) throws Exception {
		if(answer == null) {
			answer = "all";
		}
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		//답변여부에 따라 검색
		String sql = null;
		if(answer.equals("all")) {
			sql = "SELECT r.review_no reviewNo, r.order_no orderNo, r.review_title reviewTitle, r.review_content reviewContent, r.review_check_cnt reviewCheckCnt, "
					+ "a.aCnt cnt, r.createdate createdate, r.updatedate updatedate "
					+ "FROM review r LEFT OUTER JOIN (SELECT review_no, COUNT(*) aCnt FROM review_answer GROUP BY review_no) a "
					+ "ON r.review_no = a.review_no ";
		} else if(answer.equals("true")) { //답변이 없는 데이터만 조회
			sql = "SELECT r.review_no reviewNo, r.order_no orderNo, r.review_title reviewTitle, r.review_content reviewContent, r.review_check_cnt reviewCheckCnt, "
					+ "a.aCnt cnt, r.createdate createdate, r.updatedate updatedate "
					+ "FROM review r LEFT OUTER JOIN (SELECT review_no, COUNT(*) aCnt FROM review_answer GROUP BY review_no) a "
					+ "ON r.review_no = a.review_no "
					+ "WHERE aCnt IS NULL"; //LEFT JOIN이므로 review_answer가 없으면 aCnt컬럼이 null이다 
		} else { //답변이 있는 데이터만 조회
			sql = "SELECT r.review_no reviewNo, r.order_no orderNo, r.review_title reviewTitle, r.review_content reviewContent, r.review_check_cnt reviewCheckCnt, "
					+ "a.aCnt cnt, r.createdate createdate, r.updatedate updatedate "
					+ "FROM review r LEFT OUTER JOIN (SELECT review_no, COUNT(*) aCnt FROM review_answer GROUP BY review_no) a "
					+ "ON r.review_no = a.review_no "
					+ "WHERE aCnt > 0";
		}
		PreparedStatement stmt = conn.prepareStatement(sql);
		System.out.println(stmt + " <--ReviewDao");
		ResultSet rs = stmt.executeQuery();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("reviewNo", rs.getInt("reviewNo"));
			m.put("orderNo", rs.getInt("orderNo"));
			m.put("reviewTitle", rs.getString("reviewTitle"));
			m.put("reviewContent", rs.getString("reviewContent"));
			m.put("reviewCheckCnt", rs.getInt("reviewCheckCnt"));
			m.put("cnt", rs.getInt("cnt"));
			m.put("createdate", rs.getString("createdate"));
			m.put("updatedate", rs.getString("updatedate"));
			list.add(m);
		}
		return list;
	}
	
	//조회: 상품별 리뷰
	public ArrayList<HashMap<String, Object>> selectReviewListByProduct(int productNo, int beginRow, int rowPerPage) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		//답변여부에 따라 검색
		String sql = "SELECT reviewNo, orderNo, reviewTitle, reviewContent, reviewCheckCnt, t1.createdate, t1.updatedate, id, "
				+ "t2.review_ori_filename reviewOrgFilename, t2.review_save_filename reviewSaveFilename, t2.review_filetype reviewFiletype "
				+ "FROM "
				+ "(SELECT r.review_no reviewNo, r.order_no orderNo, r.review_title reviewTitle, r.review_content reviewContent, "
				+ "r.review_check_cnt reviewCheckCnt, r.createdate, r.updatedate, o.id "
				+ "FROM review r INNER JOIN orders o "
				+ "ON r.order_no = o.order_no) t1 LEFT OUTER JOIN review_img t2 "
				+ "ON t1.orderNo = t2.order_no "
				+ "WHERE t1.orderNo IN (SELECT order_no FROM orders WHERE product_no = ?) "
				+ "ORDER BY t1.createdate DESC LIMIT ? , ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, productNo);
		stmt.setInt(2, beginRow);
		stmt.setInt(3, rowPerPage);
		System.out.println(stmt + " <--revieDao");
		ResultSet rs = stmt.executeQuery();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("reviewNo", rs.getInt("reviewNo"));
			m.put("orderNo", rs.getInt("orderNo"));
			m.put("reviewTitle", rs.getString("reviewTitle"));
			m.put("reviewContent", rs.getString("reviewContent"));
			m.put("reviewCheckCnt", rs.getString("reviewCheckCnt"));
			m.put("createdate", rs.getString("createdate"));
			m.put("updatedate", rs.getString("updatedate"));
			m.put("id", rs.getString("id"));
			m.put("reviewOrgFilename", rs.getString("reviewOrgFilename"));
			m.put("reviewSaveFilename", rs.getString("reviewSaveFilename"));
			m.put("reviewFiletype", rs.getString("reviewFiletype"));
			list.add(m);
		}
		System.out.println(list.size());
		return list;
	}
	
	//조회: 리뷰리스트 행의 수 조회
	public int selectReviewCnt(int beginRow, int rowPerPage, String answer) throws Exception {
		if(answer == null) {
			answer = "all";
		}
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		//답변여부에 따라 검색
		String sql = null;
		if(answer.equals("all")) {
			sql = "SELECT COUNT(*) "
					+ "FROM review r LEFT OUTER JOIN (SELECT review_no, COUNT(*) aCnt FROM review_answer GROUP BY review_no) a "
					+ "ON r.review_no = a.review_no ";
		} else if(answer.equals("true")) { //답변이 없는 데이터만 조회
			sql = "SELECT COUNT(*) "
					+ "FROM review r LEFT OUTER JOIN (SELECT review_no, COUNT(*) aCnt FROM review_answer GROUP BY review_no) a "
					+ "ON r.review_no = a.review_no "
					+ "AND aCnt = 0";
		} else { //답변이 있는 데이터만 조회
			sql = "SELECT COUNT(*) "
					+ "FROM review r LEFT OUTER JOIN (SELECT review_no, COUNT(*) aCnt FROM review_answer GROUP BY review_no) a "
					+ "ON r.review_no = a.review_no "
					+ "AND aCnt > 0";
		}
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();
		int row = 0;
		if(rs.next()) {
			row = rs.getInt(1);
		}
		return row;
	}
	
	//조회: 리뷰번호별 리뷰
	public HashMap<String, Object> selectReviewByReviewNo(int reviewNo) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		//답변여부에 따라 검색
		String sql = "SELECT reviewNo, orderNo, reviewTitle, reviewContent, reviewCheckCnt, t1.createdate, t1.updatedate, id, "
				+ "t2.review_ori_filename reviewOrgFilename, t2.review_save_filename reviewSaveFilename, t2.review_filetype reviewFiletype "
				+ "FROM "
				+ "(SELECT r.review_no reviewNo, r.order_no orderNo, r.review_title reviewTitle, r.review_content reviewContent, "
				+ "r.review_check_cnt reviewCheckCnt, r.createdate, r.updatedate, o.id "
				+ "FROM review r INNER JOIN orders o "
				+ "ON r.order_no = o.order_no) t1 LEFT OUTER JOIN review_img t2 "
				+ "ON t1.orderNo = t2.order_no "
				+ "WHERE t1.reviewNo = ? ";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, reviewNo);
		System.out.println(stmt + " <--reviewDao");
		ResultSet rs = stmt.executeQuery();
		HashMap<String, Object> map = null;
		if(rs.next()) {
			map = new HashMap<String, Object>();
			map.put("reviewNo", rs.getInt("reviewNo"));
			map.put("orderNo", rs.getInt("orderNo"));
			map.put("reviewTitle", rs.getString("reviewTitle"));
			map.put("reviewContent", rs.getString("reviewContent"));
			map.put("reviewCheckCnt", rs.getString("reviewCheckCnt"));
			map.put("createdate", rs.getString("createdate"));
			map.put("updatedate", rs.getString("updatedate"));
			map.put("id", rs.getString("id"));
			map.put("reviewOrgFilename", rs.getString("reviewOrgFilename"));
			map.put("reviewSaveFilename", rs.getString("reviewSaveFilename"));
			map.put("reviewFiletype", rs.getString("reviewFiletype"));
		}
		return map;
	}
	
	//조회: 주문번호별 리뷰
	public HashMap<String, Object> selectReviewByOrderNo(int orderNo) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		//답변여부에 따라 검색
		String sql = "SELECT reviewNo, orderNo, reviewTitle, reviewContent, reviewCheckCnt, t1.createdate, t1.updatedate, id, "
				+ "t2.review_ori_filename reviewOrgFilename, t2.review_save_filename reviewSaveFilename, t2.review_filetype reviewFiletype "
				+ "FROM "
				+ "(SELECT r.review_no reviewNo, r.order_no orderNo, r.review_title reviewTitle, r.review_content reviewContent, "
				+ "r.review_check_cnt reviewCheckCnt, r.createdate, r.updatedate, o.id "
				+ "FROM review r INNER JOIN orders o "
				+ "ON r.order_no = o.order_no) t1 LEFT OUTER JOIN review_img t2 "
				+ "ON t1.orderNo = t2.order_no "
				+ "WHERE t1.orderNo = ? ";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, orderNo);
		System.out.println(stmt + " <--reviewDao");
		ResultSet rs = stmt.executeQuery();
		HashMap<String, Object> map = null;
		if(rs.next()) {
			map = new HashMap<String, Object>();
			map.put("reviewNo", rs.getInt("reviewNo"));
			map.put("orderNo", rs.getInt("orderNo"));
			map.put("reviewTitle", rs.getString("reviewTitle"));
			map.put("reviewContent", rs.getString("reviewContent"));
			map.put("reviewCheckCnt", rs.getString("reviewCheckCnt"));
			map.put("createdate", rs.getString("createdate"));
			map.put("updatedate", rs.getString("updatedate"));
			map.put("id", rs.getString("id"));
			map.put("reviewOrgFilename", rs.getString("reviewOrgFilename"));
			map.put("reviewSaveFilename", rs.getString("reviewSaveFilename"));
			map.put("reviewFiletype", rs.getString("reviewFiletype"));
		}
		return map;
	}
	
	//조회: id별 리뷰리스트
	public ArrayList<HashMap<String, Object>> selectReviewListById(String id, int beginRow, int rowPerPage) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		//답변여부에 따라 검색
		String sql = "SELECT reviewNo, orderNo, reviewTitle, reviewContent, reviewCheckCnt, t1.createdate, t1.updatedate, id, "
				+ "t2.review_ori_filename reviewOrgFilename, t2.review_save_filename reviewSaveFilename, t2.review_filetype reviewFiletype "
				+ "FROM "
				+ "(SELECT r.review_no reviewNo, r.order_no orderNo, r.review_title reviewTitle, r.review_content reviewContent, "
				+ "r.review_check_cnt reviewCheckCnt, r.createdate, r.updatedate, o.id "
				+ "FROM review r INNER JOIN orders o "
				+ "ON r.order_no = o.order_no) t1 LEFT OUTER JOIN review_img t2 "
				+ "ON t1.orderNo = t2.order_no "
				+ "WHERE t1.id = ? LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, id);
		stmt.setInt(2, beginRow);
		stmt.setInt(3, rowPerPage);
		System.out.println(stmt + " <--revieDao");
		ResultSet rs = stmt.executeQuery();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		while(rs.next()) {
			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("reviewNo", rs.getInt("reviewNo"));
			map.put("orderNo", rs.getInt("orderNo"));
			map.put("reviewTitle", rs.getString("reviewTitle"));
			map.put("reviewContent", rs.getString("reviewContent"));
			map.put("reviewCheckCnt", rs.getString("reviewCheckCnt"));
			map.put("createdate", rs.getString("createdate"));
			map.put("updatedate", rs.getString("updatedate"));
			map.put("id", rs.getString("id"));
			map.put("reviewOrgFilename", rs.getString("reviewOrgFilename"));
			map.put("reviewSaveFilename", rs.getString("reviewSaveFilename"));
			map.put("reviewFiletype", rs.getString("reviewFiletype"));
		}
		return list;
	}
	
	//조회: id별 리뷰의 수
	public int selectReviewCntById(String id) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "SELECT COUNT(*) FROM review WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, id);
		ResultSet rs = stmt.executeQuery();
		System.out.println(stmt + " <--ordersDao selectReviewCntByOrderNo");
		int row = 0;
		if(rs.next()) {
			row = rs.getInt(1);
		}
		return row;
	}
	
	//조회: 주문번호별 리뷰의 수
	public int selectReviewCntByOrderNo(int orderNo) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "SELECT COUNT(*) FROM review WHERE order_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, orderNo);
		ResultSet rs = stmt.executeQuery();
		System.out.println(stmt + " <--ordersDao selectReviewCntByOrderNo");
		int row = 0;
		if(rs.next()) {
			row = rs.getInt(1);
		}
		return row;
	}
	
	//삽입: 리뷰 등록
	public int insertReview(Review review) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement 
		String sql = "INSERT INTO review (order_no, review_title, review_content, review_check_cnt, createdate, updatedate) "
				+ "VALUES (?, ?, ?, ?, NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, review.getOrderNo());
		stmt.setString(2, review.getReviewTitle());
		stmt.setString(3, review.getReviewContent());
		stmt.setInt(4, review.getReviewCheckCnt());
		int row = stmt.executeUpdate();
		return row;
	}
	
	//수정: 리뷰수정
	public int updateReview(Review review) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "UPDATE review SET review_title = ?, review_content = ?, updatedate = NOW() WHERE review_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, review.getReviewTitle());
		stmt.setString(2, review.getReviewContent());
		stmt.setInt(3, review.getReviewNo());
		int row = stmt.executeUpdate();
		return row;
	}
	
	//수정: 클릭시 조회수 수정
	public int updateReviewCheckCnt(int orderNo, int checkCnt) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "UPDATE review SET review_check_cnt =?, updatedate = NOW() WHERE order_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, orderNo);
		stmt.setInt(2, checkCnt);
		int row = stmt.executeUpdate();
		return row;
	}
	
	//삭제: 리뷰삭제
	public int deleteReview(int reviewNo) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "DELETE FROM review WHERE review_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, reviewNo);		
		int row = stmt.executeUpdate();
		return row;
	}
}
