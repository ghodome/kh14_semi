package com.kh.oneTrillionCompany.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.oneTrillionCompany.dao.ItemDao;
import com.kh.oneTrillionCompany.dao.ItemInfoDao;
import com.kh.oneTrillionCompany.dao.ReviewDao;
import com.kh.oneTrillionCompany.dto.ItemDto;
import com.kh.oneTrillionCompany.dto.ItemInfoDto;
import com.kh.oneTrillionCompany.dto.ReviewDto;
import com.kh.oneTrillionCompany.vo.PageVO;

@Controller
@RequestMapping("/item")
public class ItemController {

	@Autowired
	private ItemDao itemDao;

	@Autowired
	private ItemInfoDao infoDao;
	@Autowired
	private ReviewDao reviewDao;
	
	@RequestMapping("/list")
	public String list(@ModelAttribute("pageVO") PageVO pageVO, Model model,
									@RequestParam(required = false) String keyword) {
		boolean isSearch = keyword != null;
		
		model.addAttribute("itemList", itemDao.selectList());
		
		return "/WEB-INF/views/item/list2.jsp";
	}
//	private boolean checkSearch(String keyword) {
//		if(keyword != null) return true;
//		
//		return false;
//	}
//	
	@RequestMapping("/list/cate")
	public String listCate(Model model,
			@RequestParam(required = false) String column, 
			@RequestParam(required = false) String keyword) {
		boolean isSearch = column != null && keyword != null;

		List<ItemDto> list = isSearch ? itemDao.selectListByCate(column, keyword) : itemDao.selectList();
		model.addAttribute("column", column);
		model.addAttribute("keyword", keyword);// 검색어
		model.addAttribute("itemList", list);// 조회결과
		return "/WEB-INF/views/item/list2.jsp";
	}

	@RequestMapping("/detail")
	public String detail(@RequestParam int itemNo, Model model) {
		ItemDto itemDto = itemDao.selectOne(itemNo);
		ItemInfoDto infoDto = infoDao.selectOne(itemNo);
		List<ReviewDto> list=reviewDao.selectList();
		//if(infoDto == null) throw new TargetNotFoundException("존재하지 않는 글 번호");
		model.addAttribute("list",list);
		model.addAttribute("itemDto", itemDto);
	    model.addAttribute("infoDto", infoDto);
	    model.addAttribute("itemNo", itemNo);
	    //품절시 버튼 비활성화-장바구니
	    model.addAttribute("colorList", itemDao.selectItemColors(itemNo));
		model.addAttribute("attachNo", itemDao.findImage(itemNo));
		return "/WEB-INF/views/item/detail2.jsp";
	}
	
	
	
	//
	@GetMapping("/insert")
	public String insert() {
		
		return "/WEB-INF/views/item/insert.jsp";
	}
	@PostMapping("/insert")
	public String insert(@ModelAttribute ItemDto itemDto) {
		itemDao.insert(itemDto);
		
		return "redirect:list";
	}

	
	// 이미지
	@RequestMapping("/image")
	public String image(@RequestParam int itemNo) {
		try {
			int attachNo = itemDao.findImage(itemNo);
			return "redirect:/attach/download?attachNo=" + attachNo;
				}
				catch(Exception e){
					return "redirect:https://placehold.co/200";
				}
			}
	

}
