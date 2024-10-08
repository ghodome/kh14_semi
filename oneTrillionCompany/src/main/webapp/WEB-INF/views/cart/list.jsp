<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<!-- font awesome icon cdn -->

<style>
/*장바구니 제목 스타일 */
.cart-title {
	font-weight: 700;
	font-size: 36px;
	line-height: 40px;
	margin-bottom: 20px;
	padding-top: 10px;
}
/*테이블 스타일*/
table {
	width: 100%;
	border: 0;
	border-collapse: collapse;
}

th {
	background: #fbfafa;
	font-weight: bold;
}

tfoot {
	background: #fbfafa;
}

tfoot td {
	padding: 0.5em;
}

td {
	border-bottom: 1px solid #ddd !important;
}

/* 주문 삭제 버튼 스타일 */
.link-box {
	width: 100%;
	border: none;
}

.link-box a {
	width: 150px;
	text-align: center;
}

/* 재고, 수량을 숨김 */
.hidden {
	display: none !important;
}

.cartCnt-data {
	display: none !important;
}
/*주문 요약서 스타일*/
.cart-payment-Title {
	color: #000;
	margin-bottom: 24px;
	font-size: 20px;
	line-height: 28px;
	text-transform: uppercase;
	font-weight: 700
}
/*장바구니 주문서*/
.cart-order {
	border: 1px solid #000;
}

.cart-orderTitle {
	color: #000;
	font-size: 20px;
	margin-bottom: 24px;
	line-height: 28px;
	text-transform: uppercase;
	font-weight: 700;
}

.displayNone {
	display: none;
}
/* 장바구니 input 수정*/
.cartItemPriceInput{
	text-align:center;
	border:none;
	font-weight:bold;
	color:#141414;
}
/*주문 요약서*/
.order-summary{
	font-size:20px;
}
</style>

<!-- jquery cdn -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<script type="text/javascript">
	//전체선택//
	$(function() {
		//전체선택
		$('.all-checkbox').click(function() {//상태가 변경되면
			var checked = $(this).prop("checked");
			if (checked) {
				$(".check-item").prop("checked", true);
			} else {
				$(".check-item").prop("checked", false);
			}
		});
		$(".check-item").click(function() {
			//체크된 체크박스 개수
			var checked_length = $(".check-item:checked").length;
			//전체 체크박수 개수
			var checkbox_length = $(".check-item").length;

			if (checked_length == checkbox_length) {
				$(".all-checkbox").prop("checked", true);
			} else {
				$(".all-checkbox").prop("checked", false);
			}
		});

		//삭제 ajax 통신-한개 삭제
		$(".btn-delete").click(
				function(event) {
					var choice = confirm("장바구니를 비우시겠습니까?");
					if (!choice) {
						event.preventDefault(); //클릭 이벤트 중지
						return; //종료
					}
					var row = $(this).closest('tr');//리스트 항목 전체 선택
					var cartNoValue = $(this).closest('tr').find(
							".cartCnt-data").text();
					$.ajax({
						url : "${pageContext.request.contextPath}/rest/cart/delete",
						method : 'post',
						data : {
							cartNo : cartNoValue
						},
						success : function(response) {
							location.reload(); //페이지 새고
						}
					});
				});


		//선택한 항목을 삭제
		$(".btn-selected-checkBox").click(function() {
			var cartNoList = [];
			$(".check-item:checked").each(function() {
				cartNoList.push($(this).val());
			});
			if(cartNoList.length == 0) {
		 		alert("상품을 선택 해주세요");
		 		return;
		 	}
			//삭제 알림창
			var choice = confirm("선택한 항목을 삭제하시겠습니까?");
			if (!choice) {
				return; // 선택하지 않은 경우
			}
			$.ajax({
				url : "${pageContext.request.contextPath}/rest/cart/checkDelete",
				method : 'post',
				data : {
					cartNo : cartNoList,
				},
				success : function(response) {
					location.reload();
				}
			});

		});

		//장바구니 비우기 - 전체 삭제
		$(".btn-deleteAll").click(
				function(evnet) {
					var choice = confirm("장바구니를 비우시겠습니까?");
					if (!choice) {
						event.preventDefault();
						return;
					}
					var row = $(this).closest('tr');//리스트 항목 전체 선택
					var cartNoValue = $(this).closest('tr').find(
							".cartCnt-data").text();
					$.ajax({
						url : "${pageContext.request.contextPath}/rest/cart/deleteAll",
						method : 'post',

						success : function(response) {
							location.reload(); //페이지 새고
						}
					});
				});

		// 수량 증가 및 감소
		$(".btn-up, .btn-down").click(function() {
			// 현재 버튼이 속한 행의 수량 및 재고 값 가져오기
			var row = $(this).closest('tr'); // 현재 버튼이 속한 행 
			var cartCntInput = row.find(".cartCntInput"); // 현재 행의 수량 입력 필드
			var cartCntValue = parseInt(cartCntInput.val(), 10); //cartCnt 값이 들어감
			var itemCntValue = parseInt(row.find(".itemCnt-data").text(), 10); //재고

			console.log(cartCntInput.val() + " - " + itemCntValue);

			// 버튼에 따른 수량 조절
			if ($(this).hasClass('btn-up')) {
				// 장바구니 최대 수량(재고기준)
				if (cartCntValue < itemCntValue) {
					cartCntValue += 1;
				} else {
					alert("최대 수량에 도달했습니다");
				}
			} else if ($(this).hasClass('btn-down')) {
				// 장바구니 최소 수량
				if (cartCntValue > 1) {
					cartCntValue -= 1;
				} else {
					alert("최소 수량에 도달했습니다");
				}
			}
			cartCntInput.val(cartCntValue);

			//수량 서버에 업데이트-ajax통신
			var cartNo = row.find(".cartCnt-data").text(); // 현재 행의 cartNo 값
			$.ajax({
				url : "${pageContext.request.contextPath}/rest/cart/cartCntUpdate",
				method : 'post',
				data : {
					cartNo : cartNo,
					cartCnt : cartCntValue
				},
				success : function(response) {
					console.log('장바구니 업데이트 성공'); //나중에 지우기
					updatecartTotalPrice(); //수량을 업데이트 하면서 같이 ajax통신
				}
			});
		});

		//수량 변경 시-ajax통신 
		//-상품 총구매금액 - ajax통신
		function updatecartTotalPrice() {
			$.ajax({
				url : "${pageContext.request.contextPath}/rest/cart/cartTotalPriceUpdate",
				method : 'post',
				success : function(response) {
					$(".cart-total-price").text(response);
				}
			});
		}

		/*      //장바구니에서 주문으로 order list 저장 통신 - 우선 1개만 구현
		   	$,(".btn-order").click(function()){
		   		 //장바구니에서 주문 목록으로 넘어갈 VO 생성
		   		var list = [];
		   	    for (var i = 0; i < cartItemCnt.length; i++) {
		   	    	var cartVO = {
		   		    	"carItemNo": carItemNo[i],
		   	            "cartItemPrice": itemPrice[i],
		   	            "cartItemCnt": cartCnt[i]
		   	    	};
		   	    	list.push(cartVO);
		   	    }
		   	    console.log(list);
		   			
		   		$.ajax({
		   			url: "/cart/list",
		   			method:'post',
		   			contentType: 'application/json', // JSON 데이터 전송을 위해 설정
		   	        data: JSON.stringify(list), // list를 JSON 문자열로 변환
		   			success:function(response){
		   				console.log("성공")
		   			}
		   		});
		   	}); */
	});
</script>
<div class="container w-1200 my-50">

	<div class="row center mb-50 cart-title">장바구니</div>

	<!-- 장바구니가 비어있다면(회원, 비회원)  -->
	<c:choose>
		<c:when test="${cartItemVOList.isEmpty()}">
			<!-- 결과가 없을때  -->
			<div class="row center">
				<i class="fas fa-thin fa-cart-shopping fa-2x"></i>
				<p>장바구니가 비어있습니다</p>
			</div>
		</c:when>
		<c:otherwise>

			<!-- 결과가 있을때  -->
			<div class="row cart-item-cnt">
				<h3 style="font-weight:bold;" class="mb-0">담긴 상품(${cartItemCnt})</h3>
				<hr style="width:9%; border:1px solid" class="ms-0">
			</div>
			<!-- 장바구니 목록 -->
			<div style="min-height: 300px" class="mt-10">
				<table border="1" width="1200">
					<thead>
						<tr>
							<th><input type="checkbox" class="all-checkbox"></th>
							<th>이미지</th>
							<th>상품정보</th>
							<th>색상/사이즈</th>
							<th>가격</th>
							<th>수량</th>
							<th>배송구분</th>
						</tr>
					</thead>

					<!-- cartList 반복문 -->
					<tbody class="center">
						<c:forEach var="cart" items="${cartItemVOList}" varStatus="status">
							<tr>
								<td><span class="cartCnt-data">${cart.cartNo}</span>
								<!-- 장바구니 수량을 el로 받아 제이쿼리에 적용 --> <input type="checkbox"
									class="check-item" name="cartNos" value="${cart.cartNo}">
									<input type="hidden"
									name="cartList[${status.index}].cartItemNo"
									value="${cart.cartItemNo}"></td>
								<!--itemList 반복문 -->
								<!--  -->
								<td>
									<!-- itemNo 제이쿼리에서 쓰기 --> <span class="hidden">${cart.cartItemNo}</span>
									<a href="#"><img class="shoppingmal" style="margin-top:4px;'"
										src="${pageContext.request.contextPath}/item/image?itemNo=${cart.cartItemNo}" width="80px"></a>
									<!-- 임시 이미지 -->
								</td>
								<td>${cart.itemName}</td>
								<td>${cart.itemColor} / ${cart.itemSize}</td>
								<td><input type="text"
									name="cartList[${status.index}].cartItemPrice"
									value="<fmt:formatNumber value="${cart.itemPrice}" pattern="#,###"/>원" class="field cartItemPriceInput" readonly><span
									class="hidden">${cart.itemPrice}</span> <span
									class="hidden itemCnt-data">${cart.itemStock}</span></td>
								<!-- 재고값을 el로 받아 제이쿼리에 적용 -->
								<td><span> <input type="text"
										name="cartList[${status.index}].cartItemCnt"
										class="cartCntInput" value="${cart.cartCnt}" size="2" readonly>
										<input type="hidden" name="cartList[${status.index}].buyer"
										value="${sessionScope.createdUser}"> <input
										type="hidden" name="cartList[${status.index}].cartNo"
										value="${cart.cartNo}">
										<button type="button" class="btn-cnt btn-up">
											<i class="fa-solid fa-angle-up Icon_carCnt"></i>
										</button>
										<button type="button" class="btn-cnt btn-down">
											<i class="fa-solid fa-angle-down Icon_carCnt"></i>
										</button>
								</span></td>
								<td>기본배송</td>
								<!-- <td class="link-box flex-box"
									style="flex-direction: column; align-items: center;">
									<button type="submit" class="btn btn-order btn-positive">주문하기</button>
									<button type="button" class="btn btn-negative btn-delete">삭제하기</button>
								</td> -->
							</tr>
						</c:forEach>

					</tbody>

					<tfoot class="right">
						<tr>
							<c:if test="${cartTotalPrice!=0}">
								<td colspan="10">상품구매금액: <span class="cart-total-price"><fmt:formatNumber value="${cartTotalPrice}" pattern="#,###"/></span>원
								</td>
							</c:if>
						</tr>
					</tfoot>
				</table>
			</div>

			<!-- 버튼 -->
			<div class="float-box">
				<button type="button" class="btn btn-deleteAll float-right btn-negative">
					<i class="fa-solid fa-trash-can"></i> 장바구니 비우기
				</button>
				<button type="button" class="btn btn-selected-checkBox float-right btn-negative" style="margin-right:5px;">선택상품
					삭제하기</button>
			<!-- 	<button type="button" class="btn float-left selected-order">선택상품
					주문하기</button> -->
				<form action="list" method="post">
					<c:forEach var="cart" items="${cartItemVOList}" varStatus="status">
						<input type="hidden" name="cartItemNo" value="${cart.cartItemNo}">
						<input type="hidden" name="cartItemCnt" value="${cart.cartCnt}"
							readonly size="2">
						<input type="hidden" name="buyer"
							value="${sessionScope.createdUser}">
						<input type="hidden" name="cartItemPrice"
							value="${cart.itemPrice}" readonly>
						<input type="hidden" name="cartNo" value="${cart.cartNo}">
					</c:forEach>
					<button type="submit" class="btn float-left btn-positive">전체 주문하기</button>
				</form>
			</div>
			<!-- 장바구니 주문 미리보기 -->
			<div class="row cart-payment-Title center mt-50">주문 요약서</div>
			<table border="1" class="w-100  mt-20">
				<colgroup>
					<col style="width: 200px;">
					<col style="width: 200px;" class="displayNone">
					<col style="width: 200px;">
					<col style="width: 200px;" class="displayNone">
					<col style="width: auto;">
				</colgroup>
				<thead>
					<tr>
						<th><strong>총 상품금액</strong></th>
						<th><strong>총 배송비</strong></th>
						<th><strong>결제예정금액</strong></th>
					</tr>
				</thead>
				<tbody class="center">
					<tr>
						<td>
							<div class="row">
								<strong> <span class="cart-total-price order-summary"> <!-- 배송비 가격 미포 -->
										<fmt:formatNumber value="${cartTotalPrice}" pattern="#,###"/>원
								</span>
								</strong>
							</div>
						</td>
						<td>
							<div class="row">
								<strong> <span class="order-summary"> 무료배송 </span>
								</strong>
							</div>
						</td>
						<td>
							<div class="row">
								<strong> <span class="cart-total-price order-summary" style="font-weight:bold;">
										<fmt:formatNumber value="${cartTotalPrice}" pattern="#,###"/>원</span>
								</strong>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</c:otherwise>
	</c:choose>

</div>


<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>