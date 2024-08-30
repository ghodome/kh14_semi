<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<link rel="stylesheet" type="text/css" href="/css/infinityScroll.css">
<style>
.btn.btn-more {
	background-color: rgb(196, 227, 255);
	font-size: 16px;
	padding: 1.5em;
	padding-left: 3em;
	padding-right: 3em;
	padding-bottom: 2.5em;
	margin-bottom: 3px;
	border: none;
}

.image-align {
	display: flex;
	flex-wrap: wrap;
	gap: 50px;
}

.image-align>a {
	text-decoration: none;
	color: black;
}

a>h4 {
	margin: 0.3em;
}
</style>

<div class="container w-1200 my-50">
	<div class="row center">
		<h1>상품 목록 페이지</h1>
		<!-- 나중에 삭제 할곳  -->
	</div>
</div>

<div class="row center">
	<!-- 검색창 -->
	<div class="container w-1000">
		<div class="row center"></div>
		<h3 id="data-count" data-count="${itemList.size()}">데이터 개수 : ${itemList.size()}</h3>


<!-- 		<div class="row image-align" id="images"> -->
			<div class="card-container">
				<c:forEach var="itemDto" items="${itemList}">
				<div class="card">
					<a href="/item/detail?itemNo=${itemDto.itemNo}"> <img
						src="/item/image?itemNo=${itemDto.itemNo}" width="200px"
						height="200px">
						<h4 class="card-title">${itemDto.itemName}</h4>
						<h4 class="card-content">가격 : ${itemDto.itemSalePrice}원</h4>
					</a>
				</div>
				</c:forEach>


			</div>
<!-- 		</div> -->
	</div>
</div>
<script>
const $cardContainer = get('.card-container');
const $dataCountElem = get('#data-count');
const $cards = getAll('.card');
const $skeletonContainer = get('.skeleton-container');

const CREATE_CARD_COUNT = 4;
var cardImageNumber = 0;
const totalCardCount = parseInt($dataCountElem.getAttribute('data-count'), 10);

const io = new IntersectionObserver(ioObserver, {
  threshold: 1,
});

function get(htmlElem) {
  return document.querySelector(htmlElem);
}

function getAll(htmlElem) {
  return document.querySelectorAll(htmlElem);
}

function makeCard() {
  // Check if we have loaded all the cards
  const currentCardCount = $cardContainer.querySelectorAll('.card').length;
  if (currentCardCount >= totalCardCount) return; // Stop loading if all cards are loaded

  if (cardImageNumber >= 12) cardImageNumber = 0;
  for (var i = cardImageNumber; i < cardImageNumber + CREATE_CARD_COUNT; i++) {
    if (currentCardCount >= totalCardCount) break; // Stop adding more cards if we reach the total count

    const $card = document.createElement('div');
    $card.classList.add('card');
    $card.innerHTML = `
        <a href="/item/detail?itemNo=${i}">
          <img src="/item/image?itemNo=${i}" width="200px" height="200px">
          <h4 class="card-title">Item ${i}</h4>
          <h4 class="card-content">가격 : ${i * 1000}원</h4>
        </a>
      `;
    
    appendCard($card);
  }

  cardImageNumber += CREATE_CARD_COUNT;
}

function makeSkeletonCard() {
  for (let i = 0; i < CREATE_CARD_COUNT; i++) {
    const $skeletonCard = document.createElement('div');
    $skeletonCard.classList.add('skeleton-card');

    $skeletonCard.innerHTML = `
      <div class="skeleton-card-header"></div>
      <div class="skeleton-card-title"></div>
      <div class="skeleton-card-content"></div>
    `;

    appendCard($skeletonCard);
  }
}

function appendCard(cardElem) {
  $cardContainer.appendChild(cardElem);
}

function removeSkeletonCard() {
  const $skeletonCards = getAll('.skeleton-card');
  $skeletonCards.forEach((skeletonCard) => {
    $cardContainer.removeChild(skeletonCard);
  });
}

function loading() {
  makeSkeletonCard();
}

function ioObserver(entries) {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      io.unobserve(entry.target);
      loading();

      setTimeout(() => {
        makeCard();
        removeSkeletonCard();
        observeLastCard(io, getAll('.card'));
      }, 1000);
    }
  });
}

function observeLastCard(io, cards) {
  const lastItem = cards[cards.length - 1];
  if (lastItem) {
    io.observe(lastItem);
  }
}

function init() {
  makeCard(); // Initial load
  observeLastCard(io, getAll('.card'));
}

init();
</script>

</body>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>