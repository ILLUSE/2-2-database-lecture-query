use krible;
/*
-- 오늘의 종목 뷰 만들기
-- 1.2번이상 나오는 종목 찾기
select cc.company_ticker,count(*) cnt 
from T_content c
join T_content_company cc on c.content_id = cc.content_id
where date(c.update_time) = '2023-10-30' 
group by cc.company_ticker
having cnt >= 2;

-- 2. 그걸로 뷰 만들기
create view T_today_company as
select a.company_ticker
from (
select cc.company_ticker,count(*) cnt
from T_content c
join T_content_company cc on c.content_id = cc.content_id
where date(c.update_time) = '2023-10-30' 
group by cc.company_ticker
having cnt >= 2 )a;

select * from T_today_company;
*/

/*
-- 오늘의 종목이 언급된 컨텐츠 찾기
select c.content_id
from T_content c
join T_content_company cc on c.content_id = cc.content_id -- content_ticker 없으니 조인해주고 
join T_today_company tc on cc.company_ticker = tc.company_ticker -- 오늘의 종목만 보기 위해 조인해줌
order by c.update_time desc -- 시간순 정렬
limit 3; -- 가장 최신거 3개만 보기
*/

/*
-- 컨텐츠 정보 나열하기
select c.title,c.update_time,c2.company_name,t.topic_name -- 왜 굳이 pdf에선 left join을?
from T_content c -- 제목,발행시간
join T_content_company cc on c.content_id = cc.content_id and cc.orders = 1 -- 관련종목1의 company_ticker를 알기위해
join T_company c2 on cc.company_ticker = c2.company_ticker -- 관련종목1의 이름
join T_content_topic ct on c.content_id = ct.content_id and ct.orders = 1 -- 관련토픽 1의 topic_id를 위해
join T_topic t on ct.topic_id = t.topic_id -- 관련 토픽1의 이름
where c.content_id in (9,5,4) -- 위에서 얻은 오늘의 종목이 언급된 컨텐츠 3개
order by c.update_time desc; -- 시간순 정렬
*/

/*
-- 유저 별로 관심 토픽 뷰 만들기
-- 1.유저별 가장 최근에 한 토픽별 하트 설정
select user_id,topic_id,MAX(update_time) update_time
from T_user_topic
group by user_id,topic_id
order by user_id,topic_id;

-- 2.그걸 토대로 뷰 만들기
create view  T_user_topic_heart as
select ut.user_id,ut.topic_id
from T_user_topic ut
join ( -- 원래 테이블에 1번 테이블 조인하는 이유: 하트가 없기 때문에
select user_id,topic_id,MAX(update_time) update_time
from T_user_topic
group by user_id,topic_id
order by user_id,topic_id
) a on ut.user_id = a.user_id 
and ut.topic_id = a.topic_id
and ut.update_time = a.update_time
where ut.heart = 1 -- 하트 1 인 것만
order by ut.user_id, ut.topic_id;
*/

/*
-- 관심 토픽별로 컨텐츠의 개수 찾기
select uth.topic_id ,count(*) cnt  
from T_user_topic_heart uth --  유저 별 관심 토픽
join T_content_topic ct on uth.topic_id = ct.topic_id -- T_user_topic_heart와 T_content 연결 위해서
join T_content c on ct.content_id = c.content_id -- 콘텐츠 정보
where uth.user_id = 1 and date(c.update_time) = '2023-10-30' -- 유저 1 , 날짜 설정
group by uth.topic_id; -- 관심 토픽 별로 묶음
*/

-- 토픽 정보 나열하기
select t.topic_name,count(c.content_id) cnt -- * 이 아닌 c.content_id 인 이유 : left join 할때 null인 것도 생김 , *은  null도 포함하여 계산함
from T_topic t -- 토픽 이름
join T_user_topic_heart uth on t.topic_id = uth.topic_id  -- 유저 별 관심 토픽 위해
left join T_content_topic ct on ct.topic_id = uth.topic_id -- left join : 모바일은 없지만 포함시키기 위해서
left join T_content c on c.content_id = ct.content_id
and date(c.update_time) = '2023-10-30'
where uth.user_id = 1
group by t.topic_name
order by cnt desc, t.topic_name;












