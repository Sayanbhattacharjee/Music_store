-- q1:
select *
from employee
order by levels desc
limit 1;

-- q2:
select billing_country,count(*) as c 
from invoice
group by billing_country
order by c desc;

--q3:

select total from invoice
order by total desc
limit 3;

--q4:
select sum(total) as invoicetotal, billing_city
from invoice
group by billing_city
order by invoicetotal desc;

--q5:
select  customer.first_name,customer.last_name,sum(invoice.total) as total
from customer
join invoice on customer.customer_id= invoice.customer_id
group by customer.customer_id
order by total desc
limit 1;



-- Mq1:

select distinct first_name, last_name, email from customer
join invoice on customer.customer_id= invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in (select track_id from track
				  join genre on track.genre_id=genre.genre_id
				  where genre.name like 'Rock')
order by email

--Mq2
select artist.artist_id, artist.name, count(artist.artist_id) as nos  
from artist
join album on artist.artist_id = album.artist_id
join track on album.album_id = track.album_id
join genre on track.genre_id = genre.genre_id 
where genre.name like 'Rock'
group by artist.artist_id
order by nos desc
limit 10;

--Mq3
select name, milliseconds
from track 
where milliseconds >(select avg(milliseconds) from track)
order by milliseconds desc;


---Aq1:-
WITH best_selling_artist AS (
	SELECT artist.artist_id AS artist_id, artist.name AS artist_name, SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

--A2
WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1