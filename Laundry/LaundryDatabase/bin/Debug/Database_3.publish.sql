﻿/*
Deployment script for Laundry

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "Laundry"
:setvar DefaultFilePrefix "Laundry"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Rename refactoring operation with key 6899ac0d-584c-4dad-93c3-2ecf81186371 is skipped, element [dbo].[OrderParts].[Id] (SqlSimpleColumn) will not be renamed to OrderId';


GO
PRINT N'Rename refactoring operation with key f1650231-66f3-4c75-8bd5-2b4a471198e6 is skipped, element [dbo].[OrderParts].[Price] (SqlSimpleColumn) will not be renamed to PriceId';


GO
PRINT N'Dropping [dbo].[AspNetRoles].[RoleNameIndex]...';


GO
DROP INDEX [RoleNameIndex]
    ON [dbo].[AspNetRoles];


GO
PRINT N'Dropping [dbo].[AspNetUserClaims].[IX_UserId]...';


GO
DROP INDEX [IX_UserId]
    ON [dbo].[AspNetUserClaims];


GO
PRINT N'Dropping [dbo].[AspNetUserLogins].[IX_UserId]...';


GO
DROP INDEX [IX_UserId]
    ON [dbo].[AspNetUserLogins];


GO
PRINT N'Dropping [dbo].[AspNetUserRoles].[IX_RoleId]...';


GO
DROP INDEX [IX_RoleId]
    ON [dbo].[AspNetUserRoles];


GO
PRINT N'Dropping [dbo].[AspNetUserRoles].[IX_UserId]...';


GO
DROP INDEX [IX_UserId]
    ON [dbo].[AspNetUserRoles];


GO
PRINT N'Creating [dbo].[OrderParts]...';


GO
CREATE TABLE [dbo].[OrderParts] (
    [OrderId] INT NOT NULL,
    [PriceId] INT NULL,
    [Number]  INT NULL
);


GO
PRINT N'Creating [dbo].[Orders]...';


GO
CREATE TABLE [dbo].[Orders] (
    [Id]             INT            NOT NULL,
    [ClientId]       NVARCHAR (128) NOT NULL,
    [WorkerId]       NVARCHAR (128) NOT NULL,
    [GivingAddress]  NVARCHAR (256) NULL,
    [GivingDate]     DATETIME       NULL,
    [ReceiveAddress] NVARCHAR (256) NULL,
    [ReceiveDate]    DATETIME       NULL,
    [Price]          FLOAT (53)     NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating [dbo].[Prices]...';


GO
CREATE TABLE [dbo].[Prices] (
    [Id]        INT        NOT NULL,
    [ThingId]   INT        NOT NULL,
    [ServiceId] INT        NOT NULL,
    [Price]     FLOAT (53) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating [dbo].[Services]...';


GO
CREATE TABLE [dbo].[Services] (
    [Id]   INT           NOT NULL,
    [Name] NVARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating unnamed constraint on [dbo].[OrderParts]...';


GO
ALTER TABLE [dbo].[OrderParts]
    ADD DEFAULT 1 FOR [Number];


GO
PRINT N'Creating unnamed constraint on [dbo].[OrderParts]...';


GO
ALTER TABLE [dbo].[OrderParts] WITH NOCHECK
    ADD FOREIGN KEY ([OrderId]) REFERENCES [dbo].[Orders] ([Id]);


GO
PRINT N'Creating unnamed constraint on [dbo].[Orders]...';


GO
ALTER TABLE [dbo].[Orders] WITH NOCHECK
    ADD FOREIGN KEY ([ClientId]) REFERENCES [dbo].[AspNetUsers] ([Id]);


GO
PRINT N'Creating unnamed constraint on [dbo].[Orders]...';


GO
ALTER TABLE [dbo].[Orders] WITH NOCHECK
    ADD FOREIGN KEY ([WorkerId]) REFERENCES [dbo].[AspNetUsers] ([Id]);


GO
PRINT N'Creating unnamed constraint on [dbo].[Prices]...';


GO
ALTER TABLE [dbo].[Prices] WITH NOCHECK
    ADD FOREIGN KEY ([ThingId]) REFERENCES [dbo].[Things] ([Id]);


GO
PRINT N'Creating unnamed constraint on [dbo].[Prices]...';


GO
ALTER TABLE [dbo].[Prices] WITH NOCHECK
    ADD FOREIGN KEY ([ServiceId]) REFERENCES [dbo].[Services] ([Id]);


GO
-- Refactoring step to update target server with deployed transaction logs

IF OBJECT_ID(N'dbo.__RefactorLog') IS NULL
BEGIN
    CREATE TABLE [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
    EXEC sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
END
GO
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '6899ac0d-584c-4dad-93c3-2ecf81186371')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('6899ac0d-584c-4dad-93c3-2ecf81186371')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'f1650231-66f3-4c75-8bd5-2b4a471198e6')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('f1650231-66f3-4c75-8bd5-2b4a471198e6')

GO

GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
CREATE TABLE [#__checkStatus] (
    id           INT            IDENTITY (1, 1) PRIMARY KEY CLUSTERED,
    [Schema]     NVARCHAR (256),
    [Table]      NVARCHAR (256),
    [Constraint] NVARCHAR (256)
);

SET NOCOUNT ON;

DECLARE tableconstraintnames CURSOR LOCAL FORWARD_ONLY
    FOR SELECT SCHEMA_NAME([schema_id]),
               OBJECT_NAME([parent_object_id]),
               [name],
               0
        FROM   [sys].[objects]
        WHERE  [parent_object_id] IN (OBJECT_ID(N'dbo.OrderParts'), OBJECT_ID(N'dbo.Orders'), OBJECT_ID(N'dbo.Prices'))
               AND [type] IN (N'F', N'C')
                   AND [object_id] IN (SELECT [object_id]
                                       FROM   [sys].[check_constraints]
                                       WHERE  [is_not_trusted] <> 0
                                       UNION
                                       SELECT [object_id]
                                       FROM   [sys].[foreign_keys]
                                       WHERE  [is_not_trusted] <> 0);

DECLARE @schemaname AS NVARCHAR (256);

DECLARE @tablename AS NVARCHAR (256);

DECLARE @checkname AS NVARCHAR (256);

DECLARE @is_not_trusted AS INT;

DECLARE @statement AS NVARCHAR (1024);

BEGIN TRY
    OPEN tableconstraintnames;
    FETCH tableconstraintnames INTO @schemaname, @tablename, @checkname, @is_not_trusted;
    WHILE @@fetch_status = 0
        BEGIN
            PRINT N'Checking constraint: ' + @checkname + N' [' + @schemaname + N'].[' + @tablename + N']';
            SET @statement = N'ALTER TABLE [' + @schemaname + N'].[' + @tablename + N'] WITH ' + CASE @is_not_trusted WHEN 0 THEN N'CHECK' ELSE N'NOCHECK' END + N' CHECK CONSTRAINT [' + @checkname + N']';
            BEGIN TRY
                EXECUTE [sp_executesql] @statement;
            END TRY
            BEGIN CATCH
                INSERT  [#__checkStatus] ([Schema], [Table], [Constraint])
                VALUES                  (@schemaname, @tablename, @checkname);
            END CATCH
            FETCH tableconstraintnames INTO @schemaname, @tablename, @checkname, @is_not_trusted;
        END
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH

IF CURSOR_STATUS(N'LOCAL', N'tableconstraintnames') >= 0
    CLOSE tableconstraintnames;

IF CURSOR_STATUS(N'LOCAL', N'tableconstraintnames') = -1
    DEALLOCATE tableconstraintnames;

SELECT N'Constraint verification failed:' + [Schema] + N'.' + [Table] + N',' + [Constraint]
FROM   [#__checkStatus];

IF @@ROWCOUNT > 0
    BEGIN
        DROP TABLE [#__checkStatus];
        RAISERROR (N'An error occurred while verifying constraints', 16, 127);
    END

SET NOCOUNT OFF;

DROP TABLE [#__checkStatus];


GO
PRINT N'Update complete.';


GO
