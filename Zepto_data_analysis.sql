drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
DiscountPercent NUMERIC(5,2),
availableQuantitiy INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
OutOfStock BOOLEAN,
quantity INTEGER
)

SELECT COUNT(*) from zepto;

select * from zepto
limit 10;

select * from zepto
where name is null
or
category is null
or
mrp is null
or
discountpercent is null
or
availablequantitiy is null
or
discountedsellingprice is null
or
weightingms is null
or
outofstock is null
or
quantity is null;

--different product categories
select distinct category
from zepto
order by category;

--products in stock vs out of stock
select outofstock, count(sku_id)
from zepto
group by outofstock;

--product names present multiple times
select name, count (sku_id) as "Number of sku's"
from zepto
group by name
having count (sku_id) > 1
order by count (sku_id) desc;

--data cleaning

--products with price = 0
select *
from zepto
where mrp = 0 or discountedsellingprice = 0;

delete from zepto 
where mrp = 0;

--convert paise to rupees

update zepto
set mrp = mrp / 100.0,
    discountedsellingprice = discountedsellingprice / 100.0;

select mrp , discountedsellingprice from zepto

-- 10 best valued products
select distinct name , mrp , discountpercent
from zepto
order by discountpercent desc
limit 10;

--high mrp but out of stock
select distinct name, mrp
from zepto
where outofstock = true 
  and mrp > 300
order by mrp desc;

--estimating the revenue for each category
select category,
sum (discountedsellingprice * availablequantitiy) as total_revenue
from zepto 
group by category
order by total_revenue;

--product greater than mrp 500 and discount less than 10%
select distinct name , mrp , discountpercent
from zepto
where mrp > 500 and discountpercent < 10 
order by mrp desc , discountpercent desc;

--highest average percentage (top5)
select category,
round(avg(discountpercent),2) as avg_discount
from zepto
group by category
order by avg_discount desc
limit 5;

--price by gram for products above 100 g and sorting by best value 
select distinct name , weightingms , discountedsellingprice,
round(discountedsellingprice/weightingms,2) as price_per_gram
from zepto
where weightingms >= 100
order by price_per_gram;

--categorizing products in low,medium,bulk
select distinct name , weightingms,
case when weightingms < 1000 then 'low'
     when weightingms < 5000 then 'medium'
	 else 'bulk'
	 end as weight_category
from zepto;	 

--total inventory per weight category
select category ,
sum (weightingms * availablequantitiy ) as total_weight
from zepto
group by category
order by total_weight;