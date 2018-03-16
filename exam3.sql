--Exam3, data link: https://lagunita.stanford.edu/c4x/DB/SQL/asset/moviedata.html

--Movie ( mID, title, year, director ) 
--English: There is a movie with ID number mID, a title, a release year, and a director. 

--Reviewer ( rID, name ) 
--English: The reviewer with ID number rID has a certain name. 

--Rating ( rID, mID, stars, ratingDate ) 
--English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate. 


--Q1 Add the reviewer Roger Ebert to your database, with an rID of 209. 
--Answer: 
insert into Reviewer values ("209","Roger Ebert");

--Q2 Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL. 
--Answer:
Insert into Rating 
select Rating.rID, Movie.mID, 5 as stars, null as ratingDate 
from Rating, Movie, Reviewer 
where Rating.rID= Reviewer.rID 
and Reviewer.name="James Cameron";

--Q3: For all movies that have an average rating of 4 stars or higher, add 25 to the release year. (Update the existing tuples; don't insert new tuples.) 
--Answer: 
update Movie
set year = year + 25
where mID in (
 select Movie.mId
 from Movie, Rating
 where Movie.mID = Rating.mID
 group by rating.mID
 having avg(stars) >= 4)
;


--Q4: Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars. 
--Answer: 
delete from Rating 
where mID in (
select distinct Rating.mID
from Movie,Rating 
where Movie.mID =Rating.mID
and (year <1970 or year >2000)
) 
and Rating.stars <4;
