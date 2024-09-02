<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>일조 쇼핑몰</title>

<!-- my css -->
<link rel="stylesheet" type="text/css" href="/css/commons.css">
<link rel="stylesheet" type="text/css" href="/css/test.css">
<!--  font awesome cdn -->
<link rel="stylesheet" type="text/css"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
<style>
.orderpage {
	position: relative;
	display: block;
	flex-direction: column;
	min-width: 1152px;
	min-height: 100%;
	background-color: #f3f5f7;
	margin-left: auto !important;
    margin-right: auto !important;
}

.flex-right {
	display: flex !important;
	justify-content: right;
	align-items: baseline;
}

.area-address {
	font-size: 16px;
	line-height: 22px;
	letter-spacing: -0.3px;
	margin-top: 8px;
	color: #404048;
	font-weight: 500;
	word-wrap: break-word;
}

.container {
	margin-top: 12px;
	padding: 20px 16px;
	border-radius: 12px;
	background-color: white;
}

.container-left {
	width: 500px;
}

.field1 {
	border: 0px solid transparent;
	outline: none;
}

.title {
	font-size: 28px;
}

.title2 {
	font-size: 20px;
}

.title3 {
	font-size: 18px;
	font-weight: bold;
}

.container-grid {
	display: grid;
	grid-template-columns: 600px 600px;
	grid-template-rows: 600px 600px;
	row-gap: 10px;
	column-gap: 20px;
	width:100%;
}
</style>
<!-- jquery cdn -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<!-- 자바스크립트 코드 작성 영역 -->
<script type="text/javascript">
	$(function() {
		$("select[name='order_memo']")
				.change(
						function() {
							var selectedValue = $(this).val();
							var memoContainer = $(".memo");

							if (selectedValue === '직접 입력하기') {
								// '직접 입력하기'가 선택된 경우, 인풋 박스를 보여줌
								memoContainer
										.replaceWith('<input type="text" name="custom_memo" class="memo field w-100" style="border-top:1px solid #636e72" placeholder="직접 입력하세요">');
							} else if (selectedValue !== 'noSelect') {
								// 그 외의 경우, 선택된 텍스트를 보여줌
								memoContainer
										.replaceWith('<input type="text" class="memo field w-100" readonly style="border-top:1px solid #636e72" value="'
												+ $(this).find(
														"option:selected")
														.text() + '">');
							} else {
								// '선택 안 함'이 선택된 경우, 아무 것도 표시하지 않음
								memoContainer
										.replaceWith('<div class="memo"></div>');
							}
						});

		// 페이지 로드 시 선택된 값에 따른 초기 설정
		$("select[name='order_memo']").trigger('change');
	});
