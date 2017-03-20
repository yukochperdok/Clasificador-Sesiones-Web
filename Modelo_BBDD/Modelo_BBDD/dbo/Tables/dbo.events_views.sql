USE [PRODUCCION_BD]
GO

/****** Object: Table [dbo].[events_views] Script Date: 07/02/2017 12:38:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[events_views] (
    [action_type]                        VARCHAR (20)   NULL,
    [action_name]                        VARCHAR (300)  NULL,
    [action_count]                       NUMERIC (1)    NULL,
    [action_node]                        VARCHAR (1100) NULL,
    [action_node_id]                     NUMERIC (4)    NULL,
    [action_num_step]                    NUMERIC (4)    NULL,
    [context_user_anon_id]               VARCHAR (15)   NULL,
    [context_user_auth_id]               VARCHAR (60)   NULL,
    [context_user_is_authenticated]      VARCHAR (10)   NULL,
    [context_session_id]                 VARCHAR (15)   NULL,
    [context_session_is_first]           VARCHAR (10)   NULL,
    [context_data_event_time]            DATETIME       NULL,
    [slice_datatime]                     DATETIME       NULL,
    [insert_datatime]                    DATETIME       NULL,
    [view_duration_metric]               NUMERIC (30)   NULL,
    [context_device_type]                VARCHAR (30)   NULL,
    [context_device_os_version]          VARCHAR (50)   NULL,
    [context_device_model]               VARCHAR (60)   NULL,
    [context_device_browser]             VARCHAR (60)   NULL,
    [context_location_client_ip]         VARCHAR (30)   NULL,
    [context_location_continent]         VARCHAR (30)   NULL,
    [context_location_country]           VARCHAR (40)   NULL,
    [custom_dimensions_app]              VARCHAR (60)   NULL,
    [custom_dimensions_id]               VARCHAR (120)  NULL,
    [custom_dimensions_key]              VARCHAR (60)   NULL,
    [custom_dimensions_second_parameter] VARCHAR (2000) NULL,
    [custom_dimensions_description]      VARCHAR (600)  NULL,
    [custom_dimensions_urlreferrer]      VARCHAR (2000) NULL,
    [action]                             VARCHAR (3000) NULL,
    [custom]                             VARCHAR (3000) NULL,
    [flag_load]                          CHAR (1)       NULL,
    [ColumnForADFUseOnly]                BINARY (32)    NULL
);


GO
CREATE NONCLUSTERED INDEX [index_flag_load]
    ON [dbo].[events_views]([flag_load] ASC);


GO
CREATE NONCLUSTERED INDEX [index_custom_dimensions_key]
    ON [dbo].[events_views]([custom_dimensions_key] ASC);


GO
CREATE NONCLUSTERED INDEX [index_action_name]
    ON [dbo].[events_views]([action_name] ASC);


GO
CREATE NONCLUSTERED INDEX [index_action_node]
    ON [dbo].[events_views]([action_node] ASC);


GO
CREATE NONCLUSTERED INDEX [index_context_session_id]
    ON [dbo].[events_views]([context_session_id] ASC);


GO
CREATE NONCLUSTERED INDEX [index_action_node_id]
    ON [dbo].[events_views]([action_node_id] ASC);


GO
CREATE NONCLUSTERED INDEX [index_action_type]
    ON [dbo].[events_views]([action_type] ASC);


GO
CREATE NONCLUSTERED INDEX [index_ColumnForADFUseOnly]
    ON [dbo].[events_views]([ColumnForADFUseOnly] ASC);


