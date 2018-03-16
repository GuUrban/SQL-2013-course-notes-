--Eaxam 1 _ extra, data link:https://lagunita.stanford.edu/c4x/DB/SQL/asset/moviedata.html

--data sets:
--Movie ( mID, title, year, director ) 
--English: There is a movie with ID number mID, a title, a release year, and a director. 

--Reviewer ( rID, name ) 
--English: The reviewer with ID number rID has a certain name. 

--Rating ( rID, mID, stars, ratingDate ) 
--English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate. 

--Q1: Find the names of all reviewers who rated Gone with the Wind. 
--Answer:
select distinct Reviewer.name
from Reviewer, Rating, Movie
where Rating.rID = Reviewer.rID 
and Rating.mID = Movie.mID
and Movie.title="Gone with the Wind";

--Q2: For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. 
--Answer: 
select distinct Reviewer.name, Movie.title, Rating.stars
from Reviewer, Movie, Rating
where Reviewer.rID=Rating.rID 
and Reviewer.name=Movie.director
and Movie.mID=Rating.mID

--Q3:Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first
 --word in the title is fine; no need for special processing on last names or removing "The".)  
--Answer:
select Reviewer.name desc
from Reviewer
union 
select Movie.title desc 
from Movie

--Q4: Find the titles of all movies not reviewed by Chris Jackson. 
--Answer: 
select Movie.title 
from Movie
except 
select Movie.title 
from Movie, Reviewer, Rating 
where Reviewer.name="Chris Jackson"
and Movie.mID=Rating.mID
and Reviewer.rID=Rating.rID 

--Q5:For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. 
--Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names 
--in the pair in alphabetical order. 
--Answer:
select distinct R1.name, R2.name
from Reviewer R1, Reviewer R2, Rating S1, Rating S2
where R1.name < R2.name
and R1.rID = S1.rID
and R2.rID =S2.rID 
and S1.mID=S2.mID 
order by R1.name

--Q6:For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars. 
--Answer:
select Reviewer.name, Movie.title, Rating.stars
from Reviewer, Movie, Rating 
where Rating.stars = (select MIN(Rating.stars) from Rating)
and Rating.rID = Reviewer.rID 
and Rating.mID = Movie.mID 

--Q7:List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them 
--in alphabetical order. 
--Answer:
select Movie.title, AVG(Rating.stars) 
from Movie, Rating 
where Rating.mID =Movie.mID 
group by Rating.mID 
order by AVG(Rating.stars) DESC, Movie.title 

--Q8: Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.) 
--Answer:
select Reviewer.name
from Reviewer, Rating 
where Reviewer.rID =Rating.rID 
group by Rating.rID
having count(Rating.rID)>2

--Q9: Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name.
 --Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.)
 --Answer:
select Movie.title, Movie.director 
from (select Movie.director 
from Movie
group by Movie.director having count(movie.director)>1) as d1 join Movie
Where Movie.director =d1.director 
order by Movie.director, Movie.title

--Q10:Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query 
--is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing 
--the movie(s) with that average rating.)
--Answer:
SELECT M.title, AVG(R.stars)
FROM Movie M, Rating R
WHERE M.mID = R.mID
GROUP BY R.mID
HAVING AVG(R.stars)=(
SELECT MAX(V.stars)
FROM (
SELECT AVG(Rating.stars) AS stars
FROM Rating
GROUP BY Rating.mID
) AS V
)

--Q11: Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be
-- more difficult to write in SQLite than other systems; you might think of it as finding the lowest average rating and then choosing 
 --the movie(s) with that average rating.)
 --Answer:
 SELECT M.title, AVG(R.stars)
FROM Movie M, Rating R
WHERE M.mID = R.mID
GROUP BY R.mID
HAVING AVG(R.stars)=(
SELECT MIN(V.stars)
FROM (
SELECT AVG(Rating.stars) AS stars
FROM Rating
GROUP BY Rating.mID
) AS V
)

--Q12:For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest 
--rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL. 
--Answer:
select Movie.director, Movie.title, Rating.stars
from Movie , Rating 
where Movie.mID = Rating.mID 
and Movie.director is not null
group by Movie.director 
order by Rating.stars desc

