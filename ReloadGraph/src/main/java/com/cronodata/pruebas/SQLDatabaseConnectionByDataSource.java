package com.cronodata.pruebas;

// Use the JDBC driver  
import java.sql.*;  
import com.microsoft.sqlserver.jdbc.*; 

public class SQLDatabaseConnectionByDataSource {  
    
    // Connect to your database.  
    // Replace server name, username, and password with your credentials  
    public static void main(String[] args) {  

    	// Declare the JDBC objects.  
        Connection connection = null;  
        Statement statement = null;   
        ResultSet resultSet = null;  

                      
        try { 
        	// Establish the connection.   
            SQLServerDataSource ds = new SQLServerDataSource();  
            ds.setUser("cronodata");  
            ds.setPassword("Cr0n0data");  
            ds.setServerName("carlos-database.database.windows.net");  
            ds.setPortNumber(1433);   
            ds.setDatabaseName("carlos-database");
            //ds.setEncrypt(true);
            //ds.setTrustServerCertificate(false);
            //ds.setHostNameInCertificate("*.database.windows.net;");
            //ds.setLoginTimeout(30);
            connection = ds.getConnection();  

        	System.out.println("Connection Made");
        	
        	// Create and execute a SELECT SQL statement.  
            String selectSql = "SELECT DISTINCT(context_session_id) from dbo.events_views_optimizada";  
            statement = connection.createStatement();  
            resultSet = statement.executeQuery(selectSql);  

            // Print results from select statement  
            while (resultSet.next())   
            {  
                System.out.println("Session= "+resultSet.getString(1));  
            }  


        }  
        catch (Exception e) {  
            e.printStackTrace();  
        }  
        finally {  
        	// Close the connections after the data has been handled.  
            if (resultSet != null) try { resultSet.close(); } catch(Exception e) {}  
            if (statement != null) try { statement.close(); } catch(Exception e) {}  
            if (connection != null) try { connection.close(); } catch(Exception e) {}  
 
        }  
    }  
}  

