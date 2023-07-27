package vo;

public class BoardQuestion {
	private int boardQNo;
	private String id;
	private String boardQCategory;
	private String boardQTitle;
	private String boardQContent;
	private int boardQCheckCnt;
	private String createdate;
	private String updatedate;
	public int getBoardQNo() {
		return boardQNo;
	}
	public void setBoardQNo(int boardQNo) {
		this.boardQNo = boardQNo;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getBoardQCategory() {
		return boardQCategory;
	}
	public void setBoardQCategory(String boardQCategory) {
		this.boardQCategory = boardQCategory;
	}
	public String getBoardQTitle() {
		return boardQTitle;
	}
	public void setBoardQTitle(String boardQTitle) {
		this.boardQTitle = boardQTitle;
	}
	public String getBoardQContent() {
		return boardQContent;
	}
	public void setBoardQContent(String boardQContent) {
		this.boardQContent = boardQContent;
	}
	public int getBoardQCheckCnt() {
		return boardQCheckCnt;
	}
	public void setBoardQCheckCnt(int boardQCheckCnt) {
		this.boardQCheckCnt = boardQCheckCnt;
	}
	public String getCreatedate() {
		return createdate;
	}
	public void setCreatedate(String createdate) {
		this.createdate = createdate;
	}
	public String getUpdatedate() {
		return updatedate;
	}
	public void setUpdatedate(String updatedate) {
		this.updatedate = updatedate;
	}
	
	
}
