package com.cronodata.utils;

/**
 * Clase que contiene todas las constantes utilizadas en el proceso.
 * @author Cronodata
 * @version 1.0
 */
public class Constants {
	/* Opciones menu */
	/**
	 * Operacion recarga del grafo
	 */
	public static final String OP_RELOAD = "reload_graph";
	/**
	 * Operacion testeo de la BBDD
	 */
	public static final String OP_TEST = "test_bbdd";
	/**
	 * Operacion borrado del grafo
	 */
	public static final String OP_DELETE = "delete_graph";
	
	
	
    /* Constantes ruta y nombre fichero configuracion */
	/**
	 * Indica el parametro a la JVM que contendra la ruta del fichero de configuracion
	 */
	public static final String DIR_CONFIG_PROPERTIES = "DIR_CONFIG";
	/**
	 * Indica el nombre del fichero de configuracion
	 */
	public static final String FILE_PROPERTIES = "reload_graph.properties";

	
	
	/* Nombres parametros de configuracion de fichero */

	// --> Configuracion Neo4j
	/**
	 * Indica el parametro de configuracion - HOST de NEO4j
	 */
	public static final String PARAM_NEO4J_HOST = "neo4j.host";
	/**
	 * Indica el parametro de configuracion - USER DE CONEXION de NEO4j
	 */
	public static final String PARAM_NEO4J_USER = "neo4j.user";
	/**
	 * Indica el parametro de configuracion - PASSWORD DE CONEXION de NEO4j
	 */
	public static final String PARAM_NEO4J_PASSWORD = "neo4j.password";
	

	// --> Configuracion SqlServer Database
	/**
	 * Indica el parametro de configuracion - SERVER NAME de SQL SERVER
	 */
	public static final String PARAM_SQL_DB_SERVER = "sqlserver.server.name";
	/**
	 * Indica el parametro de configuracion - DATA BASE NAME de BBDD DEL SQL SERVER
	 */
	public static final String PARAM_SQL_DB_DBNAME = "sqlserver.database.name";
	/**
	 * Indica el parametro de configuracion - PORT de BBDD DEL SQL SERVER
	 */
	public static final String PARAM_SQL_DB_PORT = "sqlserver.port";
	/**
	 * Indica el parametro de configuracion - USER de BBDD DEL SQL SERVER
	 */
	public static final String PARAM_SQL_DB_USER = "sqlserver.user";
	/**
	 * Indica el parametro de configuracion - PASSWORD de BBDD DEL SQL SERVER
	 */
	public static final String PARAM_SQL_DB_PASSWORD = "sqlserver.password";
	

	
	// --> Configuracion Execution
	/**
	 * Indica el parametro de configuracion - num.attempts
	 */
	public static final String PARAM_NUM_ATTEMPTS = "num.attempts";
	/**
	 * Indica el parametro de configuracion - time.attempt
	 */
	public static final String PARAM_TIME_ATTEMPT = "time.attempt";
	
	
	
	/* QUERYS */
	/**
	 * Indica la QUERY - Consulta de la fecha
	 */
	public static final String SQL_SELECT_DATE = "SELECT GETDATE() AS DIA_ACTUAL ";
	
	/**
	 * Indica la QUERY - Consulta de la acciones pendientes de cargar en el grafo
	 */
	public static final String SQL_SELECT_ACTIONS = "SELECT action_type,"
											     		+ "action_name,"
											     		+ "action_node,"
											     		+ "context_user_anon_id,"
											     		+ "context_user_auth_id,"
											     		+ "context_user_is_authenticated,"
											     		+ "context_session_id,"
											     		+ "context_session_is_first,"
											     		+ "view_url,"
											     		+ "context_data_event_time,"
											     		+ "slice_datatime,"
											     		+ "context_operation_id,"
											     		+ "context_operation_parent_id,"
											     		+ "context_operation_name,"
											     		+ "custom_dimensions_id,"
											     		+ "custom_dimensions_key,"
											     		+ "custom_dimensions_second_parameter,"
											     		+ "custom_dimensions_description "
											     		+ "FROM dbo.events_views ev "
											     		//+ "WHERE ev.slice_datatime >= CONVERT(datetime, '2016-12-05 12:00:00', 120) "
											     		//+ "WHERE ev.flag_load = 'N' AND ev.context_session_id IN ('0FZez','+7wHb') "
											     		+ "WHERE ev.flag_load = 'N' "
											     		+ "ORDER BY ev.context_session_id,ev.context_data_event_time"; 
	
	/**
	 * Indica la QUERY - Actualizacion acciones cargadas grafo
	 */
	public static final String  SQL_UPDATE_ACTIONS = "UPDATE dbo.events_views "
														+ "SET flag_load = 'S' "
														+ "WHERE flag_load = 'N' ";
	
	
	/**
	 * Indica la CYPHER - Actualizacion grafo
	 */
	public static final String CYPHER_INSERT_ACTIONS = " MERGE (n:ACTION{id:'{0}'}) MERGE (m:ACTION{id:'{1}'}) CREATE (n)-[r:{2} {actionTime:'{3}'}]->(m) ";	
	
	/**
	 * Indica la CYPHER - Borrado grafo
	 */
	public static final String CYPHER_REMOVE_ALL_ACTIONS = " MATCH (n)-[r]-(m) DELETE r,n,m ";
    
}  

