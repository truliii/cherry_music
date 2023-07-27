package dao;

import util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

import vo.*;

public class BoardQuestionDao {
	
	// RESET ANST CODE 콘솔창 글자색, 배경색 지정
	final String RESET = "\u001B[0m";
	final String BLUE ="\u001B[34m";
	final String BG_YELLOW ="\u001B[43m";
		
	/* 조회
	 * 1. 전체 조회 (searchWord.equals(""))
	 * 2. 제목+내용, searchWord (searchWord.equals("") == false && columnName.equals("titleContent"))
	 * 3. 제목, searchWord (searchWord.equals("") == false && columnName.equals("title"))
	 * 4. 내용, searchWord (searchWord.equals("") == false && columnName.equals("content"))
	 * 5. 작성자, searchWord (searchWord.equals("") == false && columnName.equals("cstmName"))
	 * 6. 전체, searchWord(searchWord.equals("") == false && columnName.equals(""))
	 
	 * String searchWord : sql = Like ?(searchWord)
	 * String columnName : columnName.equals()
	*/
	
	public ArrayList<HashMap<String, Object>> selectBoardQuestionByPage
	(int beginRow, int rowPerPage, String searchWord, String columnName) throws Exception{
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = null;
		PreparedStatement stmt = null;
		
		if(searchWord.equals("") || columnName.equals("")) { // 1. 전체 조회
			
			sql = "SELECT bq.board_q_no boardQNo, bq.id, bq.board_q_category boardQCategory, bq.board_q_title boardQTitle, bq.board_q_content boardQContent, "
				+ "bq.board_q_check_cnt boardQCheckCnt, bq.createdate createdate, bq.updatedate updatedate, count(ba.board_a_no) boardANoCnt, c.cstm_name cstmName "
				+ "FROM board_question bq left OUTER JOIN board_answer ba "
				+ "ON bq.board_q_no = ba.board_q_no "
				+ "LEFT OUTER JOIN customer c "
				+ "ON bq.id = c.id "
				+ "GROUP BY bq.board_q_no "
				+ "ORDER BY createdate DESC LIMIT ?, ?";
			
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1,beginRow);
			stmt.setInt(2,rowPerPage);
			System.out.println(BG_YELLOW+BLUE+stmt +"<--BoardQuestionDao 1.stmt"+RESET);
			
		} else if(searchWord.equals("") == false && columnName.equals("titleContent")){ // 2. 제목+내용, searchWord
			
			sql = "SELECT bq.board_q_no boardQNo, bq.id, bq.board_q_category boardQCategory, bq.board_q_title boardQTitle, bq.board_q_content boardQContent, "
				+ "bq.board_q_check_cnt boardQCheckCnt, bq.createdate createdate, bq.updatedate updatedate, count(ba.board_a_no) boardANoCnt, c.cstm_name cstmName "
				+ "FROM board_question bq left OUTER JOIN board_answer ba "
				+ "ON bq.board_q_no = ba.board_q_no "
				+ "LEFT OUTER JOIN customer c "
				+ "ON bq.id = c.id "
				+ "WHERE bq.board_q_title LIKE ? or bq.board_q_content LIKE ? "
				+ "GROUP BY bq.board_q_no "
				+ "ORDER BY createdate DESC LIMIT ?, ?";
			
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, "%"+searchWord+"%");
			stmt.setString(2, "%"+searchWord+"%");
			stmt.setInt(3, beginRow);
			stmt.setInt(4, rowPerPage);
			System.out.println(BG_YELLOW+BLUE+stmt +"<--BoardQuestionDao 2.stmt"+RESET);
			
		} else if(searchWord.equals("") == false && columnName.equals("title")) { // 3. 제목, searchWord
			
			sql = "SELECT bq.board_q_no boardQNo, bq.id, bq.board_q_category boardQCategory, bq.board_q_title boardQTitle, bq.board_q_content boardQContent, "
				+ "bq.board_q_check_cnt boardQCheckCnt, bq.createdate createdate, bq.updatedate updatedate, count(ba.board_a_no) boardANoCnt, c.cstm_name cstmName "
				+ "FROM board_question bq left OUTER JOIN board_answer ba "
				+ "ON bq.board_q_no = ba.board_q_no "
				+ "LEFT OUTER JOIN customer c "
				+ "ON bq.id = c.id "
				+ "WHERE bq.board_q_title LIKE ? "
				+ "GROUP BY bq.board_q_no "
				+ "ORDER BY createdate DESC LIMIT ?, ?";
			
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, "%"+searchWord+"%");
			stmt.setInt(2, beginRow);
			stmt.setInt(3, rowPerPage);
			System.out.println(BG_YELLOW+BLUE+stmt +"<--BoardQuestionDao 3.stmt"+RESET);
			
		} else if(searchWord.equals("") == false && columnName.equals("content")) { // 4. 내용, searchWord
			
			sql = "SELECT bq.board_q_no boardQNo, bq.id, bq.board_q_category boardQCategory, bq.board_q_title boardQTitle, bq.board_q_content boardQContent, "
				+ "bq.board_q_check_cnt boardQCheckCnt, bq.createdate createdate, bq.updatedate updatedate, count(ba.board_a_no) boardANoCnt, c.cstm_name cstmName "
				+ "FROM board_question bq left OUTER JOIN board_answer ba "
				+ "ON bq.board_q_no = ba.board_q_no "
				+ "LEFT OUTER JOIN customer c "
				+ "ON bq.id = c.id "
				+ "WHERE bq.board_q_content LIKE ? "
				+ "GROUP BY bq.board_q_no "
				+ "ORDER BY createdate DESC LIMIT ?, ?";
			
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, "%"+searchWord+"%");
			stmt.setInt(2, beginRow);
			stmt.setInt(3, rowPerPage);
			System.out.println(BG_YELLOW+BLUE+stmt +"<--BoardQuestionDao 4.stmt"+RESET);
			
		} else if(searchWord.equals("") == false && columnName.equals("cstmName")) { // 5. 작성자, searchWord
			
			sql = "SELECT bq.board_q_no boardQNo, bq.id, bq.board_q_category boardQCategory, bq.board_q_title boardQTitle, bq.board_q_content boardQContent, "
				+ "bq.board_q_check_cnt boardQCheckCnt, bq.createdate createdate, bq.updatedate updatedate, count(ba.board_a_no) boardANoCnt, c.cstm_name cstmName "
				+ "FROM board_question bq left OUTER JOIN board_answer ba "
				+ "ON bq.board_q_no = ba.board_q_no "
				+ "LEFT OUTER JOIN customer c "
				+ "ON bq.id = c.id "
				+ "WHERE c.cstm_name LIKE ? "
				+ "GROUP BY bq.board_q_no "
				+ "ORDER BY createdate DESC LIMIT ?, ?";
			
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, "%"+searchWord+"%");
			stmt.setInt(2, beginRow);
			stmt.setInt(3, rowPerPage);
			System.out.println(BG_YELLOW+BLUE+stmt +"<--BoardQuestionDao 5.stmt"+RESET);
			
		} else if(searchWord.equals("") == false && columnName.equals("")) { // 6. 전체, searchWord
			sql = "SELECT bq.board_q_no boardQNo, bq.id, bq.board_q_category boardQCategory, bq.board_q_title boardQTitle, bq.board_q_content boardQContent, "
				+ "bq.board_q_check_cnt boardQCheckCnt, bq.createdate createdate, bq.updatedate updatedate, count(ba.board_a_no) boardANoCnt, c.cstm_name cstmName "
				+ "FROM board_question bq left OUTER JOIN board_answer ba "
				+ "ON bq.board_q_no = ba.board_q_no "
				+ "LEFT OUTER JOIN customer c "
				+ "ON bq.id = c.id "
				+ "WHERE bq.board_q_title LIKE ? or bq.board_q_content LIKE ? or c.cstm_name LIKE ? "
				+ "GROUP BY bq.board_q_no "
				+ "ORDER BY createdate DESC LIMIT ?, ?";
			
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, "%"+searchWord+"%");
			stmt.setString(2, "%"+searchWord+"%");
			stmt.setString(3, "%"+searchWord+"%");
			stmt.setInt(4, beginRow);
			stmt.setInt(5, rowPerPage);
			System.out.println(BG_YELLOW+BLUE+stmt +"<--BoardQuestionDao 6.stmt"+RESET);
		}
		
		ResultSet rs = stmt.executeQuery();
		
		ArrayList<HashMap<String,Object>> list = new ArrayList<>();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<>();
			m.put("boardQNo", rs.getInt("boardQNo"));
			m.put("id", rs.getString("id"));
			m.put("boardQCategory", rs.getString("boardQCategory"));
			m.put("boardQTitle", rs.getString("boardQTitle"));
			m.put("boardQContent", rs.getString("boardQContent"));
			m.put("boardQCheckCnt", rs.getInt("boardQCheckCnt"));
			m.put("createdate", rs.getString("createdate"));
			m.put("updatedate", rs.getString("updatedate"));
			m.put("boardANoCnt", rs.getInt("boardANoCnt"));
			m.put("cstmName", rs.getString("cstmName"));
			list.add(m);
		}
		return list;
	}
	
	// 상세 조회(board_question)
	public BoardQuestion selectBoardQuestionOne(int boardQuestionNo) throws Exception {
		
		// 유효성 검사
		if(boardQuestionNo == 0) {
			System.out.println("입력 error");
			return null;
		}
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT board_q_no boardQNo, id, board_q_category boardQCategory, board_q_title boardQTitle, board_q_content boardQContent, board_q_check_cnt boardQCheckCnt, createdate, updatedate "
				+ "FROM board_question WHERE board_q_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, boardQuestionNo);
		ResultSet rs = stmt.executeQuery();
		
		BoardQuestion boardQuestion = null;
		if(rs.next()) {
			boardQuestion = new BoardQuestion();
			boardQuestion.setBoardQNo(rs.getInt("boardQNo"));
			boardQuestion.setId(rs.getString("id"));
			boardQuestion.setBoardQCategory(rs.getString("boardQCategory"));
			boardQuestion.setBoardQTitle(rs.getString("boardQTitle"));
			boardQuestion.setBoardQContent(rs.getString("boardQContent"));
			boardQuestion.setBoardQCheckCnt(rs.getInt("boardQCheckCnt"));
			boardQuestion.setCreatedate(rs.getString("createdate"));
			boardQuestion.setUpdatedate(rs.getString("updatedate"));
		}
		return boardQuestion;
	}
	
	// 삽입
	public int insertBoardQuestion(BoardQuestion boardQuestion) throws Exception {
		
		// 유효성 검사
		if(boardQuestion == null) {
			System.out.println("입력 error");
			return 0;
		}
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "INSERT INTO board_question(id, board_q_category, board_q_title, board_q_content, board_q_check_cnt, createdate, updatedate) "
				+ "VALUES (?, ?, ?, ?, 0, NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, boardQuestion.getId());
		stmt.setString(2, boardQuestion.getBoardQCategory());
		stmt.setString(3, boardQuestion.getBoardQTitle());
		stmt.setString(4, boardQuestion.getBoardQContent());
		int row = stmt.executeUpdate();
		
		return row;
		
	}
	
	// 수정
	public int updateBoardQuestion(BoardQuestion boardQuestion) throws Exception {
		
		// 유효성 검사
		if(boardQuestion == null) {
			System.out.println("입력 error");
			return 0;
		}
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "UPDATE board_question SET board_q_category = ?, board_q_title = ?, board_q_content = ?, updatedate = NOW() "
				+ "WHERE board_q_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, boardQuestion.getBoardQCategory());
		stmt.setString(2, boardQuestion.getBoardQTitle());
		stmt.setString(3, boardQuestion.getBoardQContent());
		stmt.setInt(4, boardQuestion.getBoardQNo());
		int row = stmt.executeUpdate();
		
		return row;
	}
	
	// 조회수 수정
	public int updateBoardQuestionCheckCnt(int boardQNo) throws Exception {
		
		// 유효성 검사
		if(boardQNo == 0) {
			System.out.println("입력 error");
			return 0;
		}
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "UPDATE board_question SET board_q_check_cnt = board_q_check_cnt + 1 WHERE board_q_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, boardQNo);
		int row = stmt.executeUpdate();
		
		return row;
	}
	
	// 삭제
	public int deleteBoardQuestion(int boardQuestionNo) throws Exception {
		
		// 유효성 검사
		if(boardQuestionNo == 0) {
			System.out.println("입력 error");
			return 0;
		}
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "DELETE FROM board_question WHERE board_q_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, boardQuestionNo);
		int row = stmt.executeUpdate();
		
		return row;
		
	}
	
	/* 출력되는 전체 행의 수(boardQuestionList)
	 * 1. 전체 조회 (searchWord.equals(""))
	 * 2. 제목+내용, searchWord (searchWord.equals("") == false && columnName.equals("titleContent"))
	 * 3. 제목, searchWord (searchWord.equals("") == false && columnName.equals("title"))
	 * 4. 내용, searchWord (searchWord.equals("") == false && columnName.equals("content"))
	 * 5. 작성자, searchWord (searchWord.equals("") == false && columnName.equals("cstmName"))
	 * 6. 전체, searchWord(searchWord.equals("") == false && columnName.equals(""))
	*/
	
	public int selectBoardQuestionListCnt(String searchWord, String columnName) throws Exception {
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = null;
		PreparedStatement stmt = null;
		
		if(searchWord.equals("")) { // 1. 전체 조회
			
			sql = "SELECT COUNT(*) FROM board_question"; 
			
			stmt = conn.prepareStatement(sql);
			System.out.println(BG_YELLOW+BLUE+stmt +"<--BoardQuestionDao cnt 1.stmt"+RESET);
			
		} else if(searchWord.equals("") == false && columnName.equals("titleContent")){ // 2. 제목+내용, searchWord
			
			sql = "SELECT COUNT(*) "
				+ "FROM board_question "
				+ "WHERE board_q_title LIKE ? OR board_q_content LIKE ?";
			
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, "%"+searchWord+"%");
			stmt.setString(2, "%"+searchWord+"%");
			System.out.println(BG_YELLOW+BLUE+stmt +"<--BoardQuestionDao cnt 2.stmt"+RESET);
			
		} else if(searchWord.equals("") == false && columnName.equals("title")) { // 3. 제목, searchWord
			
			sql = "SELECT COUNT(*) "
				+ "FROM board_question "
				+ "WHERE board_q_title LIKE ?";
			
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, "%"+searchWord+"%");
			System.out.println(BG_YELLOW+BLUE+stmt +"<--BoardQuestionDao cnt 3.stmt"+RESET);
			
		} else if(searchWord.equals("") == false && columnName.equals("content")) { // 4. 내용, searchWord
			
			sql = "SELECT COUNT(*) "
				+ "FROM board_question "
				+ "WHERE board_q_content LIKE ? ";
			
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, "%"+searchWord+"%");
			System.out.println(BG_YELLOW+BLUE+stmt +"<--BoardQuestionDao cnt 4.stmt"+RESET);
			
		} else if(searchWord.equals("") == false && columnName.equals("cstmName")) { // 5. 작성자, searchWord
			
			sql = "SELECT COUNT(*) "
				+ "FROM board_question bq LEFT OUTER JOIN customer c "
				+ "ON bq.id = c.id "
				+ "WHERE c.cstm_name LIKE ? ";
			
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, "%"+searchWord+"%");
			System.out.println(BG_YELLOW+BLUE+stmt +"<--BoardQuestionDao cnt 5.stmt"+RESET);
			
		} else if(searchWord.equals("") == false && columnName.equals("")) { // 6. 전체, searchWord
			sql = "SELECT COUNT(*) "
				+ "FROM board_question bq LEFT OUTER JOIN customer c "
				+ "ON bq.id = c.id "
				+ "WHERE bq.board_q_title LIKE ? or bq.board_q_content LIKE ? or c.cstm_name LIKE ?";
				
				stmt = conn.prepareStatement(sql);
				stmt.setString(1, "%"+searchWord+"%");
				stmt.setString(2, "%"+searchWord+"%");
				stmt.setString(3, "%"+searchWord+"%");
				System.out.println(BG_YELLOW+BLUE+stmt +"<--BoardQuestionDao cnt 6.stmt"+RESET);
			}
		
		ResultSet rs = stmt.executeQuery();
		
		int totalRow = 0;
		if(rs.next()) {
			totalRow = rs.getInt(1);
		}
		
		return totalRow;
	}
}
