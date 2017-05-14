/*------------------------------------------------------------------------------------
	COMP440 - Mushkatblat										Mike Phillips
	SPRING 2017				Term Project - SQL Saturday			   00984-1886
--------------------------------------------------------------------------------------
	Stored procedure that inserts presentations and speakers into the SQLSatDB.

	INPUT: 
	EXEC insertPresentation @Speaker_FirstName,@Speaker_LastName,@PresentationTitle
*/------------------------------------------------------------------------------------


/*-----------------------------------------------------------------------------------
	Housekeeping -Drop existing constraints and tables
*/-----------------------------------------------------------------------------------

IF OBJECT_ID('dbo.insertPresentation', 'P') IS NOT NULL 
	DROP PROCEDURE insertPresentation;
GO

/*-----------------------------------------------------------------------------------
	Procedure
*/-----------------------------------------------------------------------------------

USE s17guest02
GO

CREATE PROCEDURE insertPresentation
	@firstName	NVARCHAR(35),
	@lastName	NVARCHAR(35),
	@title		NVARCHAR(100)

	AS
	BEGIN
		BEGIN TRY

			INSERT Class (ClassTitle) VALUES (@title)			
			--If the name already exists, just insert the class
			IF EXISTS (SELECT * FROM Attendees WHERE FirstName=@firstName AND LastName=@lastName)

				BEGIN
					INSERT AttendeeClassRelation
						VALUES(
							(SELECT TOP 1 ClassID FROM Class ORDER BY ClassID DESC),
							(SELECT PersonID FROM Attendees WHERE FirstName=@firstName AND LastName=@lastName)
						);
				END

			ELSE -- Name didn't exist in the DB, so add both the name and the class

				BEGIN
					INSERT Attendees (FirstName, LastName) VALUES (@firstName, @lastName)
					INSERT AttendeeRoleRelation 
						VALUES(
							(SELECT TOP 1 PersonID FROM Attendees ORDER BY PersonID DESC),
							(SELECT RoleID FROM EventRole WHERE RoleName='Presenter')
						);

					INSERT AttendeeClassRelation 
						VALUES(
							(SELECT TOP 1 ClassID FROM Class ORDER BY ClassID DESC),
							(SELECT TOP 1 PersonID FROM Attendees ORDER BY PersonID DESC)
						);
				END
				
		END TRY
		BEGIN CATCH
			--SELECT ERROR_MESSAGE() AS ErrorMessage;
		END CATCH
	END
