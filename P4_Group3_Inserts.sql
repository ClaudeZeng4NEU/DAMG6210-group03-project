USE [MovingCompanies]
go

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
