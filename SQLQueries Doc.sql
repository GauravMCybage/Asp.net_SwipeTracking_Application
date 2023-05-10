CREATE TABLE EmployeeDetails (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Age INT,
    Gender NVARCHAR(10),
    Department NVARCHAR(50),
    IsActive BIT
);

-- Create TotalHoursInfo table
CREATE TABLE TotalHoursInfo (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    SwipeDate DATE,
    TotalHours Nvarchar(10)
);


select * from EmployeeDetails;

drop table SwipeInOutDetails;
drop table TotalHoursInfo;
drop table EmployeeDetails;

CREATE TABLE SwipeInOutDetails (
    SwipeID INT IDENTITY(1,1) PRIMARY KEY,
    SwipeDate DATE,
    SwipeIn TIME,
    SwipeOut TIME,
    EmployeeID INT FOREIGN KEY REFERENCES EmployeeDetails(EmployeeID)
);

use CybEmpTrackerSystem;

drop database SwipePractice;

---------- Table Employee Crud Operations ------------

INSERT INTO EmployeeDetails (FirstName, LastName, Age, Gender, Department, IsActive)
VALUES ('John', 'Doe', 30, 'Male', 'HR', 1);

-- Get all employees
SELECT * FROM EmployeeDetails;

-- Get employee by EmployeeID
SELECT * FROM EmployeeDetails WHERE EmployeeID = 1;

UPDATE EmployeeDetails
SET FirstName = 'Jane', LastName = 'Doe', Age = 32
WHERE EmployeeID = 1;

DELETE FROM EmployeeDetails WHERE EmployeeID = 1;


----Sotred Procedure For Insert and Update -------------- Employee Table ---------------

-- Create a stored procedure for inserting and updating rows in the EmployeeDetails table
CREATE PROCEDURE AddorEditEmployeeDetails
    @EmployeeID INT = NULL,
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Age INT,
    @Gender NVARCHAR(10),
    @Department NVARCHAR(50),
    @IsActive BIT
AS
BEGIN
    -- Check if the EmployeeID already exists in the table
    IF @EmployeeID IS NOT NULL AND EXISTS (SELECT 1 FROM EmployeeDetails WHERE EmployeeID = @EmployeeID)
    BEGIN
        -- Update the existing row
        UPDATE EmployeeDetails
        SET FirstName = @FirstName,
            LastName = @LastName,
            Age = @Age,
            Gender = @Gender,
            Department = @Department,
            IsActive = @IsActive
        WHERE EmployeeID = @EmployeeID;
    END
    ELSE
    BEGIN
        -- Insert a new row
        INSERT INTO EmployeeDetails (FirstName, LastName, Age, Gender, Department, IsActive)
        VALUES (@FirstName, @LastName, @Age, @Gender, @Department, @IsActive);
    END
END;


-- Call the stored procedure to insert a new employee
EXEC AddorEditEmployeeDetails @FirstName = 'JosdGhny',
                            @LastName = 'Dadgo',
                            @Age = 22,
                            @Gender = 'Male',
                            @Department = 'IT',
                            @IsActive = 1;

-- Call the stored procedure to update an existing employee
EXEC AddorEditEmployeeDetails @EmployeeID = 2,
                            @FirstName = 'Alexandra',
                            @LastName = 'Dovoe',
                            @Age = 33,
                            @Gender = 'Female',
                            @Department = 'HR',
                            @IsActive = 0;



-----------------------------------------------------------------------------------------------------------


----------------------Table Swipe inout CRUD Operations------------------------------------------------

INSERT INTO SwipeInOutDetails (SwipeDate, SwipeIn, SwipeOut, EmployeeID)
VALUES ('2023-04-15', '09:00:00', '18:00:00', 1);

-- Retrieve all records
SELECT * FROM SwipeInOutDetails;
-- Retrieve records for a specific employee
SELECT * FROM SwipeInOutDetails WHERE EmployeeID = 1;
-- Retrieve records for a specific date
SELECT * FROM SwipeInOutDetails WHERE SwipeDate = '2023-04-15';

