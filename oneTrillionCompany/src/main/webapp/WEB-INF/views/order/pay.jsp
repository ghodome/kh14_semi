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
<!-- <link rel="stylesheet" type="text/css" href="/css/test.css"> -->
<!--  font awesome cdn -->
<link rel="stylesheet" type="text/css"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
<style>
body{
	overflow-x:hidden;
}
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
	margin-left: 30px;
	display: grid;
	grid-template-columns: 550px 580px;
	grid-template-rows: 400px 500px;
	row-gap: 10px;
	column-gap: 20px;
	width: 100%;
	height: 1500px;
	
}

.container2 {
	margin-top: 20px;
	padding: 20px 16px;
	border-radius: 12px;
	background-color: white;
	position: absolute;
	position: fixed;
}

.container2-left {
	width: 500px;
}

.container2-grid {
	display: grid;
	grid-template-columns: 550px 600px;
	grid-template-rows: 400px 600px;
	row-gap: 10px;
	column-gap: 20px;
	width: 100%;
	height: 100%;
}

.title4 {
	font-size: 28px;
	position: absolute;
	position: fixed;
}

.itme2 {
	
}

#screen-wrapper-paying {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 1);
  z-index: 9999;
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
}
#screen-wrapper-paying .spinner {
  border: 8px solid #f3f3f3;
  border-top: 8px solid #3498db;
  border-radius: 50%;
  width: 50px;
  height: 50px;
  animation: spin 1s linear infinite;

}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

#screen-wrapper-paying .loading-text {
  margin-top: 20px;
  font-size: 18px;
  color: #333;
  text-align: center;
}
</style>
<!-- jquery cdn -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<!-- 자바스크립트 코드 작성 영역 -->
<script type="text/javascript">
	$(function() {
		$("select[name='orderMemo']")
				.change(
						function() {
							var selectedValue = $(this).val();
							var memoContainer = $(".memo");

							if (selectedValue === '직접 입력하기') {
								// '직접 입력하기'가 선택된 경우, 인풋 박스를 보여줌
								$("#memoSelect").removeAttr("name");
								memoContainer
										.replaceWith('<input type="text" name="orderMemo" class="memo field w-100" style="border-top:1px solid #636e72" placeholder="직접 입력하세요">');
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
		$("select[name='orderMemo']").trigger('change');
	});
</script>

<script type="text/javascript">
	$(function() {
		$('#screen-wrapper-paying').hide();
		$('.item1').hide();
		$('.item2').show();
		$('form').on('submit', function() {
		    $('#screen-wrapper-paying').show();
		  });
	});
</script>


</head>
<body>
	<div class="orderpage w-600 my-10 mx-30 float-box" style="height: 100%">
		<div class="ordersHeader row w-100">
			<div class="logo flex-left mx-10">
				<a href="${pageContext.request.contextPath}/"><img src="https://ifh.cc/g/SbA93J.png"
					style="width: 10%;"></a>
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
			<div class="container-grid">
				<div class="item">
					<div class="flex-box w-100">
						<div class="container container-left my-20">
							<label class="row title">배송지</label>
							<hr>
							<div class="float-box p-10 mx-30">
								<div class="row">${memberDto.memberName}</div>
								<div class="row">${memberDto.memberContact}</div>
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
								<div>배송메모</div>
								<div>
									<div class="container request-detail">
										<select class="field w-100" name="orderMemo" id="memoSelect">
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




				<div class="item1">
					<!-- 					<div class="container" style="width: 450px; height: 100%"> -->
					<div class="title">더미</div>
					<div class="container w-500">
						<div class="row w-100">
							<div class="flex-box column-2 w-100" style="font-size: 18px">
							</div>
						</div>
					</div>
					<!-- 					</div> -->
				</div>







				<!-- 유석-->
				<div class="item2">
					<!-- 					<div class="container" style="width: 450px; height: 100%"> -->
					<div class="container2 w-500">
						<div class="row w-100">
							<div class="title row">결제상세</div>
							<hr>
							<div class="flex-box column-2 w-100" style="font-size: 18px">
								<div class="row">보유 포인트</div>
								<div class="row right green flex-right">
									${memberDto.memberPoint} <i class="fa-solid fa-coins"></i>
								</div>
							</div>
							<div class="flex-box column-2">
								<div class="row title">적립 혜택</div>
								<div class="row green flex-right">최대
									${Math.round(totalPrice/100)*3+cnt*150} 원</div>
							</div>
							<div class="container">
								<div class="flex-box column-2">
									<div class="row">구매적립</div>
									<div class="row flex-right pay-coin">${Math.round(totalPrice/100)*3}
										원</div>
									<input type="hidden" name="reward"
										value="${Math.round(totalPrice/100)*3}">
								</div>
								<div class="flex-box column-2">
									<div class="row">리뷰적립</div>
									<div class="row flex-right review-coin">${cnt*150}원</div>
								</div>
								<div class="row gray">동일상품의 상품 적립은 1회로 제한</div>
							</div>
							<div class="flex-box column-2">
								<div class="center" style="padding: 0.4em 0 0 0">결제금액 :
									${totalPrice}</div>
								<button type="submit" class="btn btn-positive w-33">결제하기</button>
							</div>
						</div>
					</div>
					<!-- 					</div> -->
				</div>



				<!--여기까지-->
				<!-- 주문 상품 목록 출력 -->
				<div class="order-item">
					<div class="item">
						<div class="container container-left my-20">
							<div class="row title">주문상품</div>
							<table class="order-detail-table">
								<hr>
								<thead>
									<tr>
										<th class="center my-10" style="width: 60%;"></th>
										<th class="center" style="width: 25%"></th>
										<th class="center" style="width: 15%"></th>
										<th></th>
										<th></th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="orderDetail" items="${orderDetailList}"
										varStatus="status">
										<tr>
											<td><input type="text" name="itemName"
												value="${orderDetail.orderDetailItemName}" readonly
												style="text-align: center; width: 100%; border: none; background-color: transparent; outline: none; font-size: 20px;">
												<input type="hidden" name="itemNo"
												value="${orderDetail.orderDetailItemNo}"></td>
											<td class="center"><input type="text" name="itemPrice"
												value="${orderDetail.orderDetailPrice}" readonly
												style="text-align: center; width: 100%; border: none; background-color: transparent; outline: none; font-size: 20px;">
											</td>
											<td class="center"><input type="text" name="cnt"
												value="${orderDetail.orderDetailCnt}" readonly
												style="text-align: center; width: 50%; border: none; background-color: transparent; outline: none; font-size: 20px;">
											</td>
											<td class="center"><input type="hidden" name="buyer"
												value="${memberDto.memberId}" readonly></td>
											<td class="center"><input type="hidden" name="orderNo"
												value="${orderNo}" readonly></td>
										</tr>
									</c:forEach>
									<c:forEach var="connectionOCDto" items="${connectionList}">
										<input type="hidden" name="cartNo"
											value="${connectionOCDto.cartNo}">
										<input type="hidden" name="cartNoByConnection"
											value="${connectionOCDto.cartNo}">
										<input type="hidden" name="cntByConnection"
											value="${connectionOCDto.cntPayment}">
									</c:forEach>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>
	<div id="screen-wrapper-paying">
		<div class="spinner"></div>
		<div class="loading-text">결제 중입니다. 잠시만 기다려주세요...</div>
	</div>
</body>
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>