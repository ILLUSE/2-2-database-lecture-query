use krible;

/*
select *
from T_content c
join T_content_company cc on c.content_id = cc.content_id
join T_company co on cc.company_ticker = co.company_ticker
join T_content_topic ct on c.content_id = ct.content_id
join T_topic t on ct.topic_id = t.topic_id
join T_content_author ca on c.content_id = ca.content_id
join T_author a on ca.author_id = a.author_id
join T_user_company uc on cc.company_ticker = uc.company_ticker
join T_user_topic ut on ct.topic_id = ut.topic_id
join T_user_company_heart uch on cc.company_ticker = uc.company_ticker
join T_user_topic_heart uth on ct.topic_id = ut.topic_id
where uc.user_id = 1;
*/

select distinct title,c.update_time
from T_content c
join T_content_company cc on c.content_id = cc.content_id
join T_company co on cc.company_ticker = co.company_ticker
join T_content_topic ct on c.content_id = ct.content_id
join T_user_topic ut on ct.topic_id = ut.topic_id
where cc.company_ticker in (select company_ticker
from T_user_company_heart
where user_id = 1)
or ct.topic_id in (select topic_id
from T_user_topic_heart
where user_id = 1)
order by c.update_time desc;


-- 필요한 정보 : 하트 누른 토픽 , 회사 / 컨텐츠 제목 / 저자 정보 / 올린 시간
select
    c.title, 
    c.update_time,
    group_concat(distinct t.topic_name) as topics, -- 여러 토픽과 관련 있는 경우 묶어줌
    group_concat(distinct co.company_name) as companies, -- 여러 회사와 관련 있는 경우 묶어줌
	group_concat(distinct a.author_name) as authors, -- 여러 명의 저자가 쓴 경우 묶어줌
    group_concat(distinct a.affiliation) as affiliations -- db상에는 저자 2명이서 같이 쓴 경우엔 둘이 같은 회사지만 혹시 모르니
from T_content c
left join T_content_topic ct on c.content_id = ct.content_id
left join T_topic t on ct.topic_id = t.topic_id
left join T_content_company cc on c.content_id = cc.content_id
left join T_company co on cc.company_ticker = co.company_ticker
left join T_content_author ca on c.content_id = ca.content_id
left join T_author a on ca.author_id = a.author_id
left join T_user_topic ut on t.topic_id = ut.topic_id
where ct.topic_id 
in ( -- 유저가 하트 누른 토픽
select topic_id
from T_user_topic_heart
where user_id = 1)
or cc.company_ticker in (-- 유저가 하트 누른 회사
select company_ticker
from T_user_company_heart
where user_id = 1)
group by c.title, c.update_time -- 나머지 3개로 그룹화
order by c.update_time desc;







