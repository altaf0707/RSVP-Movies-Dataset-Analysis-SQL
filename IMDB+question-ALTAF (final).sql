USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- 1st Approach: 
-- Imp Note: Using table names in the caps they are presented in the main database of imdb eg if they are presented in the schema in small caps then using them as small caps in the codes too for better clarity, however since sql is case insensitive so it won't matter whichever case you use. It's simply for smooth understanding that I am adopting this approach. Thank You

-- No. of Rows in director_mapping table: 3867 
SELECT COUNT(*) AS Total_Rows_in_director_mapping_tbl 
FROM director_mapping;

-- No. of Rows in genre table: 14662
SELECT COUNT(*) AS Total_Rows_in_genre_tbl 
FROM genre;

-- No. of Rows in movie table: 7997
SELECT COUNT(*) AS Total_Rows_in_movie_tbl 
FROM movie;

-- No. of Rows in names table: 25735
SELECT COUNT(*) AS Total_Rows_in_names_tbl 
FROM names;

-- No. of Rows in ratings table: 7997
SELECT COUNT(*) AS Total_Rows_in_ratings_tbl 
FROM ratings;

-- No. of Rows in role_mapping table: 15615
SELECT COUNT(*) AS Total_Rows_in_role_mapping_tbl 
FROM role_mapping;







-- Q2. Which columns in the movie table have null values?
-- Type your code below:


-- Two approaches can be used to find about the columns having null values:
-- 1. is to use SELECT * FROM movie WHERE col_name IS NULL;
-- This above approach has to be used for every single column in the table: movie, which I personally find very cumbersome. Therefore, we can also look for second approach of case statement to determine total of the null values in each column of the table.
-- However, please note that column which is primary key, checking for null values in them is not required since Primary key column does not have any null value nor any duplicate value. But still it can be used if want to be more clear on this claim.

-- 2. We can use Case statement too as mentioned in the above point. With this approach only, I would be solving this particular question:

SELECT SUM(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           END) AS id_total_null_values,
       SUM(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           END) AS title_total_null_values,
       SUM(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           END) AS year_total_null_values,
       SUM(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           END) AS date_published_total_null_values,
       SUM(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           END) AS duration_total_null_values,
       SUM(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           END) AS country_total_null_values,
       SUM(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           END) AS worlwide_gross_income_total_null_values,
       SUM(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           END) AS languages_total_null_values,
       SUM(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           END) AS production_company_total_null_values
FROM   movie;
  
  

-- Inference from the above code output:
-- NULL values are present in only 4 columns of movie table, i.e. country, worlwide_gross_income, languages and production_company







-- Now as you can see four columns of the movie table has null values. Let's look at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Code for 1st part of this question is as below: Yearly - total movies released:

SELECT  year     AS Year, 
		COUNT(*) AS number_of_movies  
FROM movie
GROUP BY year;

-- Inference from the above code: in 2017: Relatively highest no. of movies saw its release. Also in the 3 years of 2017,2018, 2019: with each passing year: No. of movies release saw downfall comparatively to their preceding year. So year inversely proportional to no. of movies released
 

-- Code for 2nd part of this question is as below: Monthly - total movies released:


SELECT MONTH(date_published) AS month_num,
       COUNT(*)              AS number_of_movies
FROM   movie
GROUP  BY month_num
ORDER  BY month_num DESC;

-------------------------------------------- Self ANALYSIS STARTS--------------------------------------
-- IMPORTANT NOTE: Self Anlaysis part will where similar line like above will be displayed as Self Analysis Ends. 
-- -----------------------------------------------------------------------------------------------------

-- For Self Analysis: Trying to find the month in which we had maximum & minimum release of movie:
-- Creating View first for the month wise movie as I would be needing the same code to do some self analysis

-- Which Month from the data of 3 years saw maximum and minimum no. of movie release ?

-- Forming CTE: to fetch count of released movie details for each month: 
WITH Monthly_Movie_Release AS 
	(SELECT MONTH(date_published) AS month_num,
			COUNT(*)              AS number_of_movies
	 FROM   movie
	 GROUP  BY month_num)
-- Fetching the month detail where we had maximum no. of movie release and minimum no. of movie release:
SELECT *
FROM Monthly_Movie_Release
WHERE number_of_movies IN 
		(	SELECT MAX(number_of_movies) 
			FROM Monthly_Movie_Release
		)
