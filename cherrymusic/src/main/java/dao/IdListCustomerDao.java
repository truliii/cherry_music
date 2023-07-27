package dao;

import java.sql.*;
import java.util.*;
import util.DBUtil;

public class IdListCustomerDao {
	
	// RESET ANST CODE 콘솔창 글자색, 배경색 지정
	final String RESET = "\u001B[0m";
	final String BLUE ="\u001B[34m";
	final String BG_YELLOW ="\u001B[43m";
	
	/* 1. 회원(고객, 관리자) 전체 조회 (ckIdLevel == null && ckCstmRank == null && ckActive == null)
	 * 2. 고객 / 관리자 검색 조회 (ckCstmRank == null && ckActive == null) 
	 * 3. 등급 검색 조회 (ckIdLevel == null && ckActive == null)
	 * 4. 활성화 여부 검색 조회 (ckIdLevel == null && ckCstmRank == null)
	 * 5. 등급, 활성화 검색 조회 (ckIdLevel == null)
	 * 6. 고객or관리자 등급 검색 조회 (ckActive == null)
	 * 7. 고객or관리자, 활성화 검색 조회 (ckCstmRank == null)
	 * 8. 고객, 등급, 활성화 여부 검색 조회
	 
	 * 조회컬럼 : id, 활성화 여부, 고객등급
	 * 정렬 : 1. 회원 id_level DESC(내림차순) 2. id ASC(오름차순)
	 
	 * String[] ckActive : active 배열
	 * int[] ckIdLevel : id_level 배열
	 * String [] ckCstmRank : cstm_rank 배열
	 */
	
