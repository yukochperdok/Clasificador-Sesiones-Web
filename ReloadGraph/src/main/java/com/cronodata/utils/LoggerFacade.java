package com.cronodata.utils;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.util.ReflectionUtil;

/**
 * Clase que contiene el controlador de trazas. Este controlador se basa en Log4j2 - Y define su comportamiento en base al fichero de configuracion log4j2.xml.<br>
 * Sigue un patron de diseño - Facade
 * @author Cronodata
 * @version 1.0
 * @see <a href="http://logging.apache.org/log4j/2.x/">GUIA LOG4J2</a>
 * @see org.apache.logging.log4j.LogManager
 * @see org.apache.logging.log4j.Logger
 * @see org.apache.logging.log4j.util.ReflectionUtil
 */
public class LoggerFacade {  
	
	/**
	 * Devuelve un trazador en el pool de trazadores definidos el log4j2. Si no existe devuelve el trazador root.
	 * @return {@link Logger} Trazador - ReflectionUtil.getCallerClass(3)!=null?LogManager.getLogger(ReflectionUtil.getCallerClass(3)):LogManager.getRootLogger();
	 */
	protected static Logger getLogger(){
		return ReflectionUtil.getCallerClass(3)!=null?LogManager.getLogger(ReflectionUtil.getCallerClass(3)):LogManager.getRootLogger();
	}
	
	/* METODOS PARA TRAZAS EN LEVEL FATAL*/
	/**
	 * Realiza una traza con {@link org.apache.logging.log4j.Level#FATAL}
	 * @param message mensaje de la traza
	 */
    public static void fatal(String message) {
    	getLogger().fatal(message);    	
	} 
    /**
	 * Realiza una traza con {@link org.apache.logging.log4j.Level#FATAL}
	 * @param message mensaje de la traza
	 * @param t excepcion a trazar
	 */
    public static void fatal(String message, Throwable t) {
    	getLogger().fatal(message,t);    	
	}     

	/* METODOS PARA TRAZAS EN LEVEL ERROR*/
    /**
	 * Realiza una traza con {@link org.apache.logging.log4j.Level#ERROR}
	 * @param message mensaje de la traza
	 */
    public static void error(String message) {
    	getLogger().error(message);    	
	} 
    /**
	 * Realiza una traza con {@link org.apache.logging.log4j.Level#ERROR}
	 * @param message mensaje de la traza
	 * @param t excepcion a trazar
	 */
    public static void error(String message, Throwable t) {
    	getLogger().error(message,t);    	
	}
    
    /* METODOS PARA TRAZAS EN LEVEL WARNING*/
    /**
	 * Realiza una traza con {@link org.apache.logging.log4j.Level#WARN}
	 * @param message mensaje de la traza
	 */
    public static void warn(String message) {
    	getLogger().warn(message);    	
	}
    /**
	 * Realiza una traza con {@link org.apache.logging.log4j.Level#WARN}
	 * @param message mensaje de la traza
	 * @param t excepcion a trazar
	 */
    public static void warn(String message, Throwable t) {
    	getLogger().warn(message,t);    	
	}
    
    /* METODOS PARA TRAZAS EN LEVEL INFO*/
    /**
	 * Realiza una traza con {@link org.apache.logging.log4j.Level#INFO}
	 * @param message mensaje de la traza
	 */
    public static void info(String message) {
    	getLogger().info(message);    	
	} 
    /**
	 * Realiza una traza con {@link org.apache.logging.log4j.Level#INFO}
	 * @param message mensaje de la traza
	 * @param t excepcion a trazar
	 */
    public static void info(String message, Throwable t) {
    	getLogger().info(message,t);    	
	} 
    
    /* METODOS PARA TRAZAS EN LEVEL DEBUG*/
    /**
	 * Realiza una traza con {@link org.apache.logging.log4j.Level#DEBUG}
	 * @param message mensaje de la traza
	 */
    public static void debug(String message) {
    	getLogger().debug(message);    	
	} 
    /**
	 * Realiza una traza con {@link org.apache.logging.log4j.Level#INFO}
	 * @param message mensaje de la traza
	 * @param t excepcion a trazar
	 */
    public static void debug(String message, Throwable t) {
    	getLogger().debug(message,t);    	
	} 
    
    /* METODOS PARA TRAZAS EN LEVEL TRACE*/
    /**
	 * Realiza una traza con {@link org.apache.logging.log4j.Level#TRACE}
	 * @param message mensaje de la traza
	 */
    public static void trace(String message) {
    	getLogger().trace(message); 
	} 
    /**
	 * Realiza una traza con {@link org.apache.logging.log4j.Level#TRACE}
	 * @param message mensaje de la traza
	 * @param t excepcion a trazar
	 */
    public static void trace(String message, Throwable t) {
    	getLogger().trace(message,t);    	
	}    

}  

