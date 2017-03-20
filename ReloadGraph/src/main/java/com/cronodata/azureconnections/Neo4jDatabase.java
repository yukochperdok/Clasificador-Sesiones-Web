package com.cronodata.azureconnections;
  
import org.neo4j.driver.v1.AuthTokens;
import org.neo4j.driver.v1.Driver;
import org.neo4j.driver.v1.GraphDatabase;
import org.neo4j.driver.v1.Session;

import com.cronodata.utils.Constants;
import com.cronodata.utils.PropertiesWrapper;

/**
 * Esta clase encapsula la conexion con Neo4j a traves del protocolo bolt://<br>
 * Utilizando el host indicado en la propiedad "neo4j.host" del fichero de properties (reload_graph.properties),
 * y utilizando como connexion  una Autorizacion Token con usuario y password tambien definidos en el fichero de configuracion.<br> 
 * @author Cronodata
 * @version 1.0
 * @see <a href="https://github.com/neo4j-contrib/neo4j-jdbc">NEO4J JDBC</a>
 * @see <a href="https://neo4j.com/developer/get-started/">NEO4J Connections</a>
 * @see com.cronodata.services.ActionService
 * @see com.cronodata.utils.Constants
 * @see com.cronodata.utils.PropertiesWrapper
 * @see org.neo4j.driver.v1.Session
 */
public class Neo4jDatabase {  
	/**
	 * Driver de conexion a la BBDD de Neo4j
	 */
	private static Driver neo4jDriver;

	/**
	 * Inicializacion estatica del driver
	 */
	static {    
		neo4jDriver = GraphDatabase.driver("bolt://"+PropertiesWrapper.getProperty(Constants.PARAM_NEO4J_HOST), 
											AuthTokens.basic( PropertiesWrapper.getProperty(Constants.PARAM_NEO4J_USER), 
															  PropertiesWrapper.getProperty(Constants.PARAM_NEO4J_PASSWORD)));
	}

	/**
	 * Devuelve una sesion al Neo4j database
	 * @return {@link Session} Sesion del driver - neo4jDriver.session()
	 */
	public static Session getSession(){
		return neo4jDriver.session(); 
	}

	/**
	 * Cierra la session del Neo4j database pasada como parametro.
	 * @param session: {@link Session} Sesion del driver
	 */
	public static void closeSession(Session session){
		if (session != null && session.isOpen()) try { session.close(); } catch(Exception e) {}
	}     
}  

