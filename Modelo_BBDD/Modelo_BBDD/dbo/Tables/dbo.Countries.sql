USE [PRODUCCION_BD]
GO

/****** Object: Table [dbo].[Countries] Script Date: 07/02/2017 12:37:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Countries] (
    [NodeId]     INT            NULL,
    [ParentId]   INT            NULL,
    [Name]       NVARCHAR (255) NULL,
    [InsertDate] DATETIME       NULL
);


