<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

     <style>
        .price{
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

        .btn-shirt:hover{
            background-color: #dfe6e9 !important;
        }
        

        .image-style{
	        width: 400px;
	        height: 550px;
	        display: inline-block;
	        text-align: center;
	        font-size: 20px;
        }
        .img-show{
            transition: 0s linear;
            opacity: 1;
        }

        .img-opacity{
            transition: 0s linear;
            opacity: 0;
        }
        
        #bigImage{
            margin-bottom: 10px;
        }
        .shoppingmal{
            cursor: pointer;
            width: 410px;
            height: 570px;
            background-image: url("https://d2u3dcdbebyaiu.cloudfront.net/uploads/atch_img/197/d72693912bf2868da3e848dc5b779d4a_res.jpeg");
        }
        .shoppingmal:hover{
            background-image: url("https://sitem.ssgcdn.com/06/09/87/item/1000183870906_i1_750.jpg");
        }

        #smallShirts{
            width: 100px;
            height: 100px;
            padding: 0 5px;
            cursor: pointer;
        }
        a#smallShirts:hover{
            background-image:url("https://sitem.ssgcdn.com/06/09/87/item/1000183870906_i1_750.jpg");
            }
        
       
        
       
      

    </style>

    <!--jquery cdn-->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.js"></script>
    <script src="https://cdn.jsdelivr.net/gh/hiphop5782/score@latest/score.js"></script>
    
    
        
        
    
    <script type="text/javascript">
      
        
        $(function(){
        //버튼에 사진 투명도 조절
        //     $(".btn-opacity").on("click", function(){
            //         $(".image-style").removeClass("img-show");
            //         $(".image-style").addClass("img-opacity");
            //     });
            //     $(".btn-show").on("click", function(){
                //         $(".image-style").removeClass("img-opacity");
                //         $(".image-style").addClass("img-show");
                //     });
                
                //사진 이동 구현

                
                    
                    
        //버튼 색 조절
       
            
        //상세 페이지 표시 제어
        $(".btn-toggle").click(function(){
            $(".target").slideToggle();
        });

        //별점
        $(".test-score2").score({
                editable:true,
                display:{
                    showNumber:true,
                    placeLimit:2
                }
            });   

    });
        
        </script>


    </head>
    <body>
    <div class="container w-1200 my-50">
   
    <div class="flex-box p-20">
        <div class="w-40 p-10">
            <div id="bigImage">
                <div id="container">
                <img class="shoppingmal" src="https://d2u3dcdbebyaiu.cloudfront.net/uploads/atch_img/197/d72693912bf2868da3e848dc5b779d4a_res.jpeg" width="100%">
                </div>
            <div class="row smallImages">    
                <img id="smallShirts" src="https://sitem.ssgcdn.com/06/09/87/item/1000183870906_i1_750.jpg" width="100%">
            </div>    
        </div>
        </div>
        <div class="w-40 p-10">
            <div class="row mt-0" style="font-size: 30px;">사인 니어 블랙 셔츠</div>
            <div class="row flex-box column-2">
                <div class="left">
                    <span class="price"><del>22,900</del></span>
                    <span style="padding-left: 5px;"><b>>17,900</b></span>
                </div>
                <div class="right">
                    <span style="color: red;">20%</span>
                    <span>(할인)</span>
                </div>
            </div>
            <div class="row mt-30 mb-20">
                <span style="font-size: 13px; color: #999;">미니 라벨 포인트, 데일리로 입기 좋은 캐주얼 셔츠</span>
            </div>
            <hr>
            <div class="row mb-20">
                <div class="row flex-box column-2">
                    <div class="left">
                        <button type="button" class="btn btn-toggle" style="border-color: white; background-color: white; padding: 1px;">상품정보</button><hr>
                        <div class="left">
                            <h3 class="target left">
                                <span style="font-size: 13px; color: #999;">-소비자가</span><br>
                                <span style="font-size: 13px; color: #999;">-판매가</span><br>
                                <span style="font-size: 13px; color: #999;">-배송비결제</span><br>
                            </h3>
                        </div>
                     </div>
                    <div class="right">
                        <button type="button" class="btn btn-toggle" style="border-color: white; background-color: white; padding-left: 6em"><i class="fa-solid fa-plus"></i></button><hr>
                        <div class="left">
                            <h3 class="target left">
                                <del style="font-size: 13px;">22,900원</del><br>
                                <span style="font-size: 15px;">17,900원</span><br>
                                <span style="font-size: 12px;">2,500원 (60,000원 이상 구매 시 무료)</span><br>
                            </h3>
                        </div>
                    </div>

                </div><hr>
                   
                <div class="float-box">
                    <div class="float-left w-20 px-20 py-20">
                        <div style="font-size: 15px; height: 150px; margin-top: 60px">색상</div>
                    </div>

                    <div class="right mt-40">
                        <div class="row left">
                            <span style="font-size: 11px; color: #999;">[필수] 옵션을 선택해 주세요</span><br>
                        </div>

                        <div style="display: flex; flex-wrap: nowrap;">
                            <button type="button" class="btn btn-shirt btn-show">블랙</button>
                            <button type="button" class="btn btn-shirt btn-show">네이비</button>
                            <button type="button" class="btn btn-shirt btn-show">옐로우</button>
                        </div>

                            <div class="row my-0">
                                <div class="left">
                                    <button type="button" class="btn btn-shirt btn-show">치콜</button>
                                    <button type="button" class="btn btn-shirt btn-show">브라운</button>
                                    <button type="button" class="btn btn-shirt btn-show">베이지</button>
                                </div>
                            </div>
                
                             <div class="row my-0">
                                <div class="left">
                                 <button type="button" class="btn btn-shirt btn-show">레드</button>
                                <button type="button" class="btn btn-shirt btn-show">카키</button>
                            </div>
                        </div>

                     </div>

                     <div class="row">
                        <p style="font-size: 11px; color: #999;"><i class="fa-regular fa-circle-exclamation"></i>최소주문수량 1개 이상녕</p>
                        <p style="font-size: 11px; color: #999;"><i class="fa-regular fa-circle-exclamation"></i>옵션선택 박스를 선택하시면 아래에 상품이 추가됩니다.</p>
                        <p style="font-size: 11px; color: #999;"><i class="fa-regular fa-circle-exclamation"></i>배송비<b>2,500원 (60,000원 이상 구매 시 무료)</b></p>
                     </div>

                    <div class="row">
                        <button type="submit" class="btn w-100" style="color: white; background-color: black;">구매하기</button>
                    </div>
                </div>  
            </div>
        </div>
    </div>
    <div class="cotainer w-1200 my-50">
        <div class="row flex-box column-2">
            <div class="left">
                <h3>REVIEW ()</h3>
            </div>
           
            <div class="left">
                <h3>전체 상품 리뷰</h3>
            </div>
        </div>
</div><hr>
<div class="left">
    <div class="test-score2" data-max="5" data-rate="3"></div>
</div>
</body>