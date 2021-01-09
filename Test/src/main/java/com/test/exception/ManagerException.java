/**
 * 
 */
package com.test.exception;

import javax.ejb.ApplicationException;

/**
 * @author Ernesto Perez Guijarro
 * @since jdk1.7.0_21
 * @version 0.9.8
 */
@ApplicationException(rollback=true)
public class ManagerException extends Exception {

 

    /**
     * 
     */
    private static final long serialVersionUID = -7926103000112089261L;

    /**
     * 
     */
    public ManagerException() {
        
        super("Not possible to process Dao Bean");
    }

    /**
     * @param message
     */
    public ManagerException(String message) {
        super(message);
        
    }

    /**
     * @param cause
     */
    public ManagerException(Throwable cause) {
        super(cause);
       
    }

    /**
     * @param message
     * @param cause
     */
    public ManagerException(String message, Throwable cause) {
        super(message, cause);
       
    }

    /**
     * @param message
     * @param cause
     * @param enableSuppression
     * @param writableStackTrace
     */
    public ManagerException(String message, Throwable cause,
                            boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
       
    }

}
