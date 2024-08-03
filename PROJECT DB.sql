/*
Requirements:
----------Schedule Management for Employees-----------
-Schedule (Start Time , End Time) [e.g. 9:00 am - 6:00 pm]
-Each Schedule will have some activities(Break, Lunch, Training ,etc) other than working part
-For Example (Break 11:00 - 11:15 , Lunch 13:00 - 13:30 , Break 16:00 - 16:15)


Now we have another external system
-it contains all data in form of activities ( Working, Break , Lunch, Training etc)
-Note here working time will be an activity
-To express same schedule data we discussed above, we will have following activities here
-9:00 - 11:00 (working)
-11:00 - 11:15 (Break)
-11:15 - 13:00 (working)
-13:00 - 13:30 (Lunch)
-13:30 - 16:00 (working)
-16:00 - 16:15 (Break)
-16:15 - 18:00 (working)
*/

CREATE DATABASE ExternalDB;

USE ExternalDB;

CREATE TABLE dbo.PlannedActivities
(
	ID int identity (1,1) Primary Key,
	EmployeeID int,
	ActivityName varchar(100),
	ScheduleDate date,
	StartDate datetime,
	EndDate datetime
);


-- Schedule for 1, 9:00 am - 6:00 pm (11:00 - 11:15 Break, 1:00 - 1:30 Lunch, 4:00 - 4:15 Break)

INSERT INTO dbo.PlannedActivities
(EmployeeID,ActivityName,ScheduleDate,StartDate,EndDate) 
VALUES
(1,'Working','2024-08-03','2024-08-03 9:00','2024-08-03 11:00'),
(1,'Break','2024-08-03','2024-08-03 11:00','2024-08-03 11:15'),
(1,'Working','2024-08-03','2024-08-03 11:15','2024-08-03 13:00'),
(1,'Lunch','2024-08-03','2024-08-03 13:00','2024-08-03 13:30'),
(1,'Working','2024-08-03','2024-08-03 13:30','2024-08-03 16:00'),
(1,'Break','2024-08-03','2024-08-03 16:00','2024-08-03 16:15'),
(1,'Working','2024-08-03','2024-08-03 16:15','2024-08-03 18:00');


-- Schedule for 2, 9:00 am - 6:00 pm (11:00 - 11:15 Break, 1:00 - 1:30 Lunch, 4:00 - 4:15 Break)

INSERT INTO dbo.PlannedActivities
(EmployeeID,ActivityName,ScheduleDate,StartDate,EndDate) 
VALUES
(2,'Working','2024-08-03','2024-08-03 9:00','2024-08-03 11:00'),
(2,'Break','2024-08-03','2024-08-03 11:00','2024-08-03 11:15'),
(2,'Working','2024-08-03','2024-08-03 11:15','2024-08-03 13:00'),
(2,'Lunch','2024-08-03','2024-08-03 13:00','2024-08-03 13:30'),
(2,'Working','2024-08-03','2024-08-03 13:30','2024-08-03 16:00'),
(2,'Break','2024-08-03','2024-08-03 16:00','2024-08-03 16:15'),
(2,'Working','2024-08-03','2024-08-03 16:15','2024-08-03 18:00');

-- Schedule for 3, 18:00 pm - 3:00 am (20:00 - 20:15 Break, 22:00 - 22:30 Lunch, 1:00 - 1:15 Break)
INSERT INTO dbo.PlannedActivities
(EmployeeID,ActivityName,ScheduleDate,StartDate,EndDate) 
VALUES
(3,'Working','2024-08-03','2024-08-03 18:00','2024-08-03 20:00'),
(3,'Break','2024-08-03','2024-08-03 20:00','2024-08-03 20:15'),
(3,'Working','2024-08-03','2024-08-03 20:15','2024-08-03 22:00'),
(3,'Lunch','2024-08-03','2024-08-03 22:00','2024-08-03 22:30'),
(3,'Working','2024-08-03','2024-08-03 20:30','2024-08-04 1:00'),
(3,'Break','2024-08-03','2024-08-04 1:00','2024-08-04 1:15'),
(3,'Working','2024-08-03','2024-08-04 1:15','2024-08-04 3:00');


--------Get Total Time of all Activities--------------

-- 1 : Query to get all activites
Select * from dbo.PlannedActivities;


-- 2 : Get time of each activity (EndDate - StartDate) in Minutes
Select DATEDIFF(Minute,StartDate,EndDate) As Minutes,EmployeeID,StartDate,EndDate,ActivityName from dbo.PlannedActivities;

-- 3: Get Sum of all Differences 
Select Sum(DATEDIFF(Minute,StartDate,EndDate)) As Sum from dbo.PlannedActivities;

-------Get Total Time Activity Wise--------------
Select ActivityName,Sum(DATEDIFF(Minute,StartDate,EndDate)) As TotalSum from dbo.PlannedActivities
Group By ActivityName;

------Get Total Time Acitivity Wise for each Employee----------
Select EmployeeID,ActivityName,Sum(DATEDIFF(Minute,StartDate,EndDate)) As TotalSum from dbo.PlannedActivities
Group By ActivityName,EmployeeID;

----------------------------------------------------------------------------------------------

CREATE DATABASE ScheduleManagement;
USE ScheduleManagement;

------------------------------

CREATE TABLE dbo.ActivityType 
(
	ActivityTypeID tinyint primary key,
	ActivityType varchar(20)
);

INSERT INTO dbo.ActivityType (ActivityTypeID,ActivityType) 
VALUES
(1,'Break'),(2,'Lunch'),(3,'Training');

------------------------------

CREATE TABLE dbo.Employee
(
	EmpID int primary key,
	EmpName varchar(50) NOT NULL,
	Email varchar(30) NOT NULL
)

INSERT INTO dbo.Employee (EmpID,EmpName,Email) VALUES
(1,'Sana','sana@gmail.com'),
(2,'Amna','amna@gmail.com'),
(3,'Laraib','laraib@gmail.com'),
(4,'Mariam','mariam@gmail.com'),
(5,'Meerab','meearb@gmail.com'),
(6,'Ali','ali@gmail.com');

--------------------------------

CREATE TABLE dbo.EmpSchedules
(
	ScheduleID bigint identity(1,1) primary key,
	EmployeeId int NOT NULL,
	ScheduleDate date NOT NULL,
	StartTime datetime,
	EndTime datetime
);
--------------------------------

CREATE TABLE dbo.EmpScheduleActivities
(
	SchActID bigint identity(1,1) primary key,
	ScheduleID bigint,
	ActivityTypeID tinyint,
	StartTime datetime,
	EndTime datetime
);
-----------------Import Data from our ExternalDB to Main DB------------------------------

SELECT EmployeeID,ScheduleDate,Min(StartDate),Max(EndDate)
FROM ExternalDB.dbo.PlannedActivities
GROUP BY EmployeeID,ScheduleDate;

----------Load Data in temp Table and use for Schedule and Activities------------

CREATE TABLE #TempActivities
(
	EmployeeID int,
	ActivityName varchar(100),
	ScheduleDate date,
	StartDate datetime,
	EndDate datetime
);

INSERT INTO #TempActivities(EmployeeID,ActivityName,ScheduleDate,StartDate,EndDate)
SELECT EmployeeID,ActivityName,ScheduleDate,StartDate,EndDate
FROM ExternalDB.dbo.PlannedActivities

Select * from #TempActivities;

SELECT EmployeeID,ScheduleDate,Min(StartDate),Max(EndDate)
FROM #TempActivities
GROUP BY EmployeeID,ScheduleDate

--Now add Schedules in Schedules TABLE
INSERT INTO dbo.EmpSchedules (EmployeeId,ScheduleDate,StartTime,EndTime)
SELECT EmployeeID,ScheduleDate,Min(StartDate),Max(EndDate)
FROM #TempActivities
GROUP BY EmployeeID,ScheduleDate

Select * from EmpSchedules;


Select * from dbo.ActivityType;

--Now remove 'working' activities from #TempActivities

DELETE FROM #TempActivities WHERE ActivityName='Working';
UPDATE #TempActivities SET ActivityName='1' WHERE ActivityName='Break';
UPDATE #TempActivities SET ActivityName='2' WHERE ActivityName='Lunch';
UPDATE #TempActivities SET ActivityName='3' WHERE ActivityName='Training';

Select * from EmpSchedules;
Select * from #TempActivities;

Select s.ScheduleID,t.StartDate,t.EndDate,t.ActivityName
FROM #TempActivities t INNER JOIN EmpSchedules s
ON t.ScheduleDate = s.ScheduleDate And t.EmployeeID = s.EmployeeId;


-- ADD Result Of Join in EmpScheduleActivities Which is our Main Table
INSERT INTO EmpScheduleActivities (ScheduleID,StartTime,EndTime,ActivityTypeID)
Select s.ScheduleID,t.StartDate,t.EndDate,t.ActivityName
FROM #TempActivities t INNER JOIN EmpSchedules s
ON t.ScheduleDate = s.ScheduleDate And t.EmployeeID = s.EmployeeId;

--------RESULT OF THIS PROJECT----------
SELECT * FROM EmpScheduleActivities;


--------CREATE VIEW For Displaying Information OF Employees by JOINS---------------

CREATE VIEW dbo.EmployeeSchedulewithActivities
AS
Select s.ScheduleID,s.EmployeeID,e.EmpName,s.ScheduleDate,s.StartTime,
s.EndTime,ac.ActivityType,sa.StartTime as ActStartTime,sa.EndTime as ActEndTime
From dbo.EmpSchedules s
LEFT JOIN dbo.EmpScheduleActivities sa on s.ScheduleID = sa.ScheduleID
INNER JOIN dbo.ActivityType ac on sa.ActivityTypeID=ac.ActivityTypeID
INNER JOIN dbo.Employee e on s.EmployeeId=e.EmpID;


Select * from dbo.EmployeeSchedulewithActivities;