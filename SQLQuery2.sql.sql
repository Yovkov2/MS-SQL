--14 Car Rental Database
CREATE DATABASE CarRental

USE CarRental
GO

CREATE TABLE Categories
(
 Id INT PRIMARY KEY IDENTITY,
 CategoryName VARCHAR(50) NOT NULL,
DailyRate DECIMAL(10, 2) NOT NULL,
    WeeklyRate DECIMAL(10, 2) NOT NULL,
    MonthlyRate DECIMAL(10, 2) NOT NULL,
    WeekendRate DECIMAL(10, 2) NOT NULL
)
INSERT INTO Categories (CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate)
VALUES
('Economy', 30.00, 180.00, 720.00, 50.00),
('SUV', 50.00, 300.00, 1200.00, 70.00),
('Luxury', 100.00, 600.00, 2400.00, 150.00);

SELECT * FROM Categories

CREATE TABLE Cars
(
 Id INT PRIMARY KEY IDENTITY,
 PlateNumber VARCHAR(30) NOT NULL UNIQUE,
 Manufacturer VARCHAR(30) NOT NULL,
 Model VARCHAR(15) NOT NULL,
 CarYear INT NOT NULL,
 CategoryId INT NOT NULL,
 Doors INT NOT NULL,
 Picture VARBINARY(MAX),
 Condition VARCHAR(50)NOT NULL,
 Available BIT NOT NULL,
 FOREIGN KEY (CategoryId) REFERENCES Categories(Id)
)
INSERT INTO Cars (PlateNumber, Manufacturer, Model, CarYear, CategoryId, Doors, Picture, Condition, Available)
VALUES
('ABC123', 'Toyota', 'Corolla', 2018, 1, 4, NULL, 'Good', 1),
('DEF456', 'Ford', 'Explorer', 2020, 2, 4, NULL, 'Excellent', 1),
('GHI789', 'BMW', '7 Series', 2021, 3, 4, NULL, 'New', 1);

SELECT * FROM Cars

CREATE TABLE Employees 
(
 Id INT PRIMARY KEY IDENTITY,
 FirstName VARCHAR(15) NOT NULL,
 LastName VARCHAR(15) NOT NULL,
 Title VARCHAR(15) NOT NULL,
 Notes VARCHAR(50)
)
INSERT INTO Employees (FirstName, LastName, Title, Notes)
VALUES
('John', 'Doe', 'Manager', 'Experienced in managing rental operations.'),
('Jane', 'Smith', 'Clerk', 'Specializes in customer service.'),
('Emily', 'Johnson', 'Mechanic', 'Expert in car maintenance and repair.');
CREATE TABLE Customers
(
 Id INT PRIMARY KEY IDENTITY,
 DriverLicenceNumber VARCHAR(15) UNIQUE,
 FullName VARCHAR(15) NOT NULL,
 [Address] VARCHAR(50),
 City VARCHAR(15),
 ZIPCode VARCHAR(10),
 Notes VARCHAR (50)
)
INSERT INTO Customers (DriverLicenceNumber, FullName, Address, City, ZIPCode, Notes)
VALUES
('D1234567', 'Michael Brown', '123 Main St', 'Springfield', '11111', 'Regular customer.'),
('E2345678', 'Sarah Davis', '456 Elm St', 'Riverdale', '22222', 'Prefers luxury cars.'),
('F3456789', 'James Wilson', '789 Oak St', 'Metropolis', '33333', 'First-time renter.');
CREATE TABLE RentalOrders
(
 Id INT PRIMARY KEY IDENTITY,
 EmployeeId INT NOT NULL,
    CustomerId INT NOT NULL,
    CarId INT NOT NULL,
    TankLevel DECIMAL(5, 2) NOT NULL,
    KilometrageStart INT NOT NULL,
    KilometrageEnd INT NULL,
    TotalKilometrage INT,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    TotalDays INT ,
    RateApplied DECIMAL(10, 2) NOT NULL,
    TaxRate DECIMAL(5, 2) NOT NULL,
    OrderStatus VARCHAR(50) NOT NULL,
    Notes TEXT NULL,
    FOREIGN KEY (EmployeeId) REFERENCES Employees(Id),
    FOREIGN KEY (CustomerId) REFERENCES Customers(Id),
    FOREIGN KEY (CarId) REFERENCES Cars(Id)
)
INSERT INTO RentalOrders (EmployeeId, CustomerId, CarId, TankLevel, KilometrageStart, KilometrageEnd, StartDate, EndDate, RateApplied, TaxRate, OrderStatus, Notes)
VALUES
(1, 1, 1, 100.0, 10000, 10500, '2024-05-01', '2024-05-10', 30.00, 0.15, 'Completed', 'No issues.'),
(2, 2, 2, 75.0, 20000, NULL, '2024-05-15', '2024-05-20', 50.00, 0.15, 'Ongoing', 'Customer extended the rental.'),
(3, 3, 3, 90.0, 30000, 30500, '2024-05-05', '2024-05-12', 100.00, 0.15, 'Completed', 'No issues.');

-- 15. Hotel Database
CREATE DATABASE Hotel

USE Hotel
GO
CREATE TABLE Employees
(
 Id INT PRIMARY KEY,
 FirstName VARCHAR(15)NOT NULL,
 LastName VARCHAR(15)NOT NULL,
 Title VARCHAR(15)NOT NULL,
 Notes VARCHAR(50)
)
CREATE TABLE Customers
(
  AccountNumber INT PRIMARY KEY,
  FirstName VARCHAR(15)NOT NULL,
  LastName VARCHAR(15)NOT NULL,
  PhoneNumber VARCHAR(15)NOT NULL,
  EmergencyName VARCHAR(15),
  EmergencyNumber VARCHAR(15),
  Notes VARCHAR(50),
)
CREATE TABLE RoomStatus
(
 RoomStatus VARCHAR(20) PRIMARY KEY,
 Notes VARCHAR(50)
)
CREATE TABLE RoomTypes
(
 RoomType VARCHAR(20) PRIMARY KEY,
 Notes VARCHAR(50)
)
CREATE TABLE BedTypes
(
 BedType VARCHAR(20) PRIMARY KEY,
 Notes VARCHAR(50)
)
CREATE TABLE Rooms
(
 RoomNumber INT PRIMARY KEY,
  RoomType VARCHAR(20) NOT NULL,
    BedType VARCHAR(20) NOT NULL,
	Rate DECIMAL(10, 2) NOT NULL,
    RoomStatus VARCHAR(20) NOT NULL,
    Notes VARCHAR(50),
	FOREIGN KEY (RoomType) REFERENCES RoomTypes(RoomType),
    FOREIGN KEY (BedType) REFERENCES BedTypes(BedType),
    FOREIGN KEY (RoomStatus) REFERENCES RoomStatus(RoomStatus)
)
CREATE TABLE Payments
(
 Id INT PRIMARY KEY IDENTITY(1,1),
    EmployeeId INT NOT NULL,
    PaymentDate DATE NOT NULL,
    AccountNumber INT NOT NULL,
    FirstDateOccupied DATE NOT NULL,
    LastDateOccupied DATE NOT NULL,
    TotalDays INT,
    AmountCharged DECIMAL(10, 2) NOT NULL,
    TaxRate DECIMAL(5, 2) NOT NULL,
    TaxAmount AS (AmountCharged * TaxRate / 100) PERSISTED,
    PaymentTotal AS (AmountCharged + TaxAmount) PERSISTED,
    Notes TEXT NULL,
    FOREIGN KEY (EmployeeId) REFERENCES Employees(Id),
    FOREIGN KEY (AccountNumber) REFERENCES Customers(AccountNumber)
)
CREATE TABLE Occupancies (
    Id INT PRIMARY KEY IDENTITY(1,1),
    EmployeeId INT NOT NULL,
    DateOccupied DATE NOT NULL,
    AccountNumber INT NOT NULL,
    RoomNumber INT NOT NULL,
    RateApplied DECIMAL(10, 2) NOT NULL,
    PhoneCharge DECIMAL(10, 2) NOT NULL,
    Notes TEXT NULL,
    FOREIGN KEY (EmployeeId) REFERENCES Employees(Id),
    FOREIGN KEY (AccountNumber) REFERENCES Customers(AccountNumber),
    FOREIGN KEY (RoomNumber) REFERENCES Rooms(RoomNumber)
);
UPDATE Payments
SET TaxRate = TaxRate - 3;
GO
TRUNCATE TABLE Occupancies
INSERT INTO Employees (FirstName, LastName, Title, Notes)
VALUES
('John', 'Doe', 'Manager', 'Experienced in hotel management.'),
('Jane', 'Smith', 'Receptionist', 'Specializes in customer service.'),
('Emily', 'Johnson', 'Cleaner', 'Responsible for room cleanliness.');

