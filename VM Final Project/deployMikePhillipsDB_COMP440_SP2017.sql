/*------------------------------------------------------------------------------------
	COMP440 - Mushkatblat										Mike Phillips
	SPRING 2017				Term Project - SQL Saturday			   00984-1886
--------------------------------------------------------------------------------------
	Stored procedure that deploys deployMikePhillipsDB_COMP440_SP2017

	INPUT: 
	EXEC deployMikePhillipsDB_COMP440_SP2017
*/------------------------------------------------------------------------------------


/*-----------------------------------------------------------------------------------
	Housekeeping
*/-----------------------------------------------------------------------------------
IF OBJECT_ID('dbo.deployMikePhillipsDB_COMP440_SP2017', 'P') IS NOT NULL 
	DROP PROCEDURE deployMikePhillipsDB_COMP440_SP2017;
GO

/*-----------------------------------------------------------------------------------
	Procedure
*/-----------------------------------------------------------------------------------
CREATE PROCEDURE deployMikePhillipsDB_COMP440_SP2017
	AS
	BEGIN

	SET NOCOUNT ON;
/*-----------------------------------------------------------------------------------
	This database keeps track of SQL Saturday events, alogn with attendees who have 
	registered for SQL Saturday events. Personal information is stored along with the
	role they will serve at the event.
*/-----------------------------------------------------------------------------------
/*-----------------------------------------------------------------------------------
	Housekeeping -Drop existing FK constraints and tables
*/-----------------------------------------------------------------------------------

IF OBJECT_ID('dbo.AttendeeRoleRelation', 'U') IS NOT NULL DROP TABLE AttendeeRoleRelation;
IF OBJECT_ID('dbo.AttendeeClassRelation', 'U') IS NOT NULL DROP TABLE AttendeeClassRelation;

IF OBJECT_ID('dbo.Sponsors', 'U') IS NOT NULL DROP TABLE Sponsors;
IF OBJECT_ID('dbo.SQLSatEvents', 'U') IS NOT NULL DROP TABLE SQLSatEvents;
IF OBJECT_ID('dbo.EventRole', 'U') IS NOT NULL DROP TABLE EventRole; 
IF OBJECT_ID('dbo.Class', 'U') IS NOT NULL DROP TABLE Class;
IF OBJECT_ID('dbo.Attendees', 'U') IS NOT NULL DROP TABLE Attendees;

/*-----------------------------------------------------------------------------------
	Build Entity Tables 
*/-----------------------------------------------------------------------------------

CREATE TABLE Attendees(
	PersonID	 INT			NOT NULL IDENTITY(1,1) PRIMARY KEY,
	FirstName	 NVARCHAR(35)	NOT NULL,
	LastName	 NVARCHAR(35)	NOT NULL,
	Street1		 NVARCHAR(125),
	Street2		 NVARCHAR(75),
	City		 NVARCHAR(100),
	ZIP			 VARCHAR(12),	--See note below about BCNF
	St			 NVARCHAR(100),	--State or Province	
	EmailAddress VARCHAR(75),
	
	UNIQUE(FirstName,LastName)	-- This should prevent duplicate entries 
);
-- Street, City, State could all be bound to zip code with transitive dependency.
-- We could put the address in a ZIP(PK) table if we needed further normalization,
-- but we'll leave the address in the attendee registration table for simplicity.

CREATE TABLE SQLSatEvents(
	EventID	 	INT				NOT NULL PRIMARY KEY,
	Designation	NVARCHAR(50)	NOT NULL,
	Region		NVARCHAR(25)	NOT NULL,
	EventDate	VARCHAR(11)		NOT NULL,
);

CREATE TABLE EventRole(
	RoleID		INT				NOT NULL IDENTITY(1,1) PRIMARY KEY,
	RoleName	VARCHAR(20),
);

CREATE TABLE Class(
	ClassID				INT	NOT NULL IDENTITY(1,1) PRIMARY KEY,
	ClassTitle			NVARCHAR(100) NOT NULL,
	--ClassDesc			VARCHAR(200),
	Lvl					NVARCHAR(13), -- Beg, Int, Adv, Non-Technical
	EventLocationID		INT,
	Room				NVARCHAR(25),
	Duration			VARCHAR(19), -- Instead of an INT for duration in minutes, 
									 -- we will store the duration string 
									 -- i.e. "09:00 AM - 10:00 AM"
	Track				VARCHAR(75), -- Target audience
);

CREATE TABLE Sponsors(
	SponsorID	INT	NOT NULL IDENTITY(1,1) PRIMARY KEY,
	SponsorName	VARCHAR(50) NOT NULL,
	SponsorLvl	VARCHAR(8),
);

/*-----------------------------------------------------------------------------------
	Build Relational Tables
*/-----------------------------------------------------------------------------------

CREATE TABLE AttendeeRoleRelation(
	AttendeeID  INT NOT NULL FOREIGN KEY REFERENCES Attendees(PersonID),
	RoleID		INT NOT NULL FOREIGN KEY REFERENCES EventRole(RoleID),

	UNIQUE(AttendeeID,RoleID)	-- This should prevent duplicate entries
);

