package com.cronodata.azureconnections;

import java.sql.Connection;
import com.cronodata.utils.Constants;
import com.cronodata.utils.LoggerFacade;
import com.cronodata.utils.PropertiesWrapper;
import com.microsoft.sqlserver.jdbc.SQLServerDataSource;
import com.microsoft.sqlserver.jdbc.SQLServerException; 

/**
 * Esta clase encapsula la conexion Con la base de datos SQL Server a traves de un protocolo JDBC (a traves de un dataSource)<br>
 * Para ello utiliza las propiedades del fichero (reload_graph.properties):
 * <ul>
 * 	<li>{@code Constants.PARAM_SQL_DB_SERVER = "sqlserver.server.name"}</li>
 * 	<li>{@code Constants.PARAM_SQL_DB_DBNAME = "sqlserver.database.name"}</li>
 * 	<li>{@code Constants.PARAM_SQL_DB_PORT = "sqlserver.port"}</li>
 * 	<li>{@code Constants.PARAM_SQL_DB_USER = "sqlserver.user"}</li>
 * 	<li>{@code Constants.PARAM_SQL_DB_PASSWORD = "sqlserver.password"}</li>
 * </ul> 
 * @author Cronodata
 * @version 1.0
 * @see <a href="https://docs.microsoft.com/es-es/azure/sql-database/">SQL SERVER</a>
 * @see com.cronodata.services.ActionService
 * @see com.cronodata.utils.Constants
 * @see com.cronodata.utils.PropertiesWrapper
 * @see java.sql.Connection
 * @see com.microsoft.sqlserver.jdbc.SQLServerDataSource
 * @see com.microsoft.sqlserver.jdbc.SQLServerException
 */
public class SQLServerDatabase {

	/**
	 * Datasource que gestiona las conexiones con el SQLServer Database
	 */	
    private static SQLServerDataSource dataSource;
    
    /**
	 * Inicializacion estatica del SQLServerDataSource
	 */
    static {
        try {
            // Establish the connection.   
            dataSource = new SQLServerDataSource();  
            dataSource.setServerName(PropertiesWrapper.getProperty(Constants.PARAM_SQL_DB_SERVER));   
            dataSource.setDatabaseName(PropertiesWrapper.getProperty(Constants.PARAM_SQL_DB_DBNAME));   
            dataSource.setPortNumber(Integer.parseInt(PropertiesWrapper.getProperty(Constants.PARAM_SQL_DB_PORT))); 
            dataSource.setUser(PropertiesWrapper.getProperty(Constants.PARAM_SQL_DB_USER));  
            dataSource.setPassword(PropertiesWrapper.getProperty(Constants.PARAM_SQL_DB_PASSWORD));
            //ds.setEncrypt(true);
            //ds.setTrustServerCertificate(false);
            //ds.setHostNameInCertificate("*.database.windows.net;");
            //ds.setLoginTimeout(30);
        }
        catch (Exception ex) { 
        	LoggerFacade.error("ERROR al crear SQLServerDataSource",ex);
        	ex.printStackTrace();        	
        }
    }


    private SQLServerDatabase() {
      // private constructor //
    }

    /**
	 * Devuelve una conexion al Database del SQL Server
	 * @return {@link Connection} Conexion a la BBDD - dataSource.getConnection()
	 * @throws SQLServerException - Excepcion controlada en fallo de conexion.
	 */
    public static Connection getConnection() throws SQLServerException{
        try {            	
            return dataSource.getConnection();  
        } catch (SQLServerException ex) {        	 
        	LoggerFacade.error("ERROR al recoger una conexion del SQLServerDataSource",ex);
            throw ex;
        }
    }
}
