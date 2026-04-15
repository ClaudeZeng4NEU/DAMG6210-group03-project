USE [MovingCompanies];
GO

INSERT INTO CUSTOMER (FirstName, LastName, Phone, Email) VALUES
('James', 'Smith', '555-0101', 'james@mail.com'),
('Mary', 'Johnson', '555-0102', 'mary@mail.com'),
('Robert', 'Williams', '555-0103', 'rob@mail.com'),
('Patricia', 'Brown', '555-0104', 'pat@mail.com'),
('John', 'Jones', '555-0105', 'john@mail.com'),
('Jennifer', 'Garcia', '555-0106', 'jen@mail.com'),
('Michael', 'Miller', '555-0107', 'mike@mail.com'),
('Linda', 'Davis', '555-0108', 'linda@mail.com'),
('William', 'Rodriguez', '555-0109', 'will@mail.com'),
('Elizabeth', 'Martinez', '555-0110', 'eliz@mail.com');
GO

INSERT INTO CONSULTANT (Name, ConsultantType) VALUES
('Alice Evans', 'Senior'),
('Bob Ford', 'Junior'),
('Charlie Day', 'Lead'),
('Diana Ross', 'Senior'),
('Edward Norton', 'Lead'),
('Fiona Glen', 'Junior'),
('George King', 'Senior'),
('Hannah Bell', 'Lead'),
('Ian Wright', 'Junior'),
('Julia Roberts', 'Senior');
GO

INSERT INTO VEHICLE (LicensePlate, Model, Capacity, Status) VALUES
('TRK-001', 'Ford F-650', 500, 'Available'),
('TRK-002', 'Freightliner', 1500, 'Available'),
('TRK-003', 'Isuzu NPR', 800, 'Busy'),
('TRK-004', 'Ford F-650', 500, 'Maintenance'),
('TRK-005', 'Hino 268', 1000, 'Available'),
('TRK-006', 'Freightliner', 1500, 'Available'),
('TRK-007', 'Isuzu NPR', 800, 'Busy'),
('TRK-008', 'Hino 268', 1000, 'Available'),
('TRK-009', 'Ford F-650', 500, 'Available'),
('TRK-010', 'Isuzu NPR', 800, 'Available');
GO

INSERT INTO CREW_MEMBER (Name, Role, Phone) VALUES
('Tom Hardy', 'Driver', '555-2001'),
('Sam Lee', 'Mover', '555-2002'),
('Chris Pine', 'Mover', '555-2003'),
('Mark Ruffalo', 'Foreman', '555-2004'),
('Paul Rudd', 'Driver', '555-2005'),
('Scarlett J', 'Packer', '555-2006'),
('Jeremy Renner', 'Mover', '555-2007'),
('Don Cheadle', 'Driver', '555-2008'),
('Brie Larson', 'Mover', '555-2009'),
('Chadwick B', 'Foreman', '555-2010');
GO

INSERT INTO PACKING_MATERIAL (MaterialName, UnitPrice) VALUES
('Large Box', 5.00),
('Medium Box', 3.50),
('Bubble Wrap', 20.00),
('Packing Tape', 2.00),
('Wardrobe Box', 15.00),
('Moving Blanket', 10.00),
('Stretch Wrap', 12.00),
('Paper Pad', 4.00),
('Marker Pen', 1.50),
('Mattress Cover', 8.00);
GO

INSERT INTO GEOGRAPHIC_ZONE (ZoneName, BaseRate) VALUES
('Downtown', 150.00),
('Uptown', 175.00),
('Suburbs East', 120.00),
('Suburbs West', 120.00),
('North District', 200.00),
('South District', 190.00),
('Industrial Park', 210.00),
('Airport Area', 250.00),
('Coastal Zone', 300.00),
('Mountain Side', 350.00);
GO

INSERT INTO LOCATION (ZoneID, StreetAddress, City, State, ZipCode, Floor, HasElevator) VALUES
(1, '12 Main St', 'Boston', 'MA', '02108', 3, 1),
(2, '45 River Rd', 'Cambridge', 'MA', '02139', 2, 0),
(3, '78 Oak Ave', 'Quincy', 'MA', '02169', 1, 0),
(4, '99 Pine St', 'Brookline', 'MA', '02445', 5, 1),
(5, '10 Hill Rd', 'Newton', 'MA', '02458', 2, 1),
(6, '66 South St', 'Somerville', 'MA', '02143', 4, 0),
(7, '150 Industry Way', 'Chelsea', 'MA', '02150', 1, 0),
(8, '1 Airport Dr', 'East Boston', 'MA', '02128', 2, 1),
(9, '200 Ocean Ave', 'Revere', 'MA', '02151', 6, 1),
(10, '500 Mountain Rd', 'Waltham', 'MA', '02451', 1, 0);
GO

INSERT INTO [ORDER] (CustomerID, OriginID, DestID, ConsultantID, OrderDate, TotalVolume) VALUES
(1, 1, 2, 1, '2026-03-01', 120.50),
(2, 2, 3, 2, '2026-03-02', 200.00),
(3, 3, 4, 3, '2026-03-03', 90.75),
(4, 4, 5, 4, '2026-03-04', 150.20),
(5, 5, 6, 5, '2026-03-05', 300.00),
(6, 6, 7, 6, '2026-03-06', 175.40),
(7, 7, 8, 7, '2026-03-07', 220.00),
(8, 8, 9, 8, '2026-03-08', 80.00),
(9, 9, 10, 9, '2026-03-09', 110.00),
(10, 10, 1, 10, '2026-03-10', 260.25);
GO

INSERT INTO ESTIMATE (OrderID, EstimatedCost, ExpirationDate) VALUES
(1, 800.00, '2026-03-15'),
(2, 1200.00, '2026-03-16'),
(3, 700.00, '2026-03-17'),
(4, 950.00, '2026-03-18'),
(5, 1500.00, '2026-03-19'),
(6, 1000.00, '2026-03-20'),
(7, 1300.00, '2026-03-21'),
(8, 650.00, '2026-03-22'),
(9, 850.00, '2026-03-23'),
(10, 1400.00, '2026-03-24');
GO

INSERT INTO INVOICE (OrderID, FinalTotal, PaymentStatus, IssueDate) VALUES
(1, 820.00, 'Paid', '2026-03-11'),
(2, 1180.00, 'Pending', '2026-03-12'),
(3, 710.00, 'Paid', '2026-03-13'),
(4, 970.00, 'Pending', '2026-03-14'),
(5, 1490.00, 'Paid', '2026-03-15'),
(6, 1025.00, 'Pending', '2026-03-16'),
(7, 1320.00, 'Paid', '2026-03-17'),
(8, 670.00, 'Pending', '2026-03-18'),
(9, 860.00, 'Paid', '2026-03-19'),
(10, 1415.00, 'Pending', '2026-03-20');
GO

INSERT INTO INVENTORY_ITEM (OrderID, Description, Volume, IsFragile) VALUES
(1, 'Sofa', 25.00, 0),
(1, 'Glass Table', 15.00, 1),
(2, 'Bed Frame', 30.00, 0),
(2, 'TV', 10.00, 1),
(3, 'Dining Chairs', 12.00, 0),
(4, 'Bookshelf', 18.00, 0),
(5, 'Piano', 50.00, 1),
(6, 'Office Desk', 20.00, 0),
(7, 'Artwork', 8.00, 1),
(8, 'Boxes', 22.00, 0);
GO

INSERT INTO MATERIAL_USAGE (OrderID, MaterialID, QuantityUsed) VALUES
(1, 1, 5),
(1, 3, 2),
(2, 2, 8),
(2, 4, 4),
(3, 1, 3),
(4, 5, 2),
(5, 6, 6),
(6, 7, 3),
(7, 8, 10),
(8, 9, 2);
GO

INSERT INTO VEHICLE_ASSIGN (OrderID, VehicleID, StartMileage, EndMileage) VALUES
(1, 1, 10000, 10045),
(2, 2, 20000, 20080),
(3, 3, 15000, 15030),
(5, 5, 40000, 40120),
(6, 6, 25000, 25070),
(8, 8, 22000, 22025),
(9, 9, 17000, 17040),
(10, 10, 50000, 50110);
GO

INSERT INTO CREW_ASSIGN (OrderID, CrewMemberID, HoursWorked) VALUES
(1, 1, 5.5),
(1, 2, 5.5),
(2, 3, 7.0),
(2, 4, 7.0),
(3, 5, 4.0),
(4, 6, 6.5),
(5, 7, 8.0),
(6, 8, 5.0),
(7, 9, 7.5),
(8, 10, 4.5);
GO

SELECT * FROM CUSTOMER;
SELECT * FROM CONSULTANT;
SELECT * FROM VEHICLE;
SELECT * FROM CREW_MEMBER;
SELECT * FROM PACKING_MATERIAL;
SELECT * FROM GEOGRAPHIC_ZONE;
SELECT * FROM LOCATION;
SELECT * FROM [ORDER];
SELECT * FROM ESTIMATE;
SELECT * FROM INVOICE;
SELECT * FROM INVENTORY_ITEM;
SELECT * FROM MATERIAL_USAGE;
SELECT * FROM VEHICLE_ASSIGN;
SELECT * FROM CREW_ASSIGN;
GO
