package com.cronodata.pruebas;

// Use the JDBC driver  
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement; 

public class SQLDatabaseConnection {  
    
    // Connect to your database.  
    // Replace server name, username, and password with your credentials  
    public static void main(String[] args) {  
 
    	String connectionString =  
    			"jdbc:sqlserver://carlos-database.database.windows.net:1433;"  
    			+ "database=carlos-database;"
    			+ "encrypt=true;"  
    			+ "trustServerCertificate=false;"  
    			+ "hostNameInCertificate=*.database.windows.net;"  
    			+ "loginTimeout=30;"; 
 

    	// Declare the JDBC objects.  
        Connection connection = null;  
        Statement statement = null;   
        ResultSet resultSet = null;  

                      
        try { 
        	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver"); 
        	connection = DriverManager.getConnection(connectionString,"cronodata","Cr0n0data");
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

