package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import util.DBUtil;
import vo.Product;
import vo.Question;

public class QuestionDao {
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	// 상품문의 전체 row
	public int selectQuestionCnt() throws Exception {
		
		// 반환할 전체 행의 수
		int row = 0;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 값 저장
		PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM question");
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			row = rs.getInt(1);
		}
		return row;
		}
	//	조회수 증가를 위한 메서드
	public Question selectQCheckCnt(int qCheckCnt, int qNo) throws Exception {
		if(qNo == 0) {
			System.out.println(SJ +"잘못된 매개변수	<-- QuestionDao selectQuestion메서드" + RE);
			return null;
		}
		Question question = null;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 저장
		/*
		UPDATE question SET q_check_cnt = ? WHERE q_no = ?
		 */
		String sql = "UPDATE question SET q_check_cnt = ? WHERE q_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, qCheckCnt);
		stmt.setInt(2, qNo);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			question = new Question();
			question.setqCheckCnt(rs.getInt("qCheckCnt"));
		}
		return question;
	}
	// =============상세페이지 내 상품문의==============
	// 상품문의 리스트
	public ArrayList<Question> selectQuestionListByPage(Product product, int beginRow, int rowPerPage) throws Exception {
		if(rowPerPage ==0) {
			System.out.println(SJ +"잘못된 매개변수	<-- QuestionDao selectQuestionListByPage메서드" + RE);
			return null;
		}
		int productNo = product.getProductNo();
		System.out.println(SJ+ productNo + "<-- productNo" + RE );
		ArrayList<Question> list = new ArrayList<>();
		Question question = null;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 저장
		/*
		SELECT q_no qNo, product_no productNo, id, q_category qCategory, q_title qTitle, q_content qContent, q_check_cnt qCheckCnt, createdate, updatedate
		FROM question
		WHERE product_no = ?
		ORDER BY productNo ASC
		LIMIT ?, ?
		 */
		String sql = "SELECT q_no qNo, product_no productNo, id, q_category qCategory, q_title qTitle, q_content qContent, q_check_cnt qCheckCnt, createdate, updatedate\r\n"
				+ "		FROM question\r\n"
				+ "		WHERE product_no = ?\r\n"
				+ "		ORDER BY productNo ASC\r\n"
				+ "		LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, productNo);
		stmt.setInt(2, beginRow);
		stmt.setInt(3, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			question = new Question();
			question.setProductNo(rs.getInt("productNo"));
			question.setqNo(rs.getInt("qNo"));
			question.setId(rs.getString("id"));
			question.setqCategory(rs.getString("qCategory"));
			question.setqTitle(rs.getString("qTitle"));
			question.setqContent(rs.getString("qContent"));
			question.setqCheckCnt(rs.getInt("qCheckCnt"));
			question.setCreatedate(rs.getString("createdate"));
			question.setUpdatedate(rs.getString("updatedate"));
			list.add(question);	
		}
		return list;
	}
	
	// 상품문의 상세보기
	public Question selectQuestion(int qNo) throws Exception {
		if(qNo == 0) {
			System.out.println(SJ +"잘못된 매개변수	<-- QuestionDao selectQuestion메서드" + RE);
			return null;
		}
	Question question = null;
	// db 접속
	DBUtil dbUtil = new DBUtil();
	Connection conn = dbUtil.getConnection();
	// sql 전송 후 결과셋 반환받아 저장
	/*
	SELECT q_no qNo, product_no productNo, id, q_category qCategory, q_title qTitle, q_content qContent, q_check_cnt qCheckCnt, createdate, updatedate
	FROM question
	WHERE q_no = ?
	ORDER BY productNo asc
	 */
	String sql = "SELECT q_no qNo, product_no productNo, id, q_category qCategory, q_title qTitle, q_content qContent, q_check_cnt qCheckCnt, createdate, updatedate\r\n"
			+ "	FROM question\r\n"
			+ "	WHERE q_no = ?\r\n"
			+ "	ORDER BY productNo asc";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, qNo);
	ResultSet rs = stmt.executeQuery();
	if(rs.next()) {
		question = new Question();
		question.setProductNo(rs.getInt("productNo"));
		question.setId(rs.getString("id"));
		question.setqCategory(rs.getString("qCategory"));
		question.setqTitle(rs.getString("qTitle"));
		question.setqContent(rs.getString("qContent"));
		question.setqCheckCnt(rs.getInt("qCheckCnt"));
		question.setCreatedate(rs.getString("createdate"));
		question.setUpdatedate(rs.getString("updatedate"));
	}
	return question;
	}
	// 상품문의 삽입
	public int insertQuestion(Question question) throws Exception {
		if(question == null) {
			System.out.println(SJ +"잘못된 매개변수	<-- QuestionDao insertQuestion메서드" + RE);
			return 0;
		}
		// sql 실행시 영향받은 행의 수 
		int row = 0;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "INSERT INTO question(product_no, id, q_category, q_title, q_content, createdate, updatedate) "
				+ "VALUES(?,?,?,?,?, NOW(),NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, question.getProductNo());
		stmt.setString(2, question.getId());
		stmt.setString(3, question.getqCategory());
		stmt.setString(4, question.getqTitle());
		stmt.setString(5, question.getqContent());
		row = stmt.executeUpdate();
		return row;
	}
	// 상품문의 수정
	public int updateQuestion(Question question) throws Exception {
		if(question == null) {
			System.out.println(SJ +"잘못된 매개변수	<-- QuestionDao updateQuestion메서드" + RE);
			return 0;
		}
		// sql 실행시 영향받은 행의 수 
		int row = 0;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql ="UPDATE question SET q_category = ?, q_title = ?, q_content=?,  updatedate = NOW() WHERE q_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, question.getqCategory());
		stmt.setString(2, question.getqTitle());
		stmt.setString(3, question.getqContent());
		stmt.setInt(4, question.getqNo());
		row = stmt.executeUpdate();
		return row;
	}
	// 상품문의 삭제
	public int deleteQuestion(int qNo) throws Exception {
		if(qNo == 0) {
			System.out.println(SJ +"잘못된 매개변수	<-- QuestionDao deleteQuestion메서드" + RE);
			return 0;
		}
		// sql 실행시 영향받은 행의 수 
		int row = 0;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 영향받은 행의 수 반환받아 저장
		PreparedStatement stmt = conn.prepareStatement("DELETE FROM question WHERE q_no = ?");
		stmt.setInt(1, qNo);
		row = stmt.executeUpdate();
		return row;
	}
}
