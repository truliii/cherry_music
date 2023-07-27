package dao;

import java.sql.*;
import java.util.*;
import vo.*;
import util.*;

public class ReviewAnswerDao {
	//조회: 리뷰번호별 답변
	public ArrayList<ReviewAnswer> selectReviewAnswerList(int reviewNo) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "SELECT review_no reviewNo, review_a_content reviewAContent, createdate, updatedate "
				+ "FROM review_answer "
				+ "WHERE review_no = ?;";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, reviewNo);
		ResultSet rs = stmt.executeQuery();
		ArrayList<ReviewAnswer> list = new ArrayList<ReviewAnswer>();
		while(rs.next()) {
			ReviewAnswer rAnswer = null;
			rAnswer = new ReviewAnswer();
			rAnswer.setReviewNo(reviewNo);
			rAnswer.setReviewAContent(rs.getString("reviewAContent"));
			rAnswer.setCreatedate(rs.getString("createdate"));
			rAnswer.setUpdatedate(rs.getString("updatedate"));
			list.add(rAnswer);
		}
		return list;
	}
	
	//조회: 리뷰번호별 답변 수 (1이상이면 답변 완료로 처리)
	public int selectReviewAnswerCnt(int reviewNo) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "SELECT COUNT(*) cnt FROM review_answer WHERE review_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, reviewNo);
		ResultSet rs = stmt.executeQuery();
		int row = 0;
		if(rs.next()) {
			row = rs.getInt("cnt");
		}
		return row;
	}
	
	//삽입: 리뷰답변
	public int insertReviewAnswer(ReviewAnswer rAnswer) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement 
		String sql = "INSERT INTO review_answer (review_no, review_a_content, createdate, updatedate) "
				+ "VALUES (?, ?, NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, rAnswer.getReviewNo());
		stmt.setString(2, rAnswer.getReviewAContent());
		int row = stmt.executeUpdate();
		return row;
	}
	
	//수정: 리뷰수정
	public int updateReviewAnswer(ReviewAnswer rAnswer) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "UPDATE review_answer SET review_a_content = ?, updatedate = NOW() WHERE review_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, rAnswer.getReviewAContent());
		stmt.setInt(2, rAnswer.getReviewNo());
		int row = stmt.executeUpdate();
		return row;
	}
	
	//삭제: 리뷰답변 삭제
	public int deleteReviewAnswer(int reviewNo) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "DELETE FROM review_answer WHERE review_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, reviewNo);		
		int row = stmt.executeUpdate();
		return row;
	}
}
