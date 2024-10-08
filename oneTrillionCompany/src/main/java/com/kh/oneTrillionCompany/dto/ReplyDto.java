package com.kh.oneTrillionCompany.dto;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

@Data
public class ReplyDto {
	private int replyNo;
	private String replyWriter;
	private int replyOrigin;
	private String replyContent;
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
    private Date replyTime;
}

