package com.kh.oneTrillionCompany.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.oneTrillionCompany.dao.CartDao;
import com.kh.oneTrillionCompany.dao.ItemDao;
import com.kh.oneTrillionCompany.dao.MemberDao;
import com.kh.oneTrillionCompany.dao.OrderDetailDao;
import com.kh.oneTrillionCompany.dao.OrdersDao;
import com.kh.oneTrillionCompany.dto.MemberDto;
import com.kh.oneTrillionCompany.dto.OrderDetailDto;
import com.kh.oneTrillionCompany.dto.OrdersDto;
import com.kh.oneTrillionCompany.exception.TargetNotFoundException;
import com.kh.oneTrillionCompany.vo.OrderVO;

import jakarta.servlet.http.HttpSession;

@Transactional
@Service
public class PayService {
	@Autowired
	private OrdersDao ordersDao;
	@Autowired
	private MemberDao memberDao;
	@Autowired
	private OrderDetailDao orderDetailDao;
	@Autowired
	private ItemDao itemDao;
	@Autowired
	private CartDao cartDao;
	@Autowired
	private EmailService emailService;

	public void pay(List<OrderVO> list,  int orderNo, int reward,

			HttpSession session,String orderMemo)  throws Exception  {
		OrdersDto ordersDto=ordersDao.selectOne(orderNo);
		int payment=ordersDto.getOrderPrice();
		//세션 - 주문 아이디 검사
		String memberId=(String) session.getAttribute("createdUser");
		String buyer1=list.get(0).getBuyer();
		boolean sessionVaild=buyer1.equals(memberId); //세션 유효성 검사
		if(list.size()==0||!sessionVaild) {
			throw new TargetNotFoundException("장바구니를 확인해주세요");
		}
		//결제
		memberDao.payment(memberId, payment);
		//주문서 생성(detail)
		List<OrderDetailDto> detailList= orderDetailDao.selectListByOrderDetail(memberId,orderNo);
		List<Integer> detailNoList=new ArrayList<>();
		for(int i=0; i<detailList.size(); i++) {
			int orderDetailNo=detailList.get(i).getOrderDetailNo();
			int orderDetailCnt=detailList.get(i).getOrderDetailCnt();
			detailNoList.add(orderDetailNo);
			//재고 차감
			int orderDetailItemNo=detailList.get(i).getOrderDetailItemNo();
			itemDao.deductItem(orderDetailCnt,orderDetailItemNo);
			//장바구니 차감
			int cartNo=list.get(i).getCartNo();
//			if(cartDao.selectCnt(cartNo)==orderDetailCnt)
				//장바구니 수량 = 결제수량이면 삭제
			cartDao.delete(cartNo);
//			else if(cartDao.selectCnt(cartNo)>orderDetailCnt) {
//				//다르면 갯수 업데이트
//				String buyer = detailList.get(i).getOrderDetailItemName();
//				cartDao.updateCartCnt(buyer,cartNo,orderDetailCnt);//list.get(i).getCnt()
//			}
//			else {
//				("장바구니 수량 : "+cartDao.selectCnt(cartNo));
//				("결제 수량 : "+orderDetailCnt);
//				throw new TargetNotFoundException("장바구니 수량을 확인해주세요");
//			}
			//판매량 기록
			itemDao.salesCounting(orderDetailItemNo,orderDetailCnt);
		}
		//즉시적립
		memberDao.chargePoint(memberId, reward);
		//주문서 메모 추가
		ordersDao.updateMemo(orderMemo, orderNo);
		//주문서 이메일 발송
		MemberDto memberDto =memberDao.selectOne(memberId);
		String memberEmail = memberDto.getMemberEmail();
		String memberNickname=memberDto.getMemberNickname();
		emailService.sendPaymentDetails(memberNickname, memberEmail, list);
		orderDetailDao.payCompleteStatus(detailNoList);
	}
}
