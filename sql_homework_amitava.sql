# SQL Homework
# Author : Amitava Samaddar
# Note : Following queries are on sakila DB

# 1a. Display the first and last names of all actors from the table actor.
select first_name 'First Name', last_name 'Last Name' from actor;

# 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select upper(concat(first_name, ' ',  last_name)) 'Actor Name' from actor;

# 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
# What is one query would you use to obtain this information?
select actor_id 'Id', first_name 'First Name', last_name 'Last Name' from actor
where upper(first_name) = upper('Joe');

# 2b. Find all actors whose last name contain the letters GEN:
select * from actor
where upper(last_name) like '%GEN%';

# 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select * from actor
where upper(last_name) like '%LI%'
order by last_name, first_name;

# 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id 'Country ID', country 'Country' from country
where country in ('Afghanistan', 'Bangladesh', 'China');

# 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor 
#named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
alter table actor
add column description blob after last_name;

desc actor;

# 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
alter table actor
drop column description;

desc actor;

# 4a. List the last names of actors, as well as how many actors have that last name.
select last_name 'Last Name', count(last_name) 'Count of Last Name' from actor
group by last_name;

# 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name 'Last Name', count(last_name) 'Count of Last Name' from actor
group by last_name
having count(last_name) > 1;

# 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
update actor
set first_name = 'HARPO'
where first_name = 'GROUCHO'
and last_name = 'WILLIAMS';

#Checking whether data updated correctly or not...no record should return
select * from actor
where first_name = 'GROUCHO'
and last_name = 'WILLIAMS';

#Checking whether data updated correctly or not...one record should return
select * from actor
where first_name = 'HARPO'
and last_name = 'WILLIAMS';

# 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
# It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
update actor
set first_name = 'GROUCHO'
where first_name = 'HARPO' and last_name = 'WILLIAMS'; # why do we need to have the last_name in the query?

#Checking whether data updated correctly or not...one record should return
select * from actor
where first_name = 'GROUCHO'
and last_name = 'WILLIAMS';

#Checking whether data updated correctly or not...no record should return
select * from actor
where first_name = 'HARPO'
and last_name = 'WILLIAMS';

# 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
show create table address;

desc address;

# 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select first_name 'First Name', last_name 'Last Name', address 'Address 1'
	 , address2 'Address 2', district 'District', city_id 'City Id', postal_code 'Postal Code'
from staff st
join address ad on st.address_id = ad.address_id;

# 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select first_name 'First Name', last_name 'Last Name', sum(amount) 'Total Amount'
from staff st
join payment pt on st.staff_id = pt.staff_id
where cast(payment_date as char) like '2005-08%'
group by first_name, last_name;

# 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select title 'Title', count(actor_id) '# of Actors'
from film f
inner join film_actor fa on f.film_id = fa.film_id
group by title;

# 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select count(inventory_id) '# of Copies' 
from inventory inv, film f
where inv.film_id = f.film_id
and upper(f.title) = upper('Hunchback Impossible');

# 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select first_name 'First Name', last_name 'Last Name', sum(amount) 'Total Paid'
from customer cus
join payment pt on cus.customer_id = pt.customer_id
group by 1, 2
order by 2;


# 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have 
# also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select title 'Title'
from film
where substr(title, 1, 1) in ('K', 'Q')
and language_id = (select language_id 
					 from language
					where upper(name) = 'ENGLISH');
                    
# 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select first_name 'First Name', last_name 'Last Name' 
from actor a
where a.actor_id in (select b.actor_id
					 from   film_actor b
                     where  b.film_id = (select film_id
                                          from   film c
                                          where  upper(c.title) = upper('Alone Trip')
										 )
					);
# Alternate way - without subqueries
select first_name 'First Name', last_name 'Last Name' 
from actor a, film_actor b, film c
where a.actor_id = b.actor_id
and b.film_id = c.film_id
and upper(c.title) = upper('Alone Trip');

# 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
# Use joins to retrieve this information.
select first_name 'First Name', last_name 'Last Name', email 'Email' 
from customer a
join address b on a.address_id = b.address_id
join city c    on b.city_id    = c.city_id
join country d on c.country_id = d.country_id
where upper(d.country) = upper('Canada');

# Alternate way to write
select first_name 'First Name', last_name 'Last Name', email 'Email'
from customer a, address b, city c, country d
where a.address_id = b.address_id
and b.city_id = c.city_id
and c.country_id = d.country_id
and upper(d.country) = upper('Canada');


# 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select title 'Family Movies' 
from film a, film_category b, category c
where a.film_id = b.film_id
and b.category_id = c.category_id
and upper(c.name) = 'FAMILY';

# 7e. Display the most frequently rented movies in descending order.
select d.film_title 'Title', count(d.film_title) 'Rental Count'
from (
select c.title film_title
from rental a, inventory b, film c
where a.inventory_id = b.inventory_id
and b.film_id = c.film_id) d
group by film_title
order by count(film_title) desc, d.film_title;

# 7f. Write a query to display how much business, in dollars, each store brought in.
select store_id, sum(amount) 'Rental Amount'
from payment pt, staff sf
where pt.staff_id = sf.staff_id
group by store_id;

# 7g. Write a query to display for each store its store ID, city, and country.
select st.store_id 'Store Id', c.city 'City', cy.country 'Country'
from store st, address ad, city c, country cy
where st.address_id = ad.address_id
and ad.city_id = c.city_id
and c.country_id = cy.country_id;

# 7h. List the top five genres in gross revenue in descending order. 
select e.name 'Category', sum(a.amount) 'Gross Revenue' 
from payment a, rental b, inventory c, film_category d, category e
where a.rental_id = b.rental_id
and b.inventory_id = c.inventory_id
and c.film_id = d.film_id
and d.category_id = e.category_id
group by e.name
order by sum(a.amount) desc
limit 5;

# 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
# Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
create view top_five_genres
as 
select e.name 'Category', sum(a.amount) 'Gross Revenue' 
from payment a, rental b, inventory c, film_category d, category e
where a.rental_id = b.rental_id
and b.inventory_id = c.inventory_id
and c.film_id = d.film_id
and d.category_id = e.category_id
group by e.name
order by sum(a.amount) desc
limit 5;

# Checking whether the view created properly or not
select * from top_five_genres;

# 8b. How would you display the view that you created in 8a?
desc top_five_genres;

show create view top_five_genres;

select view_definition 
from information_schema.views
where table_name = 'top_five_genres';

# 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view top_five_genres;
