package com.cronodata.beans;

import java.sql.Timestamp;

/**
 * Esta clase modela el comportamiento de la entidad Action<br>
 * Basicamente tiene todos los get/set para los atributos privados de la clase:<br>
 * <ul>
 * 	<li>{@code private String actionType}</li>
 * 	<li>{@code private String actionName}</li>
 *  <li>{@code private String actionNode}</li>
 * 	<li>{@code private String contextUserAnonId}</li>
 * 	<li>{@code private String contextUserAuthId}</li>
 * 	<li>{@code private boolean contextUserIsAuthenticated}</li>
 * 	<li>{@code private String contextSessionId}</li>
 * 	<li>{@code private boolean contextSessionIsFirst}</li>
 * 	<li>{@code private String viewUrl}</li>
 * 	<li>{@code private java.sql.Timestamp contextDataEventTime}</li>
 * 	<li>{@code private java.sql.Timestamp sliceDataTime}</li>
 * 	<li>{@code private String contextOperationId}</li>
 * 	<li>{@code private String contextOperationParentId}</li>
 * 	<li>{@code private String contextOperationName}</li>
 * 	<li>{@code private String customDimensionsId}</li>
 * 	<li>{@code private String customDimensionsKey}</li>
 * 	<li>{@code private String customDimensionsSecondParameter}</li>
 * 	<li>{@code private String customDimensionsDescription}</li>
 * </ul>  
 * @author Cronodata
 * @version 1.0
 * @see java.sql.Timestamp
 */
public class ActionBean {
	/**
	 * Tipo de accion: Event o PageView
	 */	
	private String actionType;
	
	/**
	 * Nombre de la accion: Accion realizada + que ha realizado.
	 * Por ejemplo: ChangeSportInLivePage:soccer_1
	 */
	private String actionName;
	
	/**
	 * Nombre que recibira el nodo del grafo. Se calcula en el proceso de carga de la tabla.
	 */
	private String actionNode;
	
	/**
	 * Identificador del usuario anonimo.
	 */
	private String contextUserAnonId;
	
	/**
	 * Identificador del usuario una vez logado.
	 */
	private String contextUserAuthId;
	
	/**
	 * Flag indicando si se ha logado o no
	 */
	private boolean contextUserIsAuthenticated;
	
	/**
	 * Identificador de la session del usuario. Un usuario puede tener diferentes sessiones.
	 */
	private String contextSessionId;
	
	/**
	 * Flag indicando si es la primera conexion del usuario
	 */
	private boolean contextSessionIsFirst;
	
	/**
	 * En caso de que sea un PageView, url:
	 * Por ejemplo: https://m.apuestas.codere.es/deportes/#/HomePage
	 */
	private String viewUrl;
	
	/**
	 * Fecha y hora en que se produce la accion
	 */
	private java.sql.Timestamp contextDataEventTime;
	
	/**
	 * Fecha y hora en la que se carga la accion en BBDD
	 */
	private java.sql.Timestamp sliceDataTime;
	
	/**
	 * Identificador de la accion
	 */
	private String contextOperationId;
	
	/**
	 * Identificador del padre de la accion. Dentro del arbol de acciones de la pagina
	 */
	private String contextOperationParentId;	
	
	/**
	 * Nombre de la accion dentro del arbol de acciones.
	 * Por ejemplo:/deportes/ 
	 */
	private String contextOperationName;
	
	/**
	 * Identificador unico de la accion.
	 * Por ejemplo: 103843409.
	 */
	private String customDimensionsId;
	
	/**
	 * Clave unica de la accion.
	 * Por ejemplo: ChangeSportInLivePage.
	 */
	private String customDimensionsKey;
	
	/**
	 * Dentro de la clave unica de la accion. Segundo parametroPor ejemplo deporte o evento apostado
	 * Por ejemplo: soccer_1.
	 */
	private String customDimensionsSecondParameter;
	
	/**
	 * Descripcion de la clave unica de la accion. 
	 * Por ejemplo: Cambio deporte en pagina directos.
	 */
	private String customDimensionsDescription;
	
	/**
	 * Constructor por defecto. Carga las variables a "", false o java.sql.Timestamp(0).
	 */
	public ActionBean(){
		super();
		this.actionType = "";
		this.actionName = "";
		this.actionNode = "";
		this.contextUserAnonId = "";
		this.contextUserAuthId = "";
		this.contextUserIsAuthenticated = false;
		this.contextSessionId = "";
		this.contextSessionIsFirst = false;
		this.viewUrl = "";
		this.contextDataEventTime = new java.sql.Timestamp(0);
		this.sliceDataTime = new java.sql.Timestamp(0);
		this.contextOperationId = "";
		this.contextOperationParentId = "";
		this.contextOperationName = "";
		this.customDimensionsId = "";
		this.customDimensionsKey = "";
		this.customDimensionsSecondParameter = "";
		this.customDimensionsDescription = "";
	}
	
