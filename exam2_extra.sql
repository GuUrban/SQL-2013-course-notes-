--exam2, link to data:https://lagunita.stanford.edu/c4x/DB/SQL/asset/socialdata.html
--data sets: 
--Highschooler ( ID, name, grade ) 
--English: There is a high school student with unique ID and a given first name in a certain grade. 

--Friend ( ID1, ID2 ) 
--English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123). 

--Likes ( ID1, ID2 ) 
--English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present. 

--Q1: For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C. 
--Answer: 
select distinct H1.name,H1.grade, H2.name, H2.grade, H3.name, H3.grade 
from Highschooler H1, Highschooler H2, Highschooler H3, Likes L1, LikeS L2  
where H1.ID =L1.ID1
and H2.ID =L1.ID2 and H2.ID =L2.ID1 and H3.ID= L2.ID2 
and H3.ID not in (select ID2 from Likes where H1.ID=ID1)
and H1.ID <>H3.ID;

--Q2: Find those students for whom all of their friends are in different grades from themselves. Return the students names and grades.
--Answer: 
select name, grade
from Highschooler, (
  select ID1 from Friend
  except
  select distinct Friend.ID1
  from Friend, Highschooler H1, Highschooler H2
  where Friend.ID1 = H1.ID and Friend.ID2 = H2.ID
  and H1.grade = H2.grade
) as D
where Highschooler.ID =D.ID1
;


--Q3: What is the average number of friends per student? (Your result should be just one number.) 
--Answer: 
select AVG(Fnum.num)
from(
select count(ID2) as num 
from Friend 
group by ID1) as Fnum;


--Q4: Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend. 
--Answer:
select count(distinct F1.ID2) + count(distinct F2.ID2)
from  Highschooler, Friend F1, Friend F2
where Highschooler.name = 'Cassandra'
and Highschooler.ID = F1.ID1
and F2.ID1 = F1.ID2 
and F2.ID1 <> Highschooler.ID
and F2.ID2 <> Highschooler.ID
;

--Q5: Find the name and grade of the student(s) with the greatest number of friends. 
--Answer: 
select name, grade  
from (
select ID1 from Friend 
except -- anybodyelse has more friends 
select distinct (F1.ID1) 
from (select ID1, count(ID2)as num from Friend group by ID1) as F1, 
(select ID1, count(ID2) as num from Friend group by ID1) as F2 
where F2.num >F1.num 
) as MAXnum, Highschooler  
where MAXnum.ID1 = Highschooler.ID;
