package com.test.service;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.test.bean.Client;
import com.test.jpa.interfaces.DaoLocal;
import com.test.jpa.interfaces.DaoRWLocal;
import com.test.response.Response;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.annotation.PostConstruct;
import javax.ejb.*;
import java.io.Serializable;
import java.util.List;
import java.util.concurrent.TimeUnit;

@Stateless(mappedName = "SecurityService")
@LocalBean
@AccessTimeout(value = 30, unit = TimeUnit.SECONDS)
@TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
public class ClientService implements IClientService, Serializable {

    private static final long serialVersionUID = -3995182146339540777L;
    private static final Logger LOGGER = LoggerFactory.getLogger(ClientService.class);

    @EJB
    private DaoRWLocal daoRw;

    @EJB
    private DaoLocal dao;

    ObjectMapper mapper = new ObjectMapper();

    public ClientService() {
    }

    @PostConstruct
    public void init() {
        try {
            mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        } catch (Exception e) {
            LOGGER.error("Error in init method: [{}]", e);
        }
    }

    @Override
    public Response<List<Client>> getAll() {
        Response response = new Response();
        List<Client> list = dao.list(Client.class);

        response.setResult(true);
        response.setObject(list);

        return response;
    }

    @Override
    public Response<Client> create(Client request) throws SecurityException {
        Response response = new Response();
        Client obj = (Client) daoRw.insert(request);

        response.setResult(true);
        response.setObject(obj);

        return response;
    }

    @Override
    public Response<Client> update(Client request) throws SecurityException {
        Response response = new Response();
        Boolean obj = daoRw.update(request);

        response.setResult(true);
        response.setObject(obj);

        return response;
    }

    @Override
    public Response<Client> delete(Client request) throws SecurityException {
        Response response = new Response();

        boolean delete = true;
        try {
            daoRw.delete(request);
        } catch (Exception e) {
            delete = false;
        }

        response.setResult(true);
        response.setObject(delete);

        return response;
    }


}
