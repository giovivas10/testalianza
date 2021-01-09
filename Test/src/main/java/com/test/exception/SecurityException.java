package com.test.exception;

import javax.ejb.ApplicationException;

@ApplicationException(rollback = true)
public class SecurityException extends Exception {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8005766060836907582L;

	/**
	 * 
	 */
	public SecurityException() {

		super("Not possible to process Dao Bean");
	}

	/**
	 * @param message
	 */
	public SecurityException(String message) {
		super(message);

	}

	/**
	 * @param cause
	 */
	public SecurityException(Throwable cause) {
		super(cause);

	}

	/**
	 * @param message
	 * @param cause
	 */
	public SecurityException(String message, Throwable cause) {
		super(message, cause);

	}

	/**
	 * @param message
	 * @param cause
	 * @param enableSuppression
	 * @param writableStackTrace
	 */
	public SecurityException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
		super(message, cause, enableSuppression, writableStackTrace);

	}
}
