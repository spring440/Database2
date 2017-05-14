/*------------------------------------------------------------------------------------
	COMP440 - Mushkatblat										Mike Phillips
	SPRING 2017				Term Project - SQL Saturday			   00984-1886
--------------------------------------------------------------------------------------
	Concise Backup script
	info found at
	https://docs.microsoft.com/en-us/sql/relational-databases/backup-restore/create-a-full-database-backup-sql-server
*/------------------------------------------------------------------------------------

USE s17guest02;
GO

BACKUP DATABASE s17guest02
    TO DISK = 'c:\SQL_DB_Backups\s17guest02.Bak'
      WITH NAME = 's17guest02 Backup';
GO