
--Setting up tables
	--CREATE TABLE FamilySecretSanta.dbo.FamilyKey (
	--FamID int IDENTITY (1,1) not NULL PRIMARY KEY,
	--FamName varchar(50) not NULL
	--);

	--INSERT INTO FamilySecretSanta.dbo.FamilyKey VALUES
	--('Currie'),
	--('Rose'),
	--('Singles'),
	--('Schitt');

	--CREATE TABLE FamilySecretSanta.dbo.People (
	--PersonID int IDENTITY (1,1) not NULL PRIMARY KEY,
	--PersonName varchar(225) not NULL,
	--FamID int FOREIGN KEY REFERENCES FamilySecretSanta.dbo.FamilyKey(FamID)
	--);


	--INSERT INTO FamilySecretSanta.dbo.People VALUES
	--('Bob Currie', 1),
	--('Gwen Currie', 1),
	--('Johnny Rose', 2),
	--('Moira Rose', 2),
	--('Alexis Rose', 2),
	--('David Rose', 2),
	--('Ted Mullens', 2),
	--('Patrick Brewer', 2),
	--('Twylas Sands', 3),
	--('Ray Butani', 3),
	--('Ronnie Lee', 3),
	--('Wendy Kurtz', 3),
	--('Roland Schitt', 4),
	--('Jocelyn Schitt', 4),
	--('Mutt Schitt', 4),
	--('Stevie Budd', 4);

	--SELECT FamilyKey.FamID,
	--FamilyKey.FamName,
	--People.PersonID,
	--People.PersonName
	--from FamilySecretSanta.dbo.FamilyKey FULL OUTER JOIN FamilySecretSanta.dbo.People
	--on FamilyKey.FamID = People.FamID;

	--CREATE TABLE FamilySecretSanta.dbo.Assignments (
	--Giver varchar(225) not NULL,
	--Receiver varchar(225) not NULL
	--);

	--Alter table FamilySecretSanta.dbo.Assignments 
	--alter column Giver int 
	--ADD foreign key (Giver) references FamilySecretSanta.dbo.People(PersonID)


	--DECLARE @FamIDVariable int, 
	--@GiverVariable int,
	--@ReceiverVariable int

--Fill Assignments Table
WHILE (SELECT COUNT(*) FROM FamilySecretSanta..Assignments) < (SELECT COUNT(*) FROM FamilySecretSanta..People)
BEGIN 

	--Select Giver
	SET @GiverVariable =(SELECT TOP 1 PersonID from FamilySecretSanta.dbo.People
	WHERE PersonID NOT IN (SELECT Giver from FamilySecretSanta.dbo.Assignments) 
	ORDER BY NEWID())

	SET @FamIDVariable = (SELECT FamID FROM FamilySecretSanta.dbo.People
	WHERE PersonID = @GiverVariable)


	--Select Receiver
	SET @ReceiverVariable = (SELECT TOP 1 PersonID from FamilySecretSanta.dbo.People
	WHERE PersonID NOT IN (SELECT Receiver from FamilySecretSanta.dbo.Assignments) AND FamID <> @FamIDVariable
	ORDER BY NEWID())

	----Insert into Assignments Table
	INSERT INTO FamilySecretSanta.dbo.Assignments (Giver, Receiver) VALUES (@GiverVariable, @ReceiverVariable)

END

SELECT p1.PersonName, p2.PersonName
FROM FamilySecretSanta..Assignments a 
INNER JOIN FamilySecretSanta..People p1
ON a.Giver = p1.PersonID
INNER JOIN FamilySecretSanta..People p2
ON a.Receiver = p2.PersonID
