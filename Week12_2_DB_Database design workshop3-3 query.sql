use krible;
/*
-- 1. 종목하트개수, 내가하트했는지표기
-- 'A005380'을 하트한 사람 의 수
select count(*) cnt
from T_user_company_heart
where company_ticker =  'A005380';

-- user_id=1이 이 종목에 하트를 했는지
select *
from T_user_company_heart
where company_ticker =  'A005380'
and user_id = 1;
*/

/*
-- 2. 종목 정보 나열하기
-- 'A005380' 티커의 종목이름, 23년3분기의 시가총액, 순위, 매출액, 순이익, PER
select c.company_name,ca.*
from T_company c
join T_company_account ca on c.company_ticker = ca.company_ticker
where ca.quarters = '2303' and c.company_ticker = 'A005380';
*/

/*
-- 3.연관 토픽 찾기
select t.topic_name,count(*) cnt
from T_topic t -- topic_name
join T_content_topic ct on t.topic_id = ct.topic_id -- topic 이랑 content_company 이어주기용 
join T_content_company cc on ct.content_id = cc.content_id -- company_ticker 사용하기 위해
where cc.company_ticker =  'A005380'
group by topic_name
order by  cnt desc,topic_name;
*/

-- 4.종목이 나온 컨텐츠 정보 나열하기
SELECT 
    tt.topic_name AS topic1, 
    tt2.topic_name AS topic2,
    tc2.company_name AS company1, 
    tc3.company_name AS company2,
    tc.title, 
    tc.body_summary, 
    ta.affiliation, 
    ta.author_name, 
    tc.update_time
FROM T_content tc
JOIN T_content_company tcc ON tc.content_id = tcc.content_id
LEFT JOIN T_content_topic tct ON tc.content_id = tct.content_id AND tct.orders = 1
LEFT JOIN T_topic tt ON tct.topic_id = tt.topic_id
LEFT JOIN T_content_topic tct2 ON tc.content_id = tct2.content_id AND tct2.orders = 2
LEFT JOIN T_topic tt2 ON tct2.topic_id = tt2.topic_id
LEFT JOIN T_content_company tcc2 ON tc.content_id = tcc2.content_id AND tcc2.orders = 1
LEFT JOIN T_company tc2 ON tcc2.company_ticker = tc2.company_ticker
LEFT JOIN T_content_company tcc3 ON tc.content_id = tcc3.content_id AND tcc3.orders = 2
LEFT JOIN T_company tc3 ON tcc3.company_ticker = tc3.company_ticker
LEFT JOIN T_content_author tca ON tc.content_id = tca.content_id AND tca.orders = 1
LEFT JOIN T_author ta ON tca.author_id = ta.author_id
WHERE tcc.company_ticker = 'A005380'
ORDER BY tc.update_time DESC;




