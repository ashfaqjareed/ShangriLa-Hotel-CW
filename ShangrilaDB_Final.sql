CREATE DATABASE ShangrilaDB;
GO
USE ShangrilaDB;
GO
CREATE TABLE Guest
(
    GuestID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NULL,
    Phone VARCHAR(20) NULL,
    NIC VARCHAR(20) NULL,
    Address VARCHAR(255) NULL,
    Nationality VARCHAR(50) NULL
);
GO

CREATE TABLE RoomType
(
    RoomTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName VARCHAR(50) NOT NULL,
    Description VARCHAR(MAX) NULL,
    BasePrice DECIMAL(10,2) NOT NULL,
    MaxOccupancy INT NOT NULL
);
GO
CREATE TABLE Room
(
    RoomID INT IDENTITY(1,1) PRIMARY KEY,
    RoomNumber VARCHAR(10) NOT NULL,
    Floor INT NULL,
    Status VARCHAR(20) NOT NULL,
    RoomTypeID INT NOT NULL,
CONSTRAINT FK_Room_RoomType FOREIGN KEY (RoomTypeID) REFERENCES RoomType(RoomTypeID)
);
GO
CREATE TABLE Department
(
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL,
    ManagerID INT NULL
);
GO
CREATE TABLE Staff
(
    StaffID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NULL,
    Phone VARCHAR(20) NULL,
    Role VARCHAR(50) NULL,
    HireDate DATE NULL,
    DepartmentID INT NULL,
CONSTRAINT FK_Staff_Department FOREIGN KEY (DepartmentID)REFERENCES Department(DepartmentID)
);
GO
ALTER TABLE Department
ADD CONSTRAINT FK_Department_Manager
    FOREIGN KEY (ManagerID)
    REFERENCES Staff(StaffID);

