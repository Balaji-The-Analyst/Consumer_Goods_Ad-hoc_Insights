# Consumer Goods Ad-hoc Insights
Atliq Hardware (imaginary company) is one of the leading computer hardware producers in India and has expanded in other countries too.
However, the management noticed that they did not get enough insights to make quick and smart data-informed decisions. They want to expand their data analytics team by adding several junior data analysts. Tony Sharma, their data analytics director wanted to hire someone who is good at both tech and soft skills. Hence, he decided to conduct a SQL challenge which will help him understand both skills.

## Here are the questions I was interested in answering
1) Provide the list of markets in which customer "Atliq Exclusive" operates its business in the APAC region.
2) What is the percentage of unique product increase in 2021 vs. 2020?
3)  Provide a report with all the unique product counts for each segment and sort them in descending order of product counts.
4)  Which segment had the most increase in unique products in 2021 vs 2020?
5)  Get the products that have the highest and lowest manufacturing costs.
6)  Generate a report that contains the top 5 customers who received an average high pre_invoice_discount_pct for the fiscal year 2021 and in the Indian market.
7)  Get the complete report of the Gross sales amount for the customer “Atliq Exclusive” for each month. This analysis helps to get an idea of low and high-performing months and make strategic decisions.
8)  In which quarter of 2020, got the maximum total_sold_quantity?
9)  Which channel helped to bring more gross sales in the fiscal year 2021 and the percentage of contribution?
10)  Get the Top 3 products in each division that have a high total_sold_quantity in the fiscal_year 2021.

## I took the following steps to create my analysis
1) Utilized `SELECT DISTINCT` and `WHERE` clauses to filter and extract unique markets for specific customers.
2) Employed `CTEs` and `CROSS JOIN` to compare `year-over-year` unique product counts and calculate percentage increases.
3) Used `GROUP BY` and `ORDER BY` to count unique products by segment and sort them in descending order.
4) Leveraged `CTEs` and `CROSS JOIN` for segment-wise comparison of unique products between 2020 and 2021.
5) Applied `JOIN operations` and `ORDER BY` to retrieve products with the highest and lowest manufacturing costs.
6) Implemented `AVG()` and `GROUP BY` to calculate the average pre-invoice discount percentage for the top 5 customers.
7) Combined `SUM()`, `JOIN`, and `GROUP BY` to report gross sales by month and year for specific customers.
8) Partitioned sales data into quarters using the `NTILE()` `window function` for quarter-wise sales analysis.
9) Calculated the channel with the highest sales using `SUM()` and percentage contribution with `window functions`.
10) Utilized `RANK()` and `PARTITION BY` to find the top 3 products in each division based on total sold quantity.

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


