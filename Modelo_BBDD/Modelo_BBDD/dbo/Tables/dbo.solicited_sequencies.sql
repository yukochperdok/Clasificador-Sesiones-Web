USE [PRODUCCION_BD]
GO

/****** Object: Table [dbo].[solicited_sequencies] Script Date: 07/02/2017 12:40:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[solicited_sequencies] (
    [session_id]          VARCHAR (15)   NOT NULL,
    [secuencia]           VARCHAR (1100) NOT NULL,
    [name_clusterizacion] VARCHAR (50)   NOT NULL,
    [name_cluster]        VARCHAR (50)   NOT NULL
);


