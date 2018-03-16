--Datebases (https://lagunita.stanford.edu/c4x/DB/SQL/asset/moviedata.html)
--Movie ( mID, title, year, director ) 
--English: There is a movie with ID number mID, a title, a release year, and a director. 

--Reviewer ( rID, name ) 
--English: The reviewer with ID number rID has a certain name. 

--Rating ( rID, mID, stars, ratingDate ) 
--English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate. 

--Q1: Find the titles of all movies directed by Steven Spielberg
--Answer: 
select Movie.title from Movie where Movie.director ="Steven Spielberg";

--Q2: Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. 
--Answer:
select distinct Movie.year 
from Rating, Movie 
where Rating.stars>3 and Movie.mID=Rating.mID order by Movie.year;

--Q3: Find the titles of all movies that have no ratings. 
--Answer: 
select distinct Movie.title 
from Movie, Rating 
where Movie.mID not in 
(select Movie.mID 
from Movie, Rating
where Movie.mID =Rating.mID);

--Q4: Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. 
--Answer: 
select distinct Reviewer.name 
from Reviewer, Rating
where Rating.ratingDate is null and Reviewer.rID=Rating.rID;

--Q5: Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, 
--then by movie title, and lastly by number of stars. 
--Answer:
select Reviewer.name, Movie.title, Rating.stars, Rating.ratingDate
from Reviewer, Movie, Rating
where Reviewer.rID= Rating.rID and Movie.mID= Rating.mID 
order by Reviewer.name, Movie.title, Rating.stars

--Q6: For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. 
--Answer: 
select Reviewer.name, Movie.title 
from Reviewer, Movie, Rating S1, Rating S2
where S1.rID= S2.rID
and S1.ratingDate < S2.ratingDate 
and S1.mID = S2.mID 
and S1.stars < S2.stars
and Reviewer.rID =S2.rID and Movie.mID= S2.mID;

--Q7:For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title. 
--Answer: 
select Movie.title, MAX(Rating.stars)
from Movie, Rating 
where Movie.mID=Rating.mID
group by Movie.mID
order by Movie.title

Q8: For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread 
from highest to lowest, then by movie title. 
Answer: 
select Movie.title, MAX(Rating.stars)-MIN(Rating.stars) as ratingspread
from Movie, Rating 
where Movie.mID= Rating.mID 
group by Movie.mID 
order by ratingspread desc, Movie.title;

--Q9: Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, 
--then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.) 
--Answer: 
select MAX(average12)-MIN(average12) from 
(select AVG(average1) average12 from 
(select AVG(stars) average1  
from Rating S join Movie M on S.mID =M.mID
where M.year < 1980
group by S.mID)
union 
select AVG(average2) average12 from 
(select AVG(stars) average2  
from Rating S join Movie M on S.mID =M.mID
where M.year > 1980
group by S.mID))