INSERT INTO Customers (FirstName, LastName, PhoneNumber, EmergencyName, EmergencyNumber, Notes)
VALUES
('Michael', 'Brown', '555-1234', 'Sarah Brown', '555-5678', 'Regular customer.'),
('Sarah', 'Davis', '555-2345', 'John Davis', '555-6789', 'Prefers quiet rooms.'),
('James', 'Wilson', '555-3456', 'Karen Wilson', '555-7890', 'First-time guest.');

INSERT INTO RoomStatus (RoomStatus, Notes)
VALUES
('Available', 'Room is available for booking.'),
('Occupied', 'Room is currently occupied.'),
('Maintenance', 'Room is under maintenance.');

INSERT INTO RoomTypes (RoomType, Notes)
VALUES
('Single', 'Single room with one bed.'),
('Double', 'Double room with two beds.'),
('Suite', 'Suite with multiple rooms.');

INSERT INTO BedTypes (BedType, Notes)
VALUES
('Single', 'Single bed.'),
('Double', 'Double bed.'),
('Queen', 'Queen size bed.');

INSERT INTO Rooms (RoomNumber, RoomType, BedType, Rate, RoomStatus, Notes)
VALUES
(101, 'Single', 'Single', 50.00, 'Available', 'First floor room with garden view.'),
(102, 'Double', 'Double', 80.00, 'Occupied', 'Second floor room with city view.'),
(201, 'Suite', 'Queen', 150.00, 'Available', 'Luxury suite with balcony.');

INSERT INTO Payments (EmployeeId, PaymentDate, AccountNumber, FirstDateOccupied, LastDateOccupied, AmountCharged, TaxRate, Notes)
VALUES
(1, '2024-05-01', 1, '2024-05-01', '2024-05-05', 200.00, 10.00, 'Paid in full.'),
(2, '2024-05-10', 2, '2024-05-10', '2024-05-12', 160.00, 10.00, 'Paid in full.'),
(3, '2024-05-15', 3, '2024-05-15', '2024-05-20', 300.00, 10.00, 'Pending payment.');

INSERT INTO Occupancies (EmployeeId, DateOccupied, AccountNumber, RoomNumber, RateApplied, PhoneCharge, Notes)
VALUES
(1, '2024-05-01', 1, 101, 50.00, 5.00, 'Customer requested wake-up call.'),
(2, '2024-05-10', 2, 102, 80.00, 10.00, 'Customer requested late check-out.'),
(3, '2024-05-15', 3, 201, 150.00, 15.00, 'Customer used room service.');

--16. Create SoftUni Database
CREATE DATABASE SoftUni

USE SoftUni
GO
CREATE TABLE Towns
( 
 Id INT PRIMARY KEY IDENTITY,
 [Name] VARCHAR(15) NOT NULL,
)
CREATE TABLE Addresses
(
 Id INT PRIMARY KEY IDENTITY,
 AddressText VARCHAR(50) NOT NULL,
 TownId INT,
 FOREIGN KEY (TownId) REFERENCES Towns(Id)
)
CREATE TABLE Departments
( 
 Id INT PRIMARY KEY IDENTITY,
 [Name] VARCHAR(15) NOT NULL,
)
DROP TABLE Employees
CREATE TABLE Employees
( 
 Id INT PRIMARY KEY IDENTITY,
 FirstName VARCHAR(15) NOT NULL,
 MiddleName VARCHAR(15),
 LastName VARCHAR(15) NOT NULL,
 JobTitle VARCHAR(55),
 DepartmentId INT,
 HireDate DATE,
 Salary DECIMAL (10,2),
 AddressId INT,
 FOREIGN KEY (DepartmentId) REFERENCES Departments(Id),
 FOREIGN KEY (AddressId) REFERENCES Addresses(Id)
)
INSERT INTO Towns (Name)
VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas');
INSERT INTO Employees (FirstName, LastName, JobTitle, HireDate, Salary)
VALUES
('John', 'Doe', '.NET Developer', '2013-01-02', 3500.00),
('Jane', 'Smith', 'Senior Engineer', '2004-02-03', 4000.00),
('Emily', 'Johnson', 'Intern', '2016-08-28', 525.25),
('Michael', 'Brown', 'CEO', '2007-12-09', 3000.00),
('Sarah', 'Davis', 'Intern', '2016-08-28', 599.88);
GO

SELECT * FROM Towns
ORDER BY NAME;

SELECT * FROM Departments
ORDER BY NAME;

SELECT * FROM Employees
ORDER BY SALARY;

SELECT [Name] FROM Towns
SELECT [Name] FROM Departments

UPDATE Employees
SET Salary = Salary * 1.1
SELECT Salary FROM Employees