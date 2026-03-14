CREATE Database [MovingCompanies]
go

USE [MovingCompanies]
go

CREATE TABLE CUSTOMER (
CustomerID INT IDENTITY(1,1) PRIMARY KEY,
FirstName VARCHAR(50) NOT NULL,
LASTNAME VARCHAR(50) NOT NULL,
Phone VARCHAR(20) NOT NULL,
Email VARCHAR(200) NOT NULL);

CREATE TABLE CONSULTANT (
ConsultantID INT IDENTITY(1,1) PRIMARY KEY,
Name VARCHAR(50) NOT NULL,
ConsultantType VARCHAR(50) NOT NULL);

CREATE TABLE VEHICLE (
VehicleID INT IDENTITY(1,1) PRIMARY KEY,
LicensePlate VARCHAR(30) NOT NULL,
Model VARCHAR(50) NOT NULL,
Capacity INT NOT NULL,
Status VARCHAR(20) NOT NULL,
CONSTRAINT CK_Vehicle_Status CHECK (Status IN ('Available', 'Maintenance', 'Busy')));

CREATE TABLE [CREW_MEMBER] (
CrewMemberID INT IDENTITY(1,1) PRIMARY KEY,
Name VARCHAR(50) NOT NULL,
Role VARCHAR(50) NOT NULL,
Phone VARCHAR(100) NOT NULL);

CREATE TABLE [PACKING_MATERIAL] (
MaterialID INT IDENTITY(1,1) PRIMARY KEY,
MaterialName VARCHAR(200) NOT NULL,
UnitPrice DECIMAL(10,2) NOT NULL);

CREATE TABLE [GEOGRAPHIC_ZONE](
ZoneID INT IDENTITY(1,1) PRIMARY KEY,
ZoneName VARCHAR(100) NOT NULL,
BaseRate DECIMAL(10,2) NOT NULL
CONSTRAINT CK_BaseRate CHECK (BaseRate > 0));

CREATE TABLE LOCATION (
LocationID INT IDENTITY(1,1) PRIMARY KEY,
ZoneID INT NOT NULL,
SteetAddress VARCHAR(200) NOT NULL,
City VARCHAR(50) NOT NULL,
State CHAR(50) NOT NULL,
ZipCode VARCHAR(20) NOT NULL,
Floor INT,
HasElevator BIT NOT NULL,
Constraint FK_LOCATION FOREIGN KEY (ZoneID) REFERENCES GEOGRAPHIC_ZONE(ZoneID));

CREATE TABLE [ORDER] (
OrderID INT IDENTITY(1,1) PRIMARY KEY,
CustomerID INT NOT NULL,
OriginID INT NOT NULL,
DestID INT NOT NULL,
ConsultantID INT NOT NULL,
OrderDate DATE NOT NULL,
TotalVolume DECIMAL(10,2) NOT NULL,
CONSTRAINT CK_Positive_Volume CHECK (TotalVolume >= 0),
CONSTRAINT FK_Order_Customer FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID),
CONSTRAINT FK_Order_Origin FOREIGN KEY (OriginID) REFERENCES LOCATION(LocationID),
CONSTRAINT FK_Order_Dest FOREIGN KEY (DestID) REFERENCES LOCATION(LocationID),
CONSTRAINT FK_Order_Consultant FOREIGN KEY (ConsultantID) REFERENCES CONSULTANT(ConsultantID));

CREATE TABLE [ESTIMATE] (
EstimateID INT IDENTITY(1,1) PRIMARY KEY,
OrderID INT NOT NULL,
EstimatedCost DECIMAL(10,2) NOT NULL,
ExpirationDate DATE NOT NULL,
CONSTRAINT FK_Estimate_Order FOREIGN KEY (OrderID) REFERENCES [ORDER] (OrderID));

CREATE TABLE [INVOICE] (
InvoiceID INT IDENTITY(1,1) PRIMARY KEY,
OrderID INT NOT NULL,
FinalTotal DECIMAL(10,2) NOT NULL,
PaymentStatus VARCHAR(500) NOT NULL,
IssueDate DATE NOT NULL,
CONSTRAINT FK_Invoice_Order FOREIGN KEY (OrderID) REFERENCES [ORDER] (OrderID));

CREATE TABLE [INVENTORY_ITEM] (
ItemID INT IDENTITY(1,1) PRIMARY KEY,
OrderID INT NOT NULL,
Description VARCHAR(800) NOT NULL,
IsFragile BIT NOT NULL,
CONSTRAINT FK_Inventory_Order FOREIGN KEY (OrderID) REFERENCES [ORDER] (OrderID));

CREATE TABLE [MATERIAL_USAGE] (
UsageID INT IDENTITY(1,1) PRIMARY KEY,
OrderID INT NOT NULL,
MaterialID INT NOT NULL,
QuantityUsed INT NOT NULL,
CONSTRAINT FK_Usage_Order FOREIGN KEY (OrderID) REFERENCES [ORDER] (OrderID),
CONSTRAINT FK_Usage_Material FOREIGN KEY (MaterialID) REFERENCES [PACKING_MATERIAL] (MaterialID));

