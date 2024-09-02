<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>


<style>
	.table-border-top{
		background-color: transparent;
		border: 2px solid black;
		border-left: none;
		border-right: none;
		border-bottom: 1px solid #e9e9e9;
	}
	.table-border-middle{
		background-color: transparent;
		border-top: none;
		border-left: none;
		border-right: none;
		border-bottom: 1px solid #e9e9e9;
	}
	.table-border-center{
		background-color: #fbfafa;
		border-top: none;
		border-left: none;
		border-right: 1px solid #e9e9e9;
		border-bottom: none;
		font-size : 14px;
	}
	.table-border-side{
		background-color: transparent;
		border-top: none;
		border-left: 1px solid #e9e9e9;
		border-right: 1px solid #e9e9e9;
		border-bottom: none;
	}
</style>

<script type="text/javascript">
function removeCheck() {

	  if (confirm("정말 삭제하시겠습니까??") == true){    //확인
	      document.removefrm.submit();
	  }else{   //취소
	      return false;
	  }

	};
</script>

<div class="container w-700 my-50">
	<div class = "row center">
		<h1>${memberDto.memberId} 님의 개인 정보</h1>
	</div>
	
	<div class = "row center"> 
		<table class="table table-border-top">
		
		<tr  class="table-border-middle">
			<th class="table-border-center">
				<div class="row left ps-30">
					<span>아이디</span>
				</div>
			</th>
			<td>
				<div class="row center">
					<span>	${memberDto.memberId}</span>
				</div>
			</td>		
		</tr>		
		<tr  class="table-border-middle">
			<th class="table-border-center">
				<div class="row left ps-30">
					<span>이름</span>
				</div>
			</th>
			<td>
				<div class="row center">
					<span>	${memberDto.memberName}</span>
				</div>
			</td>		
		</tr>
		<tr class="table-border-middle">
			<th class="table-border-center">
				<div class="row left ps-30">
					<span>닉네임</span>
				</div>
			</th>
			<td>				
				<span>${memberDto.memberNickname}</span>
			</td>
		</tr>
		<tr class="table-border-middle">
			<th class="table-border-center">
				<div class="row left ps-30">
					<span>이메일</span>
				</div>				
			</th>
			<td>
				<span>${memberDto.memberEmail}</span>
			</td>
		</tr>
		<tr class="table-border-middle">
			<th class="table-border-center">
				<div class="row left ps-30">
					<span>생년월일</span>
				</div>				
			</th>
			<td>
				<span>${memberDto.memberBirth}</span>
			</td>
		</tr>
		<tr class="table-border-middle">
			<th class="table-border-center">
				<div class="row left ps-30">
					<span>연락처</span>
				</div>				
			</th>
			<td>
				<span>${memberDto.memberContact}</span>
			</td>
		</tr>
		<tr class="table-border-middle">
			<th class="table-border-center">
				<div class="row left ps-30">
					주소
				</div>				
			</th>
				<c:choose>
					<c:when test="${memberDto.memberPost==null && memberDto.memberAddress1==null && memberDto.memberAddress2==null}">
						<td>
							<span></span>
						</td>
					</c:when>
					<c:otherwise>
						<td>
							<span>[${memberDto.memberPost}] ${memberDto.memberAddress1}, ${memberDto.memberAddress2}</span>
						</td>
					</c:otherwise>						
				</c:choose>				
			</tr>
			<tr class="table-border-middle">
				<th class="table-border-center">
					<div class="row left ps-30">
						등급
					</div>
				</th>
				<td>
					<span>${memberDto.memberRank}</span>
				</td>
			</tr>
			<tr class="table-border-middle">
				<td class="table-border-center">
				<div class="row left ps-30">
					<span>포인트</span>
				</div>
				</td>
				<td>
					<span>${memberDto.memberPoint}<i class="fa-solid fa-coins"></i></span>
				</td>
			</tr>
			<tr class="table-border-middle">
				<td class="table-border-center">
					<div class="row left ps-30">
						<span>가입일</span>
					</div>
				</td>
				<td>
					<fmt:formatDate value="${memberDto.memberJoin}" pattern="y년 M월 d일"/>
				</td>
			</tr>
			<tr class="table-border-middle">
				<td class="table-border-center">
					<div class="row left ps-30">
						<span>최종 로그인</span>
					</div>
				</td>
				<td>
					<fmt:formatDate value="${memberDto.memberLogin}" pattern="y년 M월 d일 E H시 m분"/>
				</td>
			</tr>
		</table>
	</div>

	<!-- 개인정보 변경 버튼 -->
	<div class="flex-box flex-core mt-20 mb-30">
		<a href="password" class = "btn btn-positive" style="margin-right:5px;">비밀번호 변경</a>
		<a href="change" class = "btn btn-positive" style="margin-right:5px;">개인정보 변경</a>
		<a href="leaveFinish" class = "btn btn-negative member-delete" onclick="removeCheck();">회원 탈퇴</a>
	</div>

		<%--  관리자가 아닐 경우에만 차단이력을 출력 --%> 
		<c:choose>
			<c:when test="${memberDto.memberRank != '관리자'}">
				<hr>
					<div class = "row center">
								<div>
									<h1>차단/해제 이력</h1>
								</div>
							<c:choose>
								<c:when test="${blockList.isEmpty()}">
									<h3 style= "color:red">차단 이력이 존재하지 않습니다</h3>
								</c:when>
									<c:otherwise>
										<table class="table table-border-top">
											<thead>
												<tr class="table-border-middle">
													<th class="table-border-side" width="35%">일시</th>
													<th class="table-border-center" width="15%">구분</th>
													<th class="table-border-center">사유</th>
												</tr>
											</thead>
											<tbody>
												<c:forEach var="blockDto" items="${blockList}">
												<tr class="table-border-middle">
													<td class="table-border-side">
														<fmt:formatDate value="${blockDto.blockTime}"	pattern="y년 M월 d일 E H시 m분"/>
													</td>
													<td class="table-border-center">${blockDto.blockType}</td> <!--구분 -->
													<td class="table-border-center">${blockDto.blockMemo}</td> <!-- 사유 --> 
												</tr>
												</c:forEach>
											</tbody>
										</table>
									</c:otherwise>
							</c:choose>
						</div>
			</c:when>
		</c:choose>
</div>
		
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>

	