	public ArrayList<HashMap<String, Object>> selectIdCstmListByPage
	(int beginRow, int rowPerPage, int[] ckIdLevel, String[] ckCstmRank, String[] ckActive) throws Exception{
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = null;
		PreparedStatement stmt = null;
		
		if(ckIdLevel == null && ckCstmRank == null && ckActive == null) { // 1. 회원(고객, 관리자) 전체 조회
			sql = "SELECT i.id id, i.active active, nvl(c.cstm_rank, '') cstmRank, c.cstm_name cstmName "
				+ "FROM id_list i LEFT outer JOIN customer c "
				+ "ON i.id = c.id "
				+ "ORDER BY i.id_level DESC, i.id ASC LIMIT ?, ?";
				
				stmt = conn.prepareStatement(sql);
				stmt.setInt(1,beginRow);
				stmt.setInt(2,rowPerPage);
				System.out.println(BG_YELLOW+BLUE+stmt +"<--IdListCustomerDao 1.stmt"+RESET);
			
		} else if(ckCstmRank == null && ckActive == null) { // 2. 고객 / 관리자 선택 조회
			sql = "SELECT i.id id, i.id_level idLevel, i.active active, nvl(c.cstm_rank, '') cstmRank, c.cstm_name cstmName "
				+ "FROM id_list i LEFT outer JOIN customer c "
				+ "ON i.id = c.id "
				+ "WHERE id_level IN(? ";
				
				for(int i=1; i<ckIdLevel.length; i+=1){ // ckIdLevel 배열의 길이 만큼 ? 셋팅
					sql += ",?";
				}
				sql+= ") ORDER BY id_level DESC, id ASC LIMIT ?, ?";
				
				stmt = conn.prepareStatement(sql);
				for(int i=0; i<ckIdLevel.length; i+=1){ // ckIdLevel 배열의 길이만큼 ?의 값 저장
					stmt.setInt(i+1, ckIdLevel[i]);
					System.out.println(BG_YELLOW+BLUE+ckIdLevel[i] +"<--IdListCustomerDao ckIdLevel[i]"+RESET);
				}
				stmt.setInt(ckIdLevel.length+1, beginRow);
				stmt.setInt(ckIdLevel.length+2, rowPerPage);
				System.out.println(BG_YELLOW+BLUE+stmt +"<--IdListCustomerDao 2.stmt"+RESET);
				
		} else if(ckIdLevel == null && ckActive == null) { // 3. 등급 선택 조회
			sql = "SELECT i.id id, i.id_level idLevel, i.active active, nvl(c.cstm_rank, '') cstmRank, c.cstm_name cstmName "
				+ "FROM id_list i LEFT outer JOIN customer c "
				+ "ON i.id = c.id "
				+ "WHERE cstm_rank IN (? ";
			
				for(int i=1; i<ckCstmRank.length; i+=1){ // ckCstmRank 배열의 길이 만큼 ? 셋팅
					sql += ",?";
				}
				sql+= ") ORDER BY id_level DESC, id ASC LIMIT ?, ?";
				
				stmt = conn.prepareStatement(sql);
				for(int i=0; i<ckCstmRank.length; i+=1) { // ckCstmRank 배열의 길이 만큼 ?의 값 저장
					stmt.setString(i+1, ckCstmRank[i]);
					System.out.println(BG_YELLOW+BLUE+ckCstmRank[i] +"<--IdListCustomerDao ckCstmRank[i]"+RESET);
				}
				stmt.setInt(ckCstmRank.length+1, beginRow);
				stmt.setInt(ckCstmRank.length+2, rowPerPage);
				System.out.println(BG_YELLOW+BLUE+stmt +"<--IdListCustomerDao 3.stmt"+RESET);
				
		} else if(ckIdLevel == null && ckCstmRank == null) { // 4. 활성화 조회
			sql = "SELECT i.id id, i.id_level idLevel, i.active active, nvl(c.cstm_rank, '') cstmRank, c.cstm_name cstmName "
				+ "FROM id_list i LEFT outer JOIN customer c "
				+ "ON i.id = c.id "
				+ "WHERE active IN (? ";
				
				for(int i=1; i<ckActive.length; i+=1){ // ckActive 배열의 길이 만큼 ? 셋팅
					sql += ",?";
				}
				sql+= ") ORDER BY id_level DESC, id ASC LIMIT ?, ?";
		
				stmt = conn.prepareStatement(sql);
				for(int i=0; i<ckActive.length; i+=1){ // ckActive 배열의 길이 만큼 ?의 값 저장
					stmt.setString(i+1, ckActive[i]);
					System.out.println(BG_YELLOW+BLUE+ckActive[i] +"<--IdListCustomerDao ckActive[i]"+RESET);
				}
				stmt.setInt(ckActive.length+1, beginRow);
				stmt.setInt(ckActive.length+2, rowPerPage);
				System.out.println(BG_YELLOW+BLUE+stmt +"<--IdListCustomerDao 4.stmt"+RESET);
				
		} else if(ckIdLevel == null) { // 5. 등급, 활성화 검색 조회
			sql = "SELECT i.id id, i.id_level idLevel, i.active active, nvl(c.cstm_rank, '') cstmRank, c.cstm_name cstmName "
				+ "FROM id_list i LEFT outer JOIN customer c "
				+ "ON i.id = c.id "
				+ "WHERE cstm_rank IN (? ";
			
				for(int i=1; i<ckCstmRank.length; i+=1){ // ckCstmRank 배열의 길이 만큼 ? 셋팅
					sql += ",?";
				}
				sql+=") AND active IN (? ";
				
				for(int i=1; i<ckActive.length; i+=1){ // ckActive 배열의 길이 만큼 ? 셋팅
					sql += ",?";
				}
				sql+= ") ORDER BY id_level DESC, id ASC LIMIT ?, ?";
				
				stmt = conn.prepareStatement(sql);
				for(int i=0; i<ckCstmRank.length; i+=1) { // ckCstmRank 배열의 길이 만큼 ?의 값 저장
					stmt.setString(i+1, ckCstmRank[i]);
					System.out.println(BG_YELLOW+BLUE+ckCstmRank[i] +"<--IdListCustomerDao ckCstmRank[i]"+RESET);
				}
				for(int i=0; i<ckActive.length; i+=1){ // ckActive 배열의 길이 만큼 ?의 값 저장
					stmt.setString(ckCstmRank.length+i+1, ckActive[i]);
					System.out.println(BG_YELLOW+BLUE+ckActive[i] +"<--IdListCustomerDao ckActive[i]"+RESET);
				}
				stmt.setInt(ckCstmRank.length+ckActive.length+1, beginRow);
				stmt.setInt(ckCstmRank.length+ckActive.length+2, rowPerPage);
				System.out.println(BG_YELLOW+BLUE+stmt +"<--IdListCustomerDao 5.stmt"+RESET);
			
		} else if(ckActive == null) { // 6. 고객or관리자, 등급 선택 조회
			sql = "SELECT i.id id, i.id_level idLevel, i.active active, nvl(c.cstm_rank, '') cstmRank, c.cstm_name cstmName "
				+ "FROM id_list i LEFT outer JOIN customer c "
				+ "ON i.id = c.id "
				+ "WHERE id_level IN (? ";
				
				for(int i=1; i<ckIdLevel.length; i+=1){ // ckIdLevel 배열의 길이 만큼 ? 셋팅
					sql += ",?";
				}
				sql+= ") AND cstm_rank IN (? ";
				
				for(int i=1; i<ckCstmRank.length; i+=1){ // ckCstmRank 배열의 길이 만큼 ? 셋팅
					sql += ",?";
				}				
				sql+= ") ORDER BY id_level DESC, id ASC LIMIT ?, ?";
				
				stmt = conn.prepareStatement(sql);
				for(int i=0; i<ckIdLevel.length; i+=1){ // ckIdLevel 배열의 길이 만큼 ?의 값 저장
					stmt.setInt(i+1, ckIdLevel[i]);
					System.out.println(BG_YELLOW+BLUE+ckIdLevel[i] +"<--IdListCustomerDao ckIdLevel[i]"+RESET);
				}
				for(int i=0; i<ckCstmRank.length; i+=1) { // ckCstmRank 배열의 길이 만큼 ?의 값 저장
					stmt.setString(ckIdLevel.length+i+1, ckCstmRank[i]);
					System.out.println(BG_YELLOW+BLUE+ckCstmRank[i] +"<--IdListCustomerDao ckCstmRank[i]"+RESET);
				}
				stmt.setInt(ckIdLevel.length+ckCstmRank.length+1, beginRow);
				stmt.setInt(ckIdLevel.length+ckCstmRank.length+2, rowPerPage);
				System.out.println(BG_YELLOW+BLUE+stmt +"<--IdListCustomerDao 6.stmt"+RESET);
					
		} else if(ckCstmRank == null) { // 7. 고객or관리자, 활성화 조회
			sql = "SELECT i.id id, i.id_level idLevel, i.active active, nvl(c.cstm_rank, '') cstmRank, c.cstm_name cstmName "
				+ "FROM id_list i LEFT outer JOIN customer c "
				+ "ON i.id = c.id "
				+ "WHERE id_level IN (? ";
				
				for(int i=1; i<ckIdLevel.length; i+=1){ // ckIdLevel 배열의 길이 만큼 ? 셋팅
					sql += ",?";
				}
				sql+=") AND active IN (? ";
				
				for(int i=1; i<ckActive.length; i+=1){ // ckActive 배열의 길이 만큼 ? 셋팅
					sql += ",?";
				}
				sql+= ") ORDER BY id_level DESC, id ASC LIMIT ?, ?";
				
				stmt = conn.prepareStatement(sql);
				for(int i=0; i<ckIdLevel.length; i+=1){ // ckIdLevel 배열의 길이 만큼 ?의 값 저장
					stmt.setInt(i+1, ckIdLevel[i]);
					System.out.println(BG_YELLOW+BLUE+ckIdLevel[i] +"<--IdListCustomerDao ckIdLevel[i]"+RESET);
				}
				for(int i=0; i<ckActive.length; i+=1){ // ckActive 배열의 길이 만큼 ?의 값 저장
					stmt.setString(ckIdLevel.length+i+1, ckActive[i]);
					System.out.println(BG_YELLOW+BLUE+ckActive[i] +"<--IdListCustomerDao ckActive[i]"+RESET);
				}
				stmt.setInt(ckIdLevel.length+ckActive.length+1, beginRow);
				stmt.setInt(ckIdLevel.length+ckActive.length+2, rowPerPage);
				System.out.println(BG_YELLOW+BLUE+stmt +"<--IdListCustomerDao 7.stmt"+RESET);
				
		} else { // 8. 고객, 등급, 활성화 여부 선택 조회
			sql = "SELECT i.id id, i.id_level idLevel, i.active active, nvl(c.cstm_rank, '') cstmRank, c.cstm_name cstmName "
				+ "FROM id_list i LEFT outer JOIN customer c "
				+ "ON i.id = c.id "
				+ "WHERE id_level IN (? ";
				
				for(int i=1; i<ckIdLevel.length; i+=1){ // ckIdLevel 배열의 길이 만큼 ? 셋팅
					sql += ",?";
				}
				sql+= ") AND cstm_rank IN (? ";
				
				for(int i=1; i<ckCstmRank.length; i+=1){ // ckCstmRank 배열의 길이 만큼 ? 셋팅
					sql += ",?";
				}
				sql+= ") AND active IN (? ";
				
				for(int i=1; i<ckActive.length; i+=1){ // ckActive 배열의 길이 만큼 ? 셋팅
					sql += ",?";
				}
				sql+= ")ORDER BY id_level DESC, id ASC LIMIT ?, ?";
				
				stmt = conn.prepareStatement(sql);
				
				// int index : ? 번호 값 저장
				int index = 1;
				
				for(int i=0; i<ckIdLevel.length; i+=1){ // ckIdLevel 배열의 길이 만큼 ?의 값 저장
					stmt.setInt(index++, ckIdLevel[i]);
					System.out.println(BG_YELLOW+BLUE+ckIdLevel[i] +"<--IdListCustomerDao ckIdLevel[i]"+RESET);
				}
				for(int i=0; i<ckCstmRank.length; i+=1) { // ckCstmRank 배열의 길이 만큼 ?의 값 저장
					stmt.setString(index++, ckCstmRank[i]);
					System.out.println(BG_YELLOW+BLUE+ckCstmRank[i] +"<--IdListCustomerDao ckCstmRank[i]"+RESET);
				}
				for(int i=0; i<ckActive.length; i+=1){ // ckActive 배열의 길이 만큼 ?의 값 저장
					stmt.setString(index++, ckActive[i]);
					System.out.println(BG_YELLOW+BLUE+ckActive[i] +"<--IdListCustomerDao ckActive[i]"+RESET);
				}
				stmt.setInt(ckIdLevel.length+ckCstmRank.length+ckActive.length+1, beginRow);
				stmt.setInt(ckIdLevel.length+ckCstmRank.length+ckActive.length+2, rowPerPage);
				System.out.println(BG_YELLOW+BLUE+stmt +"<--IdListCustomerDao 8.stmt"+RESET);
		}
		
		ResultSet rs = stmt.executeQuery();
		
		ArrayList<HashMap<String,Object>> list = new ArrayList<>();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<>();
			m.put("id", rs.getString("id"));
			m.put("active", rs.getString("active"));
			m.put("cstmRank", rs.getString("cstmRank"));
			m.put("cstmName", rs.getString("cstmName"));
			list.add(m);
		}
		