CREATE TABLE [VEHICLE_ASSIGN] (
AssignmentID INT IDENTITY(1,1) PRIMARY KEY,
OrderID INT NOT NULL,
VehicleID INT NOT NULL,
StartMileage INT NOT NULL,
EndMileage INT NOT NULL,
CONSTRAINT FK_Assign_Order FOREIGN KEY (OrderID) REFERENCES [ORDER] (OrderID),
CONSTRAINT FK_Assign_Vehicle FOREIGN KEY (VehicleID) REFERENCES [VEHICLE] (VehicleID));

CREATE TABLE [CREW_ASSIGN] (
CrewAssignID INT IDENTITY(1,1) PRIMARY KEY,
OrderID INT NOT NULL,
CrewMemberID INT NOT NULL,
HoursWorked DECIMAL(10,2) NOT NULL,
CONSTRAINT FK_CrewAssign_Order FOREIGN KEY (OrderID) REFERENCES [ORDER] (OrderID),
CONSTRAINT FK_CrewAssign_CrewMember FOREIGN KEY (CrewMemberID) REFERENCES [CREW_MEMBER] (CrewMemberID));

-- 1. CUSTOMER
INSERT INTO CUSTOMER (FirstName, LastName, Phone, Email) VALUES 
('James', 'Smith', '555-0101', 'james@mail.com'), ('Mary', 'Johnson', '555-0102', 'mary@mail.com'),
('Robert', 'Williams', '555-0103', 'rob@mail.com'), ('Patricia', 'Brown', '555-0104', 'pat@mail.com'),
('John', 'Jones', '555-0105', 'john@mail.com'), ('Jennifer', 'Garcia', '555-0106', 'jen@mail.com'),
('Michael', 'Miller', '555-0107', 'mike@mail.com'), ('Linda', 'Davis', '555-0108', 'linda@mail.com'),
('William', 'Rodriguez', '555-0109', 'will@mail.com'), ('Elizabeth', 'Martinez', '555-0110', 'eliz@mail.com');

SELECT*FROM CUSTOMER

-- 2. CONSULTANT
INSERT INTO CONSULTANT (Name, ConsultantType) VALUES 
('Alice Evans', 'Senior'), ('Bob Ford', 'Junior'), ('Charlie Day', 'Lead'), ('Diana Ross', 'Senior'),
('Edward Norton', 'Lead'), ('Fiona Glen', 'Junior'), ('George King', 'Senior'), ('Hannah Bell', 'Lead'),
('Ian Wright', 'Junior'), ('Julia Roberts', 'Senior');

SELECT*FROM CONSULTANT

-- 3. VEHICLE
INSERT INTO VEHICLE (LicensePlate, Model, Capacity, Status) VALUES 
('TRK-001', 'Ford F-650', 500, 'Available'), ('TRK-002', 'Freightliner', 1500, 'Available'),
('TRK-003', 'Isuzu NPR', 800, 'Busy'), ('TRK-004', 'Ford F-650', 500, 'Maintenance'),
('TRK-005', 'Hino 268', 1000, 'Available'), ('TRK-006', 'Freightliner', 1500, 'Available'),
('TRK-007', 'Isuzu NPR', 800, 'Busy'), ('TRK-008', 'Hino 268', 1000, 'Available'),
('TRK-009', 'Ford F-650', 500, 'Available'), ('TRK-010', 'Isuzu NPR', 800, 'Available');

SELECT*FROM VEHICLE

-- 4. CREW_MEMBER
INSERT INTO [CREW_MEMBER] (Name, Role, Phone) VALUES 
('Tom Hardy', 'Driver', '555-2001'), ('Sam Lee', 'Mover', '555-2002'), ('Chris Pine', 'Mover', '555-2003'),
('Mark Ruffalo', 'Foreman', '555-2004'), ('Paul Rudd', 'Driver', '555-2005'), ('Scarlett J', 'Packer', '555-2006'),
('Jeremy Renner', 'Mover', '555-2007'), ('Don Cheadle', 'Driver', '555-2008'), ('Brie Larson', 'Mover', '555-2009'),
('Chadwick B', 'Foreman', '555-2010');

SELECT*FROM CREW_MEMBER

-- 5. PACKING_MATERIAL
INSERT INTO [PACKING_MATERIAL] (MaterialName, UnitPrice) VALUES 
('Large Box', 5.00), ('Medium Box', 3.50), ('Bubble Wrap', 20.00), ('Packing Tape', 2.00),
('Wardrobe Box', 15.00), ('Moving Blanket', 10.00), ('Stretch Wrap', 12.00), ('Paper Pad', 4.00),
('Marker Pen', 1.50), ('Mattress Cover', 8.00);

SELECT*FROM PACKING_MATERIAL

-- 6. GEOGRAPHIC_ZONE
INSERT INTO [GEOGRAPHIC_ZONE] (ZoneName, BaseRate) VALUES 
('Downtown', 150.00), ('Uptown', 175.00), ('Suburbs East', 120.00), ('Suburbs West', 120.00),
('North District', 200.00), ('South District', 190.00), ('Industrial Park', 210.00), ('Airport Area', 250.00),
('Coastal Zone', 300.00), ('Mountain Side', 350.00);

SELECT*FROM GEOGRAPHIC_ZONE
