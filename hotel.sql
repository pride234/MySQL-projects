create database Hotel;
create table Clients
                      (
                          PassportID int auto_increment,
                          Surname varchar(35) not null,
                          Name varchar(35) not null,
                          Patronymic varchar(35) not null,
                          Hometown varchar(35) not null,
                          CheckInDate date not null,
                          CheckOutDate date not null,
                          PRIMARY KEY (PassportID)
                      );

create unique index Clients_PassportID_uindex
    on Clients (PassportID);

create table Staff
(
    Surname varchar(35) not null,
    Name varchar(35) not null,
    Patronymic varchar(35) not null,
    Floor int not null,
    Day varchar(35) not null,
    constraint Staff_pk
        primary key (Surname, Name, Patronymic)
);

create table Hotel_Rooms
(
    Room int not null,
    NumberofRooms int not null
);

alter table hotel_rooms
    add Floor int not null after Room;

create unique index Hotel_Rooms_Room_uindex
    on Hotel_Rooms (Room);

alter table Hotel_Rooms
    add constraint Hotel_Rooms_pk
        primary key (Room);

alter table clients change CheckOutDate Room int not null;




drop procedure if exists load_foo_test_data;
delimiter #
create procedure load_foo_test_data()
begin

    declare v_max int unsigned default 13;
    declare v_counter int unsigned default 1;

    truncate table hotel_rooms;
    start transaction;
    while v_counter < v_max do
            insert into hotel_rooms values (v_counter, CEILING(v_counter/4), MOD(v_counter, 3) + 1);
            set v_counter=v_counter+1;
        end while;
    commit;
end #

delimiter ;

call load_foo_test_data();

DROP procedure  IF EXISTS  getRoomInformation;

delimiter //
CREATE PROCEDURE getRoomInformation(in roomnum int)
BEGIN
    select * from clients where room = roomnum ;
END//

DROP procedure  IF EXISTS  getHometown;

delimiter //
CREATE PROCEDURE getHometown(in city VARCHAR(35))
BEGIN
    select * from clients where Hometown = city ;
END//

DROP procedure  IF EXISTS  getCleaner;

delimiter //
CREATE PROCEDURE getCleaner(in v_surname VARCHAR(35), in v_name VARCHAR(35), in v_patronymic VARCHAR(35), in v_day int)
BEGIN
    select Surname, Name, Patronymic from staff
    where (
        select floor from hotel_rooms
        where room = (select Room from clients where (Surname, Name, Patronymic) = (v_surname, v_name, v_patronymic))
    )
      and Day = v_day;
END//

delimiter ;

DROP procedure  IF EXISTS  getFreeRooms;

delimiter //
CREATE PROCEDURE getFreeRooms()
BEGIN
    select (select count(room) from hotel_rooms) - count(Room) from clients;
END//

delimiter ;

call getFreeRooms();

insert into clients value (1001, 'Bob', 'Bob', 'Bob', 'City', '2019-12-08', 5);

drop procedure if exists Evict;

delimiter //
CREATE PROCEDURE Evict(in v_ID int)
BEGIN
    select (CURDATE() - CheckInDate) * (select NumberofRooms from hotel_rooms where room = (select room from clients where PassportID = v_ID)) * 1000 from clients where PassportID = v_ID;
    insert into storage value (default, v_ID, Room, CheckInDate, CURDATE(), CURDATE() - CheckInDate, 2);

    delete from clients where PassportID = v_ID;

END//
delimiter ;

call Evict(1001);

alter table clients
    add constraint clients_hotel_rooms_Room_fk
        foreign key (Room) references hotel_rooms (Room);


insert into clients value (0000, 'Olexander', 'Bunin', 'Andeevich', 'Vein', '2019-02-14', 5);
insert into clients value (0001, 'Polina', 'Olefir', 'Olexandrovna', 'Berlin', '2019-01-12', 1);
insert into clients value (0010, 'Bogdana', 'Pyslar', 'Bopys', 'Kyiv', '2019-12-20', 6);
insert into clients value (0011, 'Maria', 'Melko', 'Mariivna', 'Odessa', '2019-09-15', 7);
insert into clients value (0100, 'Sergei', 'Yakovlev', 'Vladimirovich', 'New-York', '2019-11-01', 11);
insert into clients value (0101, 'Maxim', 'Burluca', 'Maximovich', 'Afina', '2019-03-11', 12);
insert into clients value (0110, 'Bogdan', 'Pyasetskiy', 'Olegovich', 'Madrid', '2018-01-01', 4);

alter table staff
    add IDstaff int auto_increment first;

alter table staff modify Surname varchar(35) not null after Day;

create unique index staff_IDstaff_uindex
    on staff (IDstaff);

alter table staff drop primary key;

alter table staff
    add constraint staff_pk
        primary key (IDstaff);

insert into staff value (null, 'Anna', 'Picher', 'Olegovna', 4, 1);
insert into staff value (null, 'Sofia', 'Milkov', 'Petren', 2, 1);
insert into staff value (null, 'Sonya', 'Exet', 'Ivanovna', 1, 4);
insert into staff value (null, 'Petya', 'Ivanov', 'Ivnovicha', 4, 2);
insert into staff value (null, 'Pavel', 'Kuznetsov', 'Olegovich', 4, 4);

create table storage
(
    ID int auto_increment,
    PassportID int not null,
    CheckInDate date not null,
    CheckOutDate date null,
    DaysCount int not null,
    constraint storage_pk
        primary key (ID)
);

alter table storage
    add MoneyAmount int not null;


alter table storage modify CheckInDate date not null after MoneyAmount;

alter table storage
    add Room int null after PassportID;

drop table storage;

create table storage
(
    ID int auto_increment,
    PassportID int not null,
    Room int not null,
    CheckInDate date not null,
    CheckOutDate date null,
    DaysCount int not null,
    MoneyAmount int not null,
    constraint storage_pk
        primary key (ID),
    constraint fk1 foreign key (PassportID) references clients(PassportID),
    constraint fk2 foreign key (Room) references  hotel_rooms(room)

);