CREATE TABLE AttendeeClassRelation(
	AttendeeID  INT NOT NULL FOREIGN KEY REFERENCES Attendees(PersonID),
	ClassID		INT NOT NULL FOREIGN KEY REFERENCES Class(ClassID),

	UNIQUE(AttendeeID,ClassID)	-- This should prevent duplicate entries
);



/*-----------------------------------------------------------------------------------
	Populate data 
*/-----------------------------------------------------------------------------------

INSERT Attendees (FirstName,LastName,Street1,Street2,City,ZIP,St,EmailAddress) 
	VALUES
	 ('Amanda','Long','10 Napa Ct.','','Lebanon','97355','Oregon','ALong@gmail.com'),
	 ('Christian','Shan','1000 Bidweld Street','','Haney','V2W 1W2','British Columbia','CShan@gmail.com'),
	 ('Troy','Sara','1002 N. Spoonwood Court','','Hervey Bay','4655','Queensland','TSara@gmail.com'),
	 ('Kaitlyn','Baker','1003 Matterhorn Ct','','Lebanon','97355','Oregon','KBaker@gmail.com'),
	 ('Suzanne','Ma','1005 Matterhorn Ct.','','Cambridge','CB4 4BZ','England','SMa@gmail.com'),
	 ('Anna','Jones','1005 Matterhorn Ct.','','Mill Valley','94941','California','AJones@gmail.com'),
	 ('Carlos','Baker','1005 Tanager Court','','Corvallis','97330','Oregon','CBaker@gmail.com'),
	 ('Tanya','Munoz','1005 Tanager Court','','Milsons Point','2061','New South Wales','TMunoz@gmail.com'),
	 ('Tabitha','Gill','1006 Deercreek Ln','','Bellflower','90706','California','TGill@gmail.com'),
	 ('Alexis','Lee','1006 Deercreek Ln','','Torrance','90505','California','ALee@gmail.com'),
	 ('Erick','Suri','101 Adobe Dr','','Coffs Harbour','2450','New South Wales','ESuri@gmail.com'),
	 ('Marcus','Evans','101 Adobe Dr','','Puyallup','98371','Washington','MEvans@gmail.com'),
	 ('Marcus','Clark','101, avenue de la Gare','','Peterborough','PB12','England','MClark@gmail.com'),
	 ('Gilbert','Xu','1010 Maple','','Baltimore','21201','Maryland','GXu@gmail.com'),
	 ('Paula','Rubio','1011 Yolanda Circle','','Berkeley','94704','California','PRubio@gmail.com'),
	 ('Julian','Isla','1011 Yolanda Circle','','N. Vancouver','V7L 4J4','British Columbia','JIsla@gmail.com'),
	 ('Jesse','Scott','1013 Holiday Hills Dr.','','Bremerton','98312','Washington','JScott@gmail.com'),
	 ('Naomi','Sanz','1013 Holiday Hills Dr.','','Gateshead','GA10','England','NSanz@gmail.com'),
	 ('Isabella','Lee','1015 Lynwood Drive','','Metchosin','V9','British Columbia','ILee@gmail.com'),
	 ('Dawn','Yuan','1019 Carletto Drive','','Berkeley','94704','California','DYuan@gmail.com'),
	 ('Olivia','Blue','1019 Mt. Davidson Court','','Burien','98168','Washington','OBlue@gmail.com'),
	 ('Emmanuel','Lopez','1019 Mt. Davidson Court','','London','SW8 4BG','England','ELopez@gmail.com'),
	 ('Nathan','Yang','102 Vista Place','','Santa Monica','90401','California','NYang@gmail.com'),
	 ('Gabrielle','Wood','1020 Book Road','','Bremerton','98312','Washington','GWood@gmail.com'),
	 ('Katrina','Anand','1020 Carletto Drive','','Matraville','2036','New South Wales','KAnand@gmail.com'),
	 ('Anthony','Jones','1020 Carletto Drive','','Santa Cruz','95062','California','AJones@gmail.com'),
	 ('Natalie','Reed','1023 Hawkins Street','','Lebanon','97355','Oregon','NReed@gmail.com'),
	 ('Dakota','Ross','1024 Walnut Blvd.','','Colma','94014','California','DRoss@gmail.com'),
	 ('Shawn','Goel','1025 Holly Oak Drive','','Leeds','LE18','England','SGoel@gmail.com'),
	 ('Nicole','Diaz','1025 R St.','','Kirkland','98033','Washington','NDiaz@gmail.com'),
	 ('Wyatt','Davis','1025 Yosemite Dr.','','Oregon City','97045','Oregon','WDavis@gmail.com'),
	 ('Christy','Huang','1028 Green View Court','','Chula Vista','91910','California','CHuang@gmail.com'),
	 ('Sydney','Evans','1028 Green View Court','','Oregon City','97045','Oregon','SEvans@gmail.com'),
	 ('Katherine','Baker','1037 Hayes Court','','Stoke-on-Trent','AS23','England','KBaker@gmail.com'),
	 ('Edward','Wood','1039 Adelaide St.','','West Covina','91791','California','EWood@gmail.com'),
	 ('Johnny','Rai','104 Hilltop Dr.','','Springwood','2777','New South Wales','JRai@gmail.com'),
	 ('Emily','Moore','104 Kaski Ln.','','Portland','97205','Oregon','EMoore@gmail.com'),
	 ('Randy','Yang','1040 Greenbush Drive','','Silverwater','2264','New South Wales','RYang@gmail.com'),
	 ('Roy','Ruiz','1040 Northridge Road','','London','W1X3SE','England','RRuiz@gmail.com'),
	 ('Marshall','Sun','1044 San Carlos','','Cincinnati','45202','Ohio','MSun@gmail.com'),
	 ('Gabriella','Perez','1045 Lolita Drive','','Torrance','90505','California','GPerez@gmail.com'),
	 ('Erika','Gill','1045 Lolita Drive','','Townsville','4810','Queensland','EGill@gmail.com'),
	 ('Kathryn','Shen','1047 Las Quebradas Lane','','North Sydney','2055','New South Wales','KShen@gmail.com'),
	 ('Sharon','Yuan','1048 Burwood Way','','Hervey Bay','4655','Queensland','SYuan@gmail.com'),
	 ('Victoria','Lee','1048 Las Quebradas Lane','','Walla Walla','99362','Washington','VLee@gmail.com'),
	 ('Brenda','Arun','1048 Las Quebradas Lane','','Wollongong','2500','New South Wales','BArun@gmail.com'),
	 ('Alex','Scott','105 Clark Creek Lane','','Port Macquarie','2444','New South Wales','AScott@gmail.com'),
	 ('Yolanda','Luo','105 Woodruff Ln.','','Bellingham','98225','Washington','YLuo@gmail.com'),
	 ('Martin','Vance','1050 Creed Ave','','London','W10 6BL','England','MVance@gmail.com'),
	 ('Jeremy','Roberts','081, boulevard du Montparnasse','','Seattle','98104','Washington','JRoberts@yahoo.com'),
	 ('Amanda','Ramirez','1 Smiling Tree Court','Space 55','Los Angeles','90012','California','ARamirez@yahoo.com'),
	 ('Jada','Nelson','100, rue des Rosiers','','Everett','98201','Washington','JNelson@yahoo.com'),
	 ('Hunter','Wright','1002 N. Spoonwood Court','','Berkeley','94704','California','HWright@yahoo.com'),
	 ('Sierra','Wright','1005 Fremont Street','','Colma','94014','California','SWright@yahoo.com'),
	 ('Sarah','Simmons','1005 Valley Oak Plaza','','Langley','V3A 4R2','British Columbia','SSimmons@yahoo.com'),
	 ('Mandar','Samant','1005 Valley Oak Plaza','','London','SW6 SBY','England','MSamant@yahoo.com'),
	 ('Isaiah','Rogers','1007 Cardinet Dr.','','El Cajon','92020','California','IRogers@yahoo.com'),
	 ('Ian','Foster','1008 Lydia Lane','','Burbank','91502','California','IFoster@yahoo.com'),
	 ('Ben','Miller','101 Candy Rd.','','Redmond','98052','Washington','BMiller@yahoo.com'),
	 ('Sarah','Barnes','1011 Green St.','','Bellingham','98225','Washington','SBarnes@yahoo.com'),
	 ('Casey','Martin','1013 Buchanan Rd','','Port Macquarie','2444','New South Wales','CMartin@yahoo.com'),
	 ('Victoria','Murphy','1013 Buchanan Rd','','Yakima','98901','Washington','VMurphy@yahoo.com'),
	 ('Sydney','Rogers','1016 Park Avenue','','Burbank','91502','California','SRogers@yahoo.com'),
	 ('Marvin','Hernandez','1019 Book Road','','Rhodes','2138','New South Wales','MHernandez@yahoo.com'),
	 ('Carlos','Carter','1019 Buchanan Road','','Woodland Hills','91364','California','CCarter@yahoo.com'),
	 ('Rebekah','Garcia','1019 Candy Rd.','','Coffs Harbour','2450','New South Wales','RGarcia@yahoo.com'),
	 ('Haley','Henderson','1019 Chance Drive','','Sedro Woolley','98284','Washington','HHenderson@yahoo.com'),
	 ('Jacob','Taylor','1019 Kenwal Rd.','','Lake Oswego','97034','Oregon','JTaylor@yahoo.com'),
	 ('Seth','Martin','1019 Pennsylvania Blvd','','Marysville','98270','Washington','SMartin@yahoo.com'),
	 ('Larry','Suarez','102 Vista Place','','Milton Keynes','MK8 8DF','England','LSuarez@yahoo.com'),
	 ('Garrett','Vargas','10203 Acorn Avenue','','Calgary','T2P 2G8','Alberta','GVargas@yahoo.com'),
	 ('Abby','Martinez','1023 Hawkins Street','','Townsville','4810','Queensland','AMartinez@yahoo.com'),
	 ('Justin','Thomas','1023 Riveria Way','','Burbank','91502','California','JThomas@yahoo.com'),
	 ('Evelyn','Martinez','1023 Riviera Way','','Oxford','OX1','England','EMartinez@yahoo.com'),
	 ('Pamela','Chapman','1025 Yosemite Dr.','','Townsville','4810','Queensland','PChapman@yahoo.com'),
	 ('Kayla','Griffin','1026 Mt. Wilson Pl.','','Lynnwood','98036','Washington','KGriffin@yahoo.com'),
	 ('Jill','Navarro','1026 Mt. Wilson Pl.','','South Melbourne','3205','Victoria','JNavarro@yahoo.com'),
	 ('Nathan','Walker','1028 Indigo Ct.','','Issaquah','98027','Washington','NWalker@yahoo.com'),
	 ('Tabitha','Moreno','1028 Indigo Ct.','','Warrnambool','3280','Victoria','TMoreno@yahoo.com'),
	 ('Mason','Sanchez','1028 Royal Oak Rd.','','Burlingame','94010','California','MSanchez@yahoo.com'),
	 ('Natasha','Navarro','1029 Birchwood Dr','','Burien','98168','Washington','NNavarro@yahoo.com'),
	 ('Kevin','Russell','1029 Birchwood Dr','','Olympia','98501','Washington','KRussell@yahoo.com'),
	 ('Katelyn','Rivera','1030 Ambush Dr.','','Bury','PE17','England','KRivera@yahoo.com'),
	 ('Alfredo','Ortega','1032 Buena Vista','','North Ryde','2113','New South Wales','AOrtega@yahoo.com'),
	 ('Andrea','Campbell','1032 Coats Road','','Stoke-on-Trent','AS23','England','ACampbell@yahoo.com'),
	 ('Jeremy','Peterson','1035 Arguello Blvd.','','San Diego','92102','California','JPeterson@yahoo.com'),
	 ('Arianna','Ramirez','1036 Mason Dr','','Port Orchard','98366','Washington','ARamirez@yahoo.com'),
	 ('Mario','Sharma','1039 Adelaide St.','','Port Macquarie','2444','New South Wales','MSharma@yahoo.com'),
	 ('Adam','Collins','104 Hilltop Dr.','','Concord','94519','California','ACollins@yahoo.com'),
	 ('Taylor','Martin','1040 Greenbush Drive','','Newton','V2L3W8','British Columbia','TMartin@yahoo.com'),
	 ('Gabriel','Collins','1040 Northridge Road','','Woodland Hills','91364','California','GCollins@yahoo.com'),
	 ('Randall','Martin','1042 Hooftrail Way','','Newcastle','2300','New South Wales','RMartin@yahoo.com'),
	 ('Samantha','Jenkins','1046 Cloverleaf Circle','','Shawnee','V8Z 4N5','British Columbia','SJenkins@yahoo.com'),
	 ('Justin','Simmons','1046 San Carlos Avenue','','Colma','94014','California','JSimmons@yahoo.com'),
	 ('Ethan','Winston','1047 Las Quebradas Lane','','Oak Bay','V8P','British Columbia','EWinston@yahoo.com'),
	 ('Hunter','Roberts','1048 Burwood Way','','Haney','V2W 1W2','British Columbia','HRoberts@yahoo.com'),
	 ('Nathaniel','Murphy','105 Woodruff Ln.','','Oakland','94611','California','NMurphy@yahoo.com'),
	 ('Charles','Wilson','1050 Creed Ave','','Lebanon','97355','Oregon','CWilson@yahoo.com'),
	 ('Carrie','Alvarez','1050 Greenhills Circle','','Lane Cove','1597','New South Wales','CAlvarez@yahoo.com'),
	 ('Paige','Alexander','1050 Greenhills Circle','','Langley','V3A 4R2','British Columbia','PAlexander@yahoo.com');

INSERT SQLSatEvents (EventID,Designation,Region,EventDate)
	VALUES
	(626,'Budapest 2017','Europe/Middle East/Africa','2017-May-06'),
	(615,'Baltimore 2017','Canada/US','2017-May-06'),
	(608,'Bogota 2017','Latin America','2017-May-13'),
	(616,'Kyiv 2017','Europe/Middle East/Africa','2017-May-20'),
	(588,'New York City 2017','Canada/US','2017-May-20'),
	(630,'Brisbane 2017','Asia Pacific','2017-May-27'),
	(599,'Plovdiv 2017','Europe/Middle East/Africa','2017-May-27'),
	(638,'Philadelphia 2017','Canada/US','2017-Jun-03');

INSERT EventRole (RoleName) 
	VALUES 
	('Organizer'),
	('Presenter'),
	('Student'),
	('Sponsor'),
	('Volunteer');

-- Items posted on Moodle
INSERT Class (ClassTitle,Lvl,EventLocationID,Room,Duration,Track)
	VALUES
	('A dive into Data Quality Services','Intermediate',588,'Marquis(5-18)','01:05 PM -02:15 PM','BI'),
	('A Dynamic World Demands Dynamic SQL','Intermediate',616,'','',''),
	('A Dynamic World Demands Dynamic SQL','Intermediate',616,'','',''),
	('Absolute Introductory Session on SQL Server 2014 In-Memory Optimized Databases (Hekaton)','Beginner',626,'','',''),
	('AlwaysOn: Improve reliability and reporting performance with one cool tech','Beginner',588,'','',''),
	('An introduction to Data Mining','Intermediate',616,'','',''),
	('An Introduction to Database Design','Beginner',588,'','',''),
	('Autogenerating a process data warehouse','Advanced',588,'','',''),
	('Automate your daily checklist with PBM and CMS','Intermediate',626,'','',''),
	('Automated Installing and Configuration of SQL2014/SQL2012 AlwaysOn Across Multiple Datacenters','Intermediate',588,'','',''),
	('Automated Installing and Configuration of SQL2014/SQL2012 AlwaysOn Across Multiple Datacenters','Intermediate',616,'','',''),
	('Automating Execution Plan Analysis','Advanced',616,'','',''),
	('Automating Execution Plan Analysis','Advanced',588,'','',''),
	('Automating SQL Server using PowerShell','Intermediate',588,'','',''),
	('Balanced Scorecards using SSRS','Intermediate',626,'','',''),
	('Baselines and Performance Monitoring with PAL','Beginner',588,'','',''),
	('Basic Database Design','Beginner',588,'','',''),
	('Basic Database Programming','Beginner',616,'','',''),
	('Become a BI Independent Consultant!','Beginner',626,'','',''),
	('Becoming a Top DBA--Learning Automation in SQL Server','Beginner',616,'','',''),
	('Best Practices Document','Intermediate',616,'','',''),
	('Best Practices for Efficient SSRS Report Creation','Beginner',588,'','',''),
	('Biggest Loser: Database Edition','Intermediate',588,'','',''),
	('Building a BI Solution in the Cloud','Intermediate',626,'','',''),
	('Building an Effective Data Warehouse Architecture','Beginner',588,'','',''),
	('Building an Effective Data Warehouse Architecture with the cloud and MPP','Beginner',588,'','',''),
	('Bulk load and minimal logged inserts','Advanced',588,'','',''),
	('Business Analytics with SQL Server & Power Map:Everything you want to know but were afraid to ask','Intermediate',588,'','',''),
	('Challenges to designing financial warehouses, lessons learnt','Intermediate',588,'','',''),
	('Change Data Capture in SQL Server 2008/2012','Intermediate',588,'','',''),
	('Changing Your Habits to Improve the Performance of Your T-SQL','Beginner',616,'','',''),
	('Clusters Your Way: #SANLess Clusters for Physical, Virtual, and Cloud Environments','Beginner',616,'','',''),
	('Clusters Your Way: #SANLess Clusters for Physical, Virtual, and Cloud Environments','Non-Technical',616,'','',''),
	('Coffee Break','Non-Technical',626,'','',''),
	('Creating A Performance Health Repository - using MDW','Beginner',616,'','',''),
	('Creating efficient and effective SSRS BI Solutions','Intermediate',616,'','',''),
	('Creating efficient and effective SSRS BI Solutions','Intermediate',588,'','',''),
	('Data Partitioning','Intermediate',588,'','',''),
	('Data Tier Application Testing with NUnit and Distributed Replay','Intermediate',588,'','',''),
	('Database design for mere developers','Intermediate',626,'','',''),
	('Database design for mere developers','Intermediate',588,'','',''),
	('Database Design: Solving Problems Before they Start!','Beginner',588,'','',''),
	('Database Modeling and Design','Intermediate',588,'','',''),
	('Database Virtualization and Drinking out of the Fire Hose','Intermediate',588,'','',''),
	('DAX and the tabular model','Intermediate',616,'','',''),
	('DBA FOR DUMMIES','Beginner',626,'','',''),
	('Dealing With Difficult People','Beginner',616,'','',''),
	('Development Lifecycle with SQL Server Data Tools and DACFx','Intermediate',616,'','',''),
	('Did You Vote Today? A DBAs Guide to Cluster Quorum','Advanced',616,'','',''),
	('Dimensional Modeling Design Patterns: Beyond Basics','Intermediate',616,'','',''),
	('Dimensional Modeling Design Patterns: Beyond Basics','Intermediate',626,'','',''),
	('Diving Into Query Execution Plans','Intermediate',588,'','',''),
	('Dynamic SQL: Writing Efficient Queries on the Fly','Beginner',616,'','',''),
	('Easy Architecture Design for HA and DR','Intermediate',588,'','',''),
	('Enhancing your career: Building your personal brand','Beginner',588,'','',''),
	('Establishing a SLA','Intermediate',588,'','',''),
	('ETL not ELT! Common mistakes and misconceptions about SSIS','Advanced',626,'','',''),
	('Event Kickoff and Networking','Non-Technical',588,'','',''),
	('Execution Plans: What Can You Do With Them?','Intermediate',588,'','',''),
	('Faster, Better Decisions with Self Service Business Analytics','Intermediate',588,'','',''),
	('Full Text Indexing Basics','Beginner',626,'','',''),
	('Get your Mining Model Predictions out to all','Intermediate',588,'','',''),
	('Getting a job with Microsoft','Non-Technical',588,'','',''),
	('Graph Databases for SQL Server Professionals','Intermediate',588,'','',''),
	('Hacking Exposé - Using SSL to Protect SQL Connections','Intermediate',588,'','',''),
	('Hacking the SSIS 2012 Catalog','Beginner',626,'','',''),
	('Hidden in plain sight: master your tools','Intermediate',588,'','',''),
	('Highly Available SQL Server in Windows Azure IaaS','Intermediate',588,'','',''),
	('How to Make a LOT More Money as a Consultant','Beginner',588,'','',''),
	('How to Think Like the Engine','Intermediate',588,'','',''),
	('Hybrid Cloud Scenarios with SQL Server 2014','Intermediate',626,'','',''),
	('Hybrid Solutions: The Future of SQL Server Disaster Recovery','Intermediate',626,'','',''),
	('Implementing Data Warehouse Patterns with the Microsoft BI Tools','Intermediate',626,'','',''),
	('Inroduction to Triggers','Beginner',626,'','',''),
	('Integrating Reporting Services with SharePoint','Intermediate',588,'','',''),
	('Integration Services (SSIS) for the DBA','Intermediate',588,'','',''),
	('Introducing Power BI','Beginner',588,'','',''),
	('Introduction to Database Recovery','Beginner',588,'','',''),
	('Introduction to High Availability with SQL Server','Beginner',588,'','',''),
	('Introduction to Powershell for DBA''s','Beginner',588,'','',''),
	('Introduction to SQL Server - Part 1','Beginner',588,'','',''),
	('Introduction to SQL Server - Part 2','Beginner',588,'','',''),
	('Is That A Failover Cluster On Your Laptop/Desktop?','Intermediate',588,'','',''),
	('Leaving the Windows Open','Intermediate',588,'','',''),
	('Lunch Break','Non-Technical',588,'','',''),
	('Lunchtime Keynote','Non-Technical',588,'','',''),
	('Master Data Services Best Practices','Intermediate',588,'','',''),
	('Master Data Services Disaster Recovery','Intermediate',588,'','',''),
	('Mind your language!! Cursors are a dirty word','Intermediate',588,'','',''),
	('Modern Data Warehousing','Beginner',588,'','',''),
	('Monitoring Server health via Reporting Services dashboards','Intermediate',588,'','',''),
	('Monitoring SQL Server using Extended Events','Beginner',588,'Marquis(5-18)','02:25 PM -03:35 PM','Enterprise'),
	('Multidimensional vs Tabular - May the Best Model Win','Intermediate',588,'','',''),
	('Murder They Wrote','Intermediate',588,'','',''),
	('Never Have to Say "Mayday!!!" Again','Beginner',588,'','',''),
	('Now you see it! Now you don’t! Conjuring many reports utilizing only one SSRS report.','Intermediate',588,'','',''),
	('Optimal Infrastructure Strategies for Cisco UCS, Nexus and SQL Server','Non-Technical',626,'','',''),
	('Optimizing Protected Indexes','Intermediate',626,'','',''),
	('Partitioning as a design pattern','Advanced',626,'','',''),
	('Power BI Components in Microsoft''s Self-Service BI Suite','Beginner',588,'','',''),
	('Power to the people!!','Intermediate',616,'','',''),
	('PowerShell Basics for SQLServer','Beginner',616,'','',''),
	('PowerShell for the Reluctant DBA / Developer','Beginner',616,'','',''),
	('Prevent Recovery Amnesia – Forget the Backups','Beginner',616,'','',''),
	('Query Optimization Crash Course','Beginner',616,'','',''),
	('Raffle','Non-Technical',364,'','',''),
	('Rapid Application Development with Master Data Services','Intermediate',616,'','',''),
	('Recovery and Backup for Beginners','Beginner',616,'','',''),
	('Reduce, Reuse, Recycle: Automating Your BI Framework','Intermediate',616,'','',''),
	('Registrations','Non-Technical',364,'','',''),
	('Replicaton Technologies','Advanced',616,'','',''),
	('Reporting Services for Mere DBAs','Intermediate',616,'','',''),
	('Scaling with SQL Server Service Broker','Advanced',616,'','',''),
	('Scaling with SQL Server Service Broker','Advanced',616,'','',''),
	('Self-Service Data Integration with Power Query','Beginner',616,'','',''),
	('Shortcuts to Building SSIS in .Net','Beginner',616,'','',''),
	('So You Want To Be A Consultant?','Beginner',616,'','',''),
	('SQL anti patterns','Advanced',616,'','',''),
	('SQL Server 2012/2014 Columnstore index','Intermediate',616,'','',''),
	('SQL Server 2012/2014 Performance Tuning All Up','Intermediate',616,'','',''),
	('SQL Server 2014 Data Access Layers','Intermediate',616,'','',''),
	('SQL Server 2014 New Features','Intermediate',616,'','',''),
	('SQL Server AlwaysOn Availability Groups','Beginner',616,'','',''),
	('SQL Server and the Cloud','Beginner',616,'','',''),
	('SQL Server Compression and what it can do for you','Advanced',616,'','',''),
	('SQL Server Reporting Services 2014 on Steroids!!','Intermediate',616,'','',''),
	('SQL Server Reporting Services Best Practices','Intermediate',616,'','',''),
	('SQL Server Reporting Services, attendees choose','Intermediate',616,'','',''),
	('SQL Server Storage Engine under the hood','Intermediate',616,'','',''),
	('SQL Server Storage internals: Looking under the hood.','Advanced',616,'','',''),
	('SSIS 2014 Data Flow Tuning Tips and Tricks','Beginner',616,'','',''),
	('Standalone to High-Availability Clusters over Lunch—with Time to Spare','Intermediate',626,'','',''),
	('Stress testing SQL Server','Advanced',616,'','',''),
	('Table partitioning for Azure SQL Databases','Beginner',616,'','',''),
	('Testing','Beginner',616,'','',''),
	('The future of the data professional','Beginner',616,'','',''),
	('The Quest for the Golden Record:MDM Best Practices','Beginner',626,'','',''),
	('The Quest to Find Bad Data With Data Profiling','Intermediate',626,'','',''),
	('The Spy Who Loathed Me - An Intro to SQL Security','Beginner',626,'','',''),
	('Tired of the CRUD? Automate it!','Intermediate',626,'','',''),
	('Top 5 Ways to Improve Your triggers','Intermediate',626,'','',''),
	('Tricks that have saved my bacon','Beginner',626,'','',''),
	('T-SQL : Bad Habits & Best Practices','Beginner',626,'','',''),
	('T-SQL for Application Developers - Attendees chose','Intermediate',626,'','',''),
	('Tune Queries By Fixing Bad Parameter Sniffing','Intermediate',626,'','',''),
	('Using Extended Events in SQL Server','Advanced',626,'','',''),
	('Watch Brent Tune Queries','Intermediate',626,'','',''),
	('What every SQL Server DBA needs to know about Windows Server 10 Technical Preview','Intermediate',626,'','',''),
	('What exactly is big data and why should I care?','Beginner',626,'','',''),
	('What is it like to work for Microsoft?','Beginner',626,'','',''),
	('What’s new in SQL Server Integration Services 2012','Intermediate',626,'','',''),
	('Why do we shun using tools for DBA job?','Intermediate',626,'','',''),
	('Why OLAP? Building SSAS cubes and benefits of OLAP','Intermediate',626,'','',''),
	('You''re Doing It Wrong!!','Intermediate',626,'','','');

-- Items from the SQL Saturday 626 Budapest posted online schedule
INSERT Class (ClassTitle,Lvl,EventLocationID,Room,Duration,Track)
	VALUES
	('Microsoft adat platform áttekintés','Beginner',626,'GDFterem','09:15 AM- 10:15 AM','Strategy and Architecture'),
	('Self Service BI Solutions with Analysis Services','Beginner',626,'Kalmár terem ','09:15 AM- 10:15 AM','BI Platform Architecture, Development & Administration'),
	('SQLServer Statistical Semantic Search','Advanced',626,'Kemény terem','09:15 AM- 10:15 AM','Application & Database Development'),
	('2,4,8 &16 - Upgrade your journey with SQL Server','Advanced',626,'1-es terem ','09:15 AM- 10:15 AM','Enterprise Database Administration & Deployment'),
	('SQL Server 2016 Availability Group újdonságok','Intermediate',626,'GDFterem','10:30 AM - 11:30 AM','Enterprise Database Administration & Deployment'),
	('To be Announced','',626,'Kalmár terem ','10:30 AM - 11:30 AM',''),
	('Power Bi for beginner IoT developer','Beginner',626,'Kemény terem','10:30 AM - 11:30 AM','Application & Database Development'),
	('hash and stream aggregation','Intermediate',626,'1-es terem ','10:30 AM - 11:30 AM','Enterprise Database Administration & Deployment'),
	('Önkiszolgáló adatvizualizációs lehetőségek Power BI segítségével a földön, vagya felhőben','Beginner',626,'GDFterem','12:30 PM - 01:30 PM','Analytics and Visualization'),
	('Complex Tabular Modelling- A Case Study','Intermediate',626,'Kalmár terem ','12:30 PM - 01:30 PM','BI Platform Architecture, Development & Administration'),
	('Tricky ways to optimize your T-SQL queries','Advanced',626,'Kemény terem','12:30 PM - 01:30 PM','Professional Development'),
	('Hacking SQL Server','Intermediate',626,'1-es terem ','12:30 PM - 01:30 PM','Enterprise Database Administration & Deployment'),
	('Analysis Services biztonság','Intermediate',626,'GDFterem','01:45 PM - 02:45 PM','BI Platform Architecture, Development & Administration'),
	('Introducing R','Intermediate',626,'Kalmár terem ','01:45 PM - 02:45 PM','Advanced Analysis Techniques'),
	('SQLSERVER- Next station Azure','Intermediate',626,'Kemény terem','01:45 PM - 02:45 PM','Application & Database Development'),
	('Performance Tuning for the Transaction Log','Advanced',626,'1-es terem ','01:45 PM - 02:45 PM','Enterprise Database Administration & Deployment'),
	('Az eltűnt operátor nyomában','Intermediate',626,'GDFterem','03:00 PM - 04:00 PM','Strategy and Architecture'),
	('A Game of Hierarchies: Mastering Recursive Queries','Advanced',626,'Kalmár terem ','03:00 PM - 04:00 PM','Application & Database Development'),
	('How to use Temporal Tables in SQLServer 2016','Intermediate',626,'Kemény terem','03:00 PM - 04:00 PM','BI Platform Architecture, Development & Administration'),
	('A Masters view on Locking and blocking','Intermediate',626,'1-es terem ','03:00 PM - 04:00 PM','Enterprise Database Administration & Deployment');
INSERT Attendees (FirstName,LastName) 
	VALUES
	('Viktor','Dudas'),
	('LEONEL','ABREU'),
	('Matija','Lah'),
	('Satya','SKJayanty'),
	('Janos','Berke'),
	('Catalin','Gheorghiu'),
	('Torsten','Strauss'),
	('Attila','Kővári'),
	('Bob','Duffy'),
	('Sergey','Olontsev'),
	('André','Melancia'),
	('Zoltán','Horváth'),
	('Dejan','Sarka'),
	('Jose','Diaz'),
	('Miroslav','Dimitrov'),
	('Zoltán','Hangyál'),
	('Markus','Jensen'),
	('Dejan','Pervulov'),
	('Mikael','Wedham');
INSERT AttendeeRoleRelation (AttendeeID,RoleID)
	VALUES
	((SELECT PersonID FROM Attendees WHERE Firstname='Viktor' AND LastName='Dudas'),2),
	((SELECT PersonID FROM Attendees WHERE Firstname='LEONEL' AND LastName='ABREU'),2),
	((SELECT PersonID FROM Attendees WHERE Firstname='Matija' AND LastName='Lah'),2),
	((SELECT PersonID FROM Attendees WHERE Firstname='Satya' AND LastName='SKJayanty'),2),
	((SELECT PersonID FROM Attendees WHERE Firstname='Janos' AND LastName='Berke'),2),
	((SELECT PersonID FROM Attendees WHERE Firstname='Catalin' AND LastName='Gheorghiu'),2),
	((SELECT PersonID FROM Attendees WHERE Firstname='Torsten' AND LastName='Strauss'),2),
	((SELECT PersonID FROM Attendees WHERE Firstname='Attila' AND LastName='Kővári'),2),
	((SELECT PersonID FROM Attendees WHERE Firstname='Bob' AND LastName='Duffy'),2),
	((SELECT PersonID FROM Attendees WHERE Firstname='Sergey' AND LastName='Olontsev'),2),
	((SELECT PersonID FROM Attendees WHERE Firstname='André' AND LastName='Melancia'),2),
	((SELECT PersonID FROM Attendees WHERE Firstname='Zoltán' AND LastName='Horváth'),2),
	((SELECT PersonID FROM Attendees WHERE Firstname='Dejan' AND LastName='Sarka'),2),
	((SELECT PersonID FROM Attendees WHERE Firstname='Jose' AND LastName='Diaz'),2),
	((SELECT PersonID FROM Attendees WHERE Firstname='Miroslav' AND LastName='Dimitrov'),2),
	((SELECT PersonID FROM Attendees WHERE Firstname='Zoltán' AND LastName='Hangyál'),2),
	((SELECT PersonID FROM Attendees WHERE Firstname='Markus' AND LastName='Jensen'),2),
	((SELECT PersonID FROM Attendees WHERE Firstname='Dejan' AND LastName='Pervulov'),2),
	((SELECT PersonID FROM Attendees WHERE Firstname='Mikael' AND LastName='Wedham'),2);

INSERT Sponsors (SponsorName,SponsorLvl)
	VALUES
	('VMWare','Platinum'),
	('Verizon Digital Media Services','Platinum'),
	('Microsoft Corporation (GAP) (GAP Sponsor)','Platinum'),
	('Tintri','Platinum'),
	('Amazon Web Services, LLC','Gold'),
	('Pyramid Analytics (GAP Sponsor)','Gold'),
	('Pure Storage','Gold'),
	('Profisee','Gold'),
	('NetLib Security','Silver'),
	('Melissa Data Corp.','Silver'),
	('Red Gate Software','Silver'),
	('SentryOne','Silver'),
	('Hush Hush','Bronze'),
	('COZYROC','Bronze'),
	('SQLDocKit by Acceleratio Ltd.','Bronze');

/*-----------------------------------------------------------------------------------
	Test Section 
*/-----------------------------------------------------------------------------------

/*
SELECT * FROM Attendees
SELECT * FROM EventRole
SELECT * FROM SQLSatEvents
SELECT * FROM Class
SELECT * FROM Sponsors
*/
 

	END