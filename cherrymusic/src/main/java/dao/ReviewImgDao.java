package dao;

import java.util.*;
import java.sql.*;
import vo.*;
import util.*;

public class ReviewImgDao {
	//조회: 주문번호별 리뷰이미지 (1개만 가능)
	public ReviewImg selectReviewImg(int orderNo) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "SELECT order_no orderNo, review_ori_filename reviewOriFilename, review_save_filename reviewSaveFilename, review_filetype reviewFiletype, createdate, updatedate "
					+ "FROM review_img";
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();
		ReviewImg rImg = null;
		if(rs.next()) {
			rImg = new ReviewImg();
			rImg.setOrderNo(rs.getInt("orderNo"));
			rImg.setReviewOriFilename(rs.getString("reviewOriFilename"));
			rImg.setReviewSaveFilename(rs.getString("reviewSaveFilename"));
			rImg.setReviewFiletype(rs.getString("reviewFiletype"));
			rImg.setCreatedate(rs.getString("createdate"));
			rImg.setUpdatedate(rs.getString("updatedate"));
		}
		return rImg;
	}
		
	//삽입: 리뷰이미지 등록
	public int insertReviewImg(ReviewImg rImg) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement 
		String sql = "INSERT INTO review_img (order_no, review_ori_filename, review_save_filename, review_filetype, createdate, updatedate) "
				+ "VALUES (?, ?, ?, ?, NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, rImg.getOrderNo());
		stmt.setString(2, rImg.getReviewOriFilename());
		stmt.setString(3, rImg.getReviewSaveFilename());
		stmt.setString(4, rImg.getReviewFiletype());
		int row = stmt.executeUpdate();
		return row;
	}
	
	//수정: 리뷰이미지 수정
	public int updateReviewImg(ReviewImg rImg) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "UPDATE review_img SET review_ori_filename = ?, review_save_filename = ?, review_filetype =?, updatedate = NOW() WHERE order_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, rImg.getReviewOriFilename());
		stmt.setString(2, rImg.getReviewSaveFilename());
		stmt.setString(3, rImg.getReviewFiletype());
		stmt.setInt(4, rImg.getOrderNo());
		int row = stmt.executeUpdate();
		return row;
	}
	
	//삭제: 리뷰이미지 삭제
	public int deleteReviewImg(int orderNo) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "DELETE FROM review_img WHERE order_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, orderNo);		
		int row = stmt.executeUpdate();
		return row;
	}
}
