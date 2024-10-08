<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.30.1/locale/ko.min.js"></script>

<style>
	.flex-box {
            display: flex;
            justify-content: space-between; 
            align-items: center; 
            margin-top: 0.5em;
	}
        .row > textarea{
            resize: none;
            min-width: 100%;
            min-height: 200px;
            width: 100%;
            padding-top: 0.5em;
            margin-top : 1em;
        }
        .qna-content {
        	min-height: 200px;
        	padding-top: 0.3em;
        	width: 100%;
        	text-align: left;
        	padding-left : 0.5em;
        	font-size : 16px;
        	
        }
        /* 텍스트 엔터,스페이스 container 박스 넘어가는 문제 해결 */
        .content-box {
        	white-space: pre-wrap;
        }
        .qna-content {
        	height : 100%;
        	
        }
        .reply-wrapper > .content-wrapper{
        	font-size: 16px;
        }
        .reply-wrapper > .content-wrapper > .reply-writer{
        	font-size: 1.25em;
        }
         .reply-wrapper > .content-wrapper > .reply-content{
         	font-size: 1em;
         	min-height: 50px;
         }
         

</style>


<!-- 댓글 템플릿 -->
<script type="text/template" id="reply-template">
	<!-- 댓글 1개 영역 -->
	<div class="reply-wrapper">

		<!-- 내용 영역 -->
		<div class="content-wrapper">
			<div class="reply-writer">댓글 작성자</div>
			<div class="reply-content">댓글 내용</div>
			<div class="reply-info">
				<span class="time">yyyy-MM-dd HH:mm:ss</span>
				<a href="${pageContext.request.contextPath}/rest/reply/update" class="link link-animation reply-update-btn">수정</a>
				<a href="${pageContext.request.contextPath}/rest/reply/delete" class="link link-animation reply-delete-btn">삭제</a>
			</div>
		</div>
	</div>
</script>

<!-- 댓글 수정 템플릿 -->
<script type="text/template" id="reply-update-template">
	<div class="reply-wrapper reply-update-wrapper">
		<div>
			<div class="reply-title">작성자</div>
			<textarea class="field w-100 reply-update-input"></textarea>
			<div class="right">
				<button class="btn btn-neutral reply-cancel-btn">취소</button>
				<button class="btn btn-neutral reply-complete-btn">완료</button>
			</div>
		</div>
	</div>
</script>

<!-- 댓글 처리를 위한 JS코드 -->
<script type="text/javascript">
	$(function(){
		//현재 페이지의 파라미터 중 qnaNo 추출
		var param = new URLSearchParams(location.search);
		var qnaNo = param.get("qnaNo");
		
		//현재 로그인한 사용자의 아이디를 변수로 저장
		var currentUser = "${sessionScope.createdUser}";
		
		//댓글 등록
		$(".reply-add-btn").click(function(){
			//작성된 내용 읽기
			var content = $(".reply-input").val();
			if(content.length == 0) return;
			//비동기 통신
			$.ajax({
				url: "${pageContext.request.contextPath}/rest/reply/write",
				method: "post",
				data: {
					replyContent: content,
					replyOrigin: qnaNo
				},
				success: function(response){
					$(".reply-input").val("")
					loadList();
				}
			});
		});
		
 		//댓글 목록 처리
		loadList();
		function loadList() {

			//댓글 목록 불러오기
			$.ajax({
				url:"${pageContext.request.contextPath}/rest/reply/list",
				method:"post",
				data:{ replyOrigin : qnaNo },
				success: function(response) {
					//기존 내용 삭제
					$(".reply-list-wrapper").empty();
					
				//전달된 댓글 개수만큼 반복하여 화면 생성
				for(var i=0; i < response.length; i++) {
					var template = $("#reply-template").text();
					var html = $.parseHTML(template);
					
					$(html).find(".reply-writer").text(response[i].replyWriter);
// 	                $(html).find(".reply-content").text(response[i].replyContent);
					// 줄바꿈 문자를 <br>로 변환하여 표시
               		$(html).find(".reply-content").html(response[i].replyContent.replace(/\n/g, "<br>"));
					//시간형식 지정
					var time = moment(response[i].replyTime, "YYYY-MM-DD HH:mm").format("YYYY-MM-DD dddd HH:mm");
                    $(html).find(".reply-info > .time").text(time);
// 					$(html).find(".reply-info > .time").text(response[i].replyTime);
					
					if(response[i].replyWriter == currentUser) { //작성자가 현재 사용자(currentUser)라면
						$(html).find(".reply-update-btn , .reply-delete-btn").attr("data-reply-no", response[i].replyNo);	// 수정,삭제 버튼을 생성
					}
					else{
						$(html).find(".reply-update-btn , .reply-delete-btn").remove();	// 수정,삭제 버튼을 삭제
					}
					$(".reply-list-wrapper").append(html);
					}
				}
			});

		} 

		// 댓글 수정
		$(document).on("click", ".reply-update-btn", function(e){
		    e.preventDefault();
		    
		    // 기존 입력화면 제거
		    $(".reply-wrapper").show();
		    $(".reply-input").hide(); 
		    $(".reply-add-btn").hide();

		    var template = $("#reply-update-template").text();
		    var html = $.parseHTML(template);
		    $(this).parents(".reply-wrapper").after(html); 
		    $(this).parents(".reply-wrapper").hide();
		    
		    var replyWriter = $(this).parents(".reply-wrapper").find(".reply-writer").text();
		    $(html).find(".reply-title").text(replyWriter);
		    var replyContent = $(this).parents(".reply-wrapper").find(".reply-content").html();
		    replyContent = replyContent.replace(/<br>/g , "\n");
		    $(html).find(".reply-update-input").val(replyContent);
		    
		    var replyNo = $(this).attr("data-reply-no");
		    $(html).find(".reply-complete-btn").attr("data-reply-no", replyNo);
		});


		
		//수정 취소
		$(document).on("click",".reply-cancel-btn", function(){
			$(this).parents(".reply-update-wrapper").prev(".reply-wrapper").show();
			$(this).parents(".reply-update-wrapper").remove();
			
			$(".reply-input").show();
			$(".reply-add-btn").show();
		});
		
		//수정 완료
		$(document).on("click",".reply-complete-btn",function(e){
			e.preventDefault();
			var choice = window.alert("수정하시겠습니까?");
			if(choice == false) return;
			
			var replyContent = $(this).parents(".reply-update-wrapper").find(".reply-update-input").val();
			var replyNo = $(this).attr("data-reply-no");
			if(replyContent.length==0){
				window.alert("내용을 작성해주세요");
				return;
			}
			//서버로 댓글 수정을 위한 정보 전달
			$.ajax({
				url: "${pageContext.request.contextPath}/rest/reply/update",
				method: "post",
				data:{
					replyNo : replyNo,
					replyContent : replyContent
				},
				success : function(response){
					loadList();
				}
			})
			$(".reply-input").show();
			$(".reply-add-btn").show();
		});
		
		//댓글 삭제
		$(document).on("click",".reply-delete-btn",function(e){
			e.preventDefault();
			
			var choice = window.confirm("삭제하시겠습니까?");
			if(choice == false) return;
			
			var replyNo = $(this).attr("data-reply-no");
			$.ajax({
				url: "${pageContext.request.contextPath}/rest/reply/delete",
				method: "post",
				data: {
					replyNo : replyNo
				},
				success : function(response){
					loadList();
				},
			});
		});
	});
	/* 게시글삭제 버튼시 알림창 생성 */
	$(function(){
		$(".btn-delete").click(function(e){
			e.preventDefault();
			var historyDel = window.confirm("게시글을 삭제 하시겠습니까?");
            if (historyDel) {
                // 확인을 클릭한 경우 폼 제출
                $("#checkForm").submit();
            }
            // 취소 버튼을 누를 경우 동작X
		});
	});
