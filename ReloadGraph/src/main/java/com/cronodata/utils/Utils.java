package com.cronodata.utils;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.TimeZone;

/**
 * Clase que contiene todas las Utilities utilizadas en el proceso.
 * @author Cronodata
 * @version 1.0
 */
public class Utils {  
    
	/**
	 * Escapa un string de entrada y lo propone como salida	 
	 * @param str Cadena de entrada
	 * @return Cadena escapada.
	 */
    public static String escapeSpecialCharsSession(String str) {		
	    return "`"+str+"`";
	}
    
    /**
	 * Escapa un string de entrada y lo propone como salida	 
	 * @param str Cadena de entrada
	 * @return Cadena escapada.
	 */
    public static String escapeSpecialChars(String str) {		
	    return str.replaceAll("[\\'\\\\]", "\\\\$0");
	}
    
    /**
	 * Convierte un TImestamp en un string dandole un formato: MM-dd-yyyy hh:mm:ss.SSS, y con una zona horaria:GMT+1
	 * @param ts Timestamp de entrada
	 * @return Cadena formateada
	 */
    public static String timestampToString(Timestamp ts){
    	SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss.SSS");
    	DATE_FORMAT.setTimeZone(TimeZone.getTimeZone("GMT+1"));
        return DATE_FORMAT.format(ts);
    }
    
    /**
	 * Convierte un long de milisagundos a una cadena formateada de hh:mm:ss:SSS.
	 * @param millis Long de milisegundos
	 * @return Cadena formateada a hh:mm:ss:SSS
	 */
    public static String millisParseString(long millis){
    	long second = (millis / 1000) % 60;
    	long minute = (millis / (1000 * 60)) % 60;
    	long hour = (millis / (1000 * 60 * 60)) % 24;
    	String time = String.format("%02d:%02d:%02d:%d", hour, minute, second, millis);
    	
    	return time;
    }
    
    /**
	 * Introduce los parametros a una consulta Cypher
	 * @param cypher Consulta Cypher
	 * @param params Array de parametros
	 * @return Cadena con la consulta cypher y los parametros resuletos dentro.
	 */
    public static String getTranslatedCypher(String cypher, String[] params){    	
    	for (int i = 0; i< params.length; i++)
    		cypher = cypher.replace("{"+String.valueOf(i)+"}", params[i]);
    	return cypher;
    }
}  

