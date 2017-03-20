USE [PRODUCCION_BD]
GO

/****** Object: Table [dbo].[Sports] Script Date: 07/02/2017 12:40:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Sports] (
    [NodeId]      INT            NULL,
    [ParentId]    INT            NULL,
    [Name]        NVARCHAR (255) NULL,
    [sportHandle] NVARCHAR (100) NULL,
    [InsertDate]  DATETIME       NULL
);


