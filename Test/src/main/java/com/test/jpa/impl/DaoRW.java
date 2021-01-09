package com.test.jpa.impl;

import com.test.exception.DaoException;
import com.test.jpa.interfaces.DaoRWLocal;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.wildfly.swarm.spi.runtime.annotations.ConfigurationValue;

import javax.annotation.PostConstruct;
import javax.ejb.*;
import javax.inject.Inject;
import javax.persistence.Entity;
import javax.persistence.EntityNotFoundException;
import javax.persistence.Query;
import java.io.Serializable;
import java.util.*;
import java.util.concurrent.TimeUnit;

@Stateless()
@LocalBean
@Lock(LockType.WRITE)
@AccessTimeout(value = 20, unit = TimeUnit.MINUTES)
public class DaoRW extends Dao implements DaoRWLocal, Serializable {

    /**
     *
     */
    private static final long serialVersionUID = -6009053427176811912L;
    private static final Logger LOGGER = LoggerFactory.getLogger(DaoRW.class);
    private static final Integer registerForFlush = 10000;

    @Inject
    @ConfigurationValue("test.alianza.schema")
    String schema;

    @PostConstruct
    public void init() {

    }

     @Override
    @Lock(LockType.WRITE)
    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    public Object insert(Object entity) {
        if (entity != null && entity.getClass().isAnnotationPresent(Entity.class)) {

            LOGGER.debug("inserting:{}", entity.getClass().getSimpleName());

            this.entityManager.persist(entity);

            this.entityManager.flush();

            return entity;

        } else {
            LOGGER.error("null entity to load");
        }

        return false;
    }

    @Override
    @TransactionAttribute(TransactionAttributeType.MANDATORY)
    public boolean updateRollBack(Object entity) throws Exception {
        if (entity != null && entity.getClass().isAnnotationPresent(Entity.class)) {

            LOGGER.debug("updating:{}", entity.getClass().getSimpleName());

            this.entityManager.merge(entity);
            this.entityManager.flush();
            this.entityManager.detach(entity);

            return true;
        } else {
            LOGGER.error("null entity to load");
        }

        return false;

    }

    @Override
    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    public boolean update(Object entity) {
        if (entity != null && entity.getClass().isAnnotationPresent(Entity.class)) {

            LOGGER.debug("updating:{}", entity.getClass().getSimpleName());

            this.entityManager.merge(entity);
            this.entityManager.flush();
            this.entityManager.detach(entity);

            return true;
        } else {
            LOGGER.error("null entity to load");
        }

        return false;

    }

    @Override
    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    @Lock(LockType.WRITE)
    @AccessTimeout(value = 30, unit = TimeUnit.MINUTES)
    public boolean insertList(Set<?> list) throws DaoException {

        if (list != null && !list.isEmpty()) {
            LOGGER.info("inserting: List with {} rows", list.size());
            Iterator<?> it = list.iterator();
            Object obj = null;
            int i = 0;

            while (it.hasNext()) {
                obj = it.next();
                i++;
                if (obj == null || !obj.getClass().isAnnotationPresent(Entity.class)) {
                    LOGGER.info("null list to insert");
                    throw new DaoException("null list to insert");
                }

                this.entityManager.persist(obj);

                if (i % registerForFlush == 0) {
                    LOGGER.info("flushing each {}->{}", registerForFlush, i);
                    this.entityManager.flush();
                }

            }

            this.entityManager.flush();
            LOGGER.info("inserted field:{} of {}", i, list.size());
            return true;
        }

        return false;
    }

    @Override
    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    @Lock(LockType.WRITE)
    @AccessTimeout(value = 30, unit = TimeUnit.MINUTES)
    public <T> Set<T> insertList2(Set<T> list) throws DaoException {

        if (list != null && !list.isEmpty()) {
            LOGGER.info("inserting: List with {} rows", list.size());
            Iterator<?> it = list.iterator();
            Object obj = null;
            int i = 0;

            while (it.hasNext()) {
                obj = it.next();
                i++;
                if (obj == null || !obj.getClass().isAnnotationPresent(Entity.class)) {
                    LOGGER.info("null list to insert");
                    throw new DaoException("null list to insert");
                }

                this.entityManager.persist(obj);

                if (i % registerForFlush == 0) {
                    LOGGER.info("flushing each {}->{}", registerForFlush, i);
                    this.entityManager.flush();
                }

            }
            LOGGER.info("inserted field:{} of {}", i, list.size());
            this.entityManager.flush();
            return list;
        }

        return null;
    }

    @Override
    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    @AccessTimeout(value = 30, unit = TimeUnit.MINUTES)
    public boolean updateList(Set<?> list) throws DaoException {
        if (list != null && !list.isEmpty()) {

            Iterator<?> it = list.iterator();
            Object obj = null;
            int i = 0;

            while (it.hasNext()) {
                obj = it.next();
                i++;
                if (obj == null || !obj.getClass().isAnnotationPresent(Entity.class)) {
                    LOGGER.info("null list to insert");
                    throw new DaoException("null list to insert");
                }

                this.entityManager.merge(obj);

                if (i % registerForFlush == 0) {
                    LOGGER.info("flushing each {}->{}", registerForFlush, i);
                    this.entityManager.flush();
                }

            }

            this.entityManager.flush();
            LOGGER.info("updated field:{} of {}", i, list.size());


            return true;
        }
        return false;

    }

