package com.cronodata.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.neo4j.driver.v1.Session;
import org.neo4j.driver.v1.Transaction;
import org.neo4j.driver.v1.exceptions.Neo4jException;
import org.neo4j.driver.v1.summary.ResultSummary;

import com.cronodata.azureconnections.Neo4jDatabase;
import com.cronodata.azureconnections.SQLServerDatabase;
import com.cronodata.beans.ActionBean;
import com.cronodata.utils.Constants;
import com.cronodata.utils.LoggerFacade;
import com.cronodata.utils.Utils;

/**
 * Esta clase encapsula todo el acceso a datos (DAO) para la entidad Action<br>
 * Tiene 4 metodos:<br>
 * <ul>
 * 	<li>{@link #getDate()} - Recupera la hora del sistema en la BBDD SqlServer</li>
 *  <li>{@link #getLastActions()} - Recupera de la BBDD todas las acciones que aun no han sido cargadas en el grafo</li>
 *  <li>{@link #loadLastActions(List)} - Carga la lista de acciones pasadas como parametro en el grafo</li>
 *  <li>{@link #removeAllActions()} - Elimina todo el grafo</li>
 * </ul> <br>
 * Y basicamente utiliza {@code SQLServerDatabase.getConnection()} y {@code Neo4jDatabase.getSession()} para las conexiones a ambas BBDD.
 * @author Cronodata
 * @version 1.0
 * @see <a href="https://docs.microsoft.com/es-es/azure/sql-database/">SQL SERVER</a>
 * @see <a href="https://github.com/neo4j-contrib/neo4j-jdbc">NEO4J JDBC</a>
 * @see <a href="https://neo4j.com/developer/get-started/">NEO4J Connections</a>
 * @see <a href="https://neo4j.com/developer/cypher/">CYPHER</a>
 * @see com.cronodata.azureconnections.Neo4jDatabase
 * @see com.cronodata.azureconnections.SQLServerDatabase
 * @see com.cronodata.beans.ActionBean
 * @see com.cronodata.utils.Constants
 * @see com.cronodata.utils.LoggerFacade
 * @see com.cronodata.utils.Utils
 * @see org.neo4j.driver.v1.Session
 * @see org.neo4j.driver.v1.Transaction
 * @see org.neo4j.driver.v1.exceptions.Neo4jException
 * @see java.sql.SQLException
 */
public class ActionDAO {	
	
	/**
	 * Este metodo crea una conexion a BBDD Sql Server y lanza la select identificada por:<br>
	 * {@code Constants.SQL_SELECT_DATE = "SELECT GETDATE() AS DIA_ACTUAL "}<br>
	 * Finalmente muestra el resultado por Logger, y cierra las conexiones.
	 */
	public void getDate(){
		LoggerFacade.debug("INICIO getDate()");
		
		// Declaramos los objetos JDBC
        Connection connection = null;  
        Statement statement = null;   
        ResultSet resultSet = null;  

                      
        try { 
        	//Cremos la conexion con el SQLServer
        	connection = SQLServerDatabase.getConnection();
        	LoggerFacade.info("Conexion SQL Database realizada correctamente");
        	
        	// Crea la consulta y la lanza.
            statement = connection.createStatement();  
            resultSet = statement.executeQuery(Constants.SQL_SELECT_DATE);
            LoggerFacade.info("Consulta: "+ Constants.SQL_SELECT_DATE);
            
            // Muestra los resultados en diferentes formatos: String, Date y TimeStamp 
            while (resultSet.next())   
            {
            	LoggerFacade.info("Dia Actual (String)= "+resultSet.getString("DIA_ACTUAL"));
            	LoggerFacade.info("Dia Actual (Date)= "+resultSet.getDate("DIA_ACTUAL"));
            	LoggerFacade.info("Dia Actual (TimeStamp con Format)= "+ Utils.timestampToString(resultSet.getTimestamp("DIA_ACTUAL")));
            }  


        }  
        catch (Exception ex) {  
            ex.printStackTrace(); 
            LoggerFacade.error("Error al obtener la fecha actual del database",ex);
        }  
        finally {  
        	// Cierra las conexiones y resultset
            if (resultSet != null) try { resultSet.close(); } catch(Exception e) {}  
            if (statement != null) try { statement.close(); } catch(Exception e) {}  
            if (connection != null) try { connection.close(); } catch(Exception e) {}
			LoggerFacade.info("Conexiones cerradas correctamente");
			
			LoggerFacade.debug("FIN getDate()");
        }  
	}

