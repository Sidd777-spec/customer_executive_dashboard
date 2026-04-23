Use customer_behaviour ;

Select top 20 * from customers;

Select gender,SUM(purchase_amount) as revenue 
from customers
group by gender;


Select customer_id, purchase_amount from customers
where discount_applied = 'Yes' and purchase_amount >= (Select AVG(purchase_amount) from customers);


Select TOP 5 item_purchased, Round(AVG(review_rating),2) as "Average Review Rating"
from customers
group by item_purchased
order by AVG(review_rating) desc;


Select shipping_type, AVG(purchase_amount) as "Average_Purchase_Amount"
from customers
where shipping_type in ('Standard','Express')
group by shipping_type;


Select subscription_status,COUNT(customer_id) as "Total_Customers",
AVG(purchase_amount) as "Average_Spend",SUM(purchase_amount) as "Total_Revenue"
from customers
where subscription_status in ('Yes','No')
group by subscription_status
order by Average_Spend, Total_Revenue desc;


--Which 5 products have the highest percentage of purchases with discounts applied--
Select TOP 5 item_purchased,
CAST(100.0 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END)/COUNT(*) as decimal(5,2)) as discount_rate
from customers
group by item_purchased
order by discount_rate desc;


--Segment customers into New,Returning and Loyal based on their total number of previous purchases, and show the Count of each segment-- # Customer Loyalty Business Query
WITH customer_type as(
select customer_id,previous_purchases,     --# Customer_type is a temperory table(CTE) # --
CASE
	When previous_purchases = 1 Then 'New'
	When previous_purchases between 2 and 10 then 'Returning'
	Else 'Loyal'
	End as customer_segment
from customers
)

Select customer_segment,COUNT(*) as "Number of Customers"
from customer_type
group by customer_segment
order by COUNT(*) desc;


-- What are the top 3 most purchased products within each category--
WITH item_counts as(
Select category,item_purchased, COUNT(customer_id) as total_orders,
ROW_NUMBER() over (partition by category order by count(customer_id) DESC) as item_rank
from customers
group by category,item_purchased
)

Select item_rank,category, item_purchased, total_orders
from item_counts
where item_rank <=3;


-- Find whether customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe? --
Select subscription_status,COUNT(customer_id) as repeat_buyers
from customers
where previous_purchases > 5 
group by subscription_status
order by repeat_buyers desc;


--What is the revenue contribution by each age group ?--
Select age_group,SUM(purchase_amount) as revenue
from customers
group by age_group
order by revenue desc;