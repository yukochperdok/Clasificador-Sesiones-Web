USE [PRODUCCION_BD]
GO

/****** Object: Table [dbo].[Events] Script Date: 07/02/2017 12:37:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Events] (
    [NodeId]      INT            NULL,
    [ParentId]    INT            NULL,
    [Name]        NVARCHAR (255) NULL,
    [startDate]   DATETIME       NULL,
    [sportHandle] NVARCHAR (100) NULL,
    [InsertDate]  DATETIME       NULL,
    [islive]      BIT            NULL
);


