--Part 1: Yelp Dataset Profiling and Understanding

--1. Profile the data by finding the total number of records for each of the tables below:

SELECT * FROM attribute
SELECT * FROM business
SELECT * FROM category
SELECT * FROM checkin
SELECT * FROM elite_years
SELECT * FROM friend
SELECT * FROM hours
SELECT * FROM photo
SELECT * FROM review
SELECT * FROM tip
SELECT * FROM user

--2. Find the total distinct records by either the foreign key or primary key for each table. If two foreign keys are listed in the table, please specify which foreign key.

SELECT DISTINCT id FROM business
SELECT DISTINCT business_id FROM hours
SELECT DISTINCT business_id FROM category
SELECT DISTINCT business_id FROM attribute
SELECT DISTINCT id FROM review
SELECT DISTINCT business_id FROM checkin
SELECT DISTINCT id FROM photo
SELECT DISTINCT user_id FROM tip  
SELECT DISTINCT id FROM user
SELECT DISTINCT user_id FROM friend
SELECT DISTINCT user_id FROM elite_years


--3. Are there any columns with null values in the Users table? Indicate "yes," or "no."

SELECT id a, name b, yelping_since c, review_count d, useful e, funny f, cool g, fans h, average_stars i, compliment_hot j, compliment_more k, compliment_profile l, compliment_cute m, compliment_list n, compliment_note o, compliment_plain p, compliment_cool q, compliment_funny r, compliment_writer s, compliment_photos t
FROM user 
WHERE a IS NULL OR b IS NULL OR c IS NULL OR d IS NULL OR e IS NULL OR f IS NULL OR g IS NULL OR h IS NULL OR i IS NULL OR j IS NULL OR k IS NULL OR l IS NULL OR m IS NULL OR n IS NULL OR o IS NULL OR p IS NULL OR q IS NULL OR r IS NULL OR s IS NULL OR t IS NULL


--4. For each table and column listed below, display the smallest (minimum), largest (maximum), and average (mean) value for the following fields:

SELECT MAX(stars) AS max,
MIN(stars) AS min,
AVG(stars) AS avg
FROM review 

SELECT MAX(stars) AS max,
MIN(stars) AS min,
AVG(stars) AS avg
FROM business

SELECT MAX(likes) AS max,
MIN(likes) AS min,
AVG(likes) AS avg
FROM tip 

SELECT MAX(count) AS max,
MIN(count) AS min,
AVG(count) AS avg
FROM checkin 

SELECT MAX(review_count) AS max,
MIN(review_count) AS min,
AVG(review_count) AS avg
FROM user


--5. List the cities with the most reviews in descending order:

SELECT SUM(review_count) AS total_reviews, city, stars
FROM business
GROUP BY city
ORDER BY total_reviews DESC


--6. Find the distribution of star ratings to the business in the following cities:

--i. Avon
SELECT stars,
count(stars) count
FROM business
WHERE city = "Avon"
GROUP BY stars
Order BY stars


--ii. Beachwood
SELECT stars,
count(stars) count
FROM business
WHERE city = "Beachwood"
GROUP BY stars
Order BY stars


--7. Find the top 3 users based on their total number of reviews:

SELECT review_count , name
FROM user
ORDER BY review_count DESC
LIMIT 3


--8. Does posing more reviews correlate with more fans?

SELECT review_count , name
FROM user
ORDER BY review_count DESC

SELECT fans , name
FROM user
ORDER BY fans DESC


--9. Are there more reviews with the word "love" or with the word "hate" in them?

SELECT review.id,            -- 232
text
FROM review
WHERE text LIKE '%hate%'

SELECT review.id,             -- 1780 reviews
text
FROM review
WHERE text LIKE '%love%'


--10. Find the top 10 users with the most fans:

		SELECT fans, name
		FROM user
		ORDER BY fans DESC
		LIMIT 10


--PART 2

--1. Pick one city and category of your choice and group the businesses in that city or category by their overall star rating. Compare the businesses with 2-3 stars to the businesses with 4-5 stars and answer the following questions. Include your code.

--I have picked "Las Vegas" as city and "Restaurants" as category.
	
--i. Do the two groups you chose to analyze have a different distribution of hours?

SELECT 
business.id
,business.name
,business.neighborhood
,business.address
,business.postal_code
,business.city
,business.state
,business.stars
,business.review_count
,business.is_open
,category.category
,hours.hours
FROM business
INNER JOIN
    category ON category.business_id = business.id
INNER JOIN
    hours ON hours.business_id = business.id
WHERE business.city = "Las Vegas" 
      AND category.category = "Restaurants"
      AND hours.hours LIKE 'Monday%'
      AND business.stars IN (2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0)





--2. Group business based on the ones that are open and the ones that are closed. What differences can you find between the ones 
--that are still open and the ones that are closed? List at least two differences and the SQL code you used to arrive at your answer.
		



SELECT is_open,   
COUNT(stars)
--,AVG(stars)	--uncomment when want to know about the average stars but then comment both where statements
FROM business
WHERE stars IN (2.0, 2.5, 3.0)   -- bad rating
--WHERE stars IN (4.0, 4.5, 5.0) -- good rating    --uncomment this then comment above where statement
GROUP BY is_open



SELECT 
business.is_open
,SUM(review.useful)
,SUM(review.funny)
,SUM(review.cool)
FROM business
INNER JOIN review ON review.business_id = business.id
GROUP BY is_open


--3. For this last part of your analysis, you are going to choose the type of 
--analysis you want to conduct on the Yelp dataset and are going to prepare the data for analysis.



SELECT business.name,
business.city,
business.stars,
business.review_count,
SUM(
CASE 
  WHEN 
      review.text LIKE '%hate%' 
      OR review.text LIKE '%bad%'
      OR review.text LIKE '%rude%'
      OR review.text LIKE '%mistake%'
  THEN 1
  ELSE 0
END
) hate,
SUM(
CASE 
  WHEN 
      review.text LIKE '%love%' 
      OR review.text LIKE '%good%'
      OR review.text LIKE '%excellent%'
      OR review.text LIKE '%pleasant%'
      OR review.text LIKE '%professional%'
      OR review.text LIKE '%amazing%'
      OR review.text LIKE '%authentic%'
      OR review.text LIKE '%great%'
      OR review.text LIKE '%delicious%'
  THEN 1
  ELSE 0
END
) love,
SUM(
CASE 
  WHEN
      review.text NOT LIKE '%hate%' 
      AND review.text NOT LIKE '%bad%'
      AND review.text NOT LIKE '%rude%'
      AND review.text NOT LIKE '%mistake%'
      AND review.text NOT LIKE '%love%' 
      AND review.text NOT LIKE '%good%'
      AND review.text NOT LIKE '%excellent%'
      AND review.text NOT LIKE '%pleasant%'
      AND review.text NOT LIKE '%professional%'
      AND review.text NOT LIKE '%amazing%'
      AND review.text NOT LIKE '%authentic%'
      AND review.text NOT LIKE '%great%'
      AND review.text NOT LIKE '%delicious%'
  THEN 1
  ELSE 0
END
) normal,
SUM(review.useful) useful_reviews
FROM business
INNER JOIN review on business.id = review.business_id
GROUP BY business.name
ORDER BY useful_reviews DESC
