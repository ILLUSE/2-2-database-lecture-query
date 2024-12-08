use krible;

/*
-- 유저별 관심종목 뷰 만들기
-- 1.1번 유저의 전체 데이터
SELECT *
FROM T_user_company
WHERE user_id= 1
ORDER BY user_id, company_ticker, update_time DESC;

-- 2.각 유저 종목별로 가장 최근 것만(하트 했다가 취소했다가 할수있기떄문 , 가장 최근에 한게 현재 상태)
SELECT user_id, company_ticker, max(update_time) update_time
FROM T_user_company
GROUP BY user_id, company_ticker
ORDER BY user_id,company_ticker;

-- 3.2번에서 원래 테이블과 조인하여 하트 나오게 해줌
SELECT *
FROM T_user_company tuc
JOIN (
SELECT user_id, company_ticker, max(update_time) update_time
FROM T_user_company
GROUP BY user_id, company_ticker
) a on tuc.user_id = a.user_id
and tuc.company_ticker = a.company_ticker
and tuc.update_time = a.update_time;

-- 4.3번으로 뷰 만들기
CREATE VIEW T_user_company_heart AS
SELECT tuc.user_id, tuc.company_ticker
FROM T_user_company tuc
JOIN (
SELECT user_id, company_ticker, max(update_time) update_time
FROM T_user_company
GROUP BY user_id, company_ticker
) a on tuc.user_id = a.user_id
and tuc.company_ticker = a.company_ticker
and tuc.update_time = a.update_time
WHERE tuc.heart = 1
ORDER BY tuc.user_id, tuc.company_ticker;
*/

/*
-- 관심종목의 컨텐츠 중 가장 최근 컨텐츠 찾기
-- 1.2번 유저의 관심종목
select company_ticker
from T_user_company_heart
where user_id =2;

-- 2.관심 종목이 나온 컨텐츠 찾기
select *
from T_content_company cc
join T_content c on cc.content_id = c.content_id
where cc.company_ticker in(
select company_ticker
from T_user_company_heart
where user_id =2 );

-- 3.2번 중 가장 최근 컨텐츠
select *
from T_content_company cc
join T_content c on cc.content_id = c.content_id
where cc.company_ticker in(
select company_ticker
from T_user_company_heart
where user_id =2 )
order by c.update_time desc
limit 1;
*/

/*
-- 컨텐츠 정보 나열하기
-- 내가 짠 것
select c.title,c.body_summary,t1.topic_name,t2.topic_name,a.author_name
from T_content_company cc
left join T_content c on cc.content_id = c.content_id
left join T_content_topic ct on cc.content_id = ct.content_id
left join T_topic t1 on ct.topic_id = t1.topic_id and cc.orders = 1
left join T_topic t2 on ct.topic_id = t2.topic_id and cc.orders = 2
left join T_content_author ca on cc.content_id = ca.content_id
left join T_author a on ca.author_id = a.author_id
where c.content_id = 10;

SELECT tc.title, tc.update_time, tc.body_summary,
tc2.company_name, tt.topic_name, tt2.topic_name, ta.author_name
FROM T_content tc
LEFT JOIN T_content_company tcc on tc.content_id = tcc.content_id and tcc.orders = 1
LEFT JOIN T_company tc2 on tcc.company_ticker = tc2.company_ticker
LEFT JOIN T_content_topic tct on tc.content_id = tct.content_id and tct.orders = 1
LEFT JOIN T_topic tt on tct.topic_id = tt.topic_id
LEFT JOIN T_content_topic tct2 on tc.content_id = tct2.content_id and tct2.orders = 2
LEFT JOIN T_topic tt2 on tct2.topic_id = tt2.topic_id
LEFT JOIN T_content_author tca on tc.content_id = tca.content_id and tca.orders = 1
LEFT JOIN T_author ta on tca.author_id = ta.author_id
WHERE tc.content_id = 10;

select c.title
from T_content c -- content 테이블: 제목
left join 
*/





