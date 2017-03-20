USE [PRODUCCION_BD]
GO

/****** Object: SqlProcedure [dbo].[update_action_nodes] Script Date: 07/02/2017 12:42:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--Procedimiento almacenado que actúa sobre la tabla dbo.events_views.
--Se encarga de eliminar los registros sin utilidad para la minertía de datos y de actualizar el campo "action_node"
--dependiendo del valor del otro campo "custom_dimensions_key".
--También se carga el campo "action_node_id" a través de la tabla "dbo.actions" la cual se rellena en este PL previamente.
CREATE PROCEDURE [dbo].[update_action_nodes]
AS
--El siguiente procedimiento almacenado se compone de 17 bloques.

--BLOQUE 1:
--Se borran los registros cuyo "custom_dimensions_key" petenecen a la igualdad "=".
delete from dbo.events_views
where custom_dimensions_key = 'googleanalytics'
and action_type is not null
;

--BLOQUE 2:
--Se borran los registros cuyo "custom_dimensions_key" sea NULL y el "action_name" petenezcan al "in".
delete from dbo.events_views
where custom_dimensions_key is null
and action_name in 
('Codere Apuestas'
,'not_specified'
,'Redirect production from seo'
,'BonoBienvenida'
,'TarjetaCodere'
,'Pagina Cobros Faciles'
,'Codere200RM'
,'MejorBono'
,'Codere200'
,'CobrosFaciles'
,'Apuestas NBA'
,'Codere200NBA'
,'10eurosGratis')
;

delete from dbo.events_views
where custom_dimensions_key is null
and action_name like
'%bonus 200%'
and action_type is not null
;

delete from dbo.events_views
where custom_dimensions_key is null
and action_name like
'%Codere 200%'
and action_type is not null
;

delete from dbo.events_views
where custom_dimensions_key is null
and action_name like
'%Codere200%'
and action_type is not null
;

delete from dbo.events_views
where custom_dimensions_key is null
and action_name is null
;

--BLOQUE 3:
--Se borran los registros cuyo "custom_dimensions_key" sea NULL y su "action_name" petenezcan al "like".
delete from dbo.events_views
where custom_dimensions_key is null
and action_name like '%Bono bienvenida 200%'
and action_type is not null
;

--En cada operación "update" del siguiente procedimiento sólo se tendrán en cuenta aquellos registros cuyo "action_node" sean NULL.

--BLOQUE 4:
--Se actualiza el campo "action_node" al "custom_dimensions_key" de los registros cuyo "custom_dimensions_key" pertenezcan al "in".
update dbo.events_views
set action_node = custom_dimensions_key
where
action_node is null
and action_type is not null
and custom_dimensions_key in
('AcceptNewOdds'
,'AccessCallMeBack'
,'AccessExtLivePage'
,'AccessExtToFunction'
,'AccessLocalCodere'
,'AccessrecallGamesHG'
,'AccessToCancelOnlinePayments'
,'AccessToCasino'
,'accessToCheckCodereCard'
,'AccessToCobHistroy'
,'AccessToCobWithHalcash'
,'AccessToCobWithTicketPremiado'
,'AccessToCobWithTransfBank'
,'AccessToCodereCardActive'
,'accessToCodereCardTrans'
,'AccessToCreditCardDeposit'
,'AccessToDeptHistory'
,'accessToGetCard'
,'AccessToHalcash'
,'AccessToLanguage'
,'AccessToLoadTicket'
,'AccessToLocalDeposits'
,'AccessToLocalPayments'
,'AccessToNationalUserLimits'
,'AccessToNationalUserPoints'
,'AccessToNationalUserReports'
,'AccessToNBAEventoPage'
,'AccessToOddType'
,'AccessToPaySafeCard'
,'AccessToPersonalInf'
,'AccessToRealMadridPage'
,'accessToRecoverCard'
,'AccessToRegisterFromButton'
,'AccessToSearchedPage'
,'AccessToSearchResult'
,'AccessToSlots'
,'AccessToSlotReports'
,'AccessToTicket'
,'AccessToTransBank'
,'AccessToViewTicket'
,'AccessToRecargaCodere'
,'AccesToDepositPaySafeCard'
,'AccesToFreeBets'
,'ActivateDesElement'
,'ActivateDesElementGorH'
,'ActivateDesStreaming'
,'ActivateTar'
,'addFreeBetsTicket'
,'attemptLogin'
,'AutoLoginOk'
,'BankElementOfTicket'
,'CallMe Paso 1'
,'CallMe Paso 2'
,'cancelCobOnlineFromMenu'
,'cancelCobOnlineFromDeposits'
,'cancelFreeBetsTicket'
,'ChangeAmountTicket'
,'changePinCodereCard'
,'ChangeTypeBet'
,'checkFreeBetTicket'
,'CleanTicket'
,'CloseBet'
,'ContinueBetting'
,'CreateLocalPayment'
,'DepositOnline'
,'DepositPaymentOK'
,'Directos'
,'DirectosPage'
,'EventoPage'
,'UltimoMinutoPage'
,'EarlyCashOutAbility'
,'EarlyCashOutCall'
,'EarlyCashOutCallCodereCard'
,'EarlyCashOutComplete'
,'EarlyCashOutCompleteCodereCard'
,'EarlyCashOutFailure'
,'EarlyCashOutFailureCodereCard'
,'EarlyCashOutNoAbility'
,'errorMsgTicket'
,'getBetHistoryTar'
,'goToIndexPage'
,'HomePage'
,'InsertAmountAut'
,'InsertAmountAutLocal'
,'loadHomePage'
,'LoginKO'
,'LoginOK'
,'LoginOk'
,'LogOut'
,'MercadosPage'
,'ModalBuscador'
,'OpenTermCondReg'
,'NowLiveDetailPage'
,'RefreshBalance'
,'startSearched'
,'VinculateCodereCard')
;

--BLOQUE 5:
--Se actualiza el campo "action_node" a "Go to: custom_dimensions_key" de los registros cuyo "custom_dimensions_key" pertenezcan al "in".
update dbo.events_views
set action_node = 'Go to: ' + custom_dimensions_key
where
action_node is null
and action_type is not null
and custom_dimensions_key in
('AccessOnlineDeposits'
,'AccessToBetHistory'
,'AccessToDemoSlots'
,'AccessToLastMinute'
,'AccessToOnlinePayments'
,'American Football (SPIN)'
,'Artes Marciales (UFC)'
,'Artes Marciales (UFC)_Destacado'
,'Baloncesto'
,'Baloncesto_Destacado'
,'Balonmano'
,'Béisbol'
,'Billar_Destacado'
,'Boxeo'
,'CallMePage'
,'Cine'
,'ChangeCombiTicket'
,'Dardos'
,'Dardos_Destacado'
,'DeleteElementOfTicket'
,'DeleteLocalPayment'
,'DeleteElementGorHOfTicket'
,'eSports'
,'eSports_Destacado'
,'Football BGI'
,'Fútbol'
,'Fútbol americano NFL / NCAA'
,'Fútbol americano NFL / NCAA_Destacado'
,'Fútbol Sala'
,'Fútbol Sala_Destacado'
,'Fútbol_Destacado'
,'GoToHorsesPage'
,'GoToLivePage'
,'GoToMejoraTuPremio'
,'GoToNextRegPage'
,'goToRegister'
,'Hockey sobre hielo'
,'Hockey sobre hielo_Destacado'
,'HorsesMarket'
,'LoadPage'
,'Loterías'
,'Mejora tu premio'
,'Motor'
,'OpenHelpMsg'
,'OpenSportMenu'
,'OpenUserMenu'
,'Política'
,'RedirectDevice'
,'Rugby Union'
,'Rugby Union_Destacado'
,'Tenis'
,'Voleibol'
,'Voleibol_destacado'
,'ChangeSportInLivePage'
,'Loterías_Destacado'
,'Balonmano_Destacado'
,'Música'
,'Béisbol_Destacado'
,'Billar'
,'Tenis_Destacado'
,'Basketball BGI'
,'Pelota'
,'Bádminton'
,'misApuestasPage'
,'PaisLigaPage'
,'passToActivateTar')
;

--BLOQUE 6:
--Se actualiza el campo "action_node" a "custom_dimensions_key: custom_dimension_second_parameter" de los registros cuyo "custom_dimensions_key" pertenezcan al "in".
update dbo.events_views
set action_node = custom_dimensions_key + ': ' + custom_dimensions_second_parameter
where
action_node is null
and action_type is not null
and custom_dimensions_key in
('AccessSportBySporthandleEx'
,'AccessToGameCasino'
,'AccessToGameSlots')
;

--BLOQUE 7:
--Se actualiza el campo "action_node" a "custom_dimensions_key: Leagues.sportHandle Leagues.Name" de los registros cuyo "custom_dimensions_key" pertenezcan al "in".
--El alias "Leagues" corresponde con la tabla "dbo.Leagues" a la que se accede por el campo "NodeID" a través del campo "ParentId" de la tabla "dbo.Events" a 
--través del campo "custom_dimensions_id" de la tabla "dbo.events_views".

--Código comentado para eliminar granularidad "liga" y elevarlo a "deporte"
--update dbo.events_views
--set action_node = custom_dimensions_key + ': ' + Leagues.sportHandle + ' ' + Leagues.Name
--from 
--dbo.Events Events,
--dbo.Leagues Leagues
--where
--action_node is null
--and custom_dimensions_key in 
--('DirectAccessEvent'
--,'DirectAccessEventLive')
--and custom_dimensions_id = convert(varchar(50),Events.NodeId)
--and Events.ParentId = Leagues.NodeId
;

--Se actualiza el campo "action_node" a "custom_dimensions_key: Leagues.sportHandle" de los registros cuyo "custom_dimensions_key" pertenezcan al "in".
--El alias "Leagues" corresponde con la tabla "dbo.Leagues" a la que se accede por el campo "NodeID" a través del campo "ParentId" de la tabla "dbo.Events" que su a 
--vez se accede través del campo "custom_dimensions_id" de la tabla "dbo.events_views". Sólo se actualizarán los registros cuyo correspondiente "sportHandle" 
--en la tabla "dbo.Leagues" sea diferente de ''. Se hace una conversión a varchar del campo "NodeId" de la tabla "dbo.Events" para evitar incompatibilidad de tipos al
--comparar con el campo "custom_dimensions_key" de la tabla "dbo.events_views".
update dbo.events_views
set action_node = custom_dimensions_key + ': ' + Leagues.sportHandle
from 
dbo.Events Events,
dbo.Leagues Leagues
where
action_node is null
and action_type is not null
and custom_dimensions_key in 
('DirectAccessEvent'
,'DirectAccessEventLive')
and custom_dimensions_id = convert(varchar(50),Events.NodeId)
and Events.ParentId = Leagues.NodeId
and Leagues.sportHandle <> ''
;

--Se actualiza el campo "action_node" a "custom_dimensions_key: Leagues.Name" de los registros cuyo "custom_dimensions_key" pertenezcan al "in".
--El alias "Leagues" corresponde con la tabla "dbo.Leagues" a la que se accede por el campo "NodeID" a través del campo "ParentId" de la tabla "dbo.Events" que su a 
--vez se accede través del campo "custom_dimensions_id" de la tabla "dbo.events_views". Sólo se actualizarán los registros cuyo correspondiente "sportHandle" 
--en la tabla "dbo.Leagues" sea igual a ''. Se hace una conversión a varchar del campo "NodeId" de la tabla "dbo.Events" para evitar incompatibilidad de tipos al
--comparar con el campo "custom_dimensions_key" de la tabla "dbo.events_views".
update dbo.events_views
set action_node = custom_dimensions_key + ': ' + Leagues.Name
from 
dbo.Events Events,
dbo.Leagues Leagues
where
action_node is null
and action_type is not null
and custom_dimensions_key in 
('DirectAccessEvent'
,'DirectAccessEventLive')
and custom_dimensions_id = convert(varchar(50),Events.NodeId)
and Events.ParentId = Leagues.NodeId
and Leagues.sportHandle = ''
;

--Se actualiza el campo "action_node" a "custom_dimensions_key: Leagues.sportHandle" de los registros cuyo "custom_dimensions_key" pertenezcan al "in".
--El alias "Leagues" corresponde con la tabla "dbo.Leagues" a la que se accede por el campo "custom_dimensions_id" de la tabla "dbo.events_views". 
--Sólo se actualizarán los registros cuyo correspondiente "sportHandle" en la tabla "dbo.Leagues" sea diferente de ''. Se hace una conversión a 
--varchar del campo "NodeId" de la tabla "dbo.Leagues" para evitar incompatibilidad de tipos al comparar con el campo "custom_dimensions_key" 
--de la tabla "dbo.events_views".
update dbo.events_views
set action_node = custom_dimensions_key + ': ' + Leagues.sportHandle
from 
dbo.Leagues Leagues
where
action_node is null
and action_type is not null
and custom_dimensions_key in 
('DirectAccessEvent'
,'DirectAccessEventLive')
and custom_dimensions_id = convert(varchar(50), Leagues.NodeId)
and Leagues.sportHandle <> ''
;

--Se actualiza el campo "action_node" a "custom_dimensions_key: Leagues.Name" de los registros cuyo "custom_dimensions_key" pertenezcan al "in".
--El alias "Leagues" corresponde con la tabla "dbo.Leagues" a la que se accede por el campo "custom_dimensions_id" de la tabla "dbo.events_views". 
--Sólo se actualizarán los registros cuyo correspondiente "sportHandle" en la tabla "dbo.Leagues" sea igual a ''. Se hace una conversión a 
--varchar del campo "NodeId" de la tabla "dbo.Leagues" para evitar incompatibilidad de tipos al comparar con el campo "custom_dimensions_key" 
--de la tabla "dbo.events_views".
update dbo.events_views
set action_node = custom_dimensions_key + ': ' + Leagues.Name
from 
dbo.Leagues Leagues
where
action_node is null
and action_type is not null
and custom_dimensions_key in 
('DirectAccessEvent'
,'DirectAccessEventLive')
and custom_dimensions_id = convert(varchar(50), Leagues.NodeId)
and Leagues.sportHandle = ''
;

--Se actualiza el campo "action_node" a "custom_dimensions_key: Sports.sportHandle" de los registros cuyo "custom_dimensions_key" pertenezcan al "in".
--El alias "Sports" corresponde con la tabla "dbo.Sports" a la que se accede por el campo "custom_dimensions_id" de la tabla "dbo.events_views". 
--Sólo se actualizarán los registros cuyo correspondiente "sportHandle" en la tabla "dbo.Leagues" sea diferente de ''. Se hace una conversión a 
--varchar del campo "NodeId" de la tabla "dbo.Sports" para evitar incompatibilidad de tipos al comparar con el campo "custom_dimensions_key" 
--de la tabla "dbo.events_views".
update dbo.events_views
set action_node = custom_dimensions_key + ': ' + Sports.sportHandle
from 
dbo.Sports Sports
where
action_node is null
and action_type is not null
and custom_dimensions_key in 
('DirectAccessEvent'
,'DirectAccessEventLive')
and custom_dimensions_id = convert(varchar(50), Sports.NodeId)
and Sports.sportHandle <> ''
;

--Se actualiza el campo "action_node" a "custom_dimensions_key: Sports.Name" de los registros cuyo "custom_dimensions_key" pertenezcan al "in".
--El alias "Sports" corresponde con la tabla "dbo.Sports" a la que se accede por el campo "custom_dimensions_id" de la tabla "dbo.events_views". 
--Sólo se actualizarán los registros cuyo correspondiente "sportHandle" en la tabla "dbo.Leagues" sea igual a ''. Se hace una conversión a 
--varchar del campo "NodeId" de la tabla "dbo.Sports" para evitar incompatibilidad de tipos al comparar con el campo "custom_dimensions_key" 
--de la tabla "dbo.events_views".
update dbo.events_views
set action_node = custom_dimensions_key + ': ' + Sports.Name
from 
dbo.Sports Sports
where
action_node is null
and action_type is not null
and custom_dimensions_key in 
('DirectAccessEvent'
,'DirectAccessEventLive')
and custom_dimensions_id = convert(varchar(50), Sports.NodeId)
and Sports.sportHandle = ''
;

--Se actualiza el campo "action_node" a "custom_dimensions_key: UNKNOWN" de los registros cuyo "custom_dimensions_key" pertenezcan al "in" y cuyo "custom_dimensions_id"
--no se encuentre en sus correspondientes "NodeId" de las tablas "dbo.Sports", "dbo.Leagues" y "dbo.Events".
update dbo.events_views
set action_node = custom_dimensions_key + ': UNKNOWN'
from 
dbo.Events Events,
dbo.Leagues Leagues,
dbo.Sports Sports
where
action_node is null
and action_type is not null
and custom_dimensions_key in 
('DirectAccessEvent'
,'DirectAccessEventLive')
and custom_dimensions_id <> convert(varchar(50), Events.NodeId)
and custom_dimensions_id <> convert(varchar(50), Leagues.NodeId)
and custom_dimensions_id <> convert(varchar(50), Sports.NodeId)
;

--BLOQUE 8:
--Se actualiza el campo "action_node" a "custom_dimensions_key: Leagues.sportHandle Leagues.Name" de los registros cuyo "custom_dimensions_key" pertenezcan al "=".
--El alias "Leagues" corresponde con la tabla "dbo.Leagues" a la que se accede por el campo "NodeID" a través del campo "custom_dimensions_id" de la tabla 
--"dbo.events_views".

--Código comentado para eliminar granularidad "liga" y elevarlo a "deporte"
--update dbo.events_views
--set action_node = custom_dimensions_key + ': ' + Leagues.sportHandle + ' ' + Leagues.Name
--from 
--dbo.Leagues Leagues
--where
--action_node is null
--and custom_dimensions_key = 'DirectAccessLeague'
--and custom_dimensions_id = convert(varchar(50),Leagues.NodeId)
--;

--Se actualiza el campo "action_node" a "custom_dimensions_key: Leagues.sportHandle" de los registros cuyo "custom_dimensions_key" pertenezcan al "=".
--El alias "Leagues" corresponde con la tabla "dbo.Leagues" a la que se accede por el campo "custom_dimensions_id" de la tabla "dbo.events_views". 
--Sólo se actualizarán los registros cuyo correspondiente "sportHandle" en la tabla "dbo.Leagues" sea diferente de ''. Se hace una conversión a 
--varchar del campo "NodeId" de la tabla "dbo.Leagues" para evitar incompatibilidad de tipos al comparar con el campo "custom_dimensions_key" 
--de la tabla "dbo.events_views".
update dbo.events_views
set action_node = custom_dimensions_key + ': ' + Leagues.sportHandle
from 
dbo.Leagues Leagues
where
action_node is null
and action_type is not null
and custom_dimensions_key = 'DirectAccessLeague'
and custom_dimensions_id = convert(varchar(50),Leagues.NodeId)
and Leagues.sportHandle <> ''
;

--Se actualiza el campo "action_node" a "custom_dimensions_key: Leagues.Name" de los registros cuyo "custom_dimensions_key" pertenezcan al "=".
--El alias "Leagues" corresponde con la tabla "dbo.Leagues" a la que se accede por el campo "custom_dimensions_id" de la tabla "dbo.events_views". 
--Sólo se actualizarán los registros cuyo correspondiente "sportHandle" en la tabla "dbo.Leagues" sea igual a ''. Se hace una conversión a 
--varchar del campo "NodeId" de la tabla "dbo.Leagues" para evitar incompatibilidad de tipos al comparar con el campo "custom_dimensions_key" 
--de la tabla "dbo.events_views".
update dbo.events_views
set action_node = custom_dimensions_key + ': ' + Leagues.Name
from 
dbo.Leagues Leagues
where
action_node is null
and action_type is not null
and custom_dimensions_key = 'DirectAccessLeague'
and custom_dimensions_id = convert(varchar(50),Leagues.NodeId)
and Leagues.sportHandle = ''
;

--Se actualiza el campo "action_node" a "custom_dimensions_key: Sports.sportHandle" de los registros cuyo "custom_dimensions_key" pertenezcan al "=".
--El alias "Sports" corresponde con la tabla "dbo.Sports" a la que se accede por el campo "custom_dimensions_id" de la tabla "dbo.events_views". 
--Sólo se actualizarán los registros cuyo correspondiente "sportHandle" en la tabla "dbo.Leagues" sea diferente de ''. Se hace una conversión a 
--varchar del campo "NodeId" de la tabla "dbo.Sports" para evitar incompatibilidad de tipos al comparar con el campo "custom_dimensions_key" 
--de la tabla "dbo.events_views".
update dbo.events_views
set action_node = custom_dimensions_key + ': ' + Sports.sportHandle
from dbo.Sports
where
action_node is null
and action_type is not null
and custom_dimensions_key = 'DirectAccessLeague'
and custom_dimensions_id = convert(varchar(50),Sports.NodeId)
and Sports.sportHandle <> ''
;

--Se actualiza el campo "action_node" a "custom_dimensions_key: Sports.Name" de los registros cuyo "custom_dimensions_key" pertenezcan al "=".
--El alias "Sports" corresponde con la tabla "dbo.Sports" a la que se accede por el campo "custom_dimensions_id" de la tabla "dbo.events_views". 
--Sólo se actualizarán los registros cuyo correspondiente "sportHandle" en la tabla "dbo.Leagues" sea igual a ''. Se hace una conversión a 
--varchar del campo "NodeId" de la tabla "dbo.Sports" para evitar incompatibilidad de tipos al comparar con el campo "custom_dimensions_key" 
--de la tabla "dbo.events_views".
update dbo.events_views
set action_node = custom_dimensions_key + ': ' + Sports.Name
from dbo.Sports
where
action_node is null
and action_type is not null
and custom_dimensions_key = 'DirectAccessLeague'
and custom_dimensions_id = convert(varchar(50),Sports.NodeId)
and Sports.sportHandle = ''
;

--Se actualiza el campo "action_node" a "custom_dimensions_key: UNKNOWN" de los registros cuyo "custom_dimensions_key" pertenezcan al "=" y cuyo "custom_dimensions_id"
--no se encuentre en sus correspondientes "NodeId" de las tablas "dbo.Sports" y "dbo.Leagues".
update dbo.events_views
set action_node = custom_dimensions_key + ': UNKNOWN'
from 
dbo.Sports Sports,
dbo.Leagues Leagues
where
action_node is null
and action_type is not null
and custom_dimensions_key = 'DirectAccessLeague'
and custom_dimensions_id <> convert(varchar(50), Sports.NodeId)
and custom_dimensions_id <> convert(varchar(50), Leagues.NodeId)
;

--BLOQUE 9:
--Se actualiza el campo "action_node" a "custom_dimensions_key" de los registros cuyo "custom_dimensions_key" pertenezcan al "in".
update dbo.events_views
set action_node = custom_dimensions_key
where
action_node is null
and action_type is not null
and custom_dimensions_key in
('addBet'
,'addBetHorG'
,'addBetLive'
,'addBetRealMadrid'
,'addBetLiveRealMadrid'
,'AddForecastOrTricastBet'
,'AddBetCombForecastElement'
,'AddBetDirectForecastElement'
,'AddBetCombTricastElement'
,'AddBetDirectTricastElement'
,'betCompleted')
;

--BLOQUE 10:
--Se actualiza el campo "action_node" a "custom_dimensions_key?" de los registros cuyo "custom_dimensions_key" pertenezcan al "in" y cuyo 
--"custom_dimensions_id" sea ''.
update dbo.events_views
set action_node = custom_dimensions_key + '?'
where
action_node is null
and action_type is not null
and custom_dimensions_key in ('FinishRegister')
and custom_dimensions_id = ''
;

--Se actualiza el campo "action_node" a "custom_dimensions_key: custom_dimensions_id" de los registros cuyo "custom_dimensions_key" pertenezcan al "in" y cuyo 
--"custom_dimensions_id" sea diferente a ''.
update dbo.events_views
set action_node = custom_dimensions_key + ': ' + custom_dimensions_id
where
action_node is null
and action_type is not null
and custom_dimensions_key in ('FinishRegister')
and custom_dimensions_id <> ''
;

--BLOQUE 11:
--Se actualiza el campo "action_node" a "custom_dimensions_key: custom_dimensions_second_parameter action_name" de los registros 
--cuyo "custom_dimensions_key" pertenezcan al "in".

--Código comentado para eliminar granularidad "liga" y elevarlo a "deporte"
--update dbo.events_views
--set action_node = custom_dimensions_key + ': ' + custom_dimensions_second_parameter + ' ' + action_name
--where
--action_node is null
--and custom_dimensions_key in 
--('p_SelectEvent'
--,'SelectLeagueDestPage'
--,'SelectLeaguePage')
--;

--Se actualiza el campo "action_node" a "custom_dimensions_key: custom_dimensions_second_parameter action_name" de los registros 
--cuyo "custom_dimensions_key" pertenezcan al "in".
update dbo.events_views
set action_node = custom_dimensions_key + ': ' + custom_dimensions_second_parameter
where
action_node is null
and action_type is not null
and custom_dimensions_key in 
('p_SelectEvent'
,'SelectLeagueDestPage'
,'SelectLeaguePage')
;

--BLOQUE 12:
--Se actualiza el campo "action_node" a "custom_dimensions_key: Sports.sportHandle" de los registros cuyo "custom_dimensions_key" pertenezcan al "=".
--El alias "Sports" corresponde con la tabla "dbo.Sports" a la que se accede por el campo "custom_dimensions_id" de la tabla "dbo.events_views". 
--Sólo se actualizarán los registros cuyo correspondiente "sportHandle" en la tabla "dbo.Leagues" sea diferente de ''. Se hace una conversión a 
--varchar del campo "NodeId" de la tabla "dbo.Sports" para evitar incompatibilidad de tipos al comparar con el campo "custom_dimensions_key" 
--de la tabla "dbo.events_views".
update dbo.events_views
set action_node = custom_dimensions_key + ': ' + Sports.sportHandle
from dbo.Sports Sports
where
action_node is null
and action_type is not null
and custom_dimensions_key in ('SelectSport', 'SelectSportFromSportmenu', 'SelectSportDestFromSportmenu', 'AccessSportByIdEx')
and custom_dimensions_id = convert(varchar(50), Sports.NodeId)
and Sports.sportHandle <> ''
;

--Se actualiza el campo "action_node" a "custom_dimensions_key: Sports.sportHandle" de los registros cuyo "custom_dimensions_key" pertenezcan al "=".
--El alias "Sports" corresponde con la tabla "dbo.Sports" a la que se accede por el campo "custom_dimensions_id" de la tabla "dbo.events_views". 
--Sólo se actualizarán los registros cuyo correspondiente "sportHandle" en la tabla "dbo.Leagues" sea igual a ''. Se hace una conversión a 
--varchar del campo "NodeId" de la tabla "dbo.Sports" para evitar incompatibilidad de tipos al comparar con el campo "custom_dimensions_key" 
--de la tabla "dbo.events_views".
update dbo.events_views
set action_node = custom_dimensions_key + ': ' + Sports.Name
from dbo.Sports Sports
where
action_node is null
and action_type is not null
and custom_dimensions_key in ('SelectSport', 'SelectSportFromSportmenu', 'SelectSportDestFromSportmenu', 'AccessSportByIdEx')
and custom_dimensions_id = convert(varchar(50), Sports.NodeId)
and Sports.sportHandle = ''
;

--Se actualiza el campo "action_node" a "custom_dimensions_key: custom_dimensions_second_parameter" de los registros cuyo "custom_dimensions_key" pertenezcan al "in", 
--cuyo "custom_dimensions_second_parameter" no sea '' ni 'undefined' y cuyo "custom_dimensions_id" no se encuentre en sus correspondientes "NodeId" 
--de la tabla "dbo.Sports".
update dbo.events_views
set action_node = custom_dimensions_key + ': ' + custom_dimensions_second_parameter
from dbo.Sports Sports
where
action_node is null
and action_type is not null
and custom_dimensions_key in ('SelectSport', 'SelectSportFromSportmenu', 'SelectSportDestFromSportmenu', 'AccessSportByIdEx')
and custom_dimensions_second_parameter not in ('', 'undefined')
and custom_dimensions_id <> convert(varchar(50), Sports.NodeId)
;

--Se actualiza el campo "action_node" a "custom_dimensions_key: UNKNOWN" de los registros cuyo "custom_dimensions_key" pertenezcan al "in", 
--cuyo "custom_dimensions_second_parameter" sea '' o 'undefined' y cuyo "custom_dimensions_id" no se encuentre en sus correspondientes "NodeId" 
--de la tabla "dbo.Sports".
update dbo.events_views
set action_node = custom_dimensions_key + ': UNKNOWN'
from dbo.Sports Sports
where
action_node is null
and action_type is not null
and custom_dimensions_key in ('SelectSport', 'SelectSportFromSportmenu', 'SelectSportDestFromSportmenu', 'AccessSportByIdEx')
and custom_dimensions_second_parameter in ('', 'undefined')
and custom_dimensions_id <> convert(varchar(50), Sports.NodeId)
;

--BLOQUE 13:
--Se actualiza el campo "action_node" a "custom_dimensions_key: Eventsnode.sportHandle Leagues.Name" de los registros cuyo "custom_dimensions_key" pertenezcan al "in".
--El alias "Leagues" corresponde con la tabla "dbo.Leagues" a la que se accede por el campo "NodeID" a través del campo "ParentId" de la tabla "dbo.Events" a 
--través del campo "custom_dimensions_id" de la tabla "dbo.events_views". "Eventsnode" es el alias de la tabla "dbo.Events".

--Código comentado para eliminar granularidad "liga" y elevarlo a "deporte"
--update dbo.events_views
--set action_node = custom_dimensions_key + ': ' + Eventsnode.sportHandle + ' ' + Leagues.Name
--from 
--dbo.Events Eventsnode,
--dbo.Leagues Leagues
--where
--action_node is null
--and custom_dimensions_key in ('SelectMarket')
--and custom_dimensions_id = convert(varchar(50), Eventsnode.NodeId)
--and Eventsnode.ParentId = Leagues.NodeId
--;

--Se actualiza el campo "action_node" a "custom_dimensions_key: Leagues.sportHandle" de los registros cuyo "custom_dimensions_key" pertenezcan al "in".
--El alias "Leagues" corresponde con la tabla "dbo.Leagues" a la que se accede por el campo "NodeID" a través del campo "ParentId" de la tabla "dbo.Events" que su a 
--vez se accede través del campo "custom_dimensions_id" de la tabla "dbo.events_views". Sólo se actualizarán los registros cuyo correspondiente "sportHandle" 
--en la tabla "dbo.Leagues" sea diferente a ''. Se hace una conversión a varchar del campo "NodeId" de la tabla "dbo.Events" para evitar incompatibilidad de tipos al
--comparar con el campo "custom_dimensions_key" de la tabla "dbo.events_views".
update dbo.events_views
set action_node = custom_dimensions_key + ': ' + Leagues.sportHandle
from 
dbo.Events Eventsnode,
dbo.Leagues Leagues
where
action_node is null
and action_type is not null
and custom_dimensions_key in ('SelectMarket')
and custom_dimensions_id = convert(varchar(50), Eventsnode.NodeId)
and Eventsnode.ParentId = Leagues.NodeId
and Leagues.sportHandle <> ''
;

--Se actualiza el campo "action_node" a "custom_dimensions_key: Leagues.Name" de los registros cuyo "custom_dimensions_key" pertenezcan al "in".
--El alias "Leagues" corresponde con la tabla "dbo.Leagues" a la que se accede por el campo "NodeID" a través del campo "ParentId" de la tabla "dbo.Events" que su a 
--vez se accede través del campo "custom_dimensions_id" de la tabla "dbo.events_views". Sólo se actualizarán los registros cuyo correspondiente "sportHandle" 
--en la tabla "dbo.Leagues" sea igual a ''. Se hace una conversión a varchar del campo "NodeId" de la tabla "dbo.Events" para evitar incompatibilidad de tipos al
--comparar con el campo "custom_dimensions_key" de la tabla "dbo.events_views".
update dbo.events_views
set action_node = custom_dimensions_key + ': ' + Leagues.Name
from 
dbo.Events Eventsnode,
dbo.Leagues Leagues
where
action_node is null
and action_type is not null
and custom_dimensions_key in ('SelectMarket')
and custom_dimensions_id = convert(varchar(50), Eventsnode.NodeId)
and Eventsnode.ParentId = Leagues.NodeId
and Leagues.sportHandle = ''
;

--Se actualiza el campo "action_node" a "custom_dimensions_key: custom_dimensions_second_parameter UNKNOWN" de los registros cuyo "custom_dimensions_key" 
--pertenezcan al "in".

--Código comentado para eliminar granularidad "liga" y elevarlo a "deporte"
--update dbo.events_views
--set action_node = custom_dimensions_key + ': ' + custom_dimensions_second_parameter + ' UNKNOWN'
--where
--action_node is null
--and custom_dimensions_key in ('SelectMarket')
--;

--Se actualiza el campo "action_node" a "custom_dimensions_key: custom_dimensions_second_parameter" de los registros cuyo "custom_dimensions_key" pertenezcan al "in", 
--cuyo "custom_dimensions_second_parameter" sea diferente de '' y cuyo "custom_dimensions_id" no se encuentre en sus correspondientes "NodeId" de la tabla "dbo.Events".
update dbo.events_views
set action_node = custom_dimensions_key + ': ' + custom_dimensions_second_parameter
from dbo.Events Events
where
action_node is null
and action_type is not null
and custom_dimensions_key in ('SelectMarket')
and custom_dimensions_second_parameter <> ''
and custom_dimensions_id <> convert(varchar(50), Events.NodeId)
;

--Se actualiza el campo "action_node" a "custom_dimensions_key: UNKNOWN" de los registros cuyo "custom_dimensions_key" pertenezcan al "in", 
--cuyo "custom_dimensions_second_parameter" sea '' y cuyo "custom_dimensions_id" no se encuentre en sus correspondientes "NodeId" de la tabla "dbo.Events".
update dbo.events_views
set action_node = custom_dimensions_key + ': UNKNOWN'
from dbo.Events Events
where
action_node is null
and action_type is not null
and custom_dimensions_key in ('SelectMarket')
and custom_dimensions_second_parameter = ''
and custom_dimensions_id <> convert(varchar(50), Events.NodeId)
;

--BLOQUE 14:
--Se actualiza el campo "action_node" a "custom_dimensions_key: Eventsnode.sportHandle Leagues.Name" de los registros cuyo "custom_dimensions_key" pertenezcan al "in".
--El alias "Leagues" corresponde con la tabla "dbo.Leagues" a la que se accede por el campo "NodeID" a través del campo "ParentId" de la tabla "dbo.Events" a 
--través del campo "custom_dimensions_id" de la tabla "dbo.events_views". "Eventsnode" es el alias de la tabla "dbo.Events".

--Código comentado para eliminar granularidad "liga" y elevarlo a "deporte"
--update dbo.events_views
--set action_node = custom_dimensions_key + ': ' + Eventsnode.sportHandle + ' ' + Leagues.Name
--from 
--dbo.Events Eventsnode,
--dbo.Leagues Leagues
--where
--action_node is null
--and custom_dimensions_key in 
--('SelectEvent'
--,'SelectEventFromIndex'
--,'SelectEventFromLastMinute'
--,'SelectEventLive'
--,'SelectEventLiveFromIndex'
--,'SelectEventLiveFromSearch')
--and custom_dimensions_id = convert(varchar(50), Eventsnode.NodeId)
--and Eventsnode.ParentId = Leagues.NodeId
--;

--Se actualiza el campo "action_node" a "custom_dimensions_key: Leagues.sportHandle" de los registros cuyo "custom_dimensions_key" pertenezcan al "in".
--El alias "Leagues" corresponde con la tabla "dbo.Leagues" a la que se accede por el campo "NodeID" a través del campo "ParentId" de la tabla "dbo.Events" que su a 
--vez se accede través del campo "custom_dimensions_id" de la tabla "dbo.events_views". Sólo se actualizarán los registros cuyo correspondiente "sportHandle" 
--en la tabla "dbo.Leagues" sea diferente a ''. Se hace una conversión a varchar del campo "NodeId" de la tabla "dbo.Events" para evitar incompatibilidad de tipos al
--comparar con el campo "custom_dimensions_key" de la tabla "dbo.events_views".
update dbo.events_views
set action_node = custom_dimensions_key + ': ' + Leagues.sportHandle
from 
dbo.Events Eventsnode,
dbo.Leagues Leagues
where
action_node is null
and action_type is not null
and custom_dimensions_key in 
('SelectEvent'
,'SelectEventFromIndex'
,'SelectEventFromLastMinute'
,'SelectEventFromSearch'
,'SelectEventLive'
,'SelectEventLiveFromIndex'
,'SelectEventLiveFromSearch')
and custom_dimensions_id = convert(varchar(50), Eventsnode.NodeId)
and Eventsnode.ParentId = Leagues.NodeId
and Leagues.sportHandle <> ''
;

--Se actualiza el campo "action_node" a "custom_dimensions_key: Leagues.Name" de los registros cuyo "custom_dimensions_key" pertenezcan al "in".
--El alias "Leagues" corresponde con la tabla "dbo.Leagues" a la que se accede por el campo "NodeID" a través del campo "ParentId" de la tabla "dbo.Events" que su a 
--vez se accede través del campo "custom_dimensions_id" de la tabla "dbo.events_views". Sólo se actualizarán los registros cuyo correspondiente "sportHandle" 
--en la tabla "dbo.Leagues" sea igual a ''. Se hace una conversión a varchar del campo "NodeId" de la tabla "dbo.Events" para evitar incompatibilidad de tipos al
--comparar con el campo "custom_dimensions_key" de la tabla "dbo.events_views".
update dbo.events_views
set action_node = custom_dimensions_key + ': ' + Leagues.Name
from 
dbo.Events Eventsnode,
dbo.Leagues Leagues
where
action_node is null
and action_type is not null
and custom_dimensions_key in 
('SelectEvent'
,'SelectEventFromIndex'
,'SelectEventFromLastMinute'
,'SelectEventFromSearch'
,'SelectEventLive'
,'SelectEventLiveFromIndex'
,'SelectEventLiveFromSearch')
and custom_dimensions_id = convert(varchar(50), Eventsnode.NodeId)
and Eventsnode.ParentId = Leagues.NodeId
and Leagues.sportHandle = ''
;

--Se actualiza el campo "action_node" a "custom_dimensions_key: Leagues.sportHandle Leagues.Name" de los registros cuyo "custom_dimensions_key" pertenezcan al "in".
--El alias "Leagues" corresponde con la tabla "dbo.Leagues" a la que se accede por el campo "NodeID" a través del campo "custom_dimensions_id" de la tabla 
--"dbo.events_views".

--Código comentado para eliminar granularidad "liga" y elevarlo a "deporte"
--update dbo.events_views
--set action_node = custom_dimensions_key + ': ' + Leagues.sportHandle + ' ' + Leagues.name
--from dbo.Leagues Leagues
--where
--action_node is null
--and custom_dimensions_key in
--('SelectEvent'
--,'SelectEventFromIndex'
--,'SelectEventFromLastMinute'
--,'SelectEventLive'
--,'SelectEventLiveFromIndex'
--,'SelectEventLiveFromSearch')
--and custom_dimensions_id = convert(varchar(50), Leagues.NodeId)
--;

--Se actualiza el campo "action_node" a "custom_dimensions_key: Leagues.sportHandle" de los registros cuyo "custom_dimensions_key" pertenezcan al "in".
--El alias "Leagues" corresponde con la tabla "dbo.Leagues" a la que se accede por el campo "custom_dimensions_id" de la tabla "dbo.events_views". 
--Sólo se actualizarán los registros cuyo correspondiente "sportHandle" en la tabla "dbo.Leagues" sea diferente a ''. Se hace una conversión a 
--varchar del campo "NodeId" de la tabla "dbo.Leagues" para evitar incompatibilidad de tipos al comparar con el campo "custom_dimensions_key" 
--de la tabla "dbo.events_views".
update dbo.events_views
set action_node = custom_dimensions_key + ': ' + Leagues.sportHandle
from dbo.Leagues Leagues
where
action_node is null
and action_type is not null
and custom_dimensions_key in
('SelectEvent'
,'SelectEventFromIndex'
,'SelectEventFromLastMinute'
,'SelectEventFromSearch'
,'SelectEventLive'
,'SelectEventLiveFromIndex'
,'SelectEventLiveFromSearch')
and custom_dimensions_id = convert(varchar(50), Leagues.NodeId)
and Leagues.sportHandle <> ''
;

--Se actualiza el campo "action_node" a "custom_dimensions_key: Leagues.Name" de los registros cuyo "custom_dimensions_key" pertenezcan al "=".
--El alias "Leagues" corresponde con la tabla "dbo.Leagues" a la que se accede por el campo "custom_dimensions_id" de la tabla "dbo.events_views". 
--Sólo se actualizarán los registros cuyo correspondiente "sportHandle" en la tabla "dbo.Leagues" sea igual a ''. Se hace una conversión a 
--varchar del campo "NodeId" de la tabla "dbo.Leagues" para evitar incompatibilidad de tipos al comparar con el campo "custom_dimensions_key" 
--de la tabla "dbo.events_views".
update dbo.events_views
set action_node = custom_dimensions_key + ': ' + Leagues.Name
from dbo.Leagues Leagues
where
action_node is null
and action_type is not null
and custom_dimensions_key in
('SelectEvent'
,'SelectEventFromIndex'
,'SelectEventFromLastMinute'
,'SelectEventFromSearch'
,'SelectEventLive'
,'SelectEventLiveFromIndex'
,'SelectEventLiveFromSearch')
and custom_dimensions_id = convert(varchar(50), Leagues.NodeId)
and Leagues.sportHandle = ''
;

--Se actualiza el campo "action_node" a "custom_dimensions_key: custom_dimensions_second_parameter UNKNOWN" de los registros cuyo "custom_dimensions_key" 
--pertenezcan al "in".

--Código comentado para eliminar granularidad "liga" y elevarlo a "deporte"
--update dbo.events_views
--set action_node = custom_dimensions_key + ': ' + custom_dimensions_second_parameter + ' UNKNOWN'
--where
--action_node is null
--and custom_dimensions_key in
--('SelectEvent'
--,'SelectEventFromIndex'
--,'SelectEventFromLastMinute'
--,'SelectEventLive'
--,'SelectEventLiveFromIndex'
--,'SelectEventLiveFromSearch')
--;

--Se actualiza el campo "action_node" a "custom_dimensions_key: custom_dimensions_second_parameter" de los registros cuyo "custom_dimensions_key" pertenezcan al "in", 
--cuyo "custom_dimensions_second_parameter" no sea 'null' o 'undefined' y cuyo "custom_dimensions_id" no se encuentre en sus correspondientes "NodeId" 
--de las tablas "dbo.Leagues" y "dbo.Events".

--Se crea una tabla temporal #nodes_id donde se insertan los NodeId de las tablas dbo.Events y dbo.Leagues para mejorar el rendimiento.
select convert(varchar(50), leagues.NodeId) NodeId into #nodes_id
from dbo.Leagues leagues;

insert into #nodes_id
select convert(varchar(50), events.NodeId) NodeId
from dbo.Events events;

update dbo.events_views
set action_node = custom_dimensions_key + ': ' + custom_dimensions_second_parameter
from
#nodes_id
where
action_node is null
and action_type is not null
and custom_dimensions_key in
('SelectEvent'
,'SelectEventFromIndex'
,'SelectEventFromLastMinute'
,'SelectEventFromSearch'
,'SelectEventLive'
,'SelectEventLiveFromIndex'
,'SelectEventLiveFromSearch')
and custom_dimensions_second_parameter not in ('null', 'undefined')
and custom_dimensions_id <> #nodes_id.NodeId
;

--Se actualiza el campo "action_node" a "custom_dimensions_key: UNKNOWN" de los registros cuyo "custom_dimensions_key" pertenezcan al "in", 
--cuyo "custom_dimensions_second_parameter" sea 'null' o 'undefined' y cuyo "custom_dimensions_id" no se encuentre en sus correspondientes "NodeId" 
--de las tablas "dbo.Leagues" y "dbo.Events".
update dbo.events_views
set action_node = custom_dimensions_key + ': UNKNOWN'
from 
#nodes_id
where
action_node is null
and action_type is not null
and custom_dimensions_key in
('SelectEvent'
,'SelectEventFromIndex'
,'SelectEventFromLastMinute'
,'SelectEventFromSearch'
,'SelectEventLive'
,'SelectEventLiveFromIndex'
,'SelectEventLiveFromSearch')
and custom_dimensions_second_parameter in ('null', 'undefined')
and custom_dimensions_id <> #nodes_id.NodeId
;

--BLOQUE 15:
--Se actualiza el campo "action_node" al literal que existe a continuación del literal "SportName=" que se encuentra en el campo
--"custom_dimensions_second_parameter". Esto se hará cuando el campo "custom_dimensions_key" sea "AccessFromBanner" y el campo 
--"custom_dimensions_second_parameter" contenga el literal "SportName=".
update dbo.events_views
set action_node =
	custom_dimensions_key + ': ' + SUBSTRING([custom_dimensions_second_parameter], CHARINDEX('SportName=', [custom_dimensions_second_parameter]) + 10, len(custom_dimensions_second_parameter))
where
action_node is null
and action_type is not null
and custom_dimensions_key in ('AccessFromBanner')
and custom_dimensions_second_parameter like '%&SportName=%'
;

--Se actualiza el campo "action_node" al literal que existe a continuación del literal "SportHandle=" que se encuentra en el campo
--"custom_dimensions_second_parameter". Esto se hará cuando el campo "custom_dimensions_key" sea "AccessFromBanner" y el campo 
--"custom_dimensions_second_parameter" contenga el literal "SportHandle=".
update dbo.events_views
set action_node =
	custom_dimensions_key + ': ' + SUBSTRING([custom_dimensions_second_parameter], CHARINDEX('SportHandle=', [custom_dimensions_second_parameter]) + 12, len(custom_dimensions_second_parameter))
where
action_node is null
and action_type is not null
and custom_dimensions_key in ('AccessFromBanner')
and custom_dimensions_second_parameter like '%SportHandle=%'
;


--Se actualiza el campo "action_node" al literal que existe a continuación del literal "/#/" que se encuentra en el campo
--"custom_dimensions_second_parameter". Esto se hará cuando el campo "custom_dimensions_key" sea "AccessFromBanner" y el campo 
--"custom_dimensions_second_parameter" contenga el literal "m.apuestas.codere.es" y no contenga los literales "SportName=" y "SportHandle="
update dbo.events_views
set action_node =
	custom_dimensions_key + ': UNKNOWN'
where
action_node is null
and action_type is not null
and custom_dimensions_key in ('AccessFromBanner')
and custom_dimensions_second_parameter not like '%SportName=%'
and custom_dimensions_second_parameter not like '%SportHandle=%'
;

--Se actualiza el campo "action_node" a "custom_dimensions_key: soccer" de los registros cuyo "custom_dimensions_key" pertenezcan al "in"
--y cuyo "custom_dimensions_second_parameter" contenga el literal "BAtbol".
update dbo.events_views
set action_node = custom_dimensions_key + ': soccer'
where
custom_dimensions_key in ('AccessFromBanner')
and action_name like '%BAtbol%'
;

--BLOQUE 16:
--Se actualiza el campo "action_node" a "custom_dimensions_key: action_name" de los registros cuyo "custom_dimensions_key" pertenezcan al "in"
--y cuyo "custom_dimensions_second_parameter" contenga el literal "SportHandle".
update dbo.events_views
set action_node = action_name
where
action_node is null
and action_type is not null
and custom_dimensions_key in ('AccessFromCarrusel')
and custom_dimensions_second_parameter not like '%SportHandle%'
;

--Se actualiza el campo "action_node" al literal que existe a continuación del literal "SportHandle=" que se encuentra en el campo
--"custom_dimensions_second_parameter". Esto se hará cuando el campo "custom_dimensions_key" sea "AccessFromCarrusel" y el campo 
--"custom_dimensions_second_parameter" contenga el literal "SportHandle=".
update dbo.events_views
set action_node = 
custom_dimensions_key + ': ' + SUBSTRING([custom_dimensions_second_parameter], CHARINDEX('SportHandle=', [custom_dimensions_second_parameter]) + 12, len(custom_dimensions_second_parameter))
where
action_node is null
and action_type is not null
and custom_dimensions_key in ('AccessFromCarrusel')
and custom_dimensions_second_parameter like '%SportHandle%'
;

--BLOQUE 17:
--Se insertan en la tabla "dbo.actions" todos los "action_node" que no estuvieran previamente. La tabla "dbo.actions" contiene un id secuencial que es adjudicado 
--automáticamente a cada "action_node" cuando es insertado en la tabla.
insert into dbo.actions(
[action_node])
select
distinct([events_views].[action_node])
from 
dbo.events_views events_views
where [events_views].[action_node] not in (select distinct(action_node) from dbo.actions)
and [events_views].action_node is not null
;


--Se actualizan los "action_node_id" de la tabla "dbo.events_views" al "action_node_id" de la tabla "dbo.actions". Se actualizan aquellos que 
--el "action_node_id" esté a NULL y cuyo "action_node" sea igual al "ation_node" de la tabla "dbo.actions".
update dbo.events_views
set dbo.events_views.action_node_id = actions.action_node_id
from dbo.actions actions
where 
dbo.events_views.action_node_id is null
and dbo.events_views.action_node = actions.action_node
;
