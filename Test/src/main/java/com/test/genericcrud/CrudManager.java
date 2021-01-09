package com.test.genericcrud;

import com.test.exception.ManagerException;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.test.jpa.interfaces.DaoLocal;
import com.test.jpa.interfaces.DaoRWLocal;
import com.test.response.Response;
import com.test.util.Util;
import org.hibernate.exception.ConstraintViolationException;
import org.json.JSONObject;
import org.postgresql.util.PSQLException;
import org.slf4j.Logger;

import javax.persistence.PersistenceException;
import java.lang.reflect.Field;
import java.util.List;

public abstract class CrudManager<T> {

    protected abstract List<String> tochek();

    protected abstract DaoRWLocal getDaoRW();

    protected abstract DaoLocal getDao();

    private final Logger LOGGER;

    private Class<T> type;


    public CrudManager(Class<T> type, Logger LOGGER) {
        super();
        this.type = type;
        this.LOGGER = LOGGER;
    }


    private T mapperObj(String req) throws ManagerException {
        return mapperObj(req, false);
    }

    private <K> K mapperObj(Class<K> type, String req) throws ManagerException {
        K disco;
        ObjectMapper mapper = new ObjectMapper().configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        try {
            disco = mapper.readValue(req, type);
        } catch (Exception e) {
            LOGGER.error("Error --> {}", e.getMessage());
            throw new ManagerException("Los atributos enviados no corresponden");
        }
        return disco;
    }

    protected T mapperObj(String req, Boolean check) throws ManagerException {
        T disco;
        ObjectMapper mapper = new ObjectMapper().configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        try {
            disco = mapper.readValue(req, type);
        } catch (Exception e) {
            LOGGER.error("Error --> {}", e.getMessage());
            throw new ManagerException("Los atributos enviados no corresponden");
        }
        if (check) {
            JSONObject jObFather = new JSONObject(req);
            if (!Util.valideField(jObFather, tochek())) {
                throw new ManagerException("Parametros del servicio incompletos o no son correctos");
            }
        }

        return disco;
    }

    public static boolean checkFields(Field[] declaredFields) {
        if (declaredFields != null && declaredFields.length > 0) {
            for (int i = 0; i < declaredFields.length; i++) {
                if (declaredFields[i].getName().equalsIgnoreCase("idSite")) {
                    return true;
                }
            }
        }
        return false;
    }


    public Response findbyId(String yourIP, String id) {

        T listobjects = getDao().find(type, id);
        if (listobjects == null) {
            return new Response(null, "No se han encontrado", false);
        }
        return new Response(listobjects, null, true);

    }


    public Response create(String yourIP, String req) {
        try {
            T toins = mapperObj(req);
            if (toins != null) {
                LOGGER.info("insert  object");
                return new Response(getDaoRW().insert(toins), null, true);
            } else {
                return null;
            }
        } catch (ManagerException e) {
            return new Response(null, e.getLocalizedMessage(), false);
        }
    }

    public Response update(String yourIP, String req) {

        try {
            return new Response(getDaoRW().update(mapperObj(req)), null, true);
        } catch (ManagerException e) {
            return new Response(null, e.getLocalizedMessage(), false);
        }

    }


    public Response delete(String yourIP, String req) {
        String nametable = type.getName().contains("_Full") ? type.getName().replace("_Full", "") : type.getName();
        try {

            Class<?> typedel = Class.forName(nametable);
            getDaoRW().delete(mapperObj(typedel, req));
            return new Response(true, null, true);
        } catch (PersistenceException | PSQLException | ConstraintViolationException e1) {
            LOGGER.error("Error in init delete {} (not full): {}", nametable, e1);
            return new Response(false, "Not possible Delete:" + nametable + " Foreing Key", false);
        } catch (Exception e) {
            LOGGER.error("Error in init delete {}: {}", nametable, e);
            return new Response(false, e.getMessage(), false);
        }
    }


}
