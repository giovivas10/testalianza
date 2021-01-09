package com.test.response;

import io.swagger.annotations.ApiModelProperty;

import java.io.Serializable;

public class Response<T> implements Serializable {

	private static final long serialVersionUID = -4290828474891854415L;

	@ApiModelProperty(notes = "Indicador de si fue ejecutado el proceso correctamente o no")
	private Boolean result;

	@ApiModelProperty(notes = "Mensaje de acuerdo al resultado")
	private String message;

	@ApiModelProperty(notes = "Contenido de la respuesta")
	private T object;

	public Response(T object, String error, Boolean result) {
		super();
		this.object = object;
		this.message = error;
		this.result = result;
	}

	public Response() {
		this.result = true;
		this.message = "Proceso Ok";
	}

	public Object getObject() {
		return object;
	}

	public void setObject(T object) {
		this.object = object;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String error) {
		this.message = error;
	}

	public Boolean getResult() {
		return result;
	}

	public void setResult(Boolean result) {
		this.result = result;
	}

}