</script>

<form action="delete?qnaNo=${qnaDto.qnaNo}" method="post" id="checkForm">
	<div class="container w-1000">
		<div class="row center">
			<h1>${qnaDto.qnaTitle}</h1>
		</div>
		<hr>
		<div class="row mt-30">
			<table class="table table-border">
				<tbody>
					<tr>
						<td>
							<div class="row left">
								<span class="write-deco">작성자</span>
									<c:if test="${qnaDto.qnaWriter == null}">탈퇴한 사용자</c:if>
									<c:if test="${qnaDto.qnaWriter != null}"> ${qnaDto.qnaWriter} </c:if>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div class="row left">
								<span class="write-deco">작성일</span>
								<fmt:formatDate value="${qnaDto.qnaTime}" pattern="y-MM-d H:mm"/>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div class="row qna-content" >
								<pre class="content-box">${qnaDto.qnaContent}</pre>
							</div>
						</td>
					</tr>
					<tr>	
					<!-- 댓글수 -->
						<td>
							<div class="row left">
								<i class="fa-regular fa-comment-dots"></i> <fmt:formatNumber value="${qnaDto.qnaReply}" pattern="#,##0"/>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
			<!-- 수정/삭제 버튼  -->
			<div class= " flex-box ">
				<a href="${pageContext.request.contextPath}/qna/list"  class="btn btn-list btn-positive">
					<i class="fa-solid fa-list"></i> 목록
				</a>
		        <div>
		        	<c:if test="${sessionScope.createdUser == qnaDto.qnaWriter}">
			            <a href="update?qnaNo=${qnaDto.qnaNo}" class="btn btn-update btn-positive">
			            	<i class="fa-solid fa-pen-to-square"></i> 수정
			            </a>
		            </c:if>
		            <c:if test="${sessionScope.createdUser == qnaDto.qnaWriter || sessionScope.createdLevel == '관리자'}">
			            <button type="button" class="btn btn-delete btn-negative">
			            	<i class="fa-solid fa-trash"></i> 삭제
			            </button>
		            </c:if>
		        </div>
			</div>
		</div>
		<%-- 관리자 답변 댓글창  --%> 
		<hr>
			<div class="row reply-list-wrapper">
			</div>
		<hr>
		<c:if test="${sessionScope.createdLevel =='관리자'}">
			<div class="row">
				<textarea class="field w-100 reply-input"></textarea>
				<button type="button" class="btn btn-positive reply-add-btn">
					<i class="fa-solid fa-pen-to-square"></i> 댓글 작성
				</button>
			</div>
		</c:if>
	</div>
</form>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>