UNION
SELECT *
FROM Monthly_Movie_Release
WHERE number_of_movies IN 
		(	SELECT MIN(number_of_movies) 
			FROM Monthly_Movie_Release
		);

-- Inference from the above code: In the whole of years, March in sum total saw the highest no. of movie-release (824) where as December as lowest (438) number in movie release

-- SELF - ANALYSIS: 
 -- Want to know on which specific of march were most no. of movie was released amonst the 3 years of data specific 3 months of march:
 
 WITH March_Movie_Release 				   AS 
		(SELECT *, 
				MONTH(date_published)      AS month, 
				DAYOFMONTH(date_published) AS day_of_march
		FROM movie)

SELECT  day_of_march,
		COUNT(*) 						   AS total_movie_release 
FROM March_Movie_Release
WHERE month = 3
GROUP BY day_of_march
ORDER BY total_movie_release DESC;

-- Inference from the above code: 1st March saw the maximum no.(74) of movie release in this past 3 years data

-- Just in case you are interested in knowing the further breakup of the above code output i.e. year-wise break up for march, digging deeper in which year in which day of march saw highest movie release, that thing could also be checked through below code for more clarity on data:

WITH Yearly_March_Breakup 					AS
		(SELECT *, 
				MONTH(date_published)       AS month, 
				DAYOFMONTH(date_published)  AS day_of_march 
		FROM movie)
SELECT  year, 
		day_of_march, 
        COUNT(*) AS total_movie_release
FROM Yearly_March_Breakup
WHERE month = 3
GROUP BY year, day_of_march 
ORDER BY total_movie_release DESC;



-- Inference from the above code: 2019, 1st March: saw the maximum no. of movie release if we consider only march data (which recorded the highest no. of movie release in comparison to any other month)

-- --------------------------------- Self ANALYSIS ENDS--------------------------------------------------







/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT  year, 
		COUNT(*) AS number_of_movies
FROM   movie
WHERE  (  country     LIKE '%INDIA%'
          OR  country LIKE '%USA%' )
		  AND year = 2019; 

-- Inference: total number of movies released in 2019 in usa and india (individually and in combo) is 1059 in number

 




/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre
FROM   genre;








/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT     genre,
           COUNT(m.id) AS count_of_movies
FROM       movie       AS m
INNER JOIN genre       AS g
where      m.id = g.movie_id
GROUP BY   genre
ORDER BY   count_of_movies DESC limit 1 ;

-- Inference: genre: Drama has the highest no. of movies (4285) in our imdb dataset of movie release. 

-- However there was no need to join the genre table with movie table because just by following the below code, we could get the same output:
-- Since we have even movie id column in the genre table: so either we can use count(movie_id) or count(*): both will get us the same output.
SELECT     genre,
           COUNT(*) AS number_of_movies
FROM       genre
GROUP BY   genre
ORDER BY   number_of_movies DESC limit 1 ;




/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH movies_having_one_genre
     AS (SELECT movie_id
         FROM   genre
         GROUP  BY movie_id
         HAVING COUNT(DISTINCT genre) = 1)

SELECT COUNT(*) 	AS 
		total_movies_having_one_genre
FROM   movies_having_one_genre; 

-- Inference: 3289 movies have just one genre










/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

--  Have to join movie table with genre table as duration column is in movie table and genre is in genre table:

SELECT     genre,
           ROUND(AVG(duration),2) AS avg_duration
FROM       movie                  AS m
INNER JOIN genre                  AS g
ON      m.id = g.movie_id
GROUP BY   genre
ORDER BY avg_duration DESC;

-- Inference: Action genre (112.88 minutes) has highest average duration, followed by Romance, Crime and Drama etc.









/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


-- For this question, this can be solved even without forming any cte (just by filtering out the thriller genre movies in the main code of cte without creating any cte) but it's better to create cte so that we can use check out the rank of other genres too for our self analysis reference:
-- Later through the same cte, we can filter out the data for thriller genre movies:
-- either you can use count(*) or count(movie_id): both will work. Thus, using here movie_id for calculating count of movies in each genre:

WITH temp_genre AS
(
           SELECT     genre,
                      COUNT(movie_id)                            AS movie_count ,
                      RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS genre_rank
           FROM       genre                                 
           GROUP BY   genre )
