package com.cronodata;

import com.cronodata.services.ActionService;
import com.cronodata.utils.Constants;
import com.cronodata.utils.LoggerFacade;
import com.cronodata.utils.PropertiesWrapper;
import com.cronodata.utils.Utils;

/**
 * Esta clase es el punto de entrada de ejecuccion del proceso.<br>
 * Esta clase se ejecuta lanzando el script "reload_graph operacion".<br> 
 * Donde operacion puede ser:<br> 
 * 		<ul><li>{@link Constants#OP_RELOAD} : Para recargar el grafo en Neo4j con toda las acciones de la tabla que no hayan sido aun cargadas.</li>
 * 		<li>{@link Constants#OP_TEST} : Recoge la hora del sistema de la tabla de eventos. De esta forma se hace un testeo de la conexion y existencia de la tabla.</li>
 * 		<li>{@link Constants#OP_DELETE} : Elimina todo el contenido del grafo en Neo4j.</li></ul>
 * 
 * @author Cronodata
 * @version 1.0
 * @see com.cronodata.services.ActionService
 * @see com.cronodata.utils.Constants
 * @see com.cronodata.utils.LoggerFacade
 * @see com.cronodata.utils.PropertiesWrapper 
 */
public class ReloadGraph {	
 
	/**
	 * Metodo main que recibira como parametro args[0] la operacion a realizar.<br>
	 * Primeramente, inicializa la configuracion a traves de {@link PropertiesWrapper}<br>
	 * Posteriormente, en funcion de {@code args[0]} llamamos al correspondiente metodo del servicio {@link ActionService}.<br>
	 * Recoge la <tt> Exception </tt> producida y la muestra por Logger.<br>
	 * @param args: Como argumento en la posicion 0, la operacion a realizar
	 */
    public static void main(String[] args) {
    	LoggerFacade.debug("INICIO main(String[] args)");
    	
    	//Recogemos los milisegundos de inicio del proceso
    	long iniProcess = System.currentTimeMillis();
        
        try {
        	//Inicializamos la configuracion
        	PropertiesWrapper.initConfiguration();
        	//Si no se ha introducido operacion rechazamos el proceso y terminamos,
        	// en caso contrario redirigimos al metodo del servicio correspondiente
        	if(args[0]!=null && !args[0].isEmpty()){
        		ActionService service = new ActionService();
        		switch(args[0]){
        		//Operacion de recarga del grafo
        		case Constants.OP_RELOAD:
        			LoggerFacade.info("Opcion seleccionada: "+ args[0]);
        			service.reloadGraph();
        			break;
        		//Operacion de testeo de la BBDD
        		case Constants.OP_TEST:
        			LoggerFacade.info("Opcion seleccionada: "+ args[0]);
        			service.testBBDD();
        			break;
        		//Operacion de eliminacion del grafo
        		case Constants.OP_DELETE:
        			LoggerFacade.info("Opcion seleccionada: "+ args[0]);
        			service.deleteGraph();
        			break;
        		// Si no es ninguna de las opciones no hacemos nada
        		default:
        			LoggerFacade.error("Opcion incorrecta:"+args[0]+". Solo son permitidas: "+Constants.OP_RELOAD+", "+Constants.OP_TEST+" y "+Constants.OP_DELETE);
        			break;
        		}
        	}

        }  
        catch (Exception e) {  
            e.printStackTrace();
            LoggerFacade.error("ERROR EN EL PROCESO ReloadGraph",e);
        }
        finally{
        	// Calculamos el tiempo transcurrido del proceso y lo mostramos por Logger
        	long durationProcess = System.currentTimeMillis() - iniProcess;        	
        	LoggerFacade.info("DURACION PROCESO ReloadGraph: "+ Utils.millisParseString(durationProcess)); 
        	LoggerFacade.debug("FIN main(String[] args)");       
        }
    }  
}
