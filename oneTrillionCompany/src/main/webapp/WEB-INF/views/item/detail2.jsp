<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<!-- 장바구니 테스트 페이지 구현 완료 후 상세로 옮기기 -->

<style>
/* .test-score { */
/* 	font-size: 25px; /* 별점 크기 조정 */
* /
	/* } */ 

.content-box {
	width: 600px;
	background-color: #f6f7f8;
	font-size: 20px;
	font-weight: 200 !important;
	padding: 10px 20px;
	word-wrap: break-word; /* 긴 단어를 줄바꿈 */
	overflow-wrap: break-word; /* 박스 범위를 넘는 단어 줄바꿈 */
	white-space: normal; /* 기본 줄바꿈 설정 */
}

.price {
	font-size: 13px;
	color: #999;
	font-weight: normal;
	position: relative;
}

.btn-shirt {
	position: relative;
	overflow: hidden;
	display: inline-block;
	margin: 0 5px 3px 0;
	vertical-align: top;
	border: 2px dashed #eaeaea;
	border-radius: 5px;
	background: #fff;
	-webkit-box-sizing: border-box;
	-moz-box-sizing: border-box;
	box-sizing: border-box;
	font-size: 15px;
	color: #d0d4d5;
	border-radius: 0.3em;
}

.btn-shirt:hover {
	background-color: #dfe6e9 !important;
}

.image-style {
	width: 400px;
	height: 550px;
	display: inline-block;
	text-align: center;
	font-size: 20px;
}

.img-show {
	transition: 0s linear;
	opacity: 1;
}

.img-opacity {
	transition: 0s linear;
	opacity: 0;
}

#bigImage {
	margin-bottom: 10px;
}

.shoppingmal {
	cursor: pointer;
	width: 410px;
	height: 570px;
	background-image:
		url("https://d2u3dcdbebyaiu.cloudfront.net/uploads/atch_img/197/d72693912bf2868da3e848dc5b779d4a_res.jpeg");
}

#smallShirts {
	width: 100px;
	height: 100px;
	padding: 0 5px;
	cursor: pointer;
}

/* 사이즈 스타일 추가 */
.size-radio {
	display: flex;
	align-items: center;
	justify-content: center;
	height: 36px;
	width: 36px;
	border: 1px solid #ccc;
	position: relative;
	margin-bottom: 10px;
	border-radius: 10px;
	cursor: pointer;
	margin-right: 10px;
	padding: 0px;
	margin-top: 10px
}
/* 사이즈 클릭시 색깔변경 */
.click {
	background-color: #F2F2F2;
}

.size-text {
	font-size: 15px;
	line-height: 22px;
	color: #000;
	text-align: center;
}

/* 사용자가 선택한 옵션 창 - 숨기기*/
.hidden {
	display: none;
}
</style>

<!--jquery cdn-->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script
	src="/js/score.js"></script>
<script type="text/javascript">
    $(function() {
        $(".score").score({
            starColor: "orange", // 별 색상
            editable: false, // 점수 변경 불가
            integerOnly: true, // 정수만 허용
            send: {
                sendable: false // 전송 불가
            },
            display: {
                placeLimit: 1, // 소수점 자리수
                textColor: "#0984e3" // 텍스트 색상
            },
            point: {
                max: 5 // 최대 점수
                // rate는 data-rate 속성으로 설정됩니다.
            }
        });
    });
</script>
<!-- 자바스크립트 코드 작성 영역 -->


