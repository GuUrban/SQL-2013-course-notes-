--Exam4  , data link:https://lagunita.stanford.edu/c4x/DB/SQL/asset/socialdata.html

--Movie ( mID, title, year, director ) 
--English: There is a movie with ID number mID, a title, a release year, and a director. 

--Reviewer ( rID, name ) 
--English: The reviewer with ID number rID has a certain name. 

--Rating ( rID, mID, stars, ratingDate ) 
--English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate. 


--Q1: It's time for the seniors to graduate. Remove all 12th graders from Highschooler. 
--Answer : 
delete from Highschooler 
where grade=12; 

--Q2: If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple. 
--Answer: 
delete from Likes 
where ID1 in (
select ID1 
from (select Likes.ID1 
    from Friend, Likes 
    where Friend.ID1=Likes.ID1 
    and Friend.ID2=Likes.ID2
    except 
    select L1.ID1
    from Likes L1, Likes L2 
    Where L2.ID1 =L1.ID2
    and L2.ID2=L1.ID1)
);

--Q2: If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.
--Answer: 
delete from Likes 
where ID1 in (
select ID1 
from (select Likes.ID1 
    from Friend, Likes 
    where Friend.ID1=Likes.ID1 
    and Friend.ID2=Likes.ID2
    except 
    select L1.ID1
    from Likes L1, Likes L2 
    Where L2.ID1 =L1.ID2
    and L2.ID2=L1.ID1)
);

--Q3: For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself. (This one is a bit challenging; congratulations if you get it right.) 
--Answer: 
insert into Friend
select F1.ID1, F2.ID2
from Friend F1, Friend F2 
where F1.ID2=F2.ID1 
and F1.ID1<>F2.ID2 
except --if friendship records exist 
select * from Friend ;