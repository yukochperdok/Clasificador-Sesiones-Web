USE [PRODUCCION_BD]
GO

/****** Object: SqlProcedure [dbo].[sessions_to_ROC] Script Date: 16/03/2017 12:31:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[sessions_to_ROC]

AS
truncate table dbo.sequencies_ROC

select distinct top 10000 context_session_id into #distinct_sessions
from dbo.events_views
;

SELECT TOP 10 PERCENT context_session_id into #top_sessions_id
FROM #distinct_sessions
ORDER BY NEWID()
;

CREATE TABLE #events_views_sorted(
context_session_id VARCHAR(15),
context_data_event_time datetime,
action_node varchar(50),
action_node_id varchar(10),
context_user_is_authenticated varchar(10),
action_node_num_step INT IDENTITY(1,1)
)
;


CREATE TABLE #events_views_sorted_copy(
context_session_id VARCHAR(15),
context_data_event_time datetime,
action_node_num_step numeric(10),
action_node varchar(50),
action_node_id varchar(10),
context_user_is_authenticated varchar(10)
)
;

INSERT INTO #events_views_sorted (
context_session_id,
context_data_event_time,
action_node,
action_node_id,
context_user_is_authenticated) 
select 
main.context_session_id,
main.context_data_event_time,
main.action_node,
main.action_node_id,
main.context_user_is_authenticated
FROM dbo.events_views main,
#top_sessions_id sec
where main.context_session_id = sec.context_session_id
ORDER BY main.context_session_id, main.context_data_event_time
;

INSERT INTO #events_views_sorted_copy(
context_session_id,
context_data_event_time,
action_node,
action_node_id,
context_user_is_authenticated,
action_node_num_step)
SELECT 
context_session_id,
context_data_event_time,
action_node,
action_node_id,
context_user_is_authenticated,
action_node_num_step
FROM #events_views_sorted
;

SELECT 
MIN(action_node_num_step) RESTO,
context_session_id 
INTO #REST 
FROM #events_views_sorted_copy 
GROUP BY context_session_id
;

UPDATE #events_views_sorted_copy 
SET action_node_num_step = action_node_num_step - #REST.RESTO + 1
FROM #events_views_sorted_copy,
#REST
WHERE #events_views_sorted_copy.context_session_id = #REST.context_session_id
;

INSERT INTO 
dbo.sequencies_ROC 
select
convert(varchar (50), action_node) action_node,
convert(varchar (10), action_node_id) as action_node_id, 
convert(varchar (10), context_user_is_authenticated) as context_user_is_authenticated,
convert(varchar (10), main.context_session_id) context_session_id, 
main.context_data_event_time context_data_event_time,
convert(varchar (10), action_node_num_step) action_node_num_step,
convert(varchar (10), maximo.step) maximo_step
from #events_views_sorted_copy main,
(select distinct max(action_node_num_step) step, context_session_id from #events_views_sorted_copy group by context_session_id) maximo
where
main.context_session_id = maximo.context_session_id
--and main.action_node_num_step <= (maximo.step/2) + 1
and maximo.step > 35
;


RETURN 0
;
