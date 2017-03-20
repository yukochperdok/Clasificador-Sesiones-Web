package com.cronodata.services;

import com.cronodata.dao.ActionDAO;
import com.cronodata.utils.Constants;
import com.cronodata.utils.LoggerFacade;
import com.cronodata.utils.PropertiesWrapper;

/**
 * Esta clase encapsula todos los servicios disponibles sobre acciones. Ejecuta gracias a la clase {@link ActionDAO}<br>
 * Tiene 3 metodos:<br>
 * <ul>
 * 	<li>{@link #testBBDD()} - Testea la conexion a BBDD, consultando la hora</li>
 *  <li>{@link #reloadGraph()} - Carga todas las acciones pendientes de cargar en el grafo. Con politica de reintentos</li>
 *  <li>{@link #deleteGraph()} - Borra todo el contenido del grafo</li>
 * </ul> <br>
 * @author Cronodata
 * @version 1.0
 * @see com.cronodata.dao.ActionDAO
 * @see com.cronodata.utils.Constants
 * @see com.cronodata.utils.LoggerFacade
 * @see com.cronodata.utils.PropertiesWrapper
 */
public class ActionService {
	
	/**
	 * Envoltorio de acceso a datos
	 */	
	private ActionDAO actionDAO = null;
	
	/**
	 * Constructor por defecto. Inicializa el actionDAO - Envoltorio de acceso a datos.
	 */
	public ActionService(){
		actionDAO = new ActionDAO();
	}


	/**
	 * Este metodo testea la conexion a BBDD SqlServer, preguntando la hora.
	 * @throws Exception Si se produce algun error de conexion o en la consulta.
	 */
    public void testBBDD() throws Exception {
    	LoggerFacade.debug("INICIO testBBDD()");
        
        try {  
        	// Recoger Fecha Sql Server
        	actionDAO.getDate();
        }  
        catch (Exception e) {
            LoggerFacade.error("ERROR EN Service testBBDD()",e);
            throw e;
        }
        finally{
        	LoggerFacade.debug("FIN testBBDD()");       
        }
    }  
 
    /**
	 * Este metodo recarga todas las acciones pendientes de cargar en el grafo. Con una politica de reintentos definida por las vabiables:
	 *  <ul>
	 * 	<li>{@code Constants.PARAM_NUM_ATTEMPTS = "num.attempts"} - Numero de intentos.</li>
	 *  <li>{@code Constants.PARAM_TIME_ATTEMPT = "time.attempt"} - Numero de milisegundos entre cada intento.</li>
	 * </ul> <br>
	 * @throws Exception Si se produce algun error de consulta de variables, conexiones o en el commit de las transacciones.
	 */
    public void reloadGraph() throws Exception {
    	LoggerFacade.debug("INICIO reloadGraph()");
        boolean rigthResult = false;
        int numAttempts = 0;
        long millsTimeAttempt = 0;
        
        try {
        	numAttempts = PropertiesWrapper.getProperty(Constants.PARAM_NUM_ATTEMPTS)!=null?Integer.parseInt(PropertiesWrapper.getProperty(Constants.PARAM_NUM_ATTEMPTS)):3;
        	LoggerFacade.info("Numero de intentos configurado a "+ numAttempts);
        	millsTimeAttempt = PropertiesWrapper.getProperty(Constants.PARAM_TIME_ATTEMPT)!=null?Long.parseLong(PropertiesWrapper.getProperty(Constants.PARAM_TIME_ATTEMPT)):3000L;
        	LoggerFacade.info("Tiempo de espera entre cada intento configurado a "+ millsTimeAttempt +"(ms)");
        	
        	int i = 1;
        	while (!rigthResult && i <= numAttempts){
	        	// Actualizar el grafo con ultimos registros insertados        	
        		rigthResult = actionDAO.loadLastActions(actionDAO.getLastActions());
        		i++;
        		if(!rigthResult) 
        			Thread.sleep(millsTimeAttempt);
        	}
        }  
        catch (Exception e) {
            LoggerFacade.error("ERROR EN Service reloadGraph()",e);
            throw e;
        }
        finally{
        	LoggerFacade.debug("FIN reloadGraph()");       
        }
    }  
    
    /**
	 * Este metodo elimina todo el contenido del grafo.
	 * @throws Exception - Si se produce algun error de conexion o en la consulta.
	 */
    public void deleteGraph() throws Exception {
    	LoggerFacade.debug("INICIO deleteGraph()");
        
        try {        	
        	// Eliminar todo el grafo 
        	actionDAO.removeAllActions();
        }  
        catch (Exception e) {
            LoggerFacade.error("ERROR EN Service deleteGraph()",e);
            throw e;
        }
        finally{
        	LoggerFacade.debug("FIN deleteGraph()");       
        }
    }
}  