    @Override
    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    public void delete(Class<?> entity) {
        assert entity != null && entity.isAnnotationPresent(Entity.class);

        LOGGER.debug(" try to delete all table {} ", entity.getSimpleName());
        int del = entityManager.createNamedQuery(entity.getSimpleName() + ".del").executeUpdate();
        LOGGER.debug("delete:{} rows", del);

    }

    @Override
    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    public void delete(Object entity) {
        assert entity != null && entity.getClass().isAnnotationPresent(Entity.class);

        LOGGER.debug(" try to delete  {} ");
        entity = entityManager.merge(entity);
        entityManager.remove(entity);
        entityManager.flush();

    }

    @Override
    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    public int execQuery(String order) {
        if (order != null && !order.isEmpty()) {
            return this.entityManager.createNativeQuery(order).executeUpdate();
        }
        LOGGER.error("not possible actualize");
        return 0;
    }

    @Override
    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    public void delete(Class<?> entity, List<String> columns, List<String> operators, List<Object> in) {
        if (entity != null) {
            Iterator<String> it1 = columns.iterator();
            Iterator<String> it2 = operators.iterator();
            Iterator<Object> it3 = in.iterator();
            assert entity != null && entity.isAnnotationPresent(Entity.class);
            LOGGER.debug(" try to delete record from table {} ", entity.getSimpleName());
            String strQuery = "DELETE from " + entity.getSimpleName() + " p Where ";
            try {
                int i = 0;
                while (it1.hasNext() && it2.hasNext() && it3.hasNext()) {
                    i++;
                    strQuery = strQuery + genCondition(it1.next(), it2.next(), it3.next(), i, it1.hasNext() && it2.hasNext() && it3.hasNext());

                }
                LOGGER.info("JQPL query:{}", strQuery);
                Query query = this.entityManager.createQuery(strQuery);

                it3 = in.iterator();
                it1 = columns.iterator();
                Object aux;
                i = 0;
                while (it3.hasNext() && it1.hasNext()) {
                    i++;
                    aux = it3.next();
                    try {
                        if (aux.getClass().isAnnotationPresent(Entity.class) && !this.entityManager.contains(aux)) {
                            this.entityManager.refresh(aux);
                        }
                        ;
                    } catch (NullPointerException e) {
                        LOGGER.error("Class entity not found:{}", e.toString());
                    }
                    LOGGER.info("set param:{}", aux.toString());
                    query.setParameter(i, aux);
                }
                int del = query.executeUpdate();
                LOGGER.info("delete:{} rows", del);
            } catch (DaoException daoex) {
                LOGGER.error("Error creating delete query:{}", daoex.toString());
            }
        } else {
            LOGGER.error("try to delete null class");
        }
    }

    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    @Override
    public boolean deleteList(Set<?> list) throws DaoException {
        if (list != null && !list.isEmpty()) {

            LOGGER.debug("inserting: List with {} rows", list.size());
            Iterator<?> it = list.iterator();
            Object obj = null;
            int i = 0;
            while (it.hasNext()) {
                obj = it.next();
                if (obj == null || !obj.getClass().isAnnotationPresent(Entity.class)) {
                    throw new DaoException("null list to insert");
                }
                try {
                    this.entityManager.remove(this.entityManager.contains(obj) ? obj : this.entityManager.merge(obj));
                } catch (EntityNotFoundException e) {
                    LOGGER.warn("try to delete entity not persistent");
                }
                LOGGER.trace("insert field:{} of {}", i++, list.size());

            }

            this.entityManager.flush();
            return true;
        }

        return false;
    }

    @Override
    @Lock(LockType.WRITE)
    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    @AccessTimeout(value = 30, unit = TimeUnit.MINUTES)
    public List<Object> executeList(List<Object> entities, List<String> methods) throws DaoException {

        Long tInit = Calendar.getInstance().getTimeInMillis();

        List<Object> result = new ArrayList<Object>();

        Integer inserts = 0;
        Integer updates = 0;
        Integer deletes = 0;

        try {

            for (int i = 0; i < entities.size(); i++) {

                Object entity = entities.get(i);
                String method = methods.get(i);

                if (entity != null && entity.getClass().isAnnotationPresent(Entity.class) && method != null && method != "") {

                    switch (method) {
                        case "insert":
                            this.entityManager.persist(entity);
                            inserts++;
                            break;

                        case "update":
                            this.entityManager.merge(entity);
                            updates++;
                            break;

                        case "delete":
                            entity = entityManager.merge(entity);
                            this.entityManager.remove(entity);
                            deletes++;
                            break;

                        default:
                            LOGGER.error("null method in executeList");
                            return null;
                    }

                    result.add(entity);

                    if (i % registerForFlush == 0) {

                        LOGGER.info("flushing each {}->{}", registerForFlush, i);
                        this.entityManager.flush();

                    }

                } else {
                    LOGGER.error("null entity to load");
                    LOGGER.error("null entity to load in: {}ms", Calendar.getInstance().getTimeInMillis() - tInit);
                    return null;
                }
            }

            LOGGER.info("executed: inserts->{} updates->{} deletes->{}", inserts, updates, deletes);

        } catch (Exception ex) {
            LOGGER.error("error in executeList -> ", ex);
            LOGGER.error("null entity to load in: {}ms", Calendar.getInstance().getTimeInMillis() - tInit);
            throw new DaoException("error executing query to update");
        }

        this.entityManager.flush();

        LOGGER.info("execute list of {} queries in: {} ms", entities.size(), Calendar.getInstance().getTimeInMillis() - tInit);

        return result;
    }

}
