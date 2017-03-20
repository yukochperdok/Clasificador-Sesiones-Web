USE [PRODUCCION_BD]
GO

/****** Object: Table [dbo].[sequencies_ROC] Script Date: 16/03/2017 13:49:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[sequencies_ROC] (
    [action_node]                   VARCHAR (50) NULL,
    [action_node_id]                VARCHAR (10) NULL,
    [context_user_is_authenticated] VARCHAR (10) NULL,
    [context_session_id]            VARCHAR (10) NULL,
    [context_data_event_time]       DATETIME     NULL,
    [action_node_num_step]          VARCHAR (10) NULL,
    [maximo_step]                   VARCHAR (10) NULL
);


