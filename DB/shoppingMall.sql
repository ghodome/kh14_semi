
CREATE TABLE member (
	member_id	varchar2(20)		 primary key,
	member_pw	varchar2(16)		not null,
	member_name	varchar2(21)		NOT NULL,
	member_nickname	varchar2(30)	NOT NULL unique,
	member_email varchar2(60) not null, 
	member_block	char(1)		NULL,
	member_rank	varchar2(12)	DEFAULT '일반회원'	NOT NULL,
	member_point	number	DEFAULT 0,
	member_join	date	DEFAULT sysdate	NULL,
	member_login	date		NULL,
	member_post	varchar2(6),
	member_address1	varchar2(300),
	member_address2	varchar2(300),
	member_height	number		NULL,
	member_weight	number		NULL,
	check(regexp_like(member_id, '^[a-z][a-z0-9]{4,19}$')),
	check(
    regexp_like(member_pw, '^[A-Za-z0-9!@#$]{8,16}$')
    and
    regexp_like(member_pw, '[A-Z]+')
    and
    regexp_like(member_pw, '[a-z]+')
    and
    regexp_like(member_pw, '[0-9]+')
    and
    regexp_like(member_pw, '[!@#$]+')
	),
	
	check(regexp_like(member_nickname, '^[가-힣0-9]{2,10}$')),
	check(member_rank in ('일반회원','우수회원','관리자')),
	check(member_point >= 0),
	check(regexp_like(member_post, '^[0-9]{5,6}$')),
	check(
    --주소가 다 없는 경우
    (member_post is null and member_address1 is null and member_address2 is null)
    or
    --주소가 다 작성된 경우
    (member_post is not null and member_address1 is not null and member_address2 is not null)
)
);
INSERT INTO "MEMBER"(member_id, member_pw, member_name, member_nickname, member_email, 
MEMBER_RANK) values('testuser1', 'Testuser1!', '일반회원', '일반회원', 'meansuck9998oo@gmail.com', '일반회원');

SELECT * FROM MEMBER;
commit;

CREATE TABLE block (
	block_no	number		primary key,
	block_member_id	varchar2(20)	references member(member_id) on delete cascade	NOT NULL,
	block_type	char(6)		NOT NULL,
	block_memo	varchar2(300)		NOT NULL,
	block_time	date	DEFAULT sysdate	NOT NULL,
	check(block_type in ('차단','해제'))
);
create sequence block_seq;
SELECT * FROM block;


CREATE TABLE category (
	cate_no	number	,
	cate_name	varchar2(30)	primary key
);
create sequence category_seq;
SELECT * FROM category;


CREATE TABLE item (
	item_no	number		primary key,
	cate_no	number	references CATEGORY(CATE_NO) on delete cascade	NOT NULL,
	item_name	varchar2(300)		NOT NULL,
	item_price	number		NOT NULL,
	item_sale_price	number		NOT NULL,
	item_date	Date	DEFAULT sysdate	NOT NULL,
	item_cnt	number	DEFAULT 1	NOT NULL,
	item_size	varchar2(3)		NOT NULL,
	check(item_price >= 0),
	check(item_sale_price >= 0),
	CHECK(item_cnt >= 1),
	check(item_size IN ('S','M','L','XL'))
	);


create sequence item_seq;
SELECT * FROM item;



CREATE TABLE cart (
	cart_no	number		 primary key,
	cart_item_no	number	references ITEM(ITEM_NO) on delete cascade	not NULL,
	cart_cnt	number	DEFAULT 1	NOT NULL,
	item_attach_no	number		NOT NULL,
	cart_total_price	number		NOT NULL,
	check(cart_cnt >= 1),
	check(cart_total_price >= 0)
);
create sequence cart_seq;
SELECT * FROM cart;


CREATE TABLE orders (
	order_no	number		primary key,
	order_member_id	varchar2(20)	references member(member_id) on delete cascade	NOT NULL,
	order_cart_no	number	references CART(CART_NO) on delete cascade	NOT NULL,
	order_price	number	DEFAULT 0	NOT NULL,
	order_date	Date	DEFAULT sysdate	NOT NULL,
	order_status	varchar2(12)		NOT NULL,
	check(ORDER_price >= 0)
);
CREATE sequence order_seq;
SELECT * FROM orders;
drop table orders;

CREATE TABLE refund (
	refund_order_no	number	references ORDERS(ORDER_NO) on delete cascade	NOT NULL,
	refund_memo	varchar2(300)		NOT NULL,
	refund_date	date		NOT NULL
);
SELECT * FROM refund;




CREATE TABLE order_detail (
	order_detail_no	number		primary key,
	order_detail_item_no	number	references ITEM(ITEM_NO) on delete cascade	NOT NULL,
	order_detail_order_no	number	references ORDERS(ORDER_NO) on delete cascade	NOT NULL,
	order_detail_price	number		NOT NULL,
	order_detail_cnt	number	DEFAULT 1	NOT NULL,
	check(order_detail_price >= 0),
	check(order_detail_cnt >= 0)
);
CREATE sequence order_detail_seq;
SELECT * FROM order_detail;


CREATE TABLE attach (
	attach_no	number		 primary key,
	attach_name	varchar2(255)	NOT NULL UNIQUE,
	attach_type	varchar2(90)	NOT NULL,
	arrach_size	number		NOT NULL
);
create sequence attach_seq;
SELECT * FROM attach;


CREATE TABLE image (
	item_no	number	references ITEM(ITEM_NO) on delete cascade	not null,
	attach_no	number	references ATTACH(ATTACH_NO) on delete cascade	not null
);
SELECT * FROM image;





CREATE TABLE QNA (
	qna_no	number		 primary key,
	qna_writer	varchar2(20)	references MEMBER(MEMBER_ID) on delete cascade	NOT NULL,
	qna_title	varchar2(90)		NOT NULL,
	qna_content	varchar2(3000)		NOT NULL,
	qna_time	date	DEFAULT sysdate	NOT NULL
);
create sequence qna_seq;
SELECT * FROM QNA;


CREATE TABLE reply (
	reply_no	number		PRIMARY key,
	reply_writer	varchar2(20)	references MEMBER(MEMBER_ID) on delete cascade	NOT NULL,
	reply_origin	number	references qna(qna_no) on delete cascade	NOT NULL,
	reply_content	varchar2(1000)		NOT NULL,
	reply_time	date	DEFAULT sysdate	NOT NULL
);
SELECT * FROM reply;


CREATE TABLE review (
	review_no	number		 primary key,
	review_item_no	number	REFERENCES item(item_no) ON DELETE cascade	not NULL,
	review_writer	varchar2(20)	references MEMBER(MEMBER_ID) on delete cascade	NOT NULL,
	review_content	varchar2(1500)		NOT NULL,
	review_score	number		NOT NULL
);
create sequence review_seq;
SELECT * FROM review;
INSERT INTO review (
    review_no, 
    review_item_no, 
    review_writer, 
    review_content, 
    review_score
) VALUES (
    review_seq.NEXTVAL,    -- 자동 증가하는 review_no
    1,                    -- 예시로 아이템 번호 1
    'admin',              -- 리뷰 작성자
    'This is a dummy review content for testing purposes.',  -- 리뷰 내용
    5                     -- 리뷰 점수 (예: 5점)
);
commit;

CREATE TABLE review_image (
	review_no	number		NOT NULL,
	attach_no	number		NOT NULL
);
SELECT * FROM review_image;

commit;

