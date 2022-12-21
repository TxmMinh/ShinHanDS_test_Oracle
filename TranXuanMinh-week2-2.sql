--Bai 1
--Cau 1

drop table OrderLine;
drop table Orders;
drop table FoodItems;
drop table Prices;
drop table Members;
drop table Prices;
drop table position;
drop table campus;

create table CAMPUS (
    CampusID varchar2(5) primary key,
    CampusName varchar2(100),
    Street varchar2(100),
    City varchar2(100),
    State varchar2(100),
    Zip varchar2(100),
    Phone varchar2(100),
    CampusDiscount decimal(2,2)    
);

create table POSITION (
    PositionID varchar2(5) primary key,
    POSITION varchar2(100),
    YearlyMembershipFee DECIMAL(7,2)
);

create table MEMBERS (
    MemberID varchar2(5) primary key,
    LastName varchar2(100),
    FirstName varchar2(100),
    CampusAddress varchar2(100),
    CampusPhone varchar2(100),
    CampusID varchar2(5),
    PositionID varchar2(5),  
    ContractDuration INTEGER,
    CONSTRAINT FK_MembersPosition FOREIGN KEY (PositionID) 
    REFERENCES POSITION(PositionID)
);

create table PRICES (
    FoodItemTypeID number(20) primary key,
    MealType varchar2(100),
    MealPrice DECIMAL(7,2)
);

create table FoodItems (
    FoodItemID varchar2(5) primary key,
    FoodItemName varchar2(100),
    FoodItemTypeID number(20),
    CONSTRAINT FK_FoodItemsPrices FOREIGN KEY (FoodItemTypeID) 
    REFERENCES PRICES(FoodItemTypeID)  
);

create table Orders (
    OrderID varchar2(5) primary key,
    MemberID varchar2(5),
    OrderDate varchar2(25),
    CONSTRAINT FK_OrdersMembers FOREIGN KEY (MemberID) 
    REFERENCES MEMBERS(MemberID)  
);

create table OrderLine (
    OrderID varchar2(5),
    FoodItemID varchar2(5),
    Quantity INTEGER,
    Primary key (OrderID, FoodItemID),
    CONSTRAINT FK_OrderLineOrders FOREIGN KEY (OrderID) 
    REFERENCES Orders(OrderID),
    CONSTRAINT FK_OrderLineFoodItems FOREIGN KEY (FoodItemID) 
    REFERENCES FoodItems(FoodItemID)
);

--Cau 2
drop sequence Prices_FoodItemTypeID_SEQ;
create  sequence Prices_FoodItemTypeID_SEQ start with 1 increment by 1;

--Bai 2
--Cau 1
-- CAMPUS
insert into CAMPUS values ('1','IUPUI','425 University Blvd.','Indianapolis', 'IN','46202', '317-274-4591',.08);
insert into CAMPUS values ('2','Indiana University','107 S. Indiana Ave.','Bloomington', 'IN','47405', '812-855-4848',.07);
insert into CAMPUS values ('3','Purdue University','475 Stadium Mall Drive','West Lafayette', 'IN','47907', '765-494-1776',.06);

-- POSITION
insert into POSITION values ('1','Lecturer', 1050.50);
insert into POSITION values ('2','Associate Professor', 900.50);
insert into POSITION values ('3','Assistant Professor', 875.50);
insert into POSITION values ('4','Professor', 700.75);
insert into POSITION values ('5','Full Professor', 500.50);

-- MEMBERS
insert into members values ('1','Ellen','Monk','009 Purnell', '812-123-1234', '2', '5', 12);
insert into members values ('2','Joe','Brady','008 Statford Hall', '765-234-2345', '3', '2', 10);
insert into members values ('3','Dave','Davidson','007 Purnell', '812-345-3456', '2', '3', 10);
insert into members values ('4','Sebastian','Cole','210 Rutherford Hall', '765-234-2345', '3', '5', 10);
insert into members values ('5','Michael','Doo','66C Peobody', '812-548-8956', '2', '1', 10);
insert into members values ('6','Jerome','Clark','SL 220', '317-274-9766', '1', '1', 12);
insert into members values ('7','Bob','House','ET 329', '317-278-9098', '1', '4', 10);
insert into members values ('8','Bridget','Stanley','SI 234', '317-274-5678', '1', '1', 12);
insert into members values ('9','Bradley','Wilson','334 Statford Hall', '765-258-2567', '3', '2', 10);

-- Prices
INSERT INTO Prices VALUES (Prices_FoodItemTypeID_SEQ.NEXTVAL, 'Beer/Wine', 5.50);
INSERT INTO Prices VALUES (Prices_FoodItemTypeID_SEQ.NEXTVAL, 'Dessert', 2.75);
INSERT INTO Prices VALUES (Prices_FoodItemTypeID_SEQ.NEXTVAL, 'Dinner', 15.50);
INSERT INTO Prices VALUES (Prices_FoodItemTypeID_SEQ.NEXTVAL, 'Soft Drink', 2.50);
INSERT INTO Prices VALUES (Prices_FoodItemTypeID_SEQ.NEXTVAL, 'Lunch', 7.25);

-- FoodItems
INSERT INTO FoodItems VALUES ('10001', 'Lager', '1');
INSERT INTO FoodItems VALUES ('10002', 'Red Wine', '1');
INSERT INTO FoodItems VALUES ('10003', 'White Wine', '1');
INSERT INTO FoodItems VALUES ('10004', 'Coke', '4');
INSERT INTO FoodItems VALUES ('10005', 'Coffee', '4');
INSERT INTO FoodItems VALUES ('10006', 'Chicken a la King', '3');
INSERT INTO FoodItems VALUES ('10007', 'Rib Steak', '3');
INSERT INTO FoodItems VALUES ('10008', 'Fish and Chips', '3');
INSERT INTO FoodItems VALUES ('10009', 'Veggie Delight', '3');
INSERT INTO FoodItems VALUES ('10010', 'Chocolate Mousse', '2');
INSERT INTO FoodItems VALUES ('10011', 'Carrot Cake', '2');
INSERT INTO FoodItems VALUES ('10012', 'Fruit Cup', '2');
INSERT INTO FoodItems VALUES ('10013', 'Fish and Chips', '5');
INSERT INTO FoodItems VALUES ('10014', 'Angus and Chips', '5');
INSERT INTO FoodItems VALUES ('10015', 'Cobb Salad', '5');

-- Orders
INSERT INTO Orders VALUES ( '1', '9', 'March 5, 2005' );
INSERT INTO Orders VALUES ( '2', '8', 'March 5, 2005' );
INSERT INTO Orders VALUES ( '3', '7', 'March 5, 2005' );
INSERT INTO Orders VALUES ( '4', '6', 'March 7, 2005' );
INSERT INTO Orders VALUES ( '5', '5', 'March 7, 2005' );
INSERT INTO Orders VALUES ( '6', '4', 'March 10, 2005' );
INSERT INTO Orders VALUES ( '7', '3', 'March 11, 2005' );
INSERT INTO Orders VALUES ( '8', '2', 'March 12, 2005' );
INSERT INTO Orders VALUES ( '9', '1', 'March 13, 2005' );

-- OrderLine
INSERT INTO OrderLine VALUES ( '1', '10001', 1 );
INSERT INTO OrderLine VALUES ( '1', '10006', 1 );
INSERT INTO OrderLine VALUES ( '1', '10012', 1 );
INSERT INTO OrderLine VALUES ( '2', '10004', 2 );
INSERT INTO OrderLine VALUES ( '2', '10013', 1 ); 
INSERT INTO OrderLine VALUES ( '2', '10014', 1 );
INSERT INTO OrderLine VALUES ( '3', '10005', 1 );
INSERT INTO OrderLine VALUES ( '3', '10011', 1 );
INSERT INTO OrderLine VALUES ( '4', '10005', 2 );
INSERT INTO OrderLine VALUES ( '4', '10004', 2 );
INSERT INTO OrderLine VALUES ( '4', '10006', 1 );
INSERT INTO OrderLine VALUES ( '4', '10007', 1 );
INSERT INTO OrderLine VALUES ( '4', '10010', 2 );
INSERT INTO OrderLine VALUES ( '5', '10003', 1 );
INSERT INTO OrderLine VALUES ( '6', '10002', 2 );
INSERT INTO OrderLine VALUES ( '7', '10005', 2 );
INSERT INTO OrderLine VALUES ( '8', '10005', 1 );
INSERT INTO OrderLine VALUES ( '8', '10011', 1 );
INSERT INTO OrderLine VALUES ( '9', '10001', 1 );

-- Bai 3
-- Cau 1
select constraint_name, constraint_type, table_name
from user_constraints
where table_name = 'CAMPUS';

select constraint_name, constraint_type, table_name
from user_constraints
where table_name = 'POSITION';

select constraint_name, constraint_type, table_name
from user_constraints
where table_name = 'MEMBERS';

select constraint_name, constraint_type, table_name
from user_constraints
where table_name = 'PRICES';

select constraint_name, constraint_type, table_name
from user_constraints
where table_name = 'FOODITEMS';

select constraint_name, constraint_type, table_name
from user_constraints
where table_name = 'ORDERS';

select constraint_name, constraint_type, table_name
from user_constraints
where table_name = 'ORDERLINE';

--Cau 2
SELECT owner,table_name FROM all_tables;
--Cach 2: SELECT table_name FROM user_tables;

-- Cau 3
select sequence_name from user_sequences;

-- Cau 4
select FirstName, LastName, Position, CampusName,  TO_CHAR(YearlyMembershipFee / 12, 'fm99D00') Monthly_Dues
from MEMBERS
    JOIN POSITION USING(PositionID)
    JOIN CAMPUS USING(CampusID)
order by 4 desc, 2 asc;













