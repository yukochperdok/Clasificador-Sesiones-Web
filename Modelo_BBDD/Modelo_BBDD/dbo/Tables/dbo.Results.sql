USE [PRODUCCION_BD]
GO

/****** Object: Table [dbo].[Results] Script Date: 07/02/2017 12:40:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Results] (
    [NodeId]     INT            NULL,
    [ParentId]   INT            NULL,
    [Name]       NVARCHAR (255) NULL,
    [startDate]  DATETIME       NULL,
    [InsertDate] DATETIME       NULL
);


