package com.kh.oneTrillionCompany.controller;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.oneTrillionCompany.configuration.CustomCertProperties;
import com.kh.oneTrillionCompany.dao.BlockDao;
import com.kh.oneTrillionCompany.dao.CertDao;
import com.kh.oneTrillionCompany.dao.MemberDao;
import com.kh.oneTrillionCompany.dto.BlockDto;
import com.kh.oneTrillionCompany.dto.CertDto;
import com.kh.oneTrillionCompany.dto.MemberDto;
import com.kh.oneTrillionCompany.exception.TargetNotFoundException;
import com.kh.oneTrillionCompany.service.EmailService;

import jakarta.mail.MessagingException;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/member")
public class MemberController {
	@Autowired
	private MemberDao memberDao;
	@Autowired
	private BlockDao blockDao;
	@Autowired
	private CertDao certDao;
	@Autowired
	private CustomCertProperties customCertProperties;
	@Autowired
	private EmailService emailService;
	@Autowired
	private PasswordEncoder encoder;
	
	@GetMapping("/login")
	public String login() {
		return "/WEB-INF/views/member/login.jsp";
	}
	@PostMapping("/login")
    public String login(@RequestParam(required = false) String memberId,
            @RequestParam(required = false) String memberPw, 
            @RequestParam(required = false) String remember, //아이디 저장하기
            HttpSession session, HttpServletResponse response) {
        MemberDto memberDto = memberDao.selectOneWithPassword(memberId, memberPw);
        if(memberDto == null) return "redirect:login?error";

        boolean isNull = memberDto == null || memberDto.getMemberId() == null || memberDto.getMemberPw() == null;
        if(isNull) return "redirect:login?error";
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        String encrypt = memberDto.getMemberPw();
        String input = memberPw;
        
        boolean isValid = encoder.matches(input, encrypt);
        //boolean isValid = memberPw.equals(memberDto.getMemberPw());
        if(isValid == false) return "redirect:login?error";

        BlockDto blockDto = blockDao.selectLastOne(memberId);
        boolean isBlock = blockDto != null && blockDto.getBlockType().equals("차단");
        if(isBlock) return "redirect:block";

        session.setAttribute("createdUser", memberId);
        session.setAttribute("createdLevel", memberDto.getMemberRank());
        memberDao.updateMemberLogin(memberId);

        return "redirect:/";

    }	
	@GetMapping("/join")
	public String join() {
		return "/WEB-INF/views/member/join.jsp";
	}
	@Transactional
	@PostMapping("/join")
	public String join(@ModelAttribute MemberDto memberDto) throws IllegalStateException, IOException {
		//회원가입
		memberDao.insert(memberDto);
		
		
		return "redirect:joinFinish";
	}
	@RequestMapping("/joinFinish")
	public String joinFinish() {
		return "/WEB-INF/views/member/joinFinish.jsp";
	}
	
	@RequestMapping("/logout")
	public String logout(HttpSession session) {
		session.removeAttribute("createdUser");
		session.removeAttribute("createdLevel");
		return "redirect:/";
	}
	//마이페이지 구현
	@RequestMapping("/mypage")
	public String mypage(HttpSession session, Model model) {
		String createdUser = (String) session.getAttribute("createdUser");
		MemberDto memberDto = memberDao.selectOne(createdUser);
		if(memberDto.getMemberBirth()==null) {} 
		else 
		memberDto.setMemberBirth(memberDto.getMemberBirth().substring(0,10));
		model.addAttribute("memberDto", memberDto);
		model.addAttribute("blockList", blockDao.selectBlockHistory(createdUser));	//차단 내역 확인
		return "/WEB-INF/views/member/mypage.jsp";
	}
	
	//비밀번호 변경
	@GetMapping("/password")
	public String password() {
		return "/WEB-INF/views/member/password.jsp";
	}
	
	@PostMapping("/password")
	public String password(@RequestParam String currentPw, 
										@RequestParam String changePw,
										HttpSession session) {
//		//현재 비밀번호
//		String encodedPw=encoder.encode(currentPw);
//		//바뀐 비밀번호
//		String encodedPw2=encoder.encode(changePw);
		//아이디 추출
		String memberId = (String)session.getAttribute("createdUser");
		//현재 사용자의 정보를 추출
		MemberDto memberDto = memberDao.selectOne(memberId);
		//비밀번호 비교

		boolean isValid = encoder.matches(currentPw,memberDto.getMemberPw());
		if(isValid == false) return "redirect:password?error";
		//비밀번호 변경
		
		memberDao.updateMemberPw(memberId, changePw);

		//(+추가) 만약 비밀번호 변경 시 로그아웃 처리를 하려면 이곳에서!!!
		session.removeAttribute("createdUser");
		//완료 페이지로 추방
		return "redirect:passwordFinish";
	}
	
	@RequestMapping("/passwordFinish")
	public String passwordFinish() {
		return "redirect:login";
	}
	
	//비밀번호 찾기
	@GetMapping("/findPw")
	public String findPw() {
		return "/WEB-INF/views/member/findPw.jsp";
	}
	@PostMapping("/findPw")
	public String findPw(@RequestParam String memberId, 
											@RequestParam String memberEmail) throws IOException, MessagingException {
		MemberDto memberDto = memberDao.selectOne(memberId);
		if(memberDto == null) return "redirect:findPw:error";
		if(!memberEmail.equals(memberDto.getMemberEmail())) return "redirect:findPw:error";
		emailService.sendResetPw(memberId, memberEmail);
		return "redirect:findPwFinish";
	}
	@RequestMapping("/findPwFinish")
	public String findPwFinish() {
		
		return "/WEB-INF/views/member/findPwFinish.jsp";
	}
	
	
	
	//비밀번호 재설정 페이지
		@GetMapping("/resetPw")
		public String resetPw(@ModelAttribute CertDto certDto
							,@RequestParam String memberId
							,Model model) {
			boolean isValid = certDao.check(certDto, customCertProperties.getExpire());
			//isValid 가 true인 경우만 통과하도록 처리하면 비정상적 접근을 막을 수 있다.
			if(isValid) {
				model.addAttribute("certDto", certDto);
				model.addAttribute("memberId",memberId);
				return "/WEB-INF/views/member/resetPw.jsp";
			}
			else {
				throw new TargetNotFoundException("올바르지 않은 접근");
			}
		}
		@PostMapping("/resetPw")
		public String resetPw(@ModelAttribute CertDto certDto,
							@ModelAttribute MemberDto memberDto) {
			boolean isValid = certDao.check(certDto, customCertProperties.getExpire());
			if(!isValid) {
				throw new TargetNotFoundException("올바르지 않은 접근");
			}
			//인증 성공 시 인증번호 삭제
			//이 페이지는 1회만 접근 가능해짐
			certDao.delete(certDto.getCertEmail());
			
			//비밀번호 변경 처리
			memberDao.updateMemberPw(memberDto.getMemberId(), memberDto.getMemberPw());
			return "redirect:resetPwFinish";
		}
		@RequestMapping("/resetPwFinish")
		public String resetPwFinish() {
			return "/WEB-INF/views/member/resetPwFinish.jsp";
		}
		
		//개인정보 변경
		@GetMapping("/change")
		public String change(HttpSession session, Model model) {
			//아이디 추출
			String memberId = (String)session.getAttribute("createdUser");
			//회원정보 조회
			MemberDto memberDto = memberDao.selectOne(memberId);
			//화면에 전달
			model.addAttribute("memberDto", memberDto);
			return "/WEB-INF/views/member/change.jsp"; 
		}
		
		@PostMapping("/change")
		public String change(HttpSession session,
									@ModelAttribute MemberDto inputDto) {
			//기존 정보를 조회
			String memberId = (String)session.getAttribute("createdUser");
			//변경처리
			inputDto.setMemberId(memberId);//아이디 추가
			memberDao.updateMember(inputDto);
			return "redirect:mypage";
		}
		@GetMapping("/point")
		public String point(HttpSession session,Model model) {
			String memberId = (String) session.getAttribute("createdUser");
			MemberDto memberDto = memberDao.selectOne(memberId);
			model.addAttribute("memberDto", memberDto);
			return "/WEB-INF/views/member/point.jsp";
		}
//		회원 탈퇴
//		@GetMapping("leave")
//		public String leave() {
//			return "/WEB-INF/views/member/leave.jsp";
//			}
//		
//		@PostMapping("/leave")
//		public String leave(HttpSession session,@RequestParam String memberPw) {
//			
//			String memberId = (String) session.getAttribute("createdUser");
//			
//			
//			session.removeAttribute("createdUser");
//			session.removeAttribute("createdLevel");
//			
//			return "redirect:leaveFinish";
//		}
		
		@RequestMapping("/leaveFinish")
		public String leaveFinish(HttpSession session) {
			String memberId = (String) session.getAttribute("createdUser");
			memberDao.delete(memberId);
			session.removeAttribute("createdUser");
			session.removeAttribute("createdLevel");
			return "/WEB-INF/views/member/leaveFinish.jsp";
		}
		
		
		@RequestMapping("/block")
		public String block() {
			
			return "/WEB-INF/views/member/block.jsp";
		}
}
