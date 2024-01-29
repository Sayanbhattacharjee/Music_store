use musicstore;

select * from employee
order by levels desc
limit 1;

select count(*) as c,billing_country 
from invoice
group by billing_country
order by c desc;

select total
from invoice
order by total desc
limit 3;

select sum(total) as invoiceTotal , billing_city
from invoice
group by billing_city
order by invoiceTotal desc;


select customer.customer_id,customer.first_name,customer.last_name,sum(invoice.total) as total
from customer
join invoice on customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total desc
limit 1;


