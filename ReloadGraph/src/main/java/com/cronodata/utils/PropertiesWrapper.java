package com.cronodata.utils;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Clase que envuelve el comportamiento con el fichero de propiedades reload_graph.properties<br>
 * La ruta de este fichero o se indica por parametro a la JVM ... -DDIR_CONFIG=--ruta_config-- o bien a traves de una variable de entorno llamada DIR_CONFIG.
 * @author Cronodata
 * @version 1.0
 * @see <a href="http://logging.apache.org/log4j/2.x/">GUIA LOG4J2</a>
 * @see java.util.Properties
 * @see java.io.InputStream
 */
public class PropertiesWrapper {  
	/**
	 * Properties que refleja el contenido de reload_graph.properties
	 */
	private static Properties properties;
    
	/**
	 * Inicializacion estatica del fichero de propiedades. <br>
	 * Para hallar la ubicacion del fichero de configuracion, primero mira si existe la variable de entorno DIR_CONFIG, sino existe busca como paramentro de entrada a la JVM -DDIR_CONFIG.<br>
	 * Posteriormente carga en {@link #properties} el fichero de configuracion.
	 * @throws FileNotFoundException Fichero no encontrado.
	 * @throws IOException No se puede abrir un flujo con el fichero
	 */
	public static void initConfiguration() throws FileNotFoundException, IOException  {
		String dirConfig = System.getenv(Constants.DIR_CONFIG_PROPERTIES);
		if(dirConfig==null) dirConfig = System.getProperty(Constants.DIR_CONFIG_PROPERTIES);
		
		try (InputStream in = new FileInputStream(dirConfig+"/"+Constants.FILE_PROPERTIES)) {
			properties = new Properties();
			properties.load(in);
			for (String property : properties.stringPropertyNames()) {
				String value = properties.getProperty(property);
				LoggerFacade.debug(property + "=" + value);
			}
		} catch (FileNotFoundException e) {
			LoggerFacade.fatal("Error al cargar el fichero de propiedades. Revise la ubicacion.",e);
			throw e;
		} catch (IOException e) {
			LoggerFacade.fatal("Error al recoger propiedad. Revisar fichero configuracion -->"+dirConfig+"/"+Constants.FILE_PROPERTIES, e);
			throw e;
		}
	}
	
	/**
	 * Recupera la propiedad asocias a una clave.	 
	 * @param key Clave de la propiedad
	 * @return valor asociado a la clave.
	 */
	public static String getProperty(String key){
		return properties.getProperty(key);
	}
}  

