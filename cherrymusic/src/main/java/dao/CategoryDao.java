package dao;

import java.sql.*;
import java.util.*;
import util.DBUtil;
import vo.Category;

public class CategoryDao {
	
	// 조회
	public ArrayList<Category> selectCategoryList() throws Exception{
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT category_name categoryName, createdate, updatedate FROM category";
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();
		
		ArrayList<Category> list = new ArrayList<>();
		
		while(rs.next()) {
			Category c = new Category();
			c.setCategoryName(rs.getString("categoryName"));
			c.setCreatedate("createdate");
			c.setUpdatedate("updatedate");
			list.add(c);
		}
		
		return list;
	}
	
	// 조회(1개 category)
	public boolean selectCategoryOne(String categoryName) throws Exception{
		
		// 유효성 검사
		if(categoryName == null) {
			System.out.println("입력 error");
			return false;
		}
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT category_name categoryName, createdate, updatedate FROM category WHERE category_name = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, categoryName);
		ResultSet rs = stmt.executeQuery();
		
		if(rs.next()) {
			return true;
		}
		return false;
	}
	
	// 삽입
	public int insertCategory(String categoryName) throws Exception {
		
		// 유효성 검사
		if(categoryName == null) {
			System.out.println("입력 error");
			return 0;
		}
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "INSERT INTO category (category_name, createdate, updatedate) VALUES (?, NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, categoryName);
		int row = stmt.executeUpdate();
		
		return row;
	}
	
	// 수정
	public int updateCategory(String categoryName, String updateCategoryName) throws Exception {
		
		// 유효성 검사
		if(categoryName == null || updateCategoryName == null) {
			System.out.println("입력 error");
			return 0;
		}
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "UPDATE category SET category_name = ?, updatedate = NOW() WHERE category_name = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, updateCategoryName);
		stmt.setString(2, categoryName);
		int row = stmt.executeUpdate();
		
		return row;
	}
	
	// 삭제
	public int deleteCategory(String categoryName) throws Exception {
		
		// 유효성 검사
		if(categoryName == null) {
			System.out.println("입력 error");
			return 0;
		}
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "DELETE FROM category WHERE category_name = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, categoryName);
		int row = stmt.executeUpdate();
		
		return row;
	}
}