	/**
	 * Este metodo recupera todas las acciones cuyo flag_load='N', es decir que todavia no se han cargado utilizando para ello la siguiente query:<br>
	 * {@code Constants.SQL_SELECT_ACTIONS = "SELECT action_type,"
											     		+ "action_name,"
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
											     		+ "FROM dbo.events_views_optimizada ev "
											     		+ "WHERE ev.flag_load = 'N' "
											     		+ "ORDER BY ev.context_session_id,ev.context_data_event_time"}<br>
	 * Crea un ArrayList con el contenido de cada action y por ultimo cierra las conexiones.
	 * @return List - Lista de ActionBean de la tabla dbo.events_views_optimizada aun no cargadas en el grafo.
	 */
	@SuppressWarnings("finally")
	public List<ActionBean> getLastActions(){
		LoggerFacade.debug("INICIO getLastActions()");
		
		// Declaramos los objetos JDBC 
        Connection connection = null;  
        Statement statement = null;   
        ResultSet resultSet = null; 
        
        //Lista nuevas acciones
        List<ActionBean> listNewActions = new ArrayList<ActionBean>();
                
        try { 
        	//Cremos la conexion con el SQLServer
        	connection = SQLServerDatabase.getConnection();
        	LoggerFacade.info("Conexion SQL Database realizada correctamente");
 
        	// Crea la consulta y la lanza.
            statement = connection.createStatement();  
            resultSet = statement.executeQuery(Constants.SQL_SELECT_ACTIONS);
            LoggerFacade.info("Consulta: "+ Constants.SQL_SELECT_ACTIONS);
            
            //Por cada resultado encontrado creamos un ActionBean y lo incluimos en la lista
            while (resultSet.next())   
            {
            	ActionBean newAction = new ActionBean(
            			resultSet.getString("action_type"),
            			resultSet.getString("action_name"),
            			resultSet.getString("action_node"),
            			resultSet.getString("context_user_anon_id"),
            			resultSet.getString("context_user_auth_id"),
            			resultSet.getBoolean("context_user_is_authenticated"),
            			resultSet.getString("context_session_id"),
            			resultSet.getBoolean("context_session_is_first"),
            			resultSet.getString("view_url"),
            			resultSet.getTimestamp("context_data_event_time"),
            			resultSet.getTimestamp("slice_datatime"),
            			resultSet.getString("context_operation_id"),
            			resultSet.getString("context_operation_parent_id"),
            			resultSet.getString("context_operation_name"),
            			resultSet.getString("custom_dimensions_id"),
            			resultSet.getString("custom_dimensions_key"),
            			resultSet.getString("custom_dimensions_second_parameter"),
            			resultSet.getString("custom_dimensions_description"));
            	
            	listNewActions.add(newAction);
            	LoggerFacade.info("Añadida accion["+resultSet.getRow()+"]= "+newAction);  
            } 
            LoggerFacade.info("Recogidas "+listNewActions.size()+" acciones");
           
        }  
        catch (Exception ex) {  
            ex.printStackTrace();
            LoggerFacade.error("ERROR EN getLastActions()", ex);
        }  
        finally {  
        	// Cierra las conexiones y resultset
            if (resultSet != null) try { resultSet.close(); } catch(Exception e) {}  
            if (statement != null) try { statement.close(); } catch(Exception e) {}  
            if (connection != null) try { connection.close(); } catch(Exception e) {}  
			LoggerFacade.info("Conexiones cerradas correctamente");
            
			LoggerFacade.debug("FIN getLastActions()");
			// Devuelve la lista de acciones ordenada
            return listNewActions;
        }  
	}
	
