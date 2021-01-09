package com.test.exception;

import javax.ejb.ApplicationException;

/**
 * @author Ernesto Perez Guijarro
 * @since jdk1.7.0_21
 * @version 0.9.8
 */
@ApplicationException(rollback=true)
public class DaoException extends Exception {

    /**
     * 
     */
    private static final long serialVersionUID = -8867242281416658436L;

    /**
     * 
     */
    public  DaoException() {
        
        super("Not possible to process Dao Bean");
    }

    /**
     * @param message
     */
    public DaoException(String message) {
        super(message);
        
    }

    /**
     * @param cause
     */
    public DaoException(Throwable cause) {
        super(cause);
       
    }

    /**
     * @param message
     * @param cause
     */
    public DaoException(String message, Throwable cause) {
        super(message, cause);
       
    }

    /**
     * @param message
     * @param cause
     * @param enableSuppression
     * @param writableStackTrace
     */
    public DaoException(String message, Throwable cause,
            boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
       
    }

}

