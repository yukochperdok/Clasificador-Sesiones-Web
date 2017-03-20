USE [PRODUCCION_BD]
GO

/****** Object: Table [dbo].[Markets] Script Date: 07/02/2017 12:39:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Markets] (
    [NodeId]     INT            NULL,
    [ParentId]   INT            NULL,
    [Name]       NVARCHAR (255) NULL,
    [startDate]  DATETIME       NULL,
    [InsertDate] DATETIME       NULL
);


