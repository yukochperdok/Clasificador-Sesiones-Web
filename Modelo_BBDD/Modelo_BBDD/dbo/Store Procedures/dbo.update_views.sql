USE [PRODUCCION_BD]
GO

/****** Object: SqlProcedure [dbo].[update_views] Script Date: 07/02/2017 12:42:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--Procedimiento que redistribuye los objetos de los arrays "action" y "custom" contenidos en los campos "action" y "custom" 
--en sus campos correspondientes de la tabla dbo.events_views_optimizado cuando el registro corresponde con una página vista: page_view
--Esto se sabe porque el campo "action" contiene el literal "durationMetric"

--Inicio del procedimiento dbo.update_views_optimizado
--Recibe un parámetro de entrada @DateTime creado en el pipeline Update-DatabaseCronodata del "DataFactory-Database-Produccion" 
--con la fecha del Blob de Codere.
CREATE PROCEDURE [dbo].[update_views] @DateTime nvarchar(127)
AS
	--Inicio de la actualización
	UPDATE dbo.events_views
	set 

	
	--Actualización del campo "action_name". Se extrae el contenido del literal "name" contenido en el campo "action".
	--El literal a continuación del "name" es el "count" por lo que se extraen todos los caracteres hasta que aparezca el texto
	--"count"
	action_name =
		SUBSTRING([action], CHARINDEX('"name":', [action]) + 8, CHARINDEX('"count":', [action]) - CHARINDEX('"name":', [action]) - 10),

	--Actualización del campo "view_duration_metric". Se extrae el contenido del literal "max" contenido en el campo "action".
	--El literal a continuación del "max" es el "stdDev" por lo que se extraen todos los caracteres hasta que aparezca el texto
	--"stdDev"
	view_duration_metric =
		SUBSTRING([action], CHARINDEX('"max":', [action]) + 6, CHARINDEX('"stdDev":', [action]) - CHARINDEX('"max":', [action]) - 7),

	
	--Actualización del campo "custom_dimensions_app". Se extrae el contenido del literal "App" contenido en el campo "custom".
	--Se comprueba que el literal "urlReferrer" no esté contenido en el campo "custom". Si éste existe el campo "custom" sólo contendrá el literal
	--"urlReferrer y por tanto no existirá el "App" --> el campo "custom_dimensions_app" permanecerá a NULL.
	--Si no existe "urlReferrer" se extraen los caracteres entre el literal "App" y "id" que es el literal siguiente.
	custom_dimensions_app =
		case
		when (CHARINDEX('"urlReferrer":', [custom]) = 0) then
			SUBSTRING([custom], CHARINDEX('"App":', [custom]) + 7, CHARINDEX('"id":', [custom]) - CHARINDEX('"App":', [custom]) - 11)
		else
			custom_dimensions_app
		end,

	--Actualización del campo "custom_dimensions_id". Se extrae el contenido del literal "id" contenido en el campo "custom".
	--Se comprueba que el literal "urlReferrer" no esté contenido en el campo "custom". Si éste existe el campo "custom" sólo contendrá el literal
	--"urlReferrer y por tanto no existirá el "id" --> el campo "custom_dimensions_app" permanecerá a NULL.
	--Si no existe "urlReferrer" se extraen los caracteres entre el literal "id" y "key" que es el literal siguiente.
	custom_dimensions_id =	
		case
		when (CHARINDEX('"urlReferrer":', [custom]) = 0) then
			SUBSTRING([custom], CHARINDEX('"id":', [custom]) + 6, CHARINDEX('"key":', [custom]) - CHARINDEX('"id":', [custom]) - 10)
		else
			custom_dimensions_id
		end,

	--Actualización del campo "custom_dimensions_key". Se extrae el contenido del literal "key" contenido en el campo "custom".
	--Se comprueba que el literal "urlReferrer" no esté contenido en el campo "custom". Si éste existe el campo "custom" sólo contendrá el literal
	--"urlReferrer y por tanto no existirá el "key" --> el campo "custom_dimensions_key" permanecerá a NULL.
	--Si no existe "urlReferrer", se comprueba que el literal "secondParameter" exista. Si éste existe se extraen
	--todos los caracteres entre el literal "key" y el "secondParameter" que es el siguiente.
	--Si no existe el literal "secondParameter" se extraen todos los caracteres entre el literal "key" y "{]" ya que "key" será el último literal del
	--campo "custom"
	custom_dimensions_key =		
		case
		when (CHARINDEX('"urlReferrer":', [custom]) = 0) then
			case 
			when (CHARINDEX('"secondParameter":', [custom]) <> 0) then
				SUBSTRING([custom], CHARINDEX('"key":', [custom]) + 7, CHARINDEX('"secondParameter":', [custom]) - CHARINDEX('"key":', [custom]) - 11)
			else
				SUBSTRING([custom], CHARINDEX('"key":', [custom]) + 7, CHARINDEX('}]', [custom]) - CHARINDEX('"key":', [custom]) - 8)
			end
		else
			custom_dimensions_key
		end,

	--Actualización del campo "custom_dimensions_second_parameter". Se extrae el contenido del literal "secondParameter" contenido en el campo "custom".
	--Se comprueba que el literal "urlReferrer" no esté contenido en el campo "custom". Si éste existe el campo "custom" sólo contendrá el literal
	--"urlReferrer y por tanto no existirá el "secondParameter" --> el campo "custom_dimensions_second_parameter" permanecerá a NULL.
	--Si no existe "urlReferrer", se comprueba que el literal "secondParameter" exista. Si éste existe se extraen
	--todos los caracteres entre el literal "secondParameter" y el "description" que es el siguiente.
	--Si no existe el literal "secondParameter" el campo custom acabará en el literal "key" --> el campo ""custom_dimensions_second_parameter" permanecerá a NULL. 
	custom_dimensions_second_parameter =
		case
		when (CHARINDEX('"urlReferrer":', [custom]) = 0) then
			case 
			when (CHARINDEX('"secondParameter":', [custom]) <> 0) then
				SUBSTRING([custom], CHARINDEX('"secondParameter":', [custom]) + 19, CHARINDEX('"description":', [custom]) - CHARINDEX('"secondParameter":', [custom]) - 23)
			else
				custom_dimensions_second_parameter
			end
		else
			custom_dimensions_second_parameter
		end,

	--Actualización del campo "custom_dimensions_description". Se extrae el contenido del literal "description" contenido en el campo "custom".
	--Se comprueba que el literal "urlReferrer" no esté contenido en el campo "custom". Si éste existe el campo "custom" sólo contendrá el literal
	--"urlReferrer y por tanto no existirá el "description" --> el campo "custom_dimensions_description" permanecerá a NULL.
	--Si no existe "urlReferrer", se comprueba que el literal "secondParameter" exista. Si éste existe se extraen
	--todos los caracteres entre el literal "description" y "}]" ya que "description" es el último literal.
	--Si no existe el literal "secondParameter" el campo custom acabará en el literal "key" --> el campo ""custom_dimensions_description" permanecerá a NULL. 
	custom_dimensions_description =	
		case
		when (CHARINDEX('"urlReferrer":', [custom]) = 0) then
			case 
			when (CHARINDEX('"secondParameter":', [custom]) <> 0) then
				SUBSTRING([custom], CHARINDEX('"description":', [custom]) + 15, CHARINDEX('}]', [custom]) - CHARINDEX('"description":', [custom]) - 16)
			else
				custom_dimensions_description
			end
		else
			custom_dimensions_description
		end,

	--Actualización del campo "custom_dimensions_urlReferrer". Se extrae el contenido del literal "urlReferrer" contenido en el campo "custom".
	--Se comprueba que el literal "urlReferrer" esté contenido en el campo "custom". Si éste existe el campo "custom" sólo contendrá el literal
	--"urlReferrer y por tanto se extraen los caracteres entre "urlReferrer" y "}]".
	--Si no existe "urlReferrer" el campo "custom_dimensions_urlReferrer" permanece a NULL.
	custom_dimensions_urlreferrer =		
		case
		when (CHARINDEX('"urlReferrer":', [custom]) <> 0) then
			SUBSTRING([custom], CHARINDEX('"urlReferrer":', [custom]) + 15, CHARINDEX('}]', [custom]) - CHARINDEX('"urlReferrer":', [custom]) - 16)
		else
			custom_dimensions_urlreferrer
		end,

	--Actualización del campo "action_type" al literal "Page view"
	action_type = 'Page view',

	--Actualización del campo "slice_datatime" al parámetro de entrada "@DateTime"
	slice_datatime = @DateTime,

	--Actualización del campo "insert_datatime" a la fecha del sistema
	insert_datatime = GETDATE(),

	--Actualización del campo "flag_load" a "N". Se actualizará automáticamente a "S" cuando el registro sea introducido en el grafo.
	flag_load = 'N'
	where 
		--Sólo se actualizan los registros cuyo "action_type" sea NULL y cuyo campo "action" contenga el literal "durationMetric".
		action_type is null 
		and
		CHARINDEX('durationMetric', [action]) <> 0

RETURN 0