<script type="text/javascript">
	$(function() {
		
		// 페이지 로드 시 .target 요소를 숨긴다.
		$(".target").hide();

		// 버튼 클릭 시 .target 요소를 토글한다.
		$(".btn-toggle").click(function() {
			$(".target").slideToggle();
		});
		
		$(".target1").hide();

		// 버튼 클릭 시 .target 요소를 토글한다.
		$(".btn-toggle1").click(function() {
			$(".target1").slideToggle();
		});

		var itemTypeValid = false;

		function checkItemType() {
			var tag = document.querySelector("[name=itemColor]");
			itemTypeValid = tag.value.length > 0;
			tag.classList.remove("success", "fail");//클래스 초기화
			tag.classList.add(itemTypeValid ? "success" : "fail");//클래스 부여
		}
		function checkForm() {
			return itemTypeValid;
		}

		//사이즈 버튼 클릭 시 색 변경
		$(document).ready(function() {
			$('.size-radio').click(function() {
				$(this).toggleClass('click');

				$('.size-radio').not(this).removeClass('click');
			});
		});

		//수량 증가 및 감소
		//기본 1로 설정
		var cartCntInput = $("[name=cartCnt]");
		cartCntInput.val("1");
		$(".btn-up, .btn-down").click(function() {
			// 현재 버튼이 속한 행의 수량 및 재고 값 가져오기
			var cartCntValue = parseInt(cartCntInput.val()); //장바구니 수량을 넣는다
			var itemCntValue = parseInt($(".itemCnt-data").text()); //재고 수량 가져온다

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
			//값을 다시 input에 넣기
			cartCntInput.val(cartCntValue);
		});

		//전역변수
		var itemColorValue = "";
		var itemSizeValue = "";

		$("[name=itemColor]").change(function() {
			itemColorValue = $(this).val();
		});
		//사이즈 선택시
		$(".size-radio").click(function() {
			itemSizeValue = $(this).find(".size-text").text();
		});
		$(".btn-add-cart").click(function() {
			if (!itemColorValue) {
				alert("색상을 선택해주세요.");
				return;
			}
			if (!itemSizeValue) {
				alert("사이즈를 선택해주세요.");
				return;
			}

			var itemNameValue = $(".itemName").text().trim(); // 공백 제거
			var cartCntValue = $("[name=cartCnt]").val();
			var itemSalePriceValue = $(".itemSalePrice").text();
			var attachNoValue = $(".attachNo-data").text();

			$.ajax({
				url : "/rest/cart/insertCart",
				method : 'post',
				data : {
					itemName : itemNameValue,
					itemColor : itemColorValue,
					itemSize : itemSizeValue,
					itemSalePrice : itemSalePriceValue,
					cartCnt : cartCntValue,
					attachNo : attachNoValue
				},
				success : function(response) {
					// 장바구니에 성공적으로 담았을 때 모달을 띄운다
					$('.screen-wrapper').fadeIn();
				},
				error : function() {
					alert("품절된 상품입니다");
				}
			});
		});

		// 모달에서 "계속 쇼핑하기" 버튼 클릭 시 모달 닫기
		$('.btn-keep').click(function() {
			$('.screen-wrapper').fadeOut();
		});

		// 모달에서 "장바구니로 이동" 버튼 클릭 시 장바구니 페이지로 이동
		$('.btn-cart').click(function() {
			window.location.href = "/cart/list"; // 장바구니 페이지 URL
		});
	});
</script>

<style>
/* 
            화면 가림 장치
        */
.screen-wrapper {
	/* opacity:0.5;
            background-color: black; */
	background-color: rgba(0, 0, 0, 0.1);
	position: fixed;
	top: 0px;
	bottom: 0px;
	left: 0px;
	right: 0px;
	z-index: 99;
}
.btn
</style>