	/**
	 * Este metodo dada una lista de acciones, las actualiza en el grafo incluyendo como relacion entre accion anterior y siguiente el id_sesion. Para ello lanza el siguiente codigo CYPHER:<br>
	 * {@code Constants.CYPHER_INSERT_ACTIONS = " MERGE (n:ACTION{id:'{0}'}) MERGE (m:ACTION{id:'{1}'}) CREATE (n)-[r:{2} {actionTime:'{3}'}]->(m) "}<br>
	 * Donde {0} es la accion predecesora, {1} es la accion actual, {2} es el identificador de sesion del usuario, y {3} el momento en el que realiza la accion.<br> 
	 * Una vez que se confirma que el grafo es correcto, antes de cerrar la transaccion se hace la siguiente actualizacion sobre la tabla de SqlServer:
	 * {@code Constants.SQL_UPDATE_ACTIONS = "UPDATE dbo.events_views_optimizada "
														+ "SET flag_load = 'S' "
														+ "WHERE flag_load = 'N' "}<br>
	 * si ambas operaciones son correctas se finaliza la transaccion y se cierran ambas conexiones. En caso contrario se hace un rollback en ambas: Neo4j y SqlServer.
	 * @param listNewActions - List Lista de acciones.															
	 * @return boolean - Si se ha cargado correctamente o no el grafo con las nuevas acciones
	 */
	@SuppressWarnings("finally")
	public boolean loadLastActions(List<ActionBean> listNewActions){
		LoggerFacade.debug("INICIO loadLastActions(List<ActionBean>)");
		
		// Variable que recoge la correcta o no ejecuccion de la carga
		boolean rigthResult = true;
		// Declaramos objetos de conexion sobre SQL Database y Neo4j
		Session session = null;
		Transaction tx = null;
		ResultSummary summary = null;
		Connection connection = null;  
		Statement statement = null;   
		int resultUpdateActions = 0; 
		
		// Si no hay acciones no hago nada
		if(listNewActions==null || listNewActions.isEmpty()){
			LoggerFacade.info("No ha acciones a actualizar");
			return rigthResult;
		}
		
		try {
			//Conexion sobre Neo4j
			session = Neo4jDatabase.getSession();
			LoggerFacade.info("Conexion Neo4j realizada correctamente");
			
			//Conexion con SQL Server
			connection = SQLServerDatabase.getConnection();
			connection.setAutoCommit(false);
			LoggerFacade.info("Conexion SQL Database realizada correctamente");
			
			//Abro transacccion sobre Neo4j
			tx = session.beginTransaction();
			LoggerFacade.info("Transaccion sobre Neo4j abierta correctamente");
			
			String nodeSource,nodeTarget,sessionId,actionTime, query = "";
			//Empiezo en 1 porque el 0 no lo trato, es el origen del 1.
			for(int i = 1; i < listNewActions.size(); i++){
				sessionId = listNewActions.get(i).getContextSessionId();
				//Miro si el anterior evento pertenece a esta sesion; de esta forma al saltar a la siguiente sesion la trato desde el inicio
				if(sessionId.equals(listNewActions.get(i-1).getContextSessionId())){
					nodeSource = listNewActions.get(i-1).getActionNode()!=null?listNewActions.get(i-1).getActionNode():listNewActions.get(i-1).getActionName();
					nodeTarget = listNewActions.get(i).getActionNode()!=null?listNewActions.get(i).getActionNode():listNewActions.get(i).getActionName();
					actionTime = Utils.timestampToString(listNewActions.get(i).getContextDataEventTime());
					
					// Sustituyo en el insert de cypher los datos: accion anterior, accion actual, identificador de session y la fecha de la accion (fecha y hora).
					query = Utils.getTranslatedCypher(Constants.CYPHER_INSERT_ACTIONS, new String[] {Utils.escapeSpecialChars(nodeSource), Utils.escapeSpecialChars(nodeTarget), Utils.escapeSpecialCharsSession(sessionId), actionTime});
					
					//Ejecuto pero no cierro transaccion
					summary = tx.run(query).consume();
					//Muestro la consulta por logger
					LoggerFacade.info("Cypher["+i+"]: "+summary.statement().text());
				}
			}
			

			// Creo el UPDATE y lo lanzo			
			statement = connection.createStatement();  
			resultUpdateActions = statement.executeUpdate(Constants.SQL_UPDATE_ACTIONS); 
			
			//Actualizo transaccionalmente el Neo4j y cierro transaccion
			tx.success();
			tx.close();
			LoggerFacade.info("Grafo Actualizado correctamente");
			
			//Cierro transaccion en SQLServer
			LoggerFacade.info("Actualizacion: "+ Constants.SQL_UPDATE_ACTIONS);
			connection.commit(); 
			LoggerFacade.info("Actualizadas en tabla correctamente "+resultUpdateActions+" acciones");			

		}
		//Controlo tanto si hay una excepcion en la carga del grafo como en la actualizacion de la BBDD
		catch (SQLException | Neo4jException ex) {
			rigthResult = false;
			ex.printStackTrace();
			try {
				//En caso de error hago rollback en ambas
				LoggerFacade.error("Fallada transaccion al actualizar grafo y tabla", ex);
				connection.rollback();
				tx.failure();
				tx.close();
				LoggerFacade.info("Rollback correctamente realizado");
			}
			catch (SQLException se) {
				se.printStackTrace();
				LoggerFacade.fatal("Fallo en rollback", se);
			}
		}
		catch (Exception ex) {  
            ex.printStackTrace();
            LoggerFacade.error("ERROR EN loadLastActions(List<ActionBean>)", ex);
        }
		finally { 			
			// Cierro conexiones
			if (statement != null) try { statement.close(); } catch(Exception e) {}  
			if (connection != null) try { connection.close(); } catch(Exception e) {} 
			Neo4jDatabase.closeSession(session);
			LoggerFacade.info("Conexiones cerradas correctamente");
			//Devuelvo true si se ha realizado correctamente la operacion y false en caso de no haberse realizado.
			LoggerFacade.debug("FIN loadLastActions(List<ActionBean>)");
			return rigthResult;
		}  
	}
	
	/**
	 * Este metodo elimina todas las acciones y sus correspondientes relaciones del grafo a traves del CYPHER<br>
	 * {@code CYPHER_REMOVE_ALL_ACTIONS = " MATCH (n)-[r]-(m) DELETE r,n,m "}<br>
	 * Por ultimo cierra la transaccion y la conexion al Neo4j.
	 */
	public void removeAllActions(){
		LoggerFacade.debug("INICIO removeAllActions()");
		
		// Declaramos objetos de conexion Neo4j
		Session session = null;
		Transaction tx = null;
		ResultSummary summary = null;
		try {
			//Conexion sobre Neo4j
			session = Neo4jDatabase.getSession();	
			LoggerFacade.info("Conexion Neo4j realizada correctamente");
			
			//Abrimos tansaccion sobre el Neo4j
			tx = session.beginTransaction();	
			LoggerFacade.info("Transaccion sobre Neo4j abierta correctamente");
			
			//Lanzamos Cypher
			summary = tx.run(Constants.CYPHER_REMOVE_ALL_ACTIONS).consume();
			LoggerFacade.info("Cypher: "+summary.statement().text());	
			
			//Marcamos la transaccion como correcta y hacemos commit
			tx.success();
			tx.close();
			LoggerFacade.info("Grafo eliminado correctamente");		

		}  
		// Si se produce algun error al hacer commit, hacemos un rollback de la transaccion
		catch (Neo4jException ex) {
			ex.printStackTrace();
			LoggerFacade.error("Fallada transaccion al eliminar el grafo", ex);
			tx.failure();
			tx.close();
			LoggerFacade.info("Rollback correctamente realizado");
		}

		finally { 			
			// Cerramos la conexion con Neo4j		
			Neo4jDatabase.closeSession(session);
			LoggerFacade.info("Conexiones cerradas correctamente");
			
			LoggerFacade.debug("FIN removeAllActions()");
		}  
	}
	
	
	
	

}
