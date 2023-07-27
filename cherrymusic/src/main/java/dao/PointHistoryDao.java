package dao;

import java.util.*;
import java.sql.*;
import vo.*;
import util.*;

public class PointHistoryDao {	
	//조회: id별 포인트이력 조회(적립일 내림차순)
	public ArrayList<HashMap<String, Object>> SelectIdPointHistoryByPage(String id, int beginRow, int rowPerPage) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement 
		String sql = "SELECT order_no orderNo, CONCAT(point_pm, point) point, createdate "
				+ "FROM point_history "
				+ "WHERE order_no IN(SELECT order_no FROM orders WHERE id = ?) "
				+ "ORDER BY createdate DESC "
				+ "LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, id);
		stmt.setInt(2, beginRow);
		stmt.setInt(3, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("orderNo", rs.getInt("orderNo"));
			m.put("point", rs.getString("point"));
			m.put("createdate", rs.getString("createdate"));
			list.add(m);
		}
		return list;
	}
	
	//조회: id별 포인트의 수
	public int SelectIdPointHistoryCnt(String id) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement 
		String sql = "SELECT COUNT(*) cnt "
				+ "FROM point_history "
				+ "WHERE order_no IN(SELECT order_no FROM orders WHERE id = ?) ";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, id);
		ResultSet rs = stmt.executeQuery();
		int row = 0;
		if(rs.next()) {
			row = rs.getInt(1);
		}
		return row;
	}
	
	//조회: id별 포인트합계 조회
	public int SelectIdPointSum(String id) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement 
		String sql = "SELECT SUM(CAST(CONCAT(point_pm, point) AS SIGNED)) pointSum FROM point_history "
				+ "WHERE order_no IN(SELECT order_no FROM orders WHERE id = ?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, id);
		ResultSet rs = stmt.executeQuery();
		int point = 0;
		if(rs.next()) {
			point = rs.getInt("pointSum");
		}
		return point;
	}
	
	//삽입: 포인트 이력추가
	public int insertPointHistory(PointHistory pointHistory) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement 
		String sql = "INSERT INTO point_history (order_no, point_pm, point, createdate) "
				+ "VALUES (?, ?, ?, NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, pointHistory.getOrderNo());
		stmt.setString(2, pointHistory.getPointPm());
		stmt.setInt(3, pointHistory.getPoint());
		int row = stmt.executeUpdate();
		return row;
	}
}
