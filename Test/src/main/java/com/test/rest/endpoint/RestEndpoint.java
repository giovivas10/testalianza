package com.test.rest.endpoint;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.test.bean.Client;
import com.test.response.Response;
import com.test.service.IClientService;
import io.swagger.annotations.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ejb.AccessTimeout;
import javax.ejb.EJB;
import javax.ejb.Stateless;
import javax.ws.rs.*;
import javax.ws.rs.core.Application;
import javax.ws.rs.core.MediaType;
import java.util.List;
import java.util.concurrent.TimeUnit;

@Api(value = "Test", authorizations = {@Authorization(value = "alianz", scopes = {})}, protocols = "{\"http\",\"https\"}")
@SwaggerDefinition(info = @Info(
        description = "Test Services",
        version = "V1.0.0",
        title = "API",
        contact = @Contact(name = "Carlos Vivas", email = "cgvb16@gmail.com", url = "https://test.com")
),
        consumes = {"application/json"}, produces = {"application/json"},
        schemes = {SwaggerDefinition.Scheme.HTTP, SwaggerDefinition.Scheme.HTTPS},
        tags = {@Tag(name = "Private", description = "Tag used to denote operations as private")}
)
@Stateless
@Path("/")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
@AccessTimeout(value = 5, unit = TimeUnit.SECONDS)
public class RestEndpoint extends Application {

    private static final Logger LOGGER = LoggerFactory.getLogger(RestEndpoint.class);

    @EJB
    IClientService service;

    @ApiOperation(value = "Test for get", notes = "Test for get", response = String.class, responseContainer = "Object")
    @ApiResponses(value = {@ApiResponse(code = 200, message = "ResponseRest Type", response = String.class)})
    @ApiImplicitParams({@ApiImplicitParam(name = "Authorization", value = "Authorization Bearer token",
            required = true, dataType = "string", paramType = "header", defaultValue = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzUxMiJ9.eyJqdGkiOiIx...")})
    @GET
    public Response<List<Client>> getALL() {
        try{
            return service.getAll();
        }catch (Exception e){
            return null;
        }
    }

    @POST
    public Response<Client> Create(Client request) {
        try{
            return service.create(request);
        }catch (Exception e){
            return null;
        }
    }

    @PUT
    public Response<Client> Update(Client request) {
        try{
            return service.update(request);
        }catch (Exception e){
            return null;
        }
    }

    @DELETE
    public Response<Client> Delete(Client request) {
        try{
            return service.delete(request);
        }catch (Exception e){
            return null;
        }
    }
}