	/**
	 * Constructor por parametros. Carga las variables con los parametros de entrada.
	 * @param actionType (String) - Tipo de accion: Event o PageView
	 * @param actionName (String) - Nombre de la accion: Accion realizada + que ha realizado. Por ejemplo: ChangeSportInLivePage:soccer_1
	 * @param actionNode (String) - Nombre que recibira el nodo del grafo. Se calcula en el proceso de carga de la tabla.
	 * @param contextUserAnonId (String) - Identificador del usuario anonimo.
	 * @param contextUserAuthId (String) - Identificador del usuario una vez logado.
	 * @param contextUserIsAuthenticated (boolean) - Flag indicando si se ha logado o no
	 * @param contextSessionId (String) - Identificador de la session del usuario. Un usuario puede tener diferentes sessiones.
	 * @param contextSessionIsFirst (boolean) - Flag indicando si es la primera conexion del usuario
	 * @param viewUrl (String) - En caso de que sea un PageView, url. Por ejemplo: https://m.apuestas.codere.es/deportes/#/HomePage
	 * @param contextDataEventTime (String) - Fecha y hora en que se produce la accion
	 * @param sliceDataTime (String) - Fecha y hora en la que se carga la accion en BBDD
	 * @param contextOperationId (String) - Identificador de la accion
	 * @param contextOperationParentId (String) - Identificador del padre de la accion. Dentro del arbol de acciones de la pagina
	 * @param contextOperationName (String) - Nombre de la accion dentro del arbol de acciones. Por ejemplo:/deportes/ 
	 * @param customDimensionsId (String) - Identificador unico de la accion. Por ejemplo: 103843409.
	 * @param customDimensionsKey (String) - Clave unica de la accion. Por ejemplo: ChangeSportInLivePage.
	 * @param customDimensionsSecondParameter (String) -  Dentro de la clave unica de la accion, segundo parametro - Por ejemplo deporte o evento apostado. Por ejemplo: soccer_1.
	 * @param customDimensionsDescription (String) - Descripcion de la clave unica de la accion. Por ejemplo: Cambio deporte en pagina directos. 
	 */
	public ActionBean(String actionType, String actionName, String actionNode, String contextUserAnonId, String contextUserAuthId,
			boolean contextUserIsAuthenticated, String contextSessionId, boolean contextSessionIsFirst,
			String viewUrl, Timestamp contextDataEventTime, Timestamp sliceDataTime, String contextOperationId,
			String contextOperationParentId, String contextOperationName, String customDimensionsId,
			String customDimensionsKey, String customDimensionsSecondParameter, String customDimensionsDescription) {
		super();
		this.actionType = actionType;
		this.actionName = actionName;
		this.actionNode = actionNode;
		this.contextUserAnonId = contextUserAnonId;
		this.contextUserAuthId = contextUserAuthId;
		this.contextUserIsAuthenticated = contextUserIsAuthenticated;
		this.contextSessionId = contextSessionId;
		this.contextSessionIsFirst = contextSessionIsFirst;
		this.viewUrl = viewUrl;
		this.contextDataEventTime = contextDataEventTime;
		this.sliceDataTime = sliceDataTime;
		this.contextOperationId = contextOperationId;
		this.contextOperationParentId = contextOperationParentId;
		this.contextOperationName = contextOperationName;
		this.customDimensionsId = customDimensionsId;
		this.customDimensionsKey = customDimensionsKey;
		this.customDimensionsSecondParameter = customDimensionsSecondParameter;
		this.customDimensionsDescription = customDimensionsDescription;
	}

	/**
	 * Devuelve actionType
	 * @return actionType - Tipo de accion: Event o PageView
	 */
	public String getActionType() {
		return actionType;
	}	
	/**
	 * Establece actionType
	 * @param actionType - Tipo de accion: Event o PageView
	 */
	public void setActionType(String actionType) {
		this.actionType = actionType;
	}
	
	/**
	 * Devuelve actionName
	 * @return actionName - Nombre de la accion: Accion realizada + que ha realizado. Por ejemplo: ChangeSportInLivePage:soccer_1
	 */
	public String getActionName() {
		return actionName;
	}	
	/**
	 * Establece actionName
	 * @param actionName - Nombre de la accion: Accion realizada + que ha realizado. Por ejemplo: ChangeSportInLivePage:soccer_1
	 */
	public void setActionName(String actionName) {
		this.actionName = actionName;
	}
	
	/**
	 * Devuelve actionNode
	 * @return actionNode - Nombre que recibira el nodo del grafo. Se calcula en el proceso de carga de la tabla.
	 */
	public String getActionNode() {
		return actionNode;
	}	
	/**
	 * Establece actionNode
	 * @param actionNode - Nombre que recibira el nodo del grafo. Se calcula en el proceso de carga de la tabla.
	 */
	public void setActionNode(String actionNode) {
		this.actionNode = actionNode;
	}
	
	/**
	 * Devuelve contextUserAnonId
	 * @return contextUserAnonId - Identificador del usuario anonimo.
	 */
	public String getContextUserAnonId() {
		return contextUserAnonId;
	}
	/**
	 * Establece contextUserAnonId
	 * @param contextUserAnonId - Identificador del usuario anonimo.
	 */
	public void setContextUserAnonId(String contextUserAnonId) {
		this.contextUserAnonId = contextUserAnonId;
	}
	
	/**
	 * Devuelve getContextUserAuthId
	 * @return getContextUserAuthId - Identificador del usuario una vez logado.
	 */
	public String getContextUserAuthId() {
		return contextUserAuthId;
	}
	/**
	 * Establece contextUserAuthId
	 * @param contextUserAuthId - Identificador del usuario una vez logado.
	 */
	public void setContextUserAuthId(String contextUserAuthId) {
		this.contextUserAuthId = contextUserAuthId;
	}
	
	/**
	 * Devuelve contextUserIsAuthenticated
	 * @return <ul>
	 * 			<li>true: si se ha logado</li>
	 * 			<li>false: si no lo ha hecho</li>
	 * 			</ul>
	 */
	public boolean isContextUserIsAuthenticated() {
		return contextUserIsAuthenticated;
	}
	/**
	 * Establece contextUserIsAuthenticated
	 * @param contextUserIsAuthenticated - Flag si esta logado o no
	 */
	public void setContextUserIsAuthenticated(boolean contextUserIsAuthenticated) {
		this.contextUserIsAuthenticated = contextUserIsAuthenticated;
	}
	
	/**
	 * Devuelve contextSessionId
	 * @return contextSessionId - Identificador de la session del usuario. Un usuario puede tener diferentes sessiones.
	 */
	public String getContextSessionId() {
		return contextSessionId;
	}
	/**
	 * Establece contextSessionId
	 * @param contextSessionId - Identificador de la session del usuario. Un usuario puede tener diferentes sessiones.
	 */
	public void setContextSessionId(String contextSessionId) {
		this.contextSessionId = contextSessionId;
	}
	
	/**
	 * Devuelve contextSessionIsFirst
	 * @return <ul>
	 * 			<li>true: si es su primera sesion</li>
	 * 			<li>false: si no lo es</li>
	 * 			</ul>
	 */
	public boolean isContextSessionIsFirst() {
		return contextSessionIsFirst;
	}
	/**
	 * Establece contextSessionIsFirst
	 * @param contextSessionIsFirst - Flag de si es su primera sesion o no.
	 */
	public void setContextSessionIsFirst(boolean contextSessionIsFirst) {
		this.contextSessionIsFirst = contextSessionIsFirst;
	}
	
	/**
	 * Devuelve viewUrl
	 * @return viewUrl - En caso de que sea un PageView, url. Por ejemplo: https://m.apuestas.codere.es/deportes/#/HomePage
	 */
	public String getViewUrl() {
		return viewUrl;
	}
	/**
	 * Establece viewUrl
	 * @param viewUrl - n caso de que sea un PageView, url. Por ejemplo: https://m.apuestas.codere.es/deportes/#/HomePage
	 */
	public void setContextViewUrl(String viewUrl) {
		this.viewUrl = viewUrl;
	}
	
	/**
	 * Devuelve contextDataEventTime
	 * @return contextDataEventTime - Fecha y hora en que se produce la accion
	 */
	public java.sql.Timestamp getContextDataEventTime() {
		return contextDataEventTime;
	}
	/**
	 * Establece contextDataEventTime
	 * @param contextDataEventTime - Fecha y hora en que se produce la accion
	 */
	public void setContextDataEventTime(java.sql.Timestamp contextDataEventTime) {
		this.contextDataEventTime = contextDataEventTime;
	}
	
	/**
	 * Devuelve sliceDataTime
	 * @return sliceDataTime - Fecha y hora en la que se carga la accion en BBDD
	 */
	public java.sql.Timestamp getSliceDataTime() {
		return sliceDataTime;
	}
	/**
	 * Establece sliceDataTime
	 * @param sliceDataTime - Fecha y hora en la que se carga la accion en BBDD
	 */
	public void setSliceDataTime(java.sql.Timestamp sliceDataTime) {
		this.sliceDataTime = sliceDataTime;
	}
	
	/**
	 * Devuelve contextOperationId
	 * @return contextOperationId - Identificador de la accion
	 */
	public String getContextOperationId() {
		return contextOperationId;
	}
	/**
	 * Establece contextOperationId
	 * @param contextOperationId - Identificador de la accion
	 */
	public void setContextOperationId(String contextOperationId) {
		this.contextOperationId = contextOperationId;
	}
	
	/**
	 * Devuelve contextOperationId
	 * @return contextOperationId - Identificador del padre de la accion. Dentro del arbol de acciones de la pagina
	 */
	public String getContextOperationParentId() {
		return contextOperationParentId;
	}
	/**
	 * Establece contextOperationParentId
	 * @param contextOperationParentId - Identificador del padre de la accion. Dentro del arbol de acciones de la pagina
	 */
	public void setContextOperationParentId(String contextOperationParentId) {
		this.contextOperationParentId = contextOperationParentId;
	}
	
	/**
	 * Devuelve contextOperationName
	 * @return contextOperationName - Nombre de la accion dentro del arbol de acciones. Por ejemplo:/deportes/ 
	 */
	public String getContextOperationName() {
		return contextOperationName;
	}
	/**
	 * Establece contextOperationName
	 * @param contextOperationName - Nombre de la accion dentro del arbol de acciones. Por ejemplo:/deportes/ 
	 */
	public void setContextOperationName(String contextOperationName) {
		this.contextOperationName = contextOperationName;
	}
		
	/**
	 * Devuelve customDimensionsId
	 * @return customDimensionsId -  Identificador unico de la accion. Por ejemplo: 103843409.
	 */
	public String getCustomDimensionsId() {
		return customDimensionsId;
	}
	/**
	 * Establece customDimensionsId
	 * @param customDimensionsId - Identificador unico de la accion. Por ejemplo: 103843409.
	 */
	public void setCustomDimensionsId(String customDimensionsId) {
		this.customDimensionsId = customDimensionsId;
	}
	
	/**
	 * Devuelve customDimensionsKey
	 * @return customDimensionsKey - Clave unica de la accion. Por ejemplo: ChangeSportInLivePage.
	 */
	public String getCustomDimensionsKey() {
		return customDimensionsKey;
	}
	/**
	 * Establece customDimensionsKey
	 * @param customDimensionsKey - Clave unica de la accion. Por ejemplo: ChangeSportInLivePage.
	 */
	public void setCustomDimensionsKey(String customDimensionsKey) {
		this.customDimensionsKey = customDimensionsKey;
	}
	
	/**
	 * Devuelve customDimensionsSecondParameter
	 * @return customDimensionsSecondParameter - Dentro de la clave unica de la accion, segundo parametro - Por ejemplo deporte o evento apostado. Por ejemplo: soccer_1.
	 */
	public String getCustomDimensionsSecondParameter() {
		return customDimensionsSecondParameter;
	}
	/**
	 * Establece customDimensionsSecondParameter
	 * @param customDimensionsSecondParameter - Dentro de la clave unica de la accion, segundo parametro - Por ejemplo deporte o evento apostado. Por ejemplo: soccer_1.
	 */
	public void setCustomDimensionsSecondParameter(String customDimensionsSecondParameter) {
		this.customDimensionsSecondParameter = customDimensionsSecondParameter;
	}
	
	/**
	 * Devuelve customDimensionsDescription
	 * @return customDimensionsDescription - Descripcion de la clave unica de la accion. Por ejemplo: Cambio deporte en pagina directos.
	 */
	public String getCustomDimensionsDescription() {
		return customDimensionsDescription;
	}
	/**
	 * Establece customDimensionsDescription
	 * @param customDimensionsDescription - Descripcion de la clave unica de la accion. Por ejemplo: Cambio deporte en pagina directos.
	 */
	public void setCustomDimensionsDescription(String customDimensionsDescription) {
		this.customDimensionsDescription = customDimensionsDescription;
	}

	/**
	 * Devuelve una cadena como resultado de la concatenacion de todos los atributos de la clase
	 * @return String - Concatenacion de campos
	 */
	@Override	
	public String toString() {
		return "ActionBean [actionType=" + actionType + ", actionName=" + actionName +", actionNode=" + actionNode + ", contextUserAnonId="
				+ contextUserAnonId + ", contextUserAuthId=" + contextUserAuthId + ", contextUserIsAuthenticated="
				+ contextUserIsAuthenticated + ", contextSessionId=" + contextSessionId + ", contextSessionIsFirst="
				+ contextSessionIsFirst + ", viewUrl=" + viewUrl + ", contextDataEventTime="
				+ contextDataEventTime + ", sliceDataTime=" + sliceDataTime + ", contextOperationId="
				+ contextOperationId + ", contextOperationParentId=" + contextOperationParentId
				+ ", contextOperationName=" + contextOperationName + ", customDimensionsId=" + customDimensionsId
				+ ", customDimensionsKey=" + customDimensionsKey + ", customDimensionsSecondParameter="
				+ customDimensionsSecondParameter + ", customDimensionsDescription=" + customDimensionsDescription
				+ "]";
	}
}
