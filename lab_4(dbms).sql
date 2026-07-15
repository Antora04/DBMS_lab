CREATE DATABASE North_wind;
 USE North_wind;

-- 2. DDL: Create Tables
CREATE TABLE Category (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50),
    Description VARCHAR(100)
);

CREATE TABLE Supplier (
    SupplierID INT PRIMARY KEY,
    CompanyName VARCHAR(50),
    ContactName VARCHAR(50),
    City VARCHAR(50),
    Country VARCHAR(50)
);

CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    SupplierID INT,
    CategoryID INT,
    Unit VARCHAR(50),
    Price NUMERIC(10,2),
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID),
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    LastName VARCHAR(20),
    FirstName VARCHAR(20),
    Title VARCHAR(30),
    City VARCHAR(30),
    Country VARCHAR(30)
);

CREATE TABLE Customer (
    CustomerID VARCHAR(5) PRIMARY KEY,
    CompanyName VARCHAR(50),
    ContactName VARCHAR(50),
    City VARCHAR(50),
    Country VARCHAR(50)
); 

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID VARCHAR(5),
    EmployeeID INT,
    OrderDate DATE,
    ShipCity VARCHAR(50),
    ShipCountry VARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);
 
-- The "Junction" Table (Many-to-Many link between Order and Product)
CREATE TABLE OrderDetail (
    OrderID INT,
    ProductID INT,
    UnitPrice NUMERIC(10,2),
    Quantity INT,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- 3. DML: Insert Data

-- Categories
INSERT INTO Category VALUES (1, 'Beverages', 'Soft drinks, coffees, teas, beers');
INSERT INTO Category VALUES (2, 'Condiments', 'Sweet and savory sauces, relishes');
INSERT INTO Category VALUES (3, 'Seafood', 'Seaweed and fish');


-- Suppliers
INSERT INTO Supplier VALUES (1, 'Exotic Liquids', 'Charlotte Cooper', 'London', 'UK');
INSERT INTO Supplier VALUES (2, 'New Orleans Cajun Delights', 'Shelley Burke', 'New Orleans', 'USA');
INSERT INTO Supplier VALUES (3, 'Tokyo Traders', 'Yoshi Nagase', 'Tokyo', 'Japan');

-- Products
INSERT INTO Product VALUES (1, 'Chais', 1, 1, '10 boxes x 20 bags', 18.00); -- Beverage, Exotic Liquids
INSERT INTO Product VALUES (2, 'Chang', 1, 1, '24 - 12 oz bottles', 19.00); -- Beverage, Exotic Liquids
INSERT INTO Product VALUES (3, 'Aniseed Syrup', 1, 2, '12 - 550 ml bottles', 10.00); -- Condiment
INSERT INTO Product VALUES (4, 'Ikura', 3, 3, '12 - 200 ml jars', 31.00); -- Seafood, Tokyo Traders
-- Employees
INSERT INTO Employee VALUES (1, 'Davolio', 'Nancy', 'Sales Rep', 'Seattle', 'USA');
INSERT INTO Employee VALUES (2, 'Fuller', 'Andrew', 'Vice President', 'Tacoma', 'USA');
INSERT INTO Employee VALUES (3, 'Leverling', 'Janet', 'Sales Rep', 'Kirkland', 'USA');

 

-- Customers
INSERT INTO Customer VALUES ('ALFKI', 'Alfreds Futterkiste', 'Maria Anders', 'Berlin', 'Germany');
INSERT INTO Customer VALUES ('ANATR', 'Ana Trujillo Emparedados', 'Ana Trujillo', 'Mexico D.F.', 'Mexico');
INSERT INTO Customer VALUES ('AROUT', 'Around the Horn', 'Thomas Hardy', 'London', 'UK');

 

-- Orders
INSERT INTO Orders VALUES (10248, 'ALFKI', 1, '2025-07-04', 'Berlin', 'Germany'); -- Nancy sold to Alfreds
INSERT INTO Orders VALUES (10249, 'ANATR', 1, '2025-07-05', 'Mexico D.F.', 'Mexico'); -- Nancy sold to Ana
INSERT INTO Orders VALUES (10250, 'AROUT', 2, '2025-07-08', 'London', 'UK'); -- Andrew sold to Around the Horn

 

-- Order Details (What was actually bought?)
INSERT INTO OrderDetail VALUES (10248, 1, 18.00, 10); -- 10 units of Chais
INSERT INTO OrderDetail VALUES (10248, 3, 10.00, 5);  -- 5 units of Syrup
INSERT INTO OrderDetail VALUES (10249, 4, 31.00, 2);  -- 2 units of Ikura
INSERT INTO OrderDetail VALUES (10250, 2, 19.00, 10); -- 10 units of Chang

   --- section A Begginner---
 select ProductName,Unit,Price
 from product;
 
 select categoryID,categoryName
 from category
 where description LIKE '%Soft drinks%';
 
 select ProductName
 from product
 where price<15.00;
 
 select FirstName,LastName,City
 from employee
 where title='Sales Rep';
 
  --- Intermediate----
  select ProductName,Price
  from product
  where SupplierID AND price>18.00;
  
select CompanyName
from customer
where country='Germany' OR country='Mexico';

select CompanyName,country
from customer 
where country<>'UK';

select OrderID,CustomerID
from orders
where OrderDate='2025-07-05';

 ---- Advanced---
select p.ProductName,c.CategoryName
from product p,category c
where p.CategoryID=c.CategoryID;

select p.ProductName,s.City
from product p,supplier s
where p.SupplierID=s.SupplierID;

select o.OrderID,e.LastName
from orders o,employee e
where o.EmployeeID=e.EmployeeID;

select p.ProductName,c.CategoryName
from product p,category c
where p.CategoryID=c.CategoryID
AND c.CategoryName<>'Seafood';





