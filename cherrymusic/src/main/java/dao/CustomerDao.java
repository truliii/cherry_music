package dao;

import java.util.*;
import java.sql.*;
import vo.*;
import util.*;

public class CustomerDao {
	//조회: Customer전체 목록 출력(매개변수 정렬기준)
	public ArrayList<Customer> selectCustomerListByPage(int beginRow, int rowPerPage) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement 
		String sql = "SELECT id, cstm_name cstmName, cstm_address cstmAddress, cstm_email cstmEmail, cstm_birth cstmBirth, cstm_phone cstmPhone, "
						+ "cstm_gender cstmGender, cstm_rank cstmRank, cstm_point cstmPoint, cstm_last_login cstmLastLogin, cstm_sum_price cstmSumPrice, cstm_agree cstmAgree, "
						+ "createdate, updatedate "
						+ "FROM customer LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		//ResultSet->ArrayList
		ArrayList<Customer> list = new ArrayList<Customer>();
		while(rs.next()) {
			Customer c = new Customer();
			c.setId(rs.getString("id"));
			c.setCstmName(rs.getString("cstmName"));
			c.setCstmAddress(rs.getString("cstmAddress"));
			c.setCstmEmail(rs.getString("cstmEmail"));
			c.setCstmBirth(rs.getString("cstmBirth"));
			c.setCstmPhone(rs.getString("cstmPhone"));
			c.setCstmGender(rs.getString("cstmGender"));
			c.setCstmRank(rs.getString("cstmRank"));
			c.setCstmPoint(rs.getInt("cstmPoint"));
			c.setCstmLastLogin(rs.getString("cstmLastLogin"));
			c.setCstmSumPrice(rs.getInt("cstmSumPrice"));
			c.setCstmAgree(rs.getString("cstmAgree"));
			c.setCreatedate(rs.getString("createdate"));
			c.setUpdatedate(rs.getString("updatedate"));
			list.add(c);
		}
		return list;
	}
	
	//조회: customer의 수
	public int selectCustomerCnt() throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "SELECT COUNT(*) FROM customer";
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();
		//ResultSet->int
		int row = 0;
		if(rs.next()) {
			row = rs.getInt(1);
		}
		return row;
		}
		
	//조회: 회원상세조회
	public Customer selectCustomer(String id) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement 
		String sql = "SELECT id, cstm_name cstmName, cstm_address cstmAddress, cstm_email cstmEmail, cstm_birth cstmBirth, cstm_phone cstmPhone, "
						+ "cstm_gender cstmGender, cstm_rank cstmRank, cstm_point cstmPoint, cstm_last_login cstmLastLogin, cstm_sum_price cstmSumPrice, cstm_agree cstmAgree, "
						+ "createdate, updatedate "
						+ "FROM customer WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, id);
		ResultSet rs = stmt.executeQuery();
		//ResultSet->ArrayList
		Customer customer = new Customer();
		if(rs.next()) {
			customer.setId(rs.getString("id"));
			customer.setCstmName(rs.getString("cstmName"));
			customer.setCstmAddress(rs.getString("cstmAddress"));
			customer.setCstmEmail(rs.getString("cstmEmail"));
			customer.setCstmBirth(rs.getString("cstmBirth"));
			customer.setCstmPhone(rs.getString("cstmPhone"));
			customer.setCstmGender(rs.getString("cstmGender"));
			customer.setCstmRank(rs.getString("cstmRank"));
			customer.setCstmPoint(rs.getInt("cstmPoint"));
			customer.setCstmLastLogin(rs.getString("cstmLastLogin"));
			customer.setCstmSumPrice(rs.getInt("cstmSumPrice"));
			customer.setCstmAgree(rs.getString("cstmAgree"));
			customer.setCreatedate(rs.getString("createdate"));
			customer.setUpdatedate(rs.getString("updatedate"));
		}
		return customer;
	}
			
	//삽입: 회원추가
	public int insertCustomer(Customer customer) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement 
		String sql = "INSERT INTO customer (id, cstm_name, cstm_address, cstm_email, cstm_birth, cstm_phone, cstm_gender, cstm_point, cstm_last_login, cstm_sum_price, createdate, updatedate) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), ?, NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, customer.getId());
		stmt.setString(2, customer.getCstmName());
		stmt.setString(3, customer.getCstmAddress());
		stmt.setString(4, customer.getCstmEmail());
		stmt.setString(5, customer.getCstmBirth());
		stmt.setString(6, customer.getCstmPhone());
		stmt.setString(7, customer.getCstmGender());
		stmt.setInt(8, customer.getCstmPoint());
		stmt.setInt(9, customer.getCstmSumPrice());
		int row = stmt.executeUpdate();
		return row;
	}
	
	//수정: 회원정보 수정(회원이 정보 수정)
	public int updateCustomer(Customer customer) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "UPDATE customer SET cstm_name = ?, cstm_address = ?, cstm_email = ?, cstm_birth = ?, cstm_phone = ?, cstm_gender = ?, updatedate = NOW() WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, customer.getCstmName());
		stmt.setString(2, customer.getCstmAddress());
		stmt.setString(3, customer.getCstmEmail());
		stmt.setString(4, customer.getCstmBirth());
		stmt.setString(5, customer.getCstmPhone());
		stmt.setString(6, customer.getCstmGender());
		stmt.setString(7, customer.getId());
		int row = stmt.executeUpdate();
		return row;
	}
	
	//수정: 포인트 업데이트
	public int updatePoint(String id) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "UPDATE customer SET cstm_point = ? WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		PointHistoryDao pHistory = new PointHistoryDao();
		stmt.setInt(1, pHistory.SelectIdPointSum(id));
		stmt.setString(2, id);
		int row = stmt.executeUpdate();
		return row;
	}
	
	//수정: 주소 업데이트
	public int updateAddress(String id, String addr) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "UPDATE customer SET cstm_address = ? WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, addr);
		stmt.setString(2, id);
		int row = stmt.executeUpdate();
		return row;
	}
	
	//수정: 마지막로그인 업데이트
	public int updateLastLogin(String id) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "UPDATE customer SET cstm_last_login = NOW() WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, id);
		int row = stmt.executeUpdate();
		return row;
	}
	
	//수정: 총구매액 업데이트
	public int updateSumPrice(String id) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "UPDATE customer SET cstm_sum_price = (SELECT nvl(sum(order_price),0) sumPrice FROM orders WHERE id = ? AND delivery_status = '배송완료')";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, id);
		int row = stmt.executeUpdate();
		return row;
	}
	
	//삭제
	public int deleteCustomer(String id) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "DELETE FROM customer WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, id);
		int row = stmt.executeUpdate();
		return row;
	}
}
