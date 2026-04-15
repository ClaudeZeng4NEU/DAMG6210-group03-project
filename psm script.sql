USE [MovingCompanies];
GO

CREATE OR ALTER PROCEDURE sp_CreateOrderWithEstimate
    @CustomerID INT,
    @OriginID INT,
    @DestID INT,
    @ConsultantID INT,
    @OrderDate DATE,
    @TotalVolume DECIMAL(10,2),
    @EstimatedCost DECIMAL(10,2),
    @ExpirationDate DATE,
    @NewOrderID INT OUTPUT,
    @NewEstimateID INT OUTPUT,
    @ResultMessage VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO [ORDER] (CustomerID, OriginID, DestID, ConsultantID, OrderDate, TotalVolume)
        VALUES (@CustomerID, @OriginID, @DestID, @ConsultantID, @OrderDate, @TotalVolume);

        SET @NewOrderID = SCOPE_IDENTITY();

        INSERT INTO ESTIMATE (OrderID, EstimatedCost, ExpirationDate)
        VALUES (@NewOrderID, @EstimatedCost, @ExpirationDate);

        SET @NewEstimateID = SCOPE_IDENTITY();
        SET @ResultMessage = 'Order and estimate created successfully.';

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @NewOrderID = NULL;
        SET @NewEstimateID = NULL;
        SET @ResultMessage = ERROR_MESSAGE();
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_AssignCrewToOrder
    @OrderID INT,
    @CrewMemberID INT,
    @HoursWorked DECIMAL(10,2),
    @NewCrewAssignID INT OUTPUT,
    @ResultMessage VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM [ORDER] WHERE OrderID = @OrderID)
            THROW 50001, 'Order does not exist.', 1;

        IF NOT EXISTS (SELECT 1 FROM CREW_MEMBER WHERE CrewMemberID = @CrewMemberID)
            THROW 50002, 'Crew member does not exist.', 1;

        IF @HoursWorked <= 0
            THROW 50003, 'HoursWorked must be greater than 0.', 1;

        INSERT INTO CREW_ASSIGN (OrderID, CrewMemberID, HoursWorked)
        VALUES (@OrderID, @CrewMemberID, @HoursWorked);

        SET @NewCrewAssignID = SCOPE_IDENTITY();
        SET @ResultMessage = 'Crew member assigned successfully.';

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @NewCrewAssignID = NULL;
        SET @ResultMessage = ERROR_MESSAGE();
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_UpdateInvoicePaymentStatus
    @InvoiceID INT,
    @NewPaymentStatus VARCHAR(50),
    @UpdatedInvoiceID INT OUTPUT,
    @ResultMessage VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM INVOICE WHERE InvoiceID = @InvoiceID)
            THROW 50004, 'Invoice does not exist.', 1;

        UPDATE INVOICE
        SET PaymentStatus = @NewPaymentStatus
        WHERE InvoiceID = @InvoiceID;

        SET @UpdatedInvoiceID = @InvoiceID;
        SET @ResultMessage = 'Invoice payment status updated successfully.';

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @UpdatedInvoiceID = NULL;
        SET @ResultMessage = ERROR_MESSAGE();
    END CATCH
END;
GO

CREATE OR ALTER VIEW vw_OrderSummary
AS
SELECT
    o.OrderID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    o.OrderDate,
    o.TotalVolume,
    lo.City AS OriginCity,
    ld.City AS DestinationCity,
    oz.ZoneName AS OriginZone,
    dz.ZoneName AS DestinationZone,
    con.Name AS ConsultantName
FROM [ORDER] o
JOIN CUSTOMER c ON o.CustomerID = c.CustomerID
JOIN LOCATION lo ON o.OriginID = lo.LocationID
JOIN LOCATION ld ON o.DestID = ld.LocationID
JOIN GEOGRAPHIC_ZONE oz ON lo.ZoneID = oz.ZoneID
JOIN GEOGRAPHIC_ZONE dz ON ld.ZoneID = dz.ZoneID
JOIN CONSULTANT con ON o.ConsultantID = con.ConsultantID;
GO

CREATE OR ALTER VIEW vw_RevenueReport
AS
SELECT
    i.InvoiceID,
    i.OrderID,
    i.FinalTotal,
    i.PaymentStatus,
    i.IssueDate,
    c.FirstName + ' ' + c.LastName AS CustomerName
FROM INVOICE i
JOIN [ORDER] o ON i.OrderID = o.OrderID
JOIN CUSTOMER c ON o.CustomerID = c.CustomerID;
GO

CREATE OR ALTER VIEW vw_CrewPerformance
AS
SELECT
    cm.CrewMemberID,
    cm.Name,
    cm.Role,
    COUNT(ca.OrderID) AS TotalAssignments,
    ISNULL(SUM(ca.HoursWorked), 0) AS TotalHoursWorked,
    ISNULL(AVG(ca.HoursWorked), 0) AS AvgHoursPerAssignment
FROM CREW_MEMBER cm
LEFT JOIN CREW_ASSIGN ca ON cm.CrewMemberID = ca.CrewMemberID
GROUP BY cm.CrewMemberID, cm.Name, cm.Role;
GO

CREATE OR ALTER FUNCTION dbo.ufn_GetMaterialCost (@OrderID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @TotalCost DECIMAL(10,2);

    SELECT @TotalCost = ISNULL(SUM(mu.QuantityUsed * pm.UnitPrice), 0)
    FROM MATERIAL_USAGE mu
    JOIN PACKING_MATERIAL pm ON mu.MaterialID = pm.MaterialID
    WHERE mu.OrderID = @OrderID;

    RETURN @TotalCost;
END;
GO

CREATE OR ALTER FUNCTION dbo.ufn_GetTotalCrewHours (@OrderID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @TotalHours DECIMAL(10,2);

    SELECT @TotalHours = ISNULL(SUM(HoursWorked), 0)
    FROM CREW_ASSIGN
    WHERE OrderID = @OrderID;

    RETURN @TotalHours;
END;
GO

CREATE OR ALTER FUNCTION dbo.ufn_OrderInvoiceDetails (@OrderID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        o.OrderID,
        o.OrderDate,
        o.TotalVolume,
        i.InvoiceID,
        i.FinalTotal,
        i.PaymentStatus
    FROM [ORDER] o
    LEFT JOIN INVOICE i ON o.OrderID = i.OrderID
    WHERE o.OrderID = @OrderID
);
GO

IF OBJECT_ID('dbo.VEHICLE_ASSIGN_AUDIT', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.VEHICLE_ASSIGN_AUDIT (
        AuditID INT IDENTITY(1,1) PRIMARY KEY,
        AssignmentID INT NULL,
        OrderID INT NOT NULL,
        VehicleID INT NOT NULL,
        StartMileage INT NOT NULL,
        EndMileage INT NOT NULL,
        AuditAction VARCHAR(50) NOT NULL,
        AuditDate DATETIME NOT NULL DEFAULT GETDATE()
    );
END;
GO

CREATE OR ALTER TRIGGER trg_PreventMaintenanceVehicleAssignment
ON VEHICLE_ASSIGN
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN VEHICLE v ON i.VehicleID = v.VehicleID
        WHERE v.Status = 'Maintenance'
    )
    BEGIN
        RAISERROR ('A vehicle under maintenance cannot be assigned to an order.', 16, 1);
        RETURN;
    END;

    INSERT INTO VEHICLE_ASSIGN (OrderID, VehicleID, StartMileage, EndMileage)
    SELECT OrderID, VehicleID, StartMileage, EndMileage
    FROM inserted;

    INSERT INTO dbo.VEHICLE_ASSIGN_AUDIT (AssignmentID, OrderID, VehicleID, StartMileage, EndMileage, AuditAction)
    SELECT
        va.AssignmentID,
        i.OrderID,
        i.VehicleID,
        i.StartMileage,
        i.EndMileage,
        'INSERT'
    FROM inserted i
    JOIN VEHICLE_ASSIGN va
        ON va.OrderID = i.OrderID
       AND va.VehicleID = i.VehicleID
       AND va.StartMileage = i.StartMileage
       AND va.EndMileage = i.EndMileage;

    UPDATE v
    SET Status = 'Busy'
    FROM VEHICLE v
    JOIN inserted i ON v.VehicleID = i.VehicleID;
END;
GO

SELECT * FROM vw_OrderSummary;
SELECT * FROM vw_RevenueReport;
SELECT * FROM vw_CrewPerformance;
SELECT dbo.ufn_GetMaterialCost(1) AS MaterialCostForOrder1;
SELECT dbo.ufn_GetTotalCrewHours(1) AS TotalCrewHoursForOrder1;
SELECT * FROM dbo.ufn_OrderInvoiceDetails(1);
GO
