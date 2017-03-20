USE [PRODUCCION_BD]
GO

/****** Object: Table [dbo].[actions] Script Date: 07/02/2017 12:33:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[actions] (
    [action_node]    VARCHAR (1100) NULL,
    [action_node_id] INT            IDENTITY (1, 1) NOT NULL
);


