package com.cronodata.beans;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import com.cronodata.azureconnections.SQLServerDatabase;
import com.cronodata.utils.LoggerFacade;

/**
 * Esta clase modela el comportamiento de la entidad DateSystem<br>
 * Esta entidad esta pensada para coger la fecha y hora de la ultima vez que se cargaron las acciones.
 * Para poder identificar a partir de que fecha y hora se deben cargar las siguientes acciones.
 * <br>Actualmente no se utiliza. Se utiliza el flag_load 'S' o 'N'.

 * @author Cronodata
 * @version 1.0
 * @see java.sql.Connection
 * @see java.sql.ResultSet
 * @see java.sql.Statement
 * @see com.cronodata.azureconnections.SQLServerDatabase
 * @see com.cronodata.utils.LoggerFacade
 */
public class DateSystemBean {
	/**
	 * Ultima hora de carga.
	 */
	private static java.sql.Timestamp lastSliceDataTime = new java.sql.Timestamp(0);
	
	/**
	 * Devuelve lastSliceDataTime
	 * @return lastSliceDataTime - Ultima hora de carga.
	 */
	public static java.sql.Timestamp getLastSliceDataTime() {
		return DateSystemBean.lastSliceDataTime;
	}
	
	/**
	 * Establece lastSliceDataTime
	 * @param lastSliceDataTime - Ultima hora de carga.
	 */
	public static void setLastSliceDataTime(java.sql.Timestamp lastSliceDataTime) {
		DateSystemBean.lastSliceDataTime = lastSliceDataTime;
	}
	
	/**
	 * Establece lastSliceDataTime a partir de una consulta a una tabla de SQLServer que tenga esa informacion
	 */
	public static void setLastSliceDataTime() {
		// Declaramos los objetos JDBC  
        Connection connection = null;  
        Statement statement = null;   
        ResultSet resultSet = null;  

                      
        try { 
        	//Conectamos con la BBDD
        	connection = SQLServerDatabase.getConnection();
        	LoggerFacade.info("Conexion SQL Database realizada correctamente");
        	
        	// Creamos y ejecutamos consulta a la tabla
            String selectSql = 
            		"SELECT last_slice_data_time FROM dbo.date_system ";  
            statement = connection.createStatement();  
            resultSet = statement.executeQuery(selectSql);
            
            // Mostamos resultados y cargamos la variable lastSliceDataTime 
            if (resultSet.next())   
            {
            	LoggerFacade.info("Ultimo Slice cargado= "+resultSet.getTimestamp("last_slice_data_time"));
            	DateSystemBean.lastSliceDataTime = resultSet.getTimestamp("last_slice_data_time");
            }  


        }  
        catch (Exception ex) {  
            ex.printStackTrace(); 
            LoggerFacade.error("ERROR al obtener last_slice_data_time", ex); 
        }  
        finally {  
        	// Cerramos las conexiones y resultset 
            if (resultSet != null) try { resultSet.close(); } catch(Exception e) {}  
            if (statement != null) try { statement.close(); } catch(Exception e) {}  
            if (connection != null) try { connection.close(); } catch(Exception e) {}  
            LoggerFacade.info("Conexiones cerradas correctamente");
        }
	}

	@Override
	public String toString() {
		return "DateSystemBean [lastSliceDataTime="+ DateSystemBean.lastSliceDataTime+ "]";
	}
}
