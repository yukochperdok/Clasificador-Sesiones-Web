USE [PRODUCCION_BD]
GO

/****** Object: Table [dbo].[Leagues] Script Date: 07/02/2017 12:38:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Leagues] (
    [NodeId]      INT            NULL,
    [ParentId]    INT            NULL,
    [Name]        NVARCHAR (255) NULL,
    [sportHandle] NVARCHAR (100) NULL,
    [InsertDate]  DATETIME       NULL
);