-- UPDATE operation
-- Update records in the SwipeInOutDetails table
-- Update SwipeOut for a specific record
UPDATE SwipeInOutDetails
SET SwipeOut = '19:00:00'
WHERE SwipeID = 1;

-- DELETE operation
-- Delete a record from the SwipeInOutDetails table
DELETE FROM SwipeInOutDetails WHERE SwipeID = 3;


-- Create a stored procedure for inserting a SwipeIn record in the SwipeInOutDetails table
CREATE PROCEDURE InsertSwipeIn
    @SwipeDate DATE,
    @SwipeIn TIME,
    @EmployeeID INT
AS
BEGIN
    -- Insert the SwipeIn record---------
    INSERT INTO SwipeInOutDetails (SwipeDate, SwipeIn, EmployeeID)
    VALUES (@SwipeDate, @SwipeIn, @EmployeeID);
END;


-- Call the stored procedure to insert a SwipeIn record-------
EXEC InsertSwipeIn @SwipeDate = '2023-04-18',
                   @SwipeIn = '09:00:00',
                   @EmployeeID = 4;-- Create a stored procedure for updating a SwipeOut record in the SwipeInOutDetails table


-- Create a stored procedure for updating a SwipeIn record in the SwipeInOutDetails table
CREATE PROCEDURE UpdateSwipeIn
    @SwipeDate DATE,
    @SwipeIn TIME,
    @EmployeeID INT
AS
BEGIN
    -- Update the SwipeIn record
    UPDATE SwipeInOutDetails
    SET SwipeIn = @SwipeIn
    WHERE SwipeDate = @SwipeDate AND EmployeeID = @EmployeeID;
END;

-- Call the stored procedure to update a SwipeIn record
EXEC UpdateSwipeIn @SwipeDate = '2023-04-15',
                   @SwipeIn = '10:00:00',
                   @EmployeeID = 2;

--------------------------------

DROP PROCEDURE [CalculateTotal];
GO


-- Create a stored procedure to insert/update SwipeOut time in SwipeInOutDetails table
CREATE PROCEDURE InsertOrUpdateSwipeOut
    @SwipeDate DATE,
    @SwipeOut TIME,
    @EmployeeID INT
AS
BEGIN
    -- Check if a SwipeIn record exists for the given date and employee ID
    IF EXISTS (
        SELECT 1
        FROM SwipeInOutDetails
        WHERE SwipeDate = @SwipeDate
        AND EmployeeID = @EmployeeID
        AND SwipeIn IS NOT NULL
    )
    BEGIN
        -- Update the SwipeOut time for the existing SwipeIn record
        UPDATE SwipeInOutDetails
        SET SwipeOut = @SwipeOut
        WHERE SwipeDate = @SwipeDate
        AND EmployeeID = @EmployeeID
    END
    ELSE
    BEGIN
        -- Insert a new row with SwipeOut time
        INSERT INTO SwipeInOutDetails (SwipeDate, SwipeOut, EmployeeID)
        VALUES (@SwipeDate, @SwipeOut, @EmployeeID)
    END
END;

-- Call the stored procedure to insert/update SwipeOut time
EXEC InsertOrUpdateSwipeOut @SwipeDate = '2023-04-15',
                            @SwipeOut = '18:00:00',
                            @EmployeeID = 2;

select * from SwipeInOutDetails;

--------------------------------------------------------------------------------------------------------------


-----------------------Table For Total Hours Crud Operation---------------------------------------------------

-- CRUD operations for TotalHoursInfo table
-- CREATE (INSERT) operation
-- Insert total hours information for a specific SwipeID
INSERT INTO TotalHoursInfo (SwipeID, TotalHours)
VALUES (1, 9.00);

-- READ (SELECT) operation
-- Retrieve total hours information from the TotalHoursInfo table
-- Retrieve total hours for a specific SwipeID
SELECT TotalHours FROM TotalHoursInfo WHERE SwipeID = 1;

-- UPDATE operation
-- Update total hours for a specific SwipeID
UPDATE TotalHoursInfo
SET TotalHours = 10.00
WHERE SwipeID = 1;

