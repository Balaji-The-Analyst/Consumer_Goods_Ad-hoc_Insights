# Consumer Goods Ad-hoc Insights
Atliq Hardware (imaginary company) is one of the leading computer hardware producers in India and has expanded in other countries too.
However, the management noticed that they did not get enough insights to make quick and smart data-informed decisions. They want to expand their data analytics team by adding several junior data analysts. Tony Sharma, their data analytics director wanted to hire someone who is good at both tech and soft skills. Hence, he decided to conduct a SQL challenge which will help him understand both skills.

## Ad-hoc Requests
1. Provide the list of markets in which customer  "Atliq  Exclusive"  operates its business in the  APAC  region.      

```
select distinct market from dim_customer where customer='Atliq Exclusive' and region='APAC';
```
**Output**

![1](https://github.com/user-attachments/assets/739db421-3d29-461b-97ba-707bfaf5b871)

2. What is the percentage of unique product increase in 2021 vs. 2020?

```
with cte as(
select fiscal_year,
count(distinct product_code) Unique_productC
from fact_gross_price
group by fiscal_year
)
select c1.Unique_productc Product_2020,c2.Unique_productc Product_2021,round(((c2.Unique_productc -c1.Unique_productc)/c1.Unique_productc )*100,2) Change_Percentage
from cte c1 
cross join cte c2 
where c1.fiscal_year=2020 and c2.fiscal_year=2021;
```
**Output**
![2](https://github.com/user-attachments/assets/648f68e8-1c2f-472c-b8d1-3e117c1bc3ab)


3. Provide a report with all the unique product counts for each segment and sort them in descending order of product counts. 
```
select segment,Count(distinct product_code) unique_products 
from dim_product 
group by segment 
order by unique_products desc;
```
**Output**
![3](https://github.com/user-attachments/assets/79144ece-4299-41d2-914a-0d069467da71)

4. Which segment had the most increase in unique products in 2021 vs 2020?
```
with cte as(
select p.segment segment,gp.fiscal_year fiscal_year,count(distinct p.product_code) unique_count from dim_product p join fact_gross_price gp on p.product_code=gp.product_code 
group by segment,fiscal_year
)
select c1.segment segment,c1.unique_count fiscal_2020,c2.unique_count fiscal_2021,(c2.unique_count-c1.unique_count) difference
from cte c1 cross join cte c2 
where c1.segment=c2.segment and c1.fiscal_year=2020 and c2.fiscal_year=2021
order by difference desc;
```
**Output**
![4](https://github.com/user-attachments/assets/cd61dda0-1eca-4bb6-96c7-a6e4dee1fe13)

5. Get the products that have the highest and lowest manufacturing costs.
```
(select p.product_code productCode,p.product product,m.manufacturing_cost manufacturing_cost 
from dim_product p 
join fact_manufacturing_cost m 
order by m.manufacturing_cost desc limit 1)
union 
(select p.product_code productCode,p.product product,m.manufacturing_cost manufacturing_cost 
from dim_product p 
join fact_manufacturing_cost m 
order by m.manufacturing_cost asc limit 1);
```
**Output**
![5](https://github.com/user-attachments/assets/4e9d3e27-9c3e-4aaf-baa9-1dbce5798b90)

6. Generate a report which contains the top 5 customers who received an average high pre_invoice_discount_pct for the fiscal year 2021 and in the Indian market.
```
select i.customer_code customer_code,c.customer customer,avg(i.pre_invoice_discount_pct) avg_discount 
from fact_pre_invoice_deductions i 
join dim_customer c on i.customer_code = c.customer_code
where i.fiscal_year=2021 and c.market='india'
group by customer_code,customer
order by avg_discount desc
limit 5;
```
**Output**
![6](https://github.com/user-attachments/assets/7fa54909-7907-4596-b6fe-49320f97427a)

7. Get the complete report of the Gross sales amount for the customer “Atliq Exclusive” for each month. This analysis helps to get an idea of low and high-performing months and take strategic decisions.
```
select monthname(date) month,year(date) year,concat(round(sum(price.gross_price*sales.sold_quantity)/1000000,2),' M') sales_amount
from fact_gross_price price
join fact_sales_monthly sales
on price.product_code=sales.product_code
join dim_customer customer
on sales.customer_code=customer.customer_code
where customer.customer='Atliq Exclusive'
group by month,year 
order by year;
```
**Output**
![7](https://github.com/user-attachments/assets/f1b67c79-5554-4c7b-8ad5-abb4346bde61)

8. In which quarter of 2020, got the maximum total_sold_quantity?
```
with cte as(
select monthname(date) month,sum(sold_quantity)/1000000 total_quantity
from fact_sales_monthly 
where fiscal_year=2020
group by month
),
cte1 as (
select *,ntile(4) over() q from cte
)
select case when q=1 then 'Q1'
            when q=2 then 'Q2'
            when q=3 then 'Q3'
            else 'Q4' end Quaters,
sum(total_quantity) Qunatity_in_Millions
from cte1
group by Quaters; 
```
**Output**
![8](https://github.com/user-attachments/assets/8ff2d038-819e-47e8-a3eb-6ef9f726ceb7)

9. Which channel helped to bring more gross sales in the fiscal year 2021 and the percentage of contribution?
```
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
```
**Output**
![9](https://github.com/user-attachments/assets/932138bd-ac2e-4e49-a9ac-ba026bfa914d)

10. Get the Top 3 products in each division that have a high total_sold_quantity in the fiscal_year 2021?
```
with cte as(
select product.division division,product.product_code product_code,product.product product,
sum(sales.sold_quantity) total_sold_qunatity,
rank() over(partition by product.division order by sum(sales.sold_quantity) desc) rank_
from dim_product product
join fact_sales_monthly sales on product.product_code=sales.product_code
where sales.fiscal_year=2021
group by division,product_code,product
)
select *
from cte 
where rank_ in (1,2,3)
```
**Output**
![10](https://github.com/user-attachments/assets/ce61433a-534b-40c4-9822-b2cb92bc3472)


## Here are my key takeaways
1) Atliq Exclusive operates in diverse APAC markets such as India, Indonesia, Japan, and Australia, showcasing a strategic approach to capitalize on growth opportunities across both emerging and developed economies.
2) The number of unique products grew by 36.33%, increasing from 245 in 2020 to 334 in 2021, highlighting "Atliq Exclusive's" robust product expansion strategy.
3) The Notebook segment leads with 129 unique products, indicating its dominance in the portfolio, followed by Accessories and Peripherals, which also contribute significantly to product diversity.
4) The Accessories segment saw the largest increase in unique products from 2020 to 2021, growing by 34 products, while the Desktop segment also experienced a significant rise of 15 unique products
5) The AQ Dracula HDD exhibits a stark contrast in manufacturing costs, with the highest cost at approximately $240.54 and the lowest at $0.89, highlighting significant variability in production expenses
6) The top five customers receiving the highest average pre-invoice discounts in 2021 include Flipkart at 0.31, followed closely by Viveks and Ezone, indicating strong relationships and competitive pricing strategies in the market.
7) Monthly sales peaked at 32.25 million in November 2020, with the lowest at 0.77 million in March 2020, highlighting significant seasonal fluctuations.
8) Q1 recorded the highest total sold quantity at 7.01 million, while Q3 saw the lowest at just 2.08 million, indicating marked seasonal variation in sales.
9) The Retailer channel generated the highest gross sales at 1,924.17 million, contributing 73.22% of total sales, significantly outperforming the Direct and Distributor channels.
10) The AQ Pen Drive DRC topped sales with 688,003 units sold, followed by the AQ Gamers Ms and AQ Maxima Ms, indicating strong demand.


