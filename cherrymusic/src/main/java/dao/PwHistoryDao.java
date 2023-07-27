package dao;

import java.sql.*;
import java.util.*;
import vo.*;
import util.*;

public class PwHistoryDao {
	//조회: id별 비밀번호이력
	public ArrayList<PwHistory> selectPwHistory(String id) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "SELECT pw_no pwNo, id, pw, createdate FROM pw_history WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, id);
		ResultSet rs = stmt.executeQuery();
		//ResultSet->int
		ArrayList<PwHistory> list = new ArrayList<PwHistory>();
		while(rs.next()) {
			PwHistory p = new PwHistory();
			p.setPwNo(rs.getInt("pwNo"));
			p.setId(rs.getString("id"));
			p.setPw(rs.getString("pw"));
			p.setCreatedate(rs.getString("createdate"));
			list.add(p);
		}
		return list;
		}
	
	//조회: id별 비밀번호이력의 수
	public int selectPwHistoryCnt(String id) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "SELECT COUNT(*) FROM pw_history WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, id);
		ResultSet rs = stmt.executeQuery();
		//ResultSet->int
		int row = 0;
		if(rs.next()) {
			row = rs.getInt(1);
		}
		return row;
		}
	
	//조회: 새로입력한 비밀번호와 pw_history테이블에 있는 비밀번호 비교 후 boolean리턴
	public boolean selectPwHistoryCompare(String id, String newPw) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "SELECT COUNT(*) FROM pw_history WHERE id = ? AND pw = PASSWORD(?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, id);
		stmt.setString(2, newPw);
		ResultSet rs = stmt.executeQuery();
		//ResultSet->int
		int row = 0;
		if(rs.next()) {
			row = rs.getInt(1);
		}
		boolean usedPw = false;
		if(row >0) {
			usedPw = true;
		}
		return usedPw;
		}
		
	//삽입: 비밀번호 이력추가
	public int insertPwHistory(PwHistory pwHistory) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement 
		String sql = "INSERT INTO pw_history (id, pw, createdate) "
				+ "VALUES (?, PASSWORD(?), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, pwHistory.getId());
		stmt.setString(2, pwHistory.getPw());
		stmt.setString(3, pwHistory.getCreatedate());
		int row = stmt.executeUpdate();
		return row;
	}
			
	//삭제: 가장 오래된 pw이력 삭제
	public int deletePwHistory(String id) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "DELETE FROM pw_history WHERE id = ? and createdate = (SELECT MIN(createdate) pwNo FROM pw_history group by id having id = ?);";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, id);
		stmt.setString(2, id);
		int row = stmt.executeUpdate();
		return row;
	}
}
