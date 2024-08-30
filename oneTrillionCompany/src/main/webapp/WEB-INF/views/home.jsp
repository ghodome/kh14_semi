<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<!-- Swiper cdn-->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
<script
	src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>

<!-- jquery cdn -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<!-- 자바스크립트 작성 영역 -->

<style>
        .btn.btn-more{
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
        .image-align > a {
            text-decoration: none;
            color: black;
            
        }

        a > h4{
            margin: 0.3em;
        }
        
     </style>

<script type="text/javascript">
	$(function() {
		// var swiper = new Swiper(선택자, 옵션객체);
		var swiper = new Swiper('.swiper', {

			// Optional parameters
			direction : 'horizontal',
			loop : true, // 슬라이드 종료지점과 시작지점을 연결 할 것인가
			autoplay : true,
			autoplay : {
				delay : 2000,
				disableOnInteraction : true, // 사용자가 제어중일 경우 자동재생 해제
				pauseOnMouseEnter : true,
			},

			//If we need pagination
			                pagination: {
			                    el: '.swiper-pagination', // 적용대상
			                    clickable:true, //클릭하여 이동 가능
			                    type:'progressbar',
			                },

			// Navigation arrows
			navigation : {
				nextEl : '.swiper-button-next',
				prevEl : '.swiper-button-prev',
				hideOnClick : true,
			},

		// And if we need scrollbar
		// scrollbar: {
		//     el: '.swiper-scrollbar',
		//     enable: false,
		// },
		});
	});
</script>
</head>
<body>
	<div class="container w-600 my-50">
		<div class="row center">
			<h1 class="mt-30 mb-50">이달의 상품</h1>
		</div>
		<div class="row center">
			<!-- Slider main container -->
			<div class="swiper">
				<!-- Additional required wrapper -->
				<div class="swiper-wrapper">
					<!-- Slides -->
					<div class="swiper-slide">
						<a href="#"><img src="http://via.placeholder.com/300.png"></a>
					</div>
					<div class="swiper-slide">
						<a href="#"><img src="http://via.placeholder.com/300.png"></a>
					</div>
					<div class="swiper-slide">
						<a href="#"><img src="http://via.placeholder.com/300.png"></a>
					</div>
					<div class="swiper-slide">
						<a href="#"><img src="http://via.placeholder.com/300.png"></a>
					</div>
					<div class="swiper-slide">
						<a href="#"><img src="http://via.placeholder.com/300.png"></a>
					</div>
					<div class="swiper-slide">
						<a href="#"><img src="http://via.placeholder.com/300.png"></a>
					</div>
					<div class="swiper-slide">
						<a href="#"><img src="http://via.placeholder.com/300.png"></a>
					</div>
				</div>

				<!-- If we need navigation buttons -->
				<div class="swiper-button-prev"></div>
				<div class="swiper-button-next"></div>

				<!-- If we need pagination -->
<!-- 				<div class="swiper-pagination"></div> -->

				<!-- If we need scrollbar -->
				<!-- <div class="swiper-scrollbar""></div> -->
			</div>
		</div>
	</div>
	<div class="container w-700">

		<div class="row center">
			<h2>Best Item</h2>
		</div>
		<div class="row image-align">
            <a href="#"><img src="http://via.placeholder.com/200.png"><h4>BestItem</h4></h4></a>
            <a href="#"><img src="http://via.placeholder.com/200.png"><h4>BestItem</h4></a>
            <a href="#"><img src="http://via.placeholder.com/200.png"><h4>BestItem</h4></a>
            <a href="#"><img src="http://via.placeholder.com/200.png"><h4>BestItem</h4></a>
            <a href="#"><img src="http://via.placeholder.com/200.png"><h4>BestItem</h4></a>
            <a href="#"><img src="http://via.placeholder.com/200.png"><h4>BestItem</h4></a>
            <a href="#"><img src="http://via.placeholder.com/200.png"><h4>BestItem</h4></a>
            <a href="#"><img src="http://via.placeholder.com/200.png"><h4>BestItem</h4></a>
            <a href="#"><img src="http://via.placeholder.com/200.png"><h4>BestItem</h4></a>
        </div>
	</div>
	</div>
	</div>
	<div class="container w-700">
		<div class="row" style="height: 120px;"></div>
		<div class="row center">
			<h2>상의 Best</h2>
		</div>
		<div class="row image-align">
            <a href="#"><img src="http://via.placeholder.com/200.png"><h4>상의</h4></a>
            <a href="#"><img src="http://via.placeholder.com/200.png"><h4>상의</h4></a>
            <a href="#"><img src="http://via.placeholder.com/200.png"><h4>상의</h4></a>
            <a href="#"><img src="http://via.placeholder.com/200.png"><h4>상의</h4></a>
            <a href="#"><img src="http://via.placeholder.com/200.png"><h4>상의</h4></a>
            <a href="#"><img src="http://via.placeholder.com/200.png"><h4>상의</h4></a>
            <a href="#"><img src="http://via.placeholder.com/200.png"><h4>상의</h4></a>
            <a href="#"><img src="http://via.placeholder.com/200.png"><h4>상의</h4></a>
            <a href="#"><img src="http://via.placeholder.com/200.png"><h4>상의</h4></a>
        </div>
	</div>
</body>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>