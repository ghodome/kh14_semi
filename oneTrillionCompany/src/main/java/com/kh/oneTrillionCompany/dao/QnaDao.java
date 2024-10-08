package com.kh.oneTrillionCompany.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.JdbcTransactionManager;
import org.springframework.stereotype.Repository;

import com.kh.oneTrillionCompany.dto.QnaDto;
import com.kh.oneTrillionCompany.mapper.QnaMapper;
import com.kh.oneTrillionCompany.vo.PageVO;

@Repository
public class QnaDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	private QnaMapper qnaMapper;
	
	//시퀀스 생성
	public int sequence() {
		String sql = "select qna_seq.nextval from dual";
		return jdbcTemplate.queryForObject(sql, int.class);
	}
	
	//문의 등록
	public void insert(QnaDto qnaDto) {
		String sql = "insert into qna("
				+ "qna_no, qna_writer, qna_title, "
				+ "qna_content, qna_time"
				+ ") values(?, ?, ?, ?, sysdate)";
		Object[] data = {
				qnaDto.getQnaNo(), qnaDto.getQnaWriter(),
				qnaDto.getQnaTitle(), qnaDto.getQnaContent()};
		jdbcTemplate.update(sql, data);
	}
	
	//문의 삭제
	public boolean delete(int qnaNo) {
		String sql = "delete qna where qna_no=?";
		Object[] data = {qnaNo};
		return jdbcTemplate.update(sql, data) > 0;
	}
	
	//문의 수정
	public boolean update(QnaDto qnaDto) {
		String sql = "update qna set qna_title=? , qna_content=? "
						+ "where qna_no=?";
		Object[] data = {qnaDto.getQnaTitle() , qnaDto.getQnaContent() , qnaDto.getQnaNo()};
		return jdbcTemplate.update(sql, data) > 0;
	}	
	
	//문의 목록
	public List<QnaDto> selectList() {
		String sql = "select "
				+ "qna_no, qna_writer, qna_title, qna_content,"
				+ "qna_time "
				+ "from qna order by qna_no desc";
		return jdbcTemplate.query(sql, qnaMapper);
	}
	
	//문의 검색
	public List<QnaDto> selectList(String column, String keyword) {
		String sql = "select * from qna "
				+ "where instr(" + column + ", ?) > 0 "
				+ "order by qna_no asc";
		Object[] data = {keyword};
		return jdbcTemplate.query(sql, qnaMapper, data);		
	}
	
	//문의 상세 검색 (글 번호로 검색)
	public QnaDto selectOne(int qnaNo) {
		String sql= "select * from qna where qna_no=?";
		Object[] data = {qnaNo};
		List<QnaDto> list = jdbcTemplate.query(sql, qnaMapper, data);
		return list.isEmpty() ? null : list.get(0);		
	}
	
	//문의 상세 검색 (작성자로 검색)
		public QnaDto selectOne(String qnaWriter) {
			String sql= "select * from qna where qna_writer=?";
			Object[] data = {qnaWriter};
			List<QnaDto> list = jdbcTemplate.query(sql, qnaMapper, data);
			return list.isEmpty() ? null : list.get(0);		
		}
	
	//특정 회원의 문의 목록 조회
	public List<QnaDto> selectListByWriter(String qnaWriter){
		String sql = "select * from qna where qna_writer =? order by qna_no desc";
		Object[] data = {qnaWriter};
		return jdbcTemplate.query(sql, qnaMapper, data);
	}

	//페이징객체를 이용한 목록 및 검색
	public List<QnaDto> selectListByPaging(PageVO pageVO) {
		if(pageVO.isSearch()) {//검색이라면
			String sql = "select * from("
						+ "select rownum rn, TMP.* from("
							+ "select qna_no, qna_writer, qna_title, qna_content,"
							+ " qna_time, qna_reply  from qna where instr("+pageVO.getColumn()+", ?) > 0 "
						+ ") TMP"
					+ ") where rn between ? and ?";
			Object[] data= {pageVO.getKeyword(), pageVO.getBeginRow(), pageVO.getEndRow()};
			return jdbcTemplate.query(sql, qnaMapper, data);			
		}
		else {
			String sql="select * from("
						+ "select rownum rn, TMP.* from("
							+ "select qna_no, qna_writer, qna_title, qna_content,"
							+ " qna_time, qna_reply from qna order by qna_no desc"
						+ ") TMP"
					+ ") where rn between ? and ?";
			Object[] data= {pageVO.getBeginRow(), pageVO.getEndRow()};
			return jdbcTemplate.query(sql, qnaMapper, data);
		}
	}

	public int countByPaging(PageVO pageVO) {
		if(pageVO.isSearch()) {//검색카운트
			String sql = "select count(*) from qna where instr("+pageVO.getColumn()+", ?) > 0";
			Object[] data = {pageVO.getKeyword()};
			return jdbcTemplate.queryForObject(sql, int.class, data);
		}
		else {//목록 카운트
			String sql = "select count(*) from qna";
			return jdbcTemplate.queryForObject(sql, int.class);
		}
	}
	
//	public int pageCountByMemberId(PageVO pageVO) {
//		if(pageVO.isSearch()) {//검색카운트
//			String sql = "select count(*) from qna where instr("+pageVO.getColumn()+", ?) > 0 and qna_writer = ?";
//			Object[] data = {pageVO.getKeyword(), };
//			return jdbcTemplate.queryForObject(sql, int.class, data);
//		}
//		else {//목록 카운트
//			String sql = "select count(*) from qna";
//			return jdbcTemplate.queryForObject(sql, int.class);
//		}
//	}

	//댓글 수 최신화
	public boolean updateQnaReply(int qnaNo) {
		String sql = "update qna set qna_reply = "
				+ "(select count(*) from reply where reply_origin = ?)"
				+ " where qna_no=?";
		Object[] data = {qnaNo, qnaNo};
		return jdbcTemplate.update(sql, data) > 0;
	}
	
}