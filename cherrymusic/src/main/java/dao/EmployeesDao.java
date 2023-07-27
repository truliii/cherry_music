package dao;

import java.util.*;
import java.sql.*;
import vo.*;
import util.*;

public class EmployeesDao {
	//조회: Employees전체 목록 출력(beginRow, rowPerPage)
	public ArrayList<Employees> selectEmployeesListByPage(int beginRow, int rowPerPage) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement 
		String sql = "SELECT id, emp_name empName, emp_level empLevel, createdate, updatedate "
						+ "FROM employees LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		//ResultSet->ArrayList
		ArrayList<Employees> list = new ArrayList<Employees>();
		while(rs.next()) {
			Employees e = new Employees();
			e.setId(rs.getString("id"));
			e.setEmpName(rs.getString("empName"));
			e.setEmpLevel(rs.getString("empLevel"));
			e.setCreatedate(rs.getString("createdate"));
			e.setUpdatedate(rs.getString("updatedate"));
			list.add(e);
		}
		return list;
	}
	
	//조회: Employees의 수
	public int selectEmployeesCnt() throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "SELECT COUNT(*) FROM employees";
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();
		//ResultSet->int
		int row = 0;
		if(rs.next()) {
			row = rs.getInt(1);
		}
		return row;
		}
		
	//조회: 관리자상세조회
	public Employees selectEmployee(String id) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement 
		String sql = "SELECT id, emp_name empName, emp_level empLevel, createdate, updatedate "
						+ "FROM employees WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, id);
		ResultSet rs = stmt.executeQuery();
		//ResultSet->ArrayList
		Employees employee = null;
		if(rs.next()) {
			employee = new Employees();
			employee.setId(rs.getString("id"));
			employee.setEmpName(rs.getString("empName"));
			employee.setEmpLevel(rs.getString("empLevel"));
			employee.setCreatedate(rs.getString("createdate"));
			employee.setUpdatedate(rs.getString("updatedate"));
		}
		return employee;
	}
			
	//삽입: 관리자추가
	public int insertEmployee(Employees employee) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement 
		String sql = "INSERT INTO employees (id, emp_name, emp_level, createdate, updatedate) "
				+ "VALUES (?, ?, ?, NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, employee.getId());
		stmt.setString(2, employee.getEmpName());
		stmt.setString(3, employee.getEmpLevel());
		int row = stmt.executeUpdate();
		return row;
	}
	
	//수정: 관리자정보 수정(회원이 정보 수정)
	public int updateEmployee(Employees employee) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "UPDATE employees SET emp_name = ?, emp_level = ?, updatedate = NOW() WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, employee.getEmpName());
		stmt.setString(2, employee.getEmpLevel());
		stmt.setString(3, employee.getId());
		int row = stmt.executeUpdate();
		return row;
	}
		
	//삭제
	public int deleteEmployee(String id) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "DELETE FROM employees WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, id);
		int row = stmt.executeUpdate();
		return row;
	}
}