-- DELETE operation
-- Delete total hours information for a specific SwipeID
DELETE FROM TotalHoursInfo WHERE SwipeID = 1;

select * from TotalHoursinfo;


-- Create a stored procedure to calculate total hours and insert into TotalHoursInfo table
CREATE PROCEDURE calculate_total_hours
    @employee_id INT,
    @date DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if employee exists
    IF NOT EXISTS (SELECT * FROM EmployeeDetails WHERE EmployeeID = @Employee_id)
    BEGIN
        PRINT 'Employee not present in database';
        RETURN;
    END;
    
    -- Check if swipe in exists for the given date
    DECLARE @swipein_time TIME;
    SELECT @swipein_time = SwipeTime FROM Swipeinout_Details WHERE EmployeeID = @employee_id AND CONVERT(DATE, SwipeDate) = @date AND IsSwipeIn = 1;
    
    IF @swipein_time IS NULL
    BEGIN
        PRINT 'Contact admin';
        RETURN;
    END;

    -- Check if swipe out exists for the given date
    DECLARE @swipeout_time TIME;
    SELECT @swipeout_time = SwipeTime FROM Swipeinout_Details WHERE EmployeeID = @employee_id AND CONVERT(DATE, SwipeDate) = @date AND IsSwipeIn = 0;
    
    -- If swipe out is null, insert swipe out time as 11:59:59 and next day swipe in as 00:00:01
    IF @swipeout_time IS NULL
    BEGIN
        -- Insert swipe out time as 11:59:59 for current date
        INSERT INTO Swipeinout_Details (EmployeeID, SwipeDate, SwipeTime, IsSwipeIn)
        VALUES (@employee_id, @date, '23:59:59', 0);

        -- Insert swipe in time as 00:00:01 for next date
        DECLARE @next_date DATE;
        SET @next_date = DATEADD(day, 1, @date);
        INSERT INTO Swipeinout_Details (EmployeeID, SwipeDate, SwipeTime, IsSwipeIn)
        VALUES (@employee_id, @next_date, '00:00:01', 1);

        SET @swipeout_time = '23:59:59'; -- Set swipe out time as 11:59:59 for calculation
    END;
    
    -- Calculate total hours
    DECLARE @total_hours NVARCHAR(10);
    DECLARE @swipein_datetime DATETIME, @swipeout_datetime DATETIME;
    SELECT @swipein_datetime = CONVERT(DATETIME, CONVERT(VARCHAR(10), @date) + ' ' + CONVERT(VARCHAR(8), @swipein_time)),
           @swipeout_datetime = CONVERT(DATETIME, CONVERT(VARCHAR(10), @date) + ' ' + CONVERT(VARCHAR(8), @swipeout_time));
    
    SET @total_hours = CONVERT(NVARCHAR(10), DATEDIFF(MINUTE, @swipein_datetime, @swipeout_datetime) / 60) + ':' + 
                      CONVERT(NVARCHAR(10), DATEDIFF(MINUTE, @swipein_datetime, @swipeout_datetime) % 60);

    -- Insert total hours into TotalHoursInfo table
    IF EXISTS (SELECT * FROM TotalHoursInfo WHERE EmployeeID = @employee_id AND CONVERT(VARCHAR(10), SwipeDate) = CONVERT(VARCHAR(10), @date))
    BEGIN
        UPDATE TotalHoursInfo SET TotalHours = @total_hours WHERE EmployeeID = @employee_id AND CONVERT(VARCHAR(10), SwipeDate) = CONVERT(VARCHAR(10), @date)
    END
    ELSE
    BEGIN
        INSERT INTO TotalHoursInfo (EmployeeID, SwipeDate, TotalHours)
        VALUES (@employee_id, @date, @total_hours)
    END;
END;





-- Call the stored procedure to calculate total hours and insert into TotalHoursInfo table
EXECUTE dbo.calculate_total_hours 4, '2023-04-18';







DROP PROCEDURE calculate_total_hours;
GO

select * from SwipeInOutDetails;

select * from TotalHoursInfo;







---------------------------------------------------------------------------------------------------------------