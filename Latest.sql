CREATE TABLE EmployeeDetails (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Age INT,
    Gender NVARCHAR(10),
    Department NVARCHAR(50),
    IsActive BIT
);

INSERT INTO EmployeeDetails (FirstName, LastName, Age, Gender, Department, IsActive)
VALUES ('John', 'Doe', 32, 'Male', 'Marketing', 1);

INSERT INTO EmployeeDetails (FirstName, LastName, Age, Gender, Department, IsActive)
VALUES ('Jane', 'Smith', 27, 'Female', 'Finance', 1);

INSERT INTO EmployeeDetails (FirstName, LastName, Age, Gender, Department, IsActive)
VALUES ('Bob', 'Johnson', 42, 'Male', 'Sales', 0);

-- Create TotalHoursInfo table
CREATE TABLE TotalHoursInfo (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    SwipeDate DATE,
    TotalHours Nvarchar(10)
);


CREATE TABLE SwipeInOutDetails (
    SwipeID INT IDENTITY(1,1) PRIMARY KEY,
    SwipeDate DATE,
    SwipeIn TIME,
    SwipeOut TIME,
    EmployeeID INT FOREIGN KEY REFERENCES EmployeeDetails(EmployeeID)
);

select * from EmployeeDetails;
select * from SwipeInOutDetails;
select * from TotalHoursInfo;


CREATE PROCEDURE AddOrUpdateSwipeInData
    @EmployeeID INT,
    @SwipeDate DATE,
    @SwipeIn TIME
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if there is already a record for this employee and swipe date
    DECLARE @SwipeID INT;
    SELECT @SwipeID = SwipeID
    FROM SwipeInOutDetails
    WHERE EmployeeID = @EmployeeID AND SwipeDate = @SwipeDate;
    
    IF @SwipeID IS NULL
    BEGIN
        -- Insert new record if one does not exist
        INSERT INTO SwipeInOutDetails (SwipeDate, SwipeIn, EmployeeID)
        VALUES (@SwipeDate, @SwipeIn, @EmployeeID);
    END
    ELSE
    BEGIN
        -- Update existing record if one exists
        UPDATE SwipeInOutDetails
        SET SwipeIn = @SwipeIn
        WHERE SwipeID = @SwipeID;
    END
END

EXEC AddOrUpdateSwipeInData @EmployeeID = 1, @SwipeDate = '2023-05-04', @SwipeIn = '08:00:00';

CREATE PROCEDURE AddOrUpdateSwipeOutData
    @EmployeeID INT,
    @SwipeDate DATE,
    @SwipeOut TIME
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if there is a record for this employee and swipe date
    DECLARE @SwipeID INT;
    SELECT @SwipeID = SwipeID
    FROM SwipeInOutDetails
    WHERE EmployeeID = @EmployeeID AND SwipeDate = @SwipeDate;
    
    IF @SwipeID IS NULL
    BEGIN
        -- If there is no swipe in record for this employee and swipe date,
        -- update TotalHoursInfo table and insert a message in TotalHours
        DECLARE @TotalHours NVARCHAR(10) = 'Swipe in record is not up to date, please contact admin';
        INSERT INTO TotalHoursInfo (EmployeeID, SwipeDate, TotalHours)
        VALUES (@EmployeeID, @SwipeDate, @TotalHours);
    END
    ELSE
    BEGIN
        -- If there is a swipe in record for this employee and swipe date,
        -- update the swipe out time in SwipeInOutDetails table
        UPDATE SwipeInOutDetails
        SET SwipeOut = @SwipeOut
        WHERE SwipeID = @SwipeID;
        
        -- Calculate total hours for the employee and swipe date
        SELECT @TotalHours = CONVERT(NVARCHAR(10), DATEDIFF(MINUTE, SwipeIn, SwipeOut) / 60) + ':' + RIGHT('00' + CONVERT(NVARCHAR(2), DATEDIFF(MINUTE, SwipeIn, SwipeOut) % 60), 2)
        FROM SwipeInOutDetails
        WHERE SwipeID = @SwipeID;
        
        -- Update TotalHoursInfo table with the total hours for the employee and swipe date
        UPDATE TotalHoursInfo
        SET TotalHours = @TotalHours
        WHERE EmployeeID = @EmployeeID AND SwipeDate = @SwipeDate;
    END
END

EXEC AddOrUpdateSwipeOutData @EmployeeID = 1, @SwipeDate = '2023-05-04', @SwipeOut = '17:00:00';

CREATE PROCEDURE UpdateTotalHours
AS
BEGIN
    DECLARE @EmployeeID INT, @SwipeDate DATE, @SwipeIn TIME, @SwipeOut TIME
    DECLARE @TotalHours DECIMAL(5,2)
    DECLARE swipe_cursor CURSOR FOR 
        SELECT EmployeeID, SwipeDate, SwipeIn, SwipeOut 
        FROM SwipeInOutDetails
        ORDER BY EmployeeID, SwipeDate, SwipeIn, SwipeOut

    OPEN swipe_cursor
    FETCH NEXT FROM swipe_cursor INTO @EmployeeID, @SwipeDate, @SwipeIn, @SwipeOut

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Check if employee exists
        IF EXISTS (SELECT EmployeeID FROM EmployeeDetails WHERE EmployeeID = @EmployeeID)
        BEGIN
            -- Check if swipe in record exists
            IF EXISTS (SELECT EmployeeID FROM SwipeInOutDetails WHERE EmployeeID = @EmployeeID AND SwipeDate = @SwipeDate AND SwipeIn = @SwipeIn)
            BEGIN
                -- Check if swipe out record exists
                IF EXISTS (SELECT EmployeeID FROM SwipeInOutDetails WHERE EmployeeID = @EmployeeID AND SwipeDate = @SwipeDate AND SwipeOut = @SwipeOut)
                BEGIN
                    -- Calculate total completed hours
                    SET @TotalHours = DATEDIFF(MINUTE, @SwipeIn, @SwipeOut) / 60.0
                    -- Update total hours info table
                    UPDATE TotalHoursInfo 
                    SET TotalHours = @TotalHours 
                    WHERE EmployeeID = @EmployeeID AND SwipeDate = @SwipeDate
                END
                ELSE
                BEGIN
                    -- Update swipe in record is not up to date message
                    UPDATE TotalHoursInfo 
                    SET TotalHours = 'Swipe out record is missing, please contact admin' 
                    WHERE EmployeeID = @EmployeeID AND SwipeDate = @SwipeDate
                END
            END
            ELSE
            BEGIN
                -- Update swipe in record is not up to date message
                UPDATE TotalHoursInfo 
                SET TotalHours = 'Swipe in record is missing, please contact admin' 
                WHERE EmployeeID = @EmployeeID AND SwipeDate = @SwipeDate
            END
        END
        ELSE
        BEGIN
            -- Update employee not present message
            UPDATE TotalHoursInfo 
            SET TotalHours = 'Employee is not present in system' 
            WHERE EmployeeID = @EmployeeID AND SwipeDate = @SwipeDate
        END

        FETCH NEXT FROM swipe_cursor INTO @EmployeeID, @SwipeDate, @SwipeIn, @SwipeOut
    END

    CLOSE swipe_cursor
    DEALLOCATE swipe_cursor
END


CREATE PROCEDURE SwipeOutCheck
AS
BEGIN
    DECLARE @EmployeeID INT, @SwipeDate DATE, @SwipeOut TIME, @TotalHours NVARCHAR(10)
    DECLARE cur CURSOR LOCAL FOR
    SELECT sd.EmployeeID, sd.SwipeDate, sd.SwipeOut, thi.TotalHours
    FROM SwipeInOutDetails sd
    LEFT JOIN TotalHoursInfo thi ON sd.EmployeeID = thi.EmployeeID AND sd.SwipeDate = thi.SwipeDate
    WHERE sd.SwipeOut IS NULL
    ORDER BY sd.EmployeeID, sd.SwipeDate

    OPEN cur

    FETCH NEXT FROM cur INTO @EmployeeID, @SwipeDate, @SwipeOut, @TotalHours

    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @SwipeIn TIME, @NextDaySwipeIn TIME, @NextDaySwipeInDate DATE, @TotalCompletedHours NVARCHAR(10), @ErrorMessage NVARCHAR(200)
        
        SELECT @SwipeIn = SwipeIn FROM SwipeInOutDetails WHERE EmployeeID = @EmployeeID AND SwipeDate = @SwipeDate
        
        IF @SwipeIn IS NULL
        BEGIN
            SET @ErrorMessage = 'Swipe in record is not up to date. Please contact admin.'
            INSERT INTO TotalHoursInfo (EmployeeID, SwipeDate, TotalHours) VALUES (@EmployeeID, @SwipeDate, @ErrorMessage)
            FETCH NEXT FROM cur INTO @EmployeeID, @SwipeDate, @SwipeOut, @TotalHours
            CONTINUE
        END

        SET @NextDaySwipeIn = '00:00:01'
        SET @NextDaySwipeInDate = DATEADD(day, 1, @SwipeDate)
        EXEC AddOrUpdateSwipeInData @EmployeeID, @NextDaySwipeInDate, @NextDaySwipeIn

        EXEC AddOrUpdateSwipeOutData @EmployeeID, @SwipeDate, '11:59:59'
        SET @SwipeOut = '11:59:59'

        SELECT @TotalCompletedHours = DATEDIFF(HOUR, @SwipeIn, @SwipeOut) % 24

        UPDATE TotalHoursInfo SET TotalHours = @TotalCompletedHours WHERE EmployeeID = @EmployeeID AND SwipeDate = @SwipeDate

        FETCH NEXT FROM cur INTO @EmployeeID, @SwipeDate, @SwipeOut, @TotalHours
    END

    CLOSE cur
    DEALLOCATE cur
END
