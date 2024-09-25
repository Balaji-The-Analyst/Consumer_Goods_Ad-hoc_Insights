# Consumer Goods Ad-hoc Insights
# 1.Provide the list of markets in which customer "Atliq Exclusive" operates its business in the APAC region.

select distinct market from dim_customer where customer='Atliq Exclusive' and region='APAC';

# 2.What is the percentage of unique product increase in 2021 vs. 2020?

with cte as(
select fiscal_year,
count(distinct product_code) Unique_productC
from fact_gross_price
group by fiscal_year)
select c1.Unique_productc Product_2020,c2.Unique_productc Product_2021,round(((c2.Unique_productc -c1.Unique_productc)/c1.Unique_productc )*100,2) Change_Percentage
from cte c1 cross join cte c2 where c1.fiscal_year=2020 and c2.fiscal_year=2021;

# 3.Provide a report with all the unique product counts for each segment and sort them in descending order of product counts. 

select segment,Count(distinct product_code) unique_products from dim_product group by segment order by unique_products desc;

# 4.Which segment had the most increase in unique products in 2021 vs 2020?
with cte as
(select p.segment segment,gp.fiscal_year fiscal_year,count(distinct p.product_code) unique_count from dim_product p join fact_gross_price gp on p.product_code=gp.product_code 
group by segment,fiscal_year)
select c1.segment segment,c1.unique_count fiscal_2020,c2.unique_count fiscal_2021,(c2.unique_count-c1.unique_count) difference
from cte c1 cross join cte c2 
where c1.segment=c2.segment and c1.fiscal_year=2020 and c2.fiscal_year=2021
order by difference desc;

# 5.Get the products that have the highest and lowest manufacturing costs.
(select p.product_code productCode,p.product product,m.manufacturing_cost manufacturing_cost 
from dim_product p 
join fact_manufacturing_cost m 
order by m.manufacturing_cost desc limit 1)
union 
(select p.product_code productCode,p.product product,m.manufacturing_cost manufacturing_cost 
from dim_product p 
join fact_manufacturing_cost m 
order by m.manufacturing_cost asc limit 1);

# 6.Generate a report which contains the top 5 customers who received an average high pre_invoice_discount_pct for the fiscal year 2021 and in the Indian market.

select i.customer_code customer_code,c.customer customer,avg(i.pre_invoice_discount_pct) avg_discount 
from fact_pre_invoice_deductions i 
join dim_customer c on i.customer_code = c.customer_code
where i.fiscal_year=2021 and c.market='india'
group by customer_code,customer
order by avg_discount desc
limit 5;

# 7.Get the complete report of the Gross sales amount for the customer “Atliq Exclusive” for each month. This analysis helps to get an idea of low and high-performing months and take strategic decisions.

select monthname(date) month,year(date) year,concat(round(sum(price.gross_price*sales.sold_quantity)/1000000,2),' M') sales_amount
from fact_gross_price price
join fact_sales_monthly sales
on price.product_code=sales.product_code
join dim_customer customer
on sales.customer_code=customer.customer_code
where customer.customer='Atliq Exclusive'
group by month,year 
order by year;

# 8.In which quarter of 2020, got the maximum total_sold_quantity?

with cte as(
select monthname(date) month,sum(sold_quantity)/1000000 total_quantity
from fact_sales_monthly 
where fiscal_year=2020
group by month
),
cte1 as 
(select *,ntile(4) over() q from cte)
select case when q=1 then 'Q1'
            when q=2 then 'Q2'
            when q=3 then 'Q3'
            else 'Q4' end Quaters,
sum(total_quantity) Qunatity_in_Millions
from cte1
group by Quaters;    

# 9.Which channel helped to bring more gross sales in the fiscal year 2021 and the percentage of contribution?
with cte as (
select c.channel channel,round(sum(sales.sold_quantity*price.gross_price)/1000000,2) sales_in_Millions from dim_customer c
join fact_sales_monthly sales on c.customer_code=sales.customer_code
join fact_gross_price price on price.product_code=sales.product_code
where sales.fiscal_year=2021
group by channel
order by sales_in_Millions desc
)
select channel,sales_in_millions,(sales_in_millions/sum(sales_in_Millions) over())*100 Percentage
from cte;

# 10.Get the Top 3 products in each division that have a high total_sold_quantity in the fiscal_year 2021?
with cte as(
select product.division division,product.product_code product_code,product.product product,
sum(sales.sold_quantity) total_sold_qunatity,
rank() over(partition by product.division order by sum(sales.sold_quantity) desc) rank_
from dim_product product
join fact_sales_monthly sales on product.product_code=sales.product_code
where sales.fiscal_year=2021
group by division,product_code,product
)
select * from cte where rank_ in (1,2,3)