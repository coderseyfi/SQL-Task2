create database Task2
use Task2

create table Users(
Id int primary key identity,
Login nvarchar(35),
Password nvarchar(30),
Mail varchar(35)
);


create table Posts(
Id int primary key identity,
Content nvarchar(40),
When_shared datetime default getdate(),
UserId int foreign key references Users(Id),
Like_count int,
isDeleted bit default 0
);
alter table Posts
drop column Content 

alter table Posts
add  Content nvarchar(max)



create table Comment (
Id int primary key identity,
UserId int foreign key references Users(Id),
PostId int foreign key references Posts(Id),
Like_count int,
isDeleted bit default 0
);


create table People(
Id int primary key identity,
Name nvarchar(20),
Surname nvarchar(30),
Age int,
UserId int foreign key references Users(Id)
);

insert into Users
values('zaman.safarov','zaman123123','zaman707@gmail.com'),
('sefi.necefli','seyfi12345','sefi.madrid@gmail.com'),
('raminseferli','raminsaf123','ramin77@gmail.com'),
('abbasmammadov1','abbas3123','abbas9097@gmail.com'),
('eli.murarov','eli123321','eli1001@gmail.com')

insert into Posts(Content,When_shared,UserId,Like_count,isDeleted)
values('Create a daily, weekly or monthly series','','1','200',1),
('Run a contest or giveaway','','2','223',0),
('Host an AMA','','3','100',0),
('Run a social media takeover','','4','434',1),
('Share some relevant content','','5','2340',0)

insert into Comment
values('1','1','56',0),
('2','2','8',1),
('3','3','33',1),
('4','4','124',1),
('5','5','7',0)

insert into People
values('Zaman','Safarov',18,'1'),
('Seyfi','Necefli',20,'2'),
('Ramin','Seferli',20,'3'),
('Abbas','Memmedov',22,'4'),
('Eli','Murarov',28,'5')


select count(Posts.UserId) totalComment
from Posts

--task1--
select p.Content 'content', count(c.Id) 'totalCount' from Comment c
join Posts p
on c.PostId = p.Id
group by p.Content


--task2--
select * from Comment c
join Posts p 
on c.PostId = p.Id
join Users u 
on c.UserId = u.Id
join People pe 
on pe.UserId = u.Id

create view ShowAllData as
select u.Login, u.Mail , u.Password, pe.Name,pe.Surname, pe.Age, 
p.Content,p.When_shared,p.Like_count,p.isDeleted, c.PostId 'comment to post', 
c.Like_count 'comment likes',c.isDeleted 'when comment deleted' from Comment c
join Posts p 
on c.PostId = p.Id
join Users u 
on c.UserId = u.Id
join People pe 
on pe.UserId = u.Id
select * from ShowAllData

--task3--+
create trigger InsteadOfDeleteComment
on Comment
instead of delete 
as 
begin 
   declare @Id int
   select top 1 @Id = Id from deleted
   update Comment set isDeleted =1 where Id = @Id
 end

 create trigger InsteadOfDeletePosts
on Posts
instead of delete 
as 
begin 
   declare @Id int
   select top 1 @Id = Id from deleted
   update Posts set isDeleted =1 where Id = @Id
 end


 --task4--
create procedure usp_incPostLikee @Id int
as
update Posts set Like_count = Like_count + 1
where Posts.Id = @Id

exec usp_incPostLikee 1


create procedure usp_ResetPassword (@Mail varchar(100), @NewPassword varchar(15))
as 
update Users set Password = @NewPassword
where Users.Mail = @Mail

EXEC usp_ResetPassword @Mail = 'sef.necefli.12@gmail.com', @NewPassword = 'sefisefi@gmail.com'