CREATE TABLE Service
(
    ServiceID INT IDENTITY(1,1) PRIMARY KEY,
    ServiceName VARCHAR(100) NOT NULL,
    Description VARCHAR(MAX) NULL,
    Price DECIMAL(10,2) NOT NULL
);
GO
CREATE TABLE Reservation
(
    ReservationID INT IDENTITY(1,1) PRIMARY KEY,
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    NumGuests INT NOT NULL,
    Status VARCHAR(20) NOT NULL,

    GuestID INT NOT NULL,
    RoomID INT NOT NULL,
    ServiceID INT NULL,
    StaffID INT NULL,
CONSTRAINT FK_Reservation_Guest FOREIGN KEY (GuestID) REFERENCES Guest(GuestID),

CONSTRAINT FK_Reservation_Room FOREIGN KEY (RoomID) REFERENCES Room(RoomID),

CONSTRAINT FK_Reservation_Service FOREIGN KEY (ServiceID) REFERENCES Service(ServiceID),

CONSTRAINT FK_Reservation_Staff FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

CREATE TABLE Payment
(
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentDate DATETIME NOT NULL DEFAULT GETDATE(),
    PaymentMethod VARCHAR(50) NOT NULL,
    Status VARCHAR(20) NOT NULL,
    ReservationID INT NOT NULL,
CONSTRAINT FK_Payment_Reservation FOREIGN KEY (ReservationID) REFERENCES Reservation(ReservationID)
);

CREATE TABLE ServiceOrder
(
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    OrderDate DATETIME NOT NULL DEFAULT GETDATE(),
    Quantity INT NOT NULL DEFAULT 1,
    TotalCost DECIMAL(10,2) NOT NULL,

    GuestID INT NOT NULL,
    ServiceID INT NOT NULL,
CONSTRAINT FK_ServiceOrder_Guest FOREIGN KEY (GuestID) REFERENCES Guest(GuestID),

CONSTRAINT FK_ServiceOrder_Service FOREIGN KEY (ServiceID)REFERENCES Service(ServiceID)
);

CREATE TABLE Supplier
(
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    CompanyName VARCHAR(100) NOT NULL,
    ContactPerson VARCHAR(100) NULL,
    Email VARCHAR(100) NULL,
    Phone VARCHAR(20) NULL,
    ProductCategory VARCHAR(50) NULL
);

INSERT INTO Guest
(FirstName, LastName, Email, Phone, NIC, Address, Nationality)VALUES
('John', 'Perera', 'john@gmail.com', '0771234567','199512345678', 'Colombo', 'Sri Lankan'),
('Sarah', 'Fernando', 'sarah@gmail.com', '0712345678','199645678901', 'Kandy', 'Sri Lankan'),
('David', 'Smith', 'david@gmail.com', '0755555555','N1234567', 'London', 'British');

INSERT INTO RoomType
(TypeName, Description, BasePrice, MaxOccupancy)VALUES
('Deluxe','Deluxe room with city view',25000.00,2),
('Suite','Luxury suite with separate living area',50000.00,4),
('Family Room','Large room suitable for families',40000.00,5);

INSERT INTO Room
(RoomNumber, Floor, Status, RoomTypeID)VALUES
('101', 1, 'Available', 1),
('102', 1, 'Occupied', 1),
('201', 2, 'Available', 2),
('301', 3, 'Available', 3);

INSERT INTO Department
(DepartmentName, ManagerID)VALUES
('Housekeeping', NULL),
('Food and Beverage', NULL),
('Reception', NULL);

INSERT INTO Staff
(FirstName, LastName, Email, Phone, Role, HireDate, DepartmentID)VALUES
('Kasun', 'Fernando','kasun@gmail.com','0771111111','Manager','2024-01-15',1),
('Nimal', 'Perera','nimal@gmail.com','0772222222','Receptionist','2025-03-10',3),
('Amal', 'Silva','amal@gmail.com','0773333333','Housekeeper','2025-05-20',1);

UPDATE Department
SET ManagerID = 1
WHERE DepartmentID = 1;

INSERT INTO Service
(ServiceName, Description, Price)
VALUES
('Airport Pickup','Airport transportation service',10000.00),
('Laundry','Laundry and ironing service',5000.00),
('Room Service','Food and beverage delivered to room',3000.00);

INSERT INTO Reservation
(CheckInDate,CheckOutDate,NumGuests,Status,GuestID,RoomID,ServiceID,StaffID)VALUES
('2026-10-10','2026-10-15',2,'Confirmed',1,1,1,2),
('2026-10-20','2026-10-23',2,'Confirmed',2,3,NULL,2);

INSERT INTO Payment
(Amount,PaymentMethod,Status,ReservationID)VALUES
(125000.00,'Credit Card','Paid',1),
(150000.00,'Cash','Paid',2);

INSERT INTO ServiceOrder
(Quantity,TotalCost,GuestID,ServiceID)VALUES
(2, 10000.00, 1, 2),
(1, 10000.00, 2, 1);

INSERT INTO Supplier
(CompanyName,ContactPerson,Email,Phone,ProductCategory)
VALUES
('ABC Supplies','Kamal Silva','abc@gmail.com','0774444444','Cleaning'),
('Fresh Foods Ltd','Ruwan Perera','freshfoods@gmail.com','0715555555','Food');

SELECT *
FROM Guest;


SELECT *
FROM RoomType;


SELECT *
FROM Room;


SELECT *
FROM Department;


SELECT *
FROM Staff;


SELECT *
FROM Service;


SELECT *
FROM Reservation;


SELECT *
FROM Payment;


SELECT *
FROM ServiceOrder;


SELECT *
FROM Supplier;


SELECT
    R.ReservationID,
    G.FirstName + ' ' + G.LastName AS GuestName,
    Room.RoomNumber,
    R.CheckInDate,
    R.CheckOutDate,
    R.NumGuests,
    R.Status
FROM Reservation R
INNER JOIN Guest G
    ON R.GuestID = G.GuestID
INNER JOIN Room
    ON R.RoomID = Room.RoomID;


SELECT
    R.RoomNumber,
    R.Floor,
    R.Status,
    RT.TypeName,
    RT.BasePrice,
    RT.MaxOccupancy
FROM Room R
INNER JOIN RoomType RT
    ON R.RoomTypeID = RT.RoomTypeID;


SELECT
    S.StaffID,
    S.FirstName + ' ' + S.LastName AS StaffName,
    S.Role,
    D.DepartmentName
FROM Staff S
INNER JOIN Department D
    ON S.DepartmentID = D.DepartmentID;


SELECT
    R.ReservationID,
    G.FirstName + ' ' + G.LastName AS GuestName,
    S.FirstName + ' ' + S.LastName AS StaffName,
    R.CheckInDate,
    R.CheckOutDate,
    R.Status
FROM Reservation R
INNER JOIN Guest G
    ON R.GuestID = G.GuestID
LEFT JOIN Staff S
    ON R.StaffID = S.StaffID;


SELECT
    R.ReservationID,
    G.FirstName + ' ' + G.LastName AS GuestName,
    P.Amount,
    P.PaymentMethod,
    P.Status AS PaymentStatus
FROM Reservation R
INNER JOIN Guest G
    ON R.GuestID = G.GuestID
INNER JOIN Payment P
    ON R.ReservationID = P.ReservationID;


SELECT
    R.RoomNumber,
    RT.TypeName,
    RT.BasePrice
FROM Room R
INNER JOIN RoomType RT
    ON R.RoomTypeID = RT.RoomTypeID
WHERE R.Status = 'Available';


SELECT *
FROM Guest
WHERE Nationality = 'Sri Lankan';


SELECT
    R.RoomNumber,
    RT.TypeName,
    RT.BasePrice
FROM Room R
INNER JOIN RoomType RT
    ON R.RoomTypeID = RT.RoomTypeID
WHERE RT.BasePrice < 30000;


SELECT *
FROM Reservation
WHERE CheckInDate >= '2026-10-01'
  AND CheckInDate <= '2026-10-31';


SELECT
    S.FirstName,
    S.LastName,
    S.Role
FROM Staff S
INNER JOIN Department D
    ON S.DepartmentID = D.DepartmentID
WHERE D.DepartmentName = 'Housekeeping';


UPDATE Guest
SET Phone = '0719876543'
WHERE GuestID = 1;


UPDATE Room
SET Status = 'Occupied'
WHERE RoomID = 1;


UPDATE Service
SET Price = 6000.00
WHERE ServiceID = 2;


UPDATE Reservation
SET Status = 'Completed'
WHERE ReservationID = 1;


SELECT COUNT(*) AS TotalGuests
FROM Guest;


SELECT COUNT(*) AS TotalRooms
FROM Room;


SELECT
    Status,
    COUNT(*) AS NumberOfRooms
FROM Room
GROUP BY Status;


SELECT
    SUM(Amount) AS TotalPayments
FROM Payment
WHERE Status = 'Paid';


SELECT
    AVG(BasePrice) AS AverageRoomPrice
FROM RoomType;


SELECT
    MAX(BasePrice) AS HighestRoomPrice
FROM RoomType;


SELECT
    MIN(BasePrice) AS LowestRoomPrice
FROM RoomType;

CREATE ROLE AdminRole;
GRANT CONTROL ON DATABASE::ShangrilaDB TO AdminRole;

CREATE ROLE ReceptionRole;

GRANT SELECT, INSERT, UPDATE ON Guest TO ReceptionRole;
GRANT SELECT, INSERT, UPDATE ON Reservation TO ReceptionRole;
GRANT SELECT, INSERT, UPDATE ON Payment TO ReceptionRole;
GRANT SELECT ON Room TO ReceptionRole;
GRANT SELECT ON RoomType TO ReceptionRole;
GRANT SELECT ON Service TO ReceptionRole;
DENY DELETE ON Guest TO ReceptionRole;
DENY DELETE ON Reservation TO ReceptionRole;
DENY DELETE ON Payment TO ReceptionRole;

CREATE ROLE InventoryRole;

GRANT SELECT, INSERT, UPDATE ON Supplier TO InventoryRole;
GRANT SELECT ON Service TO InventoryRole;
GRANT SELECT ON Room TO InventoryRole;
GRANT SELECT ON RoomType TO InventoryRole;
DENY DELETE ON Supplier TO InventoryRole;

CREATE ROLE ServiceRole;

GRANT SELECT, INSERT, UPDATE ON ServiceOrder TO ServiceRole;
GRANT SELECT ON Service TO ServiceRole;
GRANT SELECT ON Guest TO ServiceRole;
GRANT SELECT, UPDATE ON Room TO ServiceRole;
DENY DELETE ON ServiceOrder TO ServiceRole;
DENY SELECT ON Payment TO ServiceRole;
DENY SELECT ON Reservation TO ServiceRole;

CREATE ROLE ReportingRole;

GRANT SELECT ON Guest TO ReportingRole;
GRANT SELECT ON RoomType TO ReportingRole;
GRANT SELECT ON Room TO ReportingRole;
GRANT SELECT ON Department TO ReportingRole;
GRANT SELECT ON Staff TO ReportingRole;
GRANT SELECT ON Service TO ReportingRole;
GRANT SELECT ON Reservation TO ReportingRole;
GRANT SELECT ON Payment TO ReportingRole;
GRANT SELECT ON ServiceOrder TO ReportingRole;
GRANT SELECT ON Supplier TO ReportingRole;
DENY INSERT ON Guest TO ReportingRole;
DENY UPDATE ON Guest TO ReportingRole;
DENY DELETE ON Guest TO ReportingRole;
