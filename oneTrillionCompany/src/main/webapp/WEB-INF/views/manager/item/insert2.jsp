<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include> 
    
    
    <div class="container w-600 center">
        <div class="row center">
            <h2>상품등록</h2>
        </div>
        <form action="insert" method="post" enctype="multipart/form-data" autocomplete="off">
                
                <label>사진 등록</label>
            <div class="row">
            	<input type="file" name="attach" class="field" >
            </div>
                <label>상품명</label>
            <div class="row">
                <input type="text" name="itemName" class="field">
            </div>
                <label>정가</label>
            <div class="row">
                <input type="number" name="itemPrice" class="field">
            </div>
                <label>판매가</label>
            <div class="row">
                <input type="number" name="itemSalePrice" class="field">
            </div>
                <label>재고 수</label>
            <div class="row">
                <input type="number" name="itemCnt" class="field">
            </div>
                <label>사이즈</label>
            <div class="row">
                <select name="itemSize" class="field" style="width: 10em;">
                	<option value="S">Small</option>
                	<option value="M">Medium</option>
                	<option value="L">Large</option>
                	<option value="XL">Extra-large</option>
                </select>
            </div>
            <div class="row">
        <h3>카테고리</h3>
        <select name="itemCate1" id="cate1-select" class="field">
        	<option value="">상위 카테고리 선택</option>
            <option value="11">상의</option>
            <option value="33">하의</option>
            <option value="55">신발</option>
            <option value="77">아우터</option>
        </select>
    </div>
    <div class="row">
        <select name="itemCate2" id="cate2-select" class="field">
            <option value="">하위 카테고리 선택</option>
        </select>
    </div>
    <div class="row">
        <select name="itemCate3" id="cate3-select" class="field">
            <option value="">세부 카테고리 선택</option>
        </select>
    </div>
                <label>할인율</label>
            <div class="row">
                <input type="number" name="itemDiscountRate" class="field">
            </div>
            	<label>색상</label>
            <div class="row">
            	<select name="itemColor" class="field" style="width: 10em;">
            		<option value="">선택없음</option>
            		<option value="black">검정</option>
            		<option value="red">빨강</option>
            		<option value="orange">주황</option>
            		<option value="yellow">노랑</option>
            		<option value="green">초록</option>
            		<option value="blue">파랑</option>
            		<option value="brown">브라운</option>
            		<option value=" pink">분홍</option>
            		<option value="white">흰색</option>
            	</select>
            </div>
        <div class="right">
        <button type="submit" class="btn btn-positive">등록</button>
    </div>
        </form>
           
    </div>
    <script>
        var cate2Options = {
            11: [
            	{ value: "", text: "선택하세요"},
                { value: "10", text: "티셔츠" },
                { value: "11", text: "셔츠" }
            ],
            33: [
                { value: "30", text: "슬랙스" },
                { value: "31", text: "데님" },
                { value: "32", text: "트레이닝" },
                { value: "33", text: "반바지" }
            ],
            55: [
                { value: "50", text: "스니커즈" },
                { value: "51", text: "로퍼/슬립온" },
                { value: "52", text: "구두" },
                { value: "53", text: "워커/부츠" },
                { value: "54", text: "샌들/슬리퍼" },
                { value: "55", text: "깔창/기타" }
            ],
            77: [
                { value: "70", text: "가디건" },
                { value: "71", text: "블루종" },
                { value: "72", text: "집업" },
                { value: "73", text: "바람막이" },
                { value: "74", text: "블레이저" },
                { value: "75", text: "청재킷" }
            ]
        };

        var cate3Options = {
            10: [
                { value: "10", text: "7부" },
                { value: "11", text: "민소매" },
                { value: "12", text: "긴팔" },
                { value: "13", text: "반팔" },
                { value: "14", text: "맨투맨" },
                { value: "15", text: "후드" },
                { value: "16", text: "니트/스웨터" }
            ],
            11: [
                { value: "17", text: "반팔셔츠" },
                { value: "18", text: "7부 셔츠" },
                { value: "19", text: "긴팔셔츠" },
                { value: "20", text: "베이직/심플" },
                { value: "21", text: "스트라이프" },
                { value: "22", text: "체크" }
            ],
            30: [
                { value: "30", text: "스트레이트핏" },
                { value: "31", text: "테이퍼드핏" },
                { value: "32", text: "와이드핏" }
            ],
            31: [
                { value: "35", text: "스트레이트핏" },
                { value: "36", text: "테이퍼드핏" },
                { value: "37", text: "와이드핏" }
            ],
            32: [
                { value: "38", text: "트레이닝" },
                { value: "39", text: "조거" }
            ],
            33: [
                { value: "33", text: "일반 반바지" },
                { value: "34", text: "데님 반바지" }
            ]
        };

        document.getElementById('cate1-select').addEventListener('change', function () {
            var cate1Value = this.value;
            var cate2Select = document.getElementById('cate2-select');
            var cate3Select = document.getElementById('cate3-select');
            
            updateSelectOptions(cate2Select, cate2Options[cate1Value] || []);
            updateSelectOptions(cate3Select, []);
        });

        document.getElementById('cate2-select').addEventListener('change', function () {
            var cate2Value = this.value;
            var cate3Select = document.getElementById('cate3-select');
            
            updateSelectOptions(cate3Select, cate3Options[cate2Value] || []);
        });

        function updateSelectOptions(selectElement, options) {
            // Clear existing options
            selectElement.innerHTML = '';
            // Add new options
            options.forEach(option => {
                var opt = document.createElement('option');
                opt.value = option.value;
                opt.text = option.text;
                selectElement.add(opt);
            });
        }
    </script>
    
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>