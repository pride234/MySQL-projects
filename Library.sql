#drop database if exists Library;
#create database Library;

#-------первая--лаба----------------------------------------------------------------|

drop table if exists credits, books, readers, authors, aw;

create table Library.Books (
	
    BookID int auto_increment,
    WorkName varchar(50),
    AuthorID int,
    PublishingYear int, 
    Price int,
    Edition bool default true,
    Annotation varchar(50),
    primary key (bookid)
	#foreign key (AuthorID) references Authors(AuthorID)
);


create table Library.Authors (
	
    AuthorID int not null auto_increment,
	AuthorName varchar(35),
	primary key (authorid)
);

alter table books
	add constraint fk32 foreign key (AuthorID) references Authors(AuthorID);

create table Library.AW (

	AuthorID int,
    BookID int,
    foreign key (AuthorID) references authors(AuthorID),
    foreign key (bookid) references books(bookid)
);

create table Library.Readers (
	
    ReaderID int not null auto_increment,
    ReaderName varchar(35) not null,
    Adress varchar(35),
    PhoneNumber int,
    primary key (ReaderID)
    #foreign key (CreditID, ReaderID) references Credits(creditid, readerid) on delete cascade
);

create table Library.Credits (
	
    CreditID int not null auto_increment,
    ReaderID int not null,
    BookID int not null,
    TakeDate date,
    ReturnDate date,
    #ActualReturnDate date,
    primary key (CreditId),
    foreign key (bookid) references books(bookid),
    foreign key (readerID) references readers(readerid)    
);

#-------вторая--лаба----------------------------------------------------------------|

alter table library.credits 
	add constraint chk check (ReturnDate >= TakeDate);

alter table library.books 
	ADD constraint pricechk check (Price >= 100),
	add	constraint edidtionchk check (Edition in(true, false)),
    ADD constraint publishingchk check (PublishingYear >= 0);
	    
alter table credits 
    add CONSTRAINT FK1 foreign key (bookid) references books(BookID),
    add CONSTRAINT FK2 foreign key (readerID) references readers(readerid);
    
    
alter table credits DROP FOREIGN KEY fk1;

/*alter table books drop CHECK  publishingchk;

insert into books values ("Franz Kafka", "The Castle", -1926, 300, 'old', "Some strange things happen in The Castle...");

alter table library.books 
    ADD constraint publishingchk check (PublishingYear >= 0);*/


alter table books add column Single varchar(3) default "так";

alter table books drop column single;

ALTER TABLE readers RENAME users;

ALTER TABLE users RENAME readers;

#--------третья--лаба------------------------------------------------------------------|

/*insert into books values (null, "Herman Melville", "Moby Dick", 1851, 500, 'new', "A mad captain wants to kill a white whale");
insert into books values (null,"Franz Kafka", "The Castle", 1926, 300, 'old', "Some strange things happen in The Castle...");
insert into books values (null,'Garest Fomp', 'Fairy tale about scary people', 2025, 1500 , 'new', 'blablabla');
insert into books values (null,'Mario Puzo', 'The Godfather', 1969, 800 , 'new', 'mafia');
insert into books values (null,'Aldous Huxley', 'Brave New World', 1932 , 600 , 'old', 'dont know');
insert into books values (null,'Jack London', 'The Sea-Wolf', 1904, 750 , 'new', 'social darwinism');
insert into books values (null,'William Makepeace Thackeray', 'Vanity Fair', 1848 , 1000, 'old', 'the name says for itself');*/

insert into Authors values (null, 'Erich Maria Remarque');
insert into Authors values (null, 'Arthur Hailey');
insert into Authors values (null, 'Nikolay Gorkavy');

insert into books values (null, 'Three Comrades', 1, 1937, 1500 , true, 'the greatest friendship and love');
insert into books values (null, 'Hotel ', 2, 1965, 950 , false, 'people');
insert into books values (null,'Strong Medicine', 2, 1984, 850 , true, 'about a strong woman');
insert into books values (null,'Astrovityanka', 3, 2008, 1150, true, 'about a strong woman too');

insert into AW values (1, 1);
insert into AW values (2, 2);
insert into AW values (2, 3);
insert into AW values (3, 4);



insert into readers values (null, 'Gregory Als', 'HappyStreet,344/23', 530444324);
insert into readers values (null, 'Conor Conorovich', 'ThinkingStreet, 23/344', 530345111);
insert into readers values (null, 'Korvo Attano', 'Dunwall', 530098123);
insert into readers values (null, 'Hideo Kojima', 'Japan', 530098145);
insert into readers values (null, 'Sam Porter Bridges', 'America', 530097756);
insert into readers values (null, 'Ekaterina Goldsman', 'neverlandstreet', 53004633);
insert into readers values (null, 'Nika Colonin', 'Journalstreet', 530045633);
insert into readers values (null, 'Demian Farmcruel', 'Kyiv', 530046664);
insert into readers values (null, 'Crum Cruah', 'somewhereland', 56321220);
insert into readers values (null, 'Lola Alol', 'Africa', 53000315);
insert into readers values (null, 'Griend Blownap', 'Germany', 566006142);
#------------четвёртая--лаба--------------------------------------------------------|

/*select readername, credits.takenbook from readers 
join credits on readers.readerid = credits.readerid;*/

#select * from credits;

select AuthorName, count(bookid) 
from authors
inner join books
on authors.AuthorID = books.AuthorID
group by Authorname
order by AuthorName;

select count(aw.AuthorID), WorkName from aw
inner join books b on aw.BookID = b.BookID
group by aw.BookID;
#------------пятая--лаба--------------------------------------------------------|

select workname from books where price > (select avg(price) from books);

select workname from books where price = (select max(price) from books);

select WorkName from (select count(aw.AuthorID) as cc, WorkName from aw inner join books b on aw.BookID = b.BookID group by aw.BookID) as temp where cc >= 2;
#-----------шестая--лаба--------------------------------------------------------|


create view authorid1 as select *
                         from authors
                         where AuthorID = 1;

select * from credits;

alter table library.credits
    add constraint chk2 check (HaveToReturn >= TakeDate);


insert into credits values (null, 1, 1, '2002-01-27', '2002-01-27', '2002-02-15');
insert into credits values (null, 1, 3, '2003-09-12', '2003-10-12', null);
insert into credits values (null, 5, 4, '2000-02-22', '2000-02-22', '2000-02-22');
insert into credits values (null, 4, 3, '2000-02-22', '2000-05-22', null);
insert into credits values (null, 6, 4, '2000-02-22', '2002-01-27', '2002-02-15');
insert into credits values (null, 10, 2, '2002-02-22', '2003-10-12', null);
insert into credits values (null, 11, 2, '2000-02-22', '2000-02-22', '2000-02-22');
insert into credits values (null, 2, 1, '2000-02-12', '2000-02-22', null);
insert into credits values (null, 6, 3, '1999-02-22', '2000-02-22', '2000-02-22');
insert into credits values (null, 7, 2, '2000-01-22', '2000-02-22', null);

create view namebookreturn as
select ReaderName, WorkName, TakeDate, ReturnDate from readers
inner join (select ReaderID, WorkName, TakeDate, ReturnDate from credits
inner join books on credits.BookID = books.BookID) as smth
on readers.ReaderID = smth.ReaderID;

create view favoritebooks as
select WorkName, max(cc) from (select WorkName, count(Credits.BookID) as cc
from books
inner join credits on books.BookID = credits.BookID
group by books.BookID) as WNc;

#-------седьмая--лаба---------------------------------------------------------------------|

drop procedure if exists update_price;

create procedure update_price(in new_year int)
begin
    update raritty2, (select BookID from raritty2) as smth
    set Price = if(new_year - PublishedYear < 50, 1, 0) + if(new_year - PublishedYear >= 50 and new_year - PublishedYear < 100, 2, 0) + if(new_year - PublishedYear >= 100, 3, 0)
    where raritty2.BookID = smth.BookID;
end;

call update_price(2019);
#-------восьмая--лаба---------------------------------------------------------------------|

create trigger deletebook before delete on books
    for each row
    begin
        update aw
        set BookID = null
        where BookID = old.BookID;
    end;

create trigger deleteauthor before delete on authors
    for each row
    begin
        delete from aw where BookID is null and aw.AuthorID = old.AuthorID;
    end;

create trigger addprice before insert on rarity
    for each row
begin
    if 2019 - new.PublishedYear >= 100 then set new.Price = 3;
    elseif 2019 - new.PublishedYear >= 50 and 2019 - new.PublishedYear < 100 then set new.Price = 2;
    elseif 2019 - new.PublishedYear < 50 then set new.Price = 1;
    end if;
end;

#-------девятая--лаба--(шифрование)---------------------------------------------------------------------|

create view encrypted as select AuthorID, aes_encrypt(AuthorName, 'key') from authors;