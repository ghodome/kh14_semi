package com.kh.oneTrillionCompany.dto;

import java.util.Date;

import lombok.Data;

@Data
public class BlockDto {
	private int blockNo;
	private String blockMemberId;
	private String blockType;
	private String blockMemo;
	private Date blockTime;
}
