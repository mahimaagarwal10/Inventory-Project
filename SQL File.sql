use inventory;

/* Total inventory available across all warehouse */
select war_name,
SUM(capacity) as inventory_total
from inventory.warehouse
group by war_name;

/* To find all the names of the employees with designations as 'Stock Clerk' */
select emp_name, designation
from inventory.employee
where designation = 'Stock Clerk'
group by emp_name;

/* Average price of all the products */
select ROUND(avg(price)) as average_price 
from product;

/* To find the reason of return through invoice id */
SELECT return_id, reason
FROM inventory.return
where order_id =
(SELECT order_id
FROM invoice
WHERE invoice_id = '9');

/* Using Case statement to get the designation of the Employees */
Select designation, emp_name, emp_id
from inventory.employee
order by (
case
when designation is null
then emp_name
else designation
end);

/* To find the amount of Dairy products that are ordered */
select distinct count(type) 
over (partition by prod_name
order by type desc) as no_of_products,prod_name,type 
from  product
where type = 'Cereals'
order by no_of_products desc;


/* To find the orders returned by retailers/customers due to expiration */
select inventory.order.order_id, 
	   inventory.order.order_type, 
       inventory.return.reason
from inventory.order
inner join inventory.return 
on inventory.order.order_id = inventory.return.order_id
where inventory.return.reason = 'Expired' 
AND inventory.order.order_type = 'Customer' ; 


/*  Number of different products stock in the inventory */
select product.type as Product_type, 
       sum(stock.quantity) as Total_quantity
from product 
join stock 
on product.prod_id = stock.prod_id
where product.type = product.type
group by product.type
having count(stock.quantity) > 1; 