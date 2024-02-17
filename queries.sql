/*запрос считает общее количество покупателей
select
COUNT(distinct customer_id) as customers_count
from customers c ;

/* запрос считает 10 продавцов с наибольшей выручкой
select
first_name||' '||last_name as name,
count(sales_id) as operations,
ROUND(SUM(s.quantity*p.price),0) as income
from sales s  
join products p 
on s.product_id = p.product_id
join employees e 
on s.sales_person_id=e.employee_id
group by 1
order by 3 desc
limit 10;;


/* запрос считает выручку и сортирует ее от меньшего к большему
select
first_name||' '||last_name as name,
round(avg(s.quantity*p.price),0) as average_income
from sales s  
join products p 
on s.product_id = p.product_id
join employees e 
on s.sales_person_id=e.employee_id
group by 1
having round(avg(s.quantity*p.price),0) < (select avg(ss.quantity*pp.price)
from sales ss
join products pp
on ss.product_id = pp.product_id)
order by 2;


/* запрос считает выручку и сортирует ее по каждому продавцу и дню недели
select
e.first_name||' '||e.last_name as name,
case to_char(s.sale_date, 'id') 
when '1' then 'monday'
when '2' then 'tuesday'
when '3' then 'wednesday'
when '4' then 'thursday'
when '5' then 'friday'
when '6' then 'saturday'
when '7' then 'sunday'
end as weekday,
round(sum(s.quantity*p.price),0) as income
from sales s  
join products p 
on s.product_id = p.product_id
join employees e 
on s.sales_person_id=e.employee_id
group by 1, to_char(s.sale_date, 'id')
order by to_char(s.sale_date, 'id'), 1;

/* запрос считает количество покупателей по разным возрастным группам(16-25, 26-40, 40+)
select
case
	when age between 16 and 25 then '16-25'
	when age between 26 and 40 then '26-40'
	when age >40 then '40+'
end age_category,
count(customer_id)
from customers c
group by case
	when age between 16 and 25 then '16-25'
	when age between 26 and 40 then '26-40'
	when age >40 then '40+' 
	end
order by 1;;




/* запрос считает количество уникальных покупателей и вырочку, которую они принесли
select 
to_char(s.sale_date, 'YYYY-MM') as date,
count(distinct c.customer_id)as total_customers,
round(SUM(s.quantity*p.price),0) as income
from customers c
join sales s
on c.customer_id = s.customer_id
join products p 
on s.product_id = p.product_id 
group by 1
;


/* запрос сортирует покупателей, первая покупка которых была в ходе акции(стоимость равна 0)
with tab as(
select 
concat_ws(' ', c.first_name,c.last_name) as customer,
min(s.sale_date) as sale_date,
concat_ws(' ', e.first_name,e.last_name) as seller
from sales s
join products p 
on s.product_id = p.product_id
join customers c 
on s.customer_id = c.customer_id 
join employees e 
on s.sales_person_id = e.employee_id 
where p.price = 0
group by concat_ws(' ', c.first_name,c.last_name), concat_ws(' ', e.first_name,e.last_name), c.customer_id
order by c.customer_id)
select distinct on(customer) customer, sale_date, seller
from tab
order by customer;

 