</script>
</head>
<body>
	<div class="orderpage w-600 my-10 mx-30 float-box">
		<div class="ordersHeader row w-100">
			<div class="logo flex-left mx-10">
				<a href="/"><img src="https://ifh.cc/g/SbA93J.png"style="width: 10%;"></a>
			</div>
			<div class="center float-center title">주문/결제</div>
		</div>
		<div class="row flex-box">
			<div class="flex-right px-50">
				장바구니 >
				<div style="font-weight: bold">주문/결제</div>
				> 완료
			</div>
		</div>
		<form action="pay" method="post">
			<label class="row title">배송지</label>
			<div class="container-grid">
				<div class="item">
					<div class="flex-box w-100">
						<div class="container container-left my-20">
							<div class="flex-right title2">
								<button type="button" class="btn">변경</button>
							</div>
							<div class="float-box p-10 mx-30">
								<div class="row">${memberDto.memberName}</div>
								<div class="row">
									${memberDto.memberContact} <input type="checkbox"> 안심번호
									사용
								</div>
								<div class="area-address">
									<c:choose>
										<c:when test="${memberDto.memberAddress1!=null}">
	                        	${memberDto.memberAddress1} ${memberDto.memberAddress2} (${memberDto.memberPost})
							</c:when>
										<c:otherwise>
								주소를 변경해주세요
							</c:otherwise>
									</c:choose>

								</div>
								<hr>
								<div class="row">
									<input class="field" type="checkbox"> 배송메모 개별 입력
								</div>
								<div class="row">
									<div class="container request-detail">
										<select class="field w-100" name="order_memo">
											<option value="선택 안 함">선택 안 함</option>
											<option value="직접 입력하기">직접 입력하기</option>
											<option value="부재시 문앞에 두고 가주세요">부재시 문앞에 두고 가주세요</option>
											<option value="부재시 집앞에 두고 가주세요">부재시 집앞에 두고 가주세요</option>
											<option value="부재시 연락 부탁드려요">부재시 연락 부탁드려요</option>
											<option value="배송시 연락주세요">배송시 연락주세요</option>
										</select>

										<!-- 초기 상태를 위한 빈 메모 영역 -->
										<div class="memo"></div>
									</div>
								</div>
							</div>
									<input type="hidden" name="orderNo" value="${orderNo}">
						</div>
					</div>
				</div>
				<div class="item">
					<div class="container" style="width: 450px; height: 100%">
						<div class="title">결제상세</div>
						<div class="container">
							<div class="row w-100">
								<div class="flex-box column-2 w-100" style="font-size: 18px">
									<div class="row">포인트 결제</div>
									<div class="row right green flex-right">
										${memberDto.memberPoint} <i class="fa-solid fa-coins"></i>
									</div>
								</div>
								<div class="flex-box column-2">
									<div class="row title">적립 혜택</div>
									<div class="row green flex-right">최대 몇 원</div>
								</div>
								<div class="container">
									<div class="flex-box column-2">
										<div class="row">구매적립</div>
										<div class="row flex-right pay-coin">${Math.round(totalPrice/100)*3}
											원</div>
									</div>
									<div class="flex-box column-2">
										<div class="row">리뷰적립</div>
										<div class="row flex-right review-coin">${cnt*150} 원</div>
									</div>
									<div class="row">동일상품의 상품 적립은 1회로 제한</div>
								</div>
								<div class="flex-box column-2">
									<div class="flex-left center">결제금액 : ${totalPrice}</div>
									<button type="submit" class="btn btn-positive w-33">결제하기</button>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- 주문 상품 목록 출력 -->
				<div class="order-item">
					<div class="row title">주문상품</div>
					<div class="item">
						<div class="container container-left my-20">
							<table class="order-detail-table">
								<thead>
									<tr>
										<th class="center" style="width: 25%">상품번호</th>
										<th class="center" style="width: 50%">가격</th>
										<th class="center" style="width: 25%">수량</th>
										<th></th>
										<th></th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="orderDetail" items="${orderDetailList}"
										varStatus="status">
										<tr>
											<td class="center"><input type="text"
												name="itemNo"
												value="${orderDetail.orderDetailItemNo}" readonly>번
											</td>
											<td class="center"><input type="text"
												name="itemPrice"
												value="${orderDetail.orderDetailPrice}" readonly>원</td>
											<td class="center"><input type="text"
												name="cnt"
												value="${orderDetail.orderDetailCnt}" readonly>개</td>
											<td class="center"><input type="hidden"
												name="buyer"
												value="${memberDto.memberId}" readonly></td>
											<td class="center"><input type="hidden"
												name="orderNo" value="${orderNo}"
												readonly></td>
										</tr>
									</c:forEach>
									<c:forEach var="connectionOCDto" items="${connectionList}">
										<input type="hidden" name="cartNo" value="${connectionOCDto.cartNo}">
										<input type="hidden" name="cartNoByConnection" value="${connectionOCDto.cartNo}">
										<input type="hidden" name="cntByConnection" value="${connectionOCDto.cntPayment}">
									</c:forEach>
								</tbody>
							</table>
						</div>
						</div>
					</div>
				</div>
		</form>
	</div>
</body>
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>