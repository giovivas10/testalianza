package com.test.filter.request;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.annotation.Priority;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.Priorities;
import javax.ws.rs.container.ContainerRequestContext;
import javax.ws.rs.container.ContainerRequestFilter;
import javax.ws.rs.container.ResourceInfo;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.Response;
import javax.ws.rs.ext.Provider;
import java.io.IOException;

@Provider
@Priority(Priorities.AUTHORIZATION)
public class AuthRequestFilter implements ContainerRequestFilter {

    private static final Logger LOGGER = LoggerFactory.getLogger(AuthRequestFilter.class);

    @Context
    private ResourceInfo resourceInfo;

    @Context
    private HttpServletRequest servletRequest;

    @Override
    public void filter(ContainerRequestContext requestContext) throws IOException {

        try {
            LOGGER.info("Start to filter token");

        } catch (Exception e) {
            LOGGER.info("Access denied");
            LOGGER.error("Error in authorization [{}]", e.getMessage());
            requestContext.abortWith(Response.status(Response.Status.UNAUTHORIZED).build());
        } finally {
            LOGGER.info("End to filter token");
        }

    }

}
