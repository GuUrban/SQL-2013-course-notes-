--exam2, link to data:https://lagunita.stanford.edu/c4x/DB/SQL/asset/socialdata.html
--data sets: 
--Highschooler ( ID, name, grade ) 
--English: There is a high school student with unique ID and a given first name in a certain grade. 

--Friend ( ID1, ID2 ) 
--English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123). 

--Likes ( ID1, ID2 ) 
--English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present. 

--Q1: Find the names of all students who are friends with someone named Gabriel. 
--Answer: 
select highschooler.name
from(select Friend.ID1 
from (select ID from Highschooler where Highschooler.name = "Gabriel"
) as S join Friend
where S.ID = Friend.ID2) as s2 join Highschooler
where highschooler.ID = s2.ID1

--Q2: For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like. 
--Answer: 
select H1.name, H1.grade, H2.name, H2.grade
from Highschooler H1, Highschooler H2, Likes
where H1.ID = Likes.ID1
and H2.ID = Likes.ID2
and H1.grade -H2.grade >1 

--Q3: For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order. 
--Answer: 
select h1.name, h1.grade, h2.name, h2.grade
from (select l1.ID1 as l1ID, l1.ID2 as l2ID
from likes l1) as L1 join (select l2.ID1 as l1ID, l2.ID2 as l2ID
from likes l2) as L2 join  highschooler h1 join  highschooler h2
where L1.l1ID = L2.l2ID
AND L1.l2ID = L2.l1ID
And h2.ID = L1.l1ID
AND h1.ID = L1.l2ID
and h1.name < h2.name 

--Q4: Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade. 
--Answer:
select Highschooler.name, Highschooler.grade
from Highschooler
where ID not in (
select ID1 
from Likes
union 
select ID2
from Likes
)

--Q5: For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), 
--return A and B's names and grades. 
--Answer: 
select H1.name, H1.grade, H2.name, H2.grade
from (
select ID1, ID2
from Likes
where ID2 not in ( select ID1 from Likes)) as oneway join Highschooler H1 
join Highschooler H2 
where H1.ID = oneway.ID1
and H2.ID = oneway.ID2

--Q6:Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade. 
--Answer:
select name, grade
from
(select ID1 from Friend 
union 
select ID2 from Friend 
where ID1 <> ID2) as friendmerge 
inner join Highschooler
where ID = friendmerge.ID1
and friendmerge.ID1 not in (
select distinct ID1 
from (select ID1, ID2 from Friend) as friendmerge2 
join Highschooler H1
join Highschooler H2 
where friendmerge2.ID1=H1.ID
and friendmerge2.ID2=H2.ID
and H1.grade <> H2.grade
)
order by grade, name 

--Q7: For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). 
--For all such trios, return the name and grade of A, B, and C. 
--Answer:
select distinct H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
from Highschooler H1, Highschooler H2, Highschooler H3, Friend F1, Friend F2, Likes 
where H1.ID = Likes.ID1 
and Likes.ID2=H2.ID 
and H2.ID not in (select ID2 from Friend where ID1 = H1.ID) 
and H1.ID = F1.ID1 and F1.ID2=H3.ID 
and F2.ID1= H3.ID and F2.ID2 = H2.ID 

--Q8:Find the difference between the number of students in the school and the number of different first names.
--Answer:
select ABS(num2.Namenum-num1.IDnum)
from 
(select count(ID) as IDnum from Highschooler) as num1,
(select count(distinct name) as Namenum from Highschooler) as num2 

--Q9:Find the name and grade of all students who are liked by more than one other student. 
--Answer:
select name, grade
from Highschooler 
join 
(select likecount.ID2, count(likecount.ID2)as likenum
from 
(select ID2 from Likes) as likecount 
group by likecount.ID2)as chooselikecount
where likenum >1 and chooselikecount.ID2 = Highschooler.ID