SELECT *
FROM   temp_genre
WHERE  genre = "Thriller";








/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT MIN(avg_rating)    AS MIN_AVG_RATING,
       MAX(avg_rating)    AS MAX_AVG_RATING,
       MIN(total_votes)   AS MIN_TOTAL_VOTES,
       MAX(total_votes)   AS MAX_TOTAL_VOTES,
       MIN(median_rating) AS MIN_MEDIAN_RATING,
       MAX(median_rating) AS MAX_MEDIAN_RATING
FROM   ratings;




    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

-- 1st approach:
-- This below approach can be one such approach where even without cte we can determine the top 10 movies based on their average rating
-- Using rank() in the below code:
-- Below code just for top 10 movie (on basis of avg rating- ranked in desc. order of avg rating). top 10 rows of movie will be displayed in the output
-- However for the same row_number() can also be used other than rank().

-- The below code will fetch details of only top 10 rows from the table post-accounting the requirements of the question:
SELECT  m.title,
		r.avg_rating,
        RANK() OVER (ORDER BY r.avg_rating DESC) AS movie_rank
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
LIMIT 10;

-- Inference: Using rank(): in the top 10 rows of movie: the last ranked movie, i.e. the 10th row: which has min. avg rating of 9.4. So all the rows above it would have avg rating more than 9.4.


-- 2nd Approach: Using Rank() and not using limit: Filtering the top 10 ranked movies based on their average rating:

WITH top_10_ranked_movie AS 
(
SELECT  m.title,
		r.avg_rating,
        RANK() OVER (ORDER BY r.avg_rating DESC) AS movie_rank
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
)
SELECT *
FROM top_10_ranked_movie 
WHERE movie_rank <=10;


 -- 3rd Approach: Using Dense_rank() and not using limit:       
-- But the best practice would still be of cte because with it in case you want to have a look to the rank of some other movie that can also be done with it.
-- However, solving the same question with cte below:
-- Using dense_rank() in the below code:
-- Below Code for To 10 dense ranked movie
WITH Movie_Rank AS
( 
SELECT  m.title,
		r.avg_rating,
        DENSE_RANK() OVER (ORDER BY r.avg_rating DESC) AS movie_rank
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
)
SELECT *
FROM Movie_Rank
WHERE movie_rank <= 10;

-- Inference: Using dense_rank(): in the top 10 dense ranked movies: the last dense ranked movie, i.e. Innocent, Abstruse and many others, has min. avg rating of 9.0. So all the rows above 9.0 rating, would have avg rating more than 9.0, which is quite good rating.






/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have