<div class="container w-1200 my-50">
	<!-- 모달 구조 -->
	<div class="full screen-wrapper flex-core" style="display: none;">
		<div class="container w-450 my-50 p-20"
			style="height: 200px; background-color: white; border-radius: 10px;">
			<div class="row center my-30"
				style="font-weight: bold; font-size: 20px">장바구니에 상품을 담았습니다</div>
			<div class="row center" style="font-size: 12px">장바구니로 이동하시겠습니까?
			</div>
			<div class="flex-box column-2">
				<div class="row ms-30">
					<button type="button" class="btn btn-cart w-100 link btn-positive"
						>장바구니로 이동</button>
				</div>
				<div class="row me-30">
					<button type="button" class="btn btn-keep w-100 btn-neutral">계속 쇼핑하기</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 모달 끝 -->
	<div class="flex-box column-2">
		<div class="left">
			<div id="bigImage">
				<div id="container">
					<img class="shoppingmal" src="/item/image?itemNo=${itemDto.itemNo}"
						width="100%">
					<!-- attachNo값 가져오기* -->
					<span class="attachNo-data hidden">${attachNo}</span>
				</div>

			</div>
		</div>

		<div class="right">
			<!--상품이름 클래스 추가*-->
			<div class="left">
				<div class="row mt-0 itemName" style="font-size: 30px;">
					${itemDto.itemName}</div>
			</div>
			<div class="row flex-box column-2">
				<div class="left">
					<!-- 상품원가* -->
					<span class="itemPrice"><del style="color: #999;">${itemDto.itemPrice}</del></span>
					<!-- 상품판매가* -->
					<span class="itemSalePrice" style="padding-left: 5px;"><b
						style="font-weight: bolder;">${itemDto.itemSalePrice}</b></span>
				</div>
				<%-- <div class="right">
					<!-- 상품할인비율* -->
					<span style="color: red;"><fmt:formatNumber
							value="${itemDto.itemDiscountRate * 100}" type="number"
							maxFractionDigits="0" />%</span> <span>(할인)</span>
				</div> --%>
			</div>
			

			<hr>

			<div class="row mb-30">
				<div class="row flex-box column-2">
					<div class="left">
						<button type="button" class="btn btn-toggle"
							style="border-color: white; background-color: white; padding: 1px;">상품정보</button>
						<div class="left">
							<h3 class="target left">
								<span style="font-size: 13px; color: #999;">-소비자가</span><br>
								<span style="font-size: 13px; color: #999;">-판매가</span><br>
								<span style="font-size: 13px; color: #999;">-배송비결제</span><br>
							</h3>
						</div>
					</div>
					<div class="right">
						<button type="button" class="btn btn-toggle"
							style="font-size: 13px; border-color: white; background-color: white; padding-left: 6em">
							<i class="fa-solid fa-plus"></i>
						</button>
						<div class="left">
							<h4 class="target left">
								<span style="font-size: 14px; font-weight: bolder; color: black">${itemDto.itemPrice}</span><br>
								<span style="font-size: 14px; font-weight: bolder;">${itemDto.itemSalePrice}</span><br>
								<span style="font-size: 14px; font-weight: bolder;">무료배송</span><br>
							</h4>
						</div>
					</div>
				</div>
				<hr>

				<div class="row center">
					<div style="font-size: 15px; font-weight: bolder;">
						<i class="fa-solid fa-palette"></i> <b
							style="font-weight: bolder; font-size: 14px">C</b> <b
							style="font-weight: bolder; font-size: 14px">O</b>
						<b style="font-weight: bolder; font-size: 14px">L</b>
						<b style="font-weight: bolder; font-size: 14px">O</b>
						<b style="font-weight: bolder; font-size: 14px">R</b>
					</div>
				</div>

				<div class="row center"></div>
				<div class="left">
					<span style="font-size: 11px; color: #999;">[필수] 옵션을 선택해 주세요</span>
				</div>
				<div class="row">
					<select name="itemColor" class="field w-100"
						style="border-radius: 20px;" oninput="checkItemType();">
						<option value="">선택하세요</option>
						<option value="black">블랙</option>
						<option value="white">화이트</option>
						<option value="blue">블루</option>
						<option value="brown">브라운</option>
					</select>
				</div>

				<div class="row center">
					<span><i class="fa-solid fa-tape"></i>Size</span>
				</div>
				<div class="left">
					<span style="font-size: 11px; color: #999;">[필수] 옵션을 선택해 주세요</span>
				</div>
				<!-- 사이즈 추가 -->
				<div class="size-content-group">
					<div class="size-content flex-box">
						<div class="size-radio">
							<div class="size-text">S</div>
						</div>
						<div class="size-radio">
							<div class="size-text">M</div>
						</div>
						<div class="size-radio">
							<div class="size-text">L</div>
						</div>
						<div class="size-radio">
							<div class="size-text">XL</div>
						</div>
					</div>
				</div>

				<div class="row center">
					<div style="font-size: 15px; mt: 8px" class="left">수량</div>
				</div>
				<!-- 수량 선택추가* -->
				<div class="left my-0">
					<span class="input_cartCnt"> <input type="text"
						name="cartCnt" size="2" style="border-radius: 30px"><span
						class="itemCnt-data hidden">${itemDto.itemCnt}</span>
						<button type="button" class="btn-cnt btn-up"
							style="background-color: white; border-color: white;">
							<i class="fa-solid fa-angle-up Icon_carCnt"></i>
						</button>
						<button type="button" class="btn-cnt btn-down"
							style="background-color: white; border-color: white;">
							<i class="fa-solid fa-angle-down Icon_carCnt"></i>
						</button>
					</span>
				</div>
			</div>

			<div class="left">
				<p style="font-size: 11px; color: #999;">
					<i class="fa-regular fa-circle-exclamation"></i>최소주문수량 1개 이상입니다
				</p>
				<p style="font-size: 11px; color: #999;">
					<i class="fa-regular fa-circle-exclamation"></i>옵션선택 박스를 선택하시면 아래에
					상품이 추가됩니다.
				</p>
				<p style="font-size: 11px; color: #999;">
					<i class="fa-regular fa-circle-exclamation"></i>배송비<b>무료 </b>
				</p>
			</div>

			<div class="row">

				<!-- 장바구니버튼 -->
				<button type="button" class="btn w-100 btn-add-cart"
					style="color: white; background-color: black;">장바구니</button>
			</div>
		</div>

	</div>
