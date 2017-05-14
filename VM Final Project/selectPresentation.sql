/*------------------------------------------------------------------------------------
	COMP440 - Mushkatblat										Mike Phillips
	SPRING 2017				Term Project - SQL Saturday			   00984-1886
--------------------------------------------------------------------------------------
	Stored procedure that selects presentations according to city, ordered by Track

	INPUT: 
	EXEC selectPresentation 'Budapest'
*/------------------------------------------------------------------------------------


/*-----------------------------------------------------------------------------------
	Housekeeping
*/-----------------------------------------------------------------------------------
IF OBJECT_ID('dbo.selectPresentation', 'P') IS NOT NULL 
	DROP PROCEDURE selectPresentation;
GO
/*-----------------------------------------------------------------------------------
	Procedure
*/-----------------------------------------------------------------------------------
CREATE PROCEDURE selectPresentation
	@city		NVARCHAR(100)

	AS
	BEGIN
		BEGIN TRY
			SELECT FirstName,LastName,ClassTitle,Designation,Track DESC
				FROM Attendees,Class,SQLSatEvents 
				WHERE Designation LIKE @city + '%'
				ORDER BY Track;
				
	    END TRY
	    BEGIN CATCH
	      SELECT ERROR_MESSAGE() AS ErrorMessage;
	    END CATCH
	  END