SELECT median_rating,
       COUNT(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY movie_count DESC;

-- Inference: Movies with a median rating of 7 are slightly higher in number than other median ratings' movies in our database










/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:


-- Using rank() in the below cte for the above question requirement:
WITH production_company_hit_movie
     AS (SELECT production_company,
                COUNT(movie_id)                     AS MOVIE_COUNT,
                RANK()
                  OVER(
                    ORDER BY COUNT(movie_id) DESC ) AS PROD_COMPANY_RANK
		FROM              movie   AS M
		INNER JOIN        ratings AS R 
                
                        ON M.id = R.movie_id
         WHERE  avg_rating > 8
                AND production_company IS NOT NULL
         GROUP  BY production_company)
SELECT *
FROM   production_company_hit_movie
WHERE  prod_company_rank = 1; 

-- Inference: 2 Production company: Dream Warrior Pictures, and  National Theatre Live are the top 2 production company which produced 3 hit movies each (avg_rating > 8).

 







-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- For this question Joining is required of movie table (country column), ratings table (total_votes column), and genre table (genre column)

SELECT genre,
       COUNT(M.id) AS MOVIE_COUNT
FROM   movie AS M
       INNER JOIN genre AS G
               ON G.movie_id = M.id
       INNER JOIN ratings AS R
               ON R.movie_id = M.id
WHERE  year = 2017
       AND MONTH(date_published) = 3
       AND country LIKE '%USA%'
       AND total_votes > 1000
GROUP  BY genre
ORDER  BY movie_count DESC;

-- Inference: Drama type of genre movies were produced the maximum no. of time (24) considering the question requirement, i.e. March 2017,USA and 1,000 + votes
-- Inference: Top 3 genres are drama, comedy and action during March 2017 in the USA and had more than 1,000 votes









-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

-- Group by is not required over here because we need each genre to show up in the output for each movie

SELECT  title,
       avg_rating,
       genre
FROM   movie AS m
       INNER JOIN genre AS g
               ON g.movie_id = m.id
       INNER JOIN ratings AS r
               ON r.movie_id = m.id
WHERE  avg_rating > 8
       AND title LIKE 'THE%'
ORDER BY avg_rating DESC;


-- Inference: 
-- There are 8 movies which begin with "The" in their title.
-- The Brighton Miracle has the highest average rating of 9.5.
-- Drama Genre over here tops the list.



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

-- date_published in movie table and median_rating in ratings table: So join these 2 tables:
SELECT  median_rating, 
		COUNT(*) AS movie_count
FROM   movie AS m
       INNER JOIN ratings AS r
               ON r.movie_id = m.id
WHERE  median_rating = 8
       AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY median_rating;

-- Inference: Total 361 movies were produced which had a median rating of 8 in the 3 years of the imdb dataset given.











-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

-- There are two apprtoaches to solve this question:
-- 1. By Languages and 2. By country
--  Solving 1st with 1st approach of languages in the below code:

-- Trying to form a temporary table that consist of Italian and German Languages Total Votes
WITH Votes_temp AS 
(
SELECT languages, SUM(total_votes) AS VOTES 
FROM movie AS m
INNER JOIN ratings AS r 
ON m.id = r.movie_id 
WHERE languages LIKE '%Italian%'
UNION
SELECT languages, SUM(total_votes) AS VOTES 
FROM movie AS m
INNER JOIN ratings AS r 
ON m.id = r.movie_id
WHERE languages LIKE '%GERMAN%'
),
-- In Below Code: Getting that language datset from above cte who has got more votes 
Languages_Votes AS
(
SELECT languages 
FROM Votes_temp
ORDER BY VOTES DESC
LIMIT 1)
-- In below Code: Trying to get get an answer in the output whether the German language movie received more votes than Italian language movie or not: So Fetching answer in yes and no: 
SELECT IF (languages LIKE 'GERMAN' , 'YES', 'NO') AS ANSWER
FROM Languages_Votes;

-- Inference: German Language Movie recieved more votes than Italian Language Movie

-- Approach 2nd : By country column:
-- But here, we can answer only by checking the output of the below code: like for eg from the two no. which is higher for total_votes: 
SELECT  country, 
		SUM(total_votes) AS total_votes
FROM movie AS M
	INNER JOIN ratings	 AS R 
    ON M.id=R.movie_id
WHERE country = 'Germany' 
	OR country = 'Italy'
GROUP BY country;

-- Inference: Clearly it can be seen that Germany movies got more votes than Italy Movies.
-- Inference: Germany leads with a margin of 28745 w.r.t. Italy Movie







-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


SELECT 
		SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls, 
		SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
		SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
		SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
		
FROM names;

-- Inference: Columns: Height, date_of_birth, known_for_movies contain some NULL values.



/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Firstly: Trying to get the details of the top 3 ranked genres only basis the no.of movies made on it:
WITH genre_temp AS
(
           SELECT     genre,
                      COUNT(*)                            AS movie_count ,
                      RANK() OVER(ORDER BY Count(*) DESC) AS genre_rank
           FROM       genre                               AS g
           INNER JOIN ratings 							  AS r
           ON         r.movie_id = g.movie_id
           WHERE      avg_rating > 8
           GROUP BY   genre),
-- Inference From the above code: Drame Genre Tops with 175 movie counts, followed by Action and Comedy with movie count of 46 and 44 respectively.           

-- Trying to Join the director_mapping table with the above cte for top 3 ranked genre: so that only top 3 ranked genres' director details come up:
-- Then we can easily find the top 3 director names after filtering with avg rating of 8+ and computing director names basis the no. of time they made the movies.
directors_temp AS
(SELECT    n.NAME            				    AS director_name ,
           COUNT(*) 							AS movie_count,
           RANK() OVER(ORDER BY COUNT(*) DESC)  AS director_rank
FROM       director_mapping  					AS d
-- Joining with genre because we would need genre column as common column to join this table with the above cte: i.e. top 3 genre details
INNER JOIN genre 								AS g
ON d.movie_id = g.movie_id
INNER JOIN names 								AS n
ON         n.id = d.name_id
INNER JOIN genre_temp 							AS t
ON g.genre = t.genre
INNER JOIN ratings 								AS r
ON d.movie_id = r.movie_id
WHERE       avg_rating > 8
		AND genre_rank <=3
GROUP BY   NAME
ORDER BY   movie_count DESC)

SELECT  director_name, 
		movie_count
FROM directors_temp
WHERE director_rank <= 3;



-- Inference: James Mangold (rank 1), Anthony Russo (rank 2), Joe Russo (rank 2) and Soubin Shahir (rank 2) are the top 3 directors (top 3 ranked directors) in the top three ranked genre CTE table whose movies have an average rating > 8
-- Inference: James Mangold should be hired for Drama Genre as it Tops and Even James Mangold tops into it.




/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH actor_rank AS
(	SELECT  n.name           						AS actor_name,
			COUNT(m.id) 							AS movie_count,
			RANK() OVER(ORDER BY COUNT(m.id) desc)  AS actor_rank 
	FROM   role_mapping 							AS rm
		INNER JOIN movie							AS m
                ON m.id = rm.movie_id
		INNER JOIN ratings 							AS r
				ON m.id = r.movie_id
		INNER JOIN names 							AS n
                ON n.id = rm.name_id
	WHERE  	r.median_rating >= 8
		AND category = "ACTOR"
	GROUP  BY actor_name
	ORDER  BY movie_count DESC
)
SELECT  actor_name,
		movie_count
FROM actor_rank 
WHERE actor_rank <=2;

-- Inference from the above code: Top 2 actors: Mammootty and Mohanlal






/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

-- 2 approaches are these to solve this question
--  one is direct method without using cte aand another one using cte

-- One approach: Trying solving the same first without cte's:

SELECT     production_company,
           SUM(total_votes)                            AS vote_count,
           Rank() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM       movie                                       AS m
INNER JOIN ratings                                     AS r
ON         r.movie_id = m.id
GROUP BY   production_company 
LIMIT 3;

-- 2nd Approach: Trying to solve it using cte's: CTE approach is generally preferred: as with it one can even get a bird's eye view over other rank's movies data
-- So, trying to solve the question with cte below:

WITH Prod_Comp_Rank AS(
SELECT  production_company,
		SUM(total_votes) 							AS vote_count,
		RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM movie 											AS m
	INNER JOIN ratings 								AS r 
		ON r.movie_id = m.id
GROUP BY production_company)
SELECT  *
FROM Prod_Comp_Rank
WHERE prod_comp_rank < 4;


-- Inference: Top 3 Production mentioned in the descending order in terms of the no. no. votes they received for their movies:
-- 1. Marvel Studios 2. Twentieth Century Fox 3. Warner Bros.
-- Thus, RSVP Movies Company can partner with Marvel Studios.






/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- There are 2 approaches to solve this question:
-- 1. If you to visually observe from the output table (from the list of multiple actors ranked basis the weighted average on votes & total as tie-breaker) then that can be an indirect method to answer the query: but here just single actor row won't come. 
-- 2. If you directly that the output should come for top ranked Actor basis the weighted average on votes & total as tie-breaker:


-- 1st Approach: Indirect Method: Visually observing the output table and then answering the question:
WITH actor_temp
     AS (SELECT N.NAME                                                     AS
                actor_name,
                SUM(total_votes)                                           AS 
					total_votes,
                COUNT(R.movie_id)                                          AS
                   movie_count,
                ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS
                   actor_avg_rating
-- movie table is required to filter country column to fetch data for "india"
         FROM   movie 													   AS M
                INNER JOIN ratings 										   AS R
                        ON M.id = R.movie_id
                INNER JOIN role_mapping 			    				   AS RM
                        ON M.id = RM.movie_id
                INNER JOIN names 										   AS N
                        ON RM.name_id = N.id
         WHERE  category = "ACTOR"
                AND country = "india"
         GROUP  BY NAME
         HAVING movie_count >= 5)
SELECT *,
	RANK()
		OVER(
		ORDER BY actor_avg_rating DESC, total_votes DESC) 					AS actor_rank
FROM   actor_temp;

-- Inference: Vijay Sethupathi can be seen as to ranked actor with rank 1 in the output table, followed by Fahadh Faasil and Yogi Babu


-- 2nd approach: Direct Method: Top rank 1 actor row will come in the output table to answer the question
WITH actor_temp
     AS (SELECT N.NAME                                                     AS
                actor_name,
                SUM(total_votes)                                           AS
					total_votes,
                COUNT(R.movie_id)                                          AS
                   movie_count,
                ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS
                   actor_avg_rating
-- movie table is required to filter country column to fetch data for "india"
         FROM   movie 						AS M
                INNER JOIN ratings 			AS R
                        ON M.id = R.movie_id
                INNER JOIN role_mapping 	AS RM
                        ON M.id = RM.movie_id
                INNER JOIN names 			AS N
                        ON RM.name_id = N.id
         WHERE  category = "ACTOR"
                AND country = "india"
         GROUP  BY NAME
         HAVING movie_count >= 5),
-- For Top actor, forming one cte with having the output from the above cte:
Top_Actor AS
(
	SELECT *,
		RANK()
			OVER(
			ORDER BY actor_avg_rating DESC, total_votes DESC) AS actor_rank
	FROM   actor_temp
)
-- Extracting the top ranked actor detail, rank 1 actor detail:
SELECT * 
FROM Top_Actor
WHERE actor_rank = 1;



-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_temp AS
(
           SELECT     n.NAME 												AS actress_name,
                      SUM(total_votes) 										AS total_votes,
                      COUNT(r.movie_id)                                     AS movie_count,
                      ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actress_avg_rating
-- movie table is required to filter country column to fetch data for "india"
           FROM       movie                                                  AS m
				INNER JOIN ratings                                           AS r
				ON         m.id=r.movie_id
				INNER JOIN role_mapping 									 AS rm
				ON         m.id = rm.movie_id
				INNER JOIN names 											 AS n
				ON         rm.name_id = n.id
           WHERE    	  category = "ACTRESS"
				AND       country = "INDIA"
				AND       languages LIKE "%HINDI%"
           GROUP BY   NAME
           HAVING     movie_count>=3 ),
-- For Top Actress, forming one cte with having the output from the above cte:
Top_Actress AS
(
	SELECT   *,
			RANK() OVER(ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
	FROM     actress_temp
)
SELECT * 
FROM Top_Actress 
WHERE actress_rank <=5;

-- Inference: Top 5 actresses in Hindi movies released in India based on their weighted average ratings, & total_votes in case of a tie, are Taapsee Pannu, Kriti Sanon, Divya Dutta, Shraddha Kapoor, Kriti Kharbanda








/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

-- Forming a cte first to gather all the necessary columns from multiple table and doing necessary filtering on it:
WITH thriller_genre_movies
     AS (SELECT DISTINCT title,
                         avg_rating
         FROM   movie 						AS m
                INNER JOIN ratings 			AS r
                        ON r.movie_id = m.id
                INNER JOIN genre 			AS g 
						USING(movie_id)
         WHERE  genre LIKE "THRILLER")
-- Now selecting the output from above: and classifying the avg_rating column as per the question instructions:
SELECT *,
       CASE
         WHEN avg_rating > 8 THEN "Superhit movies"
         WHEN avg_rating BETWEEN 7 AND 8 THEN "Hit movies"
         WHEN avg_rating BETWEEN 5 AND 7 THEN "One-time-watch movies"
         ELSE "Flop movies"
       END AS avg_rating_category
FROM   thriller_genre_movies;






/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT genre,
		ROUND(AVG(duration),2) 	AS 
				avg_duration,
        SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS 
				running_total_duration,
        ROUND(AVG(AVG(duration)) OVER(ORDER BY genre ROWS BETWEEN 10 PRECEDING AND CURRENT ROW),2) AS 
				moving_avg_duration
FROM movie						AS m 
	INNER JOIN genre 			AS g 
	ON m.id= g.movie_id
GROUP BY genre
ORDER BY genre;






-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

-- First forming a cte for for top 3 genre:
WITH genre_temp AS
(
           SELECT     genre,
                      COUNT(*)                            AS movie_count ,
                      RANK() OVER(ORDER BY COUNT(*) DESC) AS genre_rank
           FROM       genre                               AS g
           INNER JOIN ratings 							  AS r
           ON         r.movie_id = g.movie_id
           WHERE      avg_rating > 8
           GROUP BY   genre), 
-- Fetching details of highest gross income movie world wide that meets the top 3 ranked genre requirement from the above cte:
movie_temp AS
(
           SELECT     genre,
                      year,
                      title AS 
						movie_name,
                      CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10)) AS 
						worldwide_gross_income,
					  DENSE_RANK() OVER(partition BY year ORDER BY CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS 
						decimal(10))  DESC ) AS movie_rank
           FROM       movie        					    AS m
				INNER JOIN genre      					AS g
				ON         m.id = g.movie_id
				INNER JOIN genre_temp					AS tg
				USING(genre)	
			WHERE genre_rank <= 3
           GROUP BY   movie_name
)
-- fetching now the details from the above table(cte) of only those top gross income movies that not only belongs to either of the top 3 genre but also ranked less than 5 orr equal to 5:
SELECT *
FROM   movie_temp
WHERE  movie_rank <= 5
ORDER BY YEAR ;








-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_company_temp
     AS (SELECT production_company,
                COUNT(*) 							 	 AS movie_count,
                RANK() OVER (ORDER BY COUNT(*) DESC)     AS prod_comp_rank
         FROM   movie 									 AS m
                INNER JOIN ratings  					 AS r
                        ON r.movie_id = m.id
         WHERE  median_rating >= 8
                AND production_company IS NOT NULL
                AND Position(',' IN languages) > 0
         GROUP  BY production_company)
SELECT *
FROM   production_company_temp
WHERE prod_comp_rank <=2;



-- Inference: Star Cinema and Twentieth Century Fox are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


WITH actress_temp AS
(
	SELECT            n.NAME 												AS actress_name,
					  SUM(total_votes) 										AS total_votes,
                      COUNT(r.movie_id)                                     AS movie_count,
                      ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actress_avg_rating,
                      RANK() OVER(ORDER BY COUNT(r.movie_id) DESC) 			AS actress_rank
   FROM               ratings                                               AS r
           INNER JOIN role_mapping										    AS rm
           ON         r.movie_id = rm.movie_id
           INNER JOIN names 												AS n
           ON         rm.name_id = n.id
           INNER JOIN GENRE 												AS g
           ON g.movie_id = r.movie_id
   WHERE              category = "ACTRESS"
           AND        avg_rating > 8
           AND        genre = "Drama"
   GROUP BY  NAME
)
SELECT   *
FROM     actress_temp
WHERE 	 actress_rank <= 3;

-- Inference: Parvathy Thiruvothu (rank 1), Susan Brown (rank 1), Amanda Lawrence (rank 1), Denise Gough (rank 1) are the top 3 ranked actresses based on number of Super Hit movies (average rating >8) in drama genre

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH next_date_published_temp AS
(
           SELECT     d.name_id,
                      NAME,
                      d.movie_id,
                      duration,
                      r.avg_rating,
                      total_votes,
                      m.date_published,
                      LEAD(date_published,1) OVER(PARTITION BY d.name_id ORDER BY date_published) 			AS next_date_published
           FROM       director_mapping                                                                      AS d
           INNER JOIN names                                                                                 AS n
           ON         n.id = d.name_id
           INNER JOIN movie						 				   AS m
           ON         m.id = d.movie_id
           INNER JOIN ratings 									   AS r
           ON         r.movie_id = m.id ), 
date_diff_temp AS
(
       SELECT *,
              DATEDIFF(next_date_published, date_published) 	  AS date_difference
       FROM   next_date_published_temp ),

top_director_temp AS 
(       
		SELECT      name_id                     			      AS director_id,
					NAME                       				 	  AS director_name,
					COUNT(movie_id)               	     	 	  AS number_of_movies,
                    RANK() OVER (ORDER BY COUNT(movie_id) DESC)   AS director_rank, 
					ROUND(AVG(date_difference),2) 				  AS avg_inter_movie_days,
					ROUND(AVG(avg_rating),2)                      AS avg_rating,
					SUM(total_votes)              				  AS total_votes,
					MIN(avg_rating)               				  AS min_rating,
					MAX(avg_rating)               				  AS max_rating,
					SUM(duration) 				                  AS total_duration
		FROM     date_diff_temp
		GROUP BY director_id)

SELECT  director_id,
		director_name, 
        number_of_movies, 
        avg_inter_movie_days,
        avg_rating,
        total_votes, 
        min_rating,
        max_rating,
        total_duration
FROM top_director_temp
WHERE director_rank <= 9 ;