</div>



<div class="row center">
	<div class="row flex-box column-2">
		<div class="center">
			<h3 style="font-weight: bolder;">REVIEW ( ${reviewList.size()} )</h3>
		</div>
			
			
		
		<div class="center">
			<button type="button" class="btn btn-toggle1"
				style="margin-top: 10px; font-weight: bolder; border-color: white; background-color: white";>
				상품 리뷰 <i class="fa-solid fa-sort-down"></i>
			</button>
		</div>
	</div>


	<c:forEach var="dto" items="${reviewList}">
		<div class="container w-700 my-50">
			<div class="row target1">

				<div class="left">
					<div class="score"  data-max="5" data-rate="${dto.reviewScore}" style="margin-right: 5px; margin-bottom: 8px;"></div>

					<c:choose>
						<c:when test="${dto.reviewWriter == null}">탈퇴한 사용자</c:when>
						<c:otherwise>
							<c:choose>
								<c:when test="${fn:length(dto.reviewWriter) > 3}">
									<%-- 작성자의 아이디를 3글자 추출 후 표시 --%>
									<c:out value="${fn:substring(dto.reviewWriter, 0, 3)}" />
									<%-- 이후 아이디를 * 처리 --%>
									<c:out value="***" />
								</c:when>
								<c:otherwise>
									<%-- 아이디의 길이가 3글자 이하인 경우를 처리 --%>
									<c:out value="${dto.reviewWriter}" />
								</c:otherwise>
							</c:choose>
						</c:otherwise>
					</c:choose>
				</div>

				<div class="left">
					<div
						style="height: 170px; background-color: white; box-shadow: 0 0 2px #999; border-radius: 15px">
						${dto.reviewContent}</div>
				</div>

			</div>
		</div>
	</c:forEach>

	<div class="container w-1000">
		<%-- 	<h3>정보 번호 : ${infoDto.infoNo}</h3> --%>
		<%-- 	<h3>상품 번호 : ${infoDto.infoItemNo}</h3> --%>
		<div class="row center">
			<h3>${infoDto.infoContent}</h3>
		</div>
	</div>
</div>
</body>


<jsp:include page="/WEB-INF/views/template/size.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>