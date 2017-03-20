package com.cronodata.pruebas;

// Use the Noe4j driver  
import org.neo4j.driver.v1.*;  

public class Neo4jConnection {  
    
 
    public static void main(String[] args) {  
  
    	Driver driver = GraphDatabase.driver( "bolt://neo4j-virtual-machine.northeurope.cloudapp.azure.com", AuthTokens.basic( "neo4j", "cronodata" ) );
    	Session session = driver.session(); 

                      
        try { 
        	

        	//session.run( "CREATE (a:Person {name:'Arthur5', title:'King'})" );

        	StatementResult result = session.run( "MATCH (a:Person) WHERE a.name = 'Arthur5' RETURN a.name AS name, a.title AS title" );
        	while ( result.hasNext() )
        	{
        	    Record record = result.next();
        	    System.out.println( record.get( "title" ).asString() + " " + record.get("name").asString() );
        	}

        	session.close();
        	driver.close();


        }  
        catch (Exception e) {  
            e.printStackTrace();  
        }  
        finally {  
        	// Close the connections after the data has been handled.  
            if (session != null) try { session.close(); } catch(Exception e) {}  
            if (driver != null) try { driver.close(); } catch(Exception e) {}  
 
        }  
    }  
}  