		return list;
	}
	
	/* 검색 조건에 따라 출력되는 전체 행의 수(idCustomerList)
	 * 1. 회원(고객, 관리자) 전체 조회 (ckIdLevel == null && ckCstmRank == null && ckActive == null)
	 * 2. 고객 / 관리자 검색 조회 (ckCstmRank == null && ckActive == null) 
	 * 3. 등급 검색 조회 (ckIdLevel == null && ckActive == null)
	 * 4. 활성화 여부 검색 조회 (ckIdLevel == null && ckCstmRank == null)
	 * 5. 등급, 활성화 검색 조회 (ckIdLevel == null)
	 * 6. 고객or관리자 등급 검색 조회 (ckActive == null)
	 * 7. 고객or관리자, 활성화 검색 조회 (ckCstmRank == null)
	 * 8. 고객, 등급, 활성화 여부 검색 조회
	*/
	
	public int selectIdCstmListCnt(int[] ckIdLevel, String[] ckCstmRank, String[] ckActive) throws Exception {
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = null;
		PreparedStatement stmt = null;
		
		if(ckIdLevel == null && ckCstmRank == null && ckActive == null) { // 1. 회원(고객, 관리자) 
			
			sql = "SELECT COUNT(*) "
				+ "FROM id_list i LEFT outer JOIN customer c "
				+ "ON i.id = c.id";
			stmt = conn.prepareStatement(sql);
			System.out.println(BG_YELLOW+BLUE+stmt +"<--IdListCustomerDao cnt 1.stmt"+RESET);
			
		} else if(ckCstmRank == null && ckActive == null) { // 2. 고객 / 관리자 검색 조회
			
			sql = "SELECT COUNT(*) "
				+ "FROM id_list i LEFT outer JOIN customer c "
				+ "ON i.id = c.id "
				+ "WHERE id_level IN(? ";
			
				for(int i=1; i<ckIdLevel.length; i+=1){ // ckIdLevel 배열의 길이 만큼 ? 셋팅
					sql += ",?";
				};
				sql += ")";
				
			stmt= conn.prepareStatement(sql);
			for(int i=0; i<ckIdLevel.length; i+=1){ // ckIdLevel 배열의 길이만큼 ?의 값 저장
				stmt.setInt(i+1, ckIdLevel[i]);
				System.out.println(BG_YELLOW+BLUE+ckIdLevel[i] +"<--IdListCustomerDao cnt ckIdLevel[i]"+RESET);
			}
			System.out.println(BG_YELLOW+BLUE+stmt +"<--IdListCustomerDao 2.stmt"+RESET);
			
		} else if(ckIdLevel == null && ckActive == null) { // 3. 등급 검색
			
			sql = "SELECT COUNT(*) "
				+ "FROM id_list i LEFT outer JOIN customer c "
				+ "ON i.id = c.id "
				+ "WHERE cstm_rank IN (? ";
			
				for(int i=1; i<ckCstmRank.length; i+=1){ // ckCstmRank 배열의 길이 만큼 ? 셋팅
					sql += ",?";
				}
				sql+= ")";
				
				stmt = conn.prepareStatement(sql);
				for(int i=0; i<ckCstmRank.length; i+=1) { // ckCstmRank 배열의 길이 만큼 ?의 값 저장
					stmt.setString(i+1, ckCstmRank[i]);
					System.out.println(BG_YELLOW+BLUE+ckCstmRank[i] +"<--IdListCustomerDao cnt ckCstmRank[i]"+RESET);
				}
				System.out.println(BG_YELLOW+BLUE+stmt +"<--IdListCustomerDao cnt 3.stmt"+RESET);
				
		} else if(ckIdLevel == null && ckCstmRank == null) { // 4. 활성화 여부
			
			sql = "SELECT COUNT(*) "
				+ "FROM id_list i LEFT outer JOIN customer c "
				+ "ON i.id = c.id "
				+ "WHERE active IN (? ";
				
				for(int i=1; i<ckActive.length; i+=1){ // ckActive 배열의 길이 만큼 ? 셋팅
					sql += ",?";
				}
				sql+= ")";
		
				stmt = conn.prepareStatement(sql);
				for(int i=0; i<ckActive.length; i+=1){ // ckActive 배열의 길이 만큼 ?의 값 저장
					stmt.setString(i+1, ckActive[i]);
					System.out.println(BG_YELLOW+BLUE+ckActive[i] +"<--IdListCustomerDao ckActive[i]"+RESET);
				}
				System.out.println(BG_YELLOW+BLUE+stmt +"<--IdListCustomerDao 4.stmt"+RESET);
				
		} else if(ckIdLevel == null) { // 5. 등급, 활성화
			
			sql = "SELECT COUNT(*) "
				+ "FROM id_list i LEFT outer JOIN customer c "
				+ "ON i.id = c.id "
				+ "WHERE cstm_rank IN (? ";
			
				for(int i=1; i<ckCstmRank.length; i+=1){ // ckCstmRank 배열의 길이 만큼 ? 셋팅
					sql += ",?";
				}
				sql+=") AND active IN (? ";
				
				for(int i=1; i<ckActive.length; i+=1){ // ckActive 배열의 길이 만큼 ? 셋팅
					sql += ",?";
				}
				sql+= ")";
				
				stmt = conn.prepareStatement(sql);
				for(int i=0; i<ckCstmRank.length; i+=1) { // ckCstmRank 배열의 길이 만큼 ?의 값 저장
					stmt.setString(i+1, ckCstmRank[i]);
					System.out.println(BG_YELLOW+BLUE+ckCstmRank[i] +"<--IdListCustomerDao cnt ckCstmRank[i]"+RESET);
				}
				for(int i=0; i<ckActive.length; i+=1){ // ckActive 배열의 길이 만큼 ?의 값 저장
					stmt.setString(ckCstmRank.length+i+1, ckActive[i]);
					System.out.println(BG_YELLOW+BLUE+ckActive[i] +"<--IdListCustomerDao cnt ckActive[i]"+RESET);
				}
				
				System.out.println(BG_YELLOW+BLUE+stmt +"<--IdListCustomerDao cnt 5.stmt"+RESET);
				
		} else if(ckActive == null) { // 6. 고객or관리자 등급
			
			sql = "SELECT COUNT(*) "
				+ "FROM id_list i LEFT outer JOIN customer c "
				+ "ON i.id = c.id "
				+ "WHERE id_level IN (? ";
				
				for(int i=1; i<ckIdLevel.length; i+=1){ // ckIdLevel 배열의 길이 만큼 ? 셋팅
					sql += ",?";
				}
				sql+= ") AND cstm_rank IN (? ";
				
				for(int i=1; i<ckCstmRank.length; i+=1){ // ckCstmRank 배열의 길이 만큼 ? 셋팅
					sql += ",?";
				}				
				sql+= ")";
				
				stmt = conn.prepareStatement(sql);
				for(int i=0; i<ckIdLevel.length; i+=1){ // ckIdLevel 배열의 길이 만큼 ?의 값 저장
					stmt.setInt(i+1, ckIdLevel[i]);
					System.out.println(BG_YELLOW+BLUE+ckIdLevel[i] +"<--IdListCustomerDao cnt ckIdLevel[i]"+RESET);
				}
				for(int i=0; i<ckCstmRank.length; i+=1) { // ckCstmRank 배열의 길이 만큼 ?의 값 저장
					stmt.setString(ckIdLevel.length+i+1, ckCstmRank[i]);
					System.out.println(BG_YELLOW+BLUE+ckCstmRank[i] +"<--IdListCustomerDao cnt ckCstmRank[i]"+RESET);
				}
				System.out.println(BG_YELLOW+BLUE+stmt +"<--IdListCustomerDao cnt 6.stmt"+RESET);
					
		} else if(ckCstmRank == null) { // 7. 고객or관리자, 활성화
			sql = "SELECT COUNT(*) "
				+ "FROM id_list i LEFT outer JOIN customer c "
				+ "ON i.id = c.id "
				+ "WHERE id_level IN (? ";
				
				for(int i=1; i<ckIdLevel.length; i+=1){ // ckIdLevel 배열의 길이 만큼 ? 셋팅
					sql += ",?";
				}
				sql+=") AND active IN (? ";
				
				for(int i=1; i<ckActive.length; i+=1){ // ckActive 배열의 길이 만큼 ? 셋팅
					sql += ",?";
				}
				sql+= ")";
				
				stmt = conn.prepareStatement(sql);
				for(int i=0; i<ckIdLevel.length; i+=1){ // ckIdLevel 배열의 길이 만큼 ?의 값 저장
					stmt.setInt(i+1, ckIdLevel[i]);
					System.out.println(BG_YELLOW+BLUE+ckIdLevel[i] +"<--IdListCustomerDao cnt ckIdLevel[i]"+RESET);
				}
				for(int i=0; i<ckActive.length; i+=1){ // ckActive 배열의 길이 만큼 ?의 값 저장
					stmt.setString(ckIdLevel.length+i+1, ckActive[i]);
					System.out.println(BG_YELLOW+BLUE+ckActive[i] +"<--IdListCustomerDao cnt ckActive[i]"+RESET);
				}
				System.out.println(BG_YELLOW+BLUE+stmt +"<--IdListCustomerDao cnt 7.stmt"+RESET);
				
		} else { // 8. 고객, 등급, 활성화 여부
			
			sql = "SELECT COUNT(*) "
				+ "FROM id_list i LEFT outer JOIN customer c "
				+ "ON i.id = c.id "
				+ "WHERE id_level IN (? ";
				
				for(int i=1; i<ckIdLevel.length; i+=1){ // ckIdLevel 배열의 길이 만큼 ? 셋팅
					sql += ",?";
				}
				sql+= ") AND cstm_rank IN (? ";
				
				for(int i=1; i<ckCstmRank.length; i+=1){ // ckCstmRank 배열의 길이 만큼 ? 셋팅
					sql += ",?";
				}
				sql+= ") AND active IN (? ";
				
				for(int i=1; i<ckActive.length; i+=1){ // ckActive 배열의 길이 만큼 ? 셋팅
					sql += ",?";
				}
				sql+= ")";
				
				stmt = conn.prepareStatement(sql);
				
				// int index : ? 번호 값 저장
				int index =1;
				
				for(int i=0; i<ckIdLevel.length; i+=1){ // ckIdLevel 배열의 길이 만큼 ?의 값 저장
					stmt.setInt(index++, ckIdLevel[i]);
					System.out.println(BG_YELLOW+BLUE+ckIdLevel[i] +"<--IdListCustomerDao ckIdLevel[i]"+RESET);
				}
				for(int i=0; i<ckCstmRank.length; i+=1) { // ckCstmRank 배열의 길이 만큼 ?의 값 저장
					stmt.setString(index++, ckCstmRank[i]);
					System.out.println(BG_YELLOW+BLUE+ckCstmRank[i] +"<--IdListCustomerDao ckCstmRank[i]"+RESET);
				}
				for(int i=0; i<ckActive.length; i+=1){ // ckActive 배열의 길이 만큼 ?의 값 저장
					stmt.setString(index++, ckActive[i]);
					System.out.println(BG_YELLOW+BLUE+ckActive[i] +"<--IdListCustomerDao ckActive[i]"+RESET);
				}
				System.out.println(BG_YELLOW+BLUE+stmt +"<--IdListCustomerDao 8.stmt"+RESET);
		}
		
		ResultSet rs = stmt.executeQuery();
		
		int totalRow = 0;
		if(rs.next()) {
			totalRow = rs.getInt(1);
		}
		
		return totalRow;
	}
	
	// Id 1개 검색 조회
	public HashMap<String, Object> selectId(String id) throws Exception{
		
		if(id == null) {
			System.out.println("입력 error");
			return null;
		}
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT id, active, cstmRank, cstmName "
				+ "FROM "
				+ "(SELECT i.id id, i.id_level idLevel, i.active active, nvl(c.cstm_rank, '') cstmRank, c.cstm_name cstmName "
				+ "FROM id_list i LEFT outer JOIN customer c "
				+ "ON i.id = c.id) ic "
				+ "WHERE id = ?";
		
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, id);
		System.out.println(BG_YELLOW+BLUE+stmt +"<--IdListCustomerDao selectId stmt"+RESET);
		
		ResultSet rs = stmt.executeQuery();
		
		HashMap<String,Object> m = null;
		
		if(rs.next()) {
			m = new HashMap<>();
			m.put("id", rs.getString("id"));
			m.put("active", rs.getString("active"));
			m.put("cstmRank", rs.getString("cstmRank"));
			m.put("cstmName", rs.getString("cstmName"));
			
		}
		return m;
	}
}
