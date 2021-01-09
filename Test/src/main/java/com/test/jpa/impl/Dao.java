package com.test.jpa.impl;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.TimeUnit;

import javax.ejb.AccessTimeout;
import javax.ejb.LocalBean;
import javax.ejb.Lock;
import javax.ejb.LockType;
import javax.ejb.Stateless;
import javax.ejb.TransactionAttribute;
import javax.ejb.TransactionAttributeType;

import javax.persistence.Entity;
import javax.persistence.EntityManager;
import javax.persistence.LockModeType;
import javax.persistence.ParameterMode;
import javax.persistence.PersistenceContext;
import javax.persistence.PersistenceException;
import javax.persistence.Query;
import javax.persistence.StoredProcedureQuery;
import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Expression;
import javax.persistence.criteria.Order;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import com.test.exception.DaoException;
import com.test.jpa.interfaces.DaoLocal;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


@Stateless
@TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
@Lock(LockType.READ)
@AccessTimeout(value = 20, unit = TimeUnit.MINUTES)
@LocalBean
public class Dao implements DaoLocal, Serializable {

    /**
     *
     */
    private static final long serialVersionUID = 1539938468233213239L;

    @PersistenceContext(unitName = "TestDS")
    protected EntityManager entityManager;


    protected Connection conn;

    private static final Logger LOGGER = LoggerFactory.getLogger(Dao.class);

    /**
     * Default constructor.
     */
    public Dao() {

    }


    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    @Override
    public int count(String tablename) {
        if (tablename != null) {
            LOGGER.debug(" try to count {} table", tablename);
            String queryString = "SELECT COUNT(p) FROM " + tablename + " p";

            Query query = this.entityManager.createQuery(queryString);
            query.setLockMode(LockModeType.NONE);

            Object i = query.getSingleResult();
            if (i != null) {
                LOGGER.debug("Obtain:{}", i.toString());
                return (int) Math.max(Math.min((long) Integer.MAX_VALUE, (Long) i), (long) Integer.MIN_VALUE);
            } else {
                LOGGER.warn("Obtain null of count");

            }
        } else {
            LOGGER.error("try to load null table");

        }
        return 0;
    }

    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    @SuppressWarnings("unchecked")
    @Override
    public <T> T find(Class<T> class1, String ColumnName, Object id) {

        if (class1 != null && ColumnName != null && !ColumnName.isEmpty() && id != null) {
            String jpql = "SELECT p FROM " + class1.getSimpleName() + " p where p." + ColumnName + "= ?1";
            try {
                Query query = this.entityManager.createQuery(jpql);
                query.setLockMode(LockModeType.NONE);

                query.setParameter(1, id);
                LOGGER.info("JQPL query:{}", jpql);
                List<T> result = query.getResultList();

                T out = (result != null) ? (result.size() > 0) ? result.get(0) : null : null;
                if (out != null) {
                    this.entityManager.detach(out);
                }
                return out;

            } catch (IllegalArgumentException | IndexOutOfBoundsException | PersistenceException
                    | NullPointerException e) {
                LOGGER.error("Not possible find:->{}", e.toString());

            }
        } else {
            LOGGER.error("try to find null class or columname");
        }
        return null;

    }

    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    @Override
    public <T> T find(Class<T> class1, Object id) {

        if (class1 != null && id != null) {
            try {
                if (id.getClass().isAnnotationPresent(Entity.class) && !this.entityManager.contains(id)) {
                    this.entityManager.refresh(id);
                }
                ;

                return this.entityManager.find(class1, id);
            } catch (IllegalArgumentException | IndexOutOfBoundsException | PersistenceException
                    | NullPointerException e) {
                LOGGER.error("Not possible find:->{}", e.toString());

            }
        } else {
            LOGGER.error("try to find null class or null id");

        }
        return null;
    }

    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    @Override
    public <T> List<T> list(Class<T> class1) {

        return listLimit(class1, -1);

    }

    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    @Override
    public <T> List<T> search(Class<T> class1, String Columnname, List<String> columRestriction,
                              List<String> restriction, List<Object> in) throws DaoException {
        return search(class1, Columnname, columRestriction, restriction, in, -1);
    }

    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)

    @Override
    public <T> List<T> search(Class<T> class1, String Columnname, List<String> column, List<String> cond,
                              List<Object> values, Integer max) throws DaoException {

        return search(class1, Columnname, column, cond, values, null, max);

    }

    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    @SuppressWarnings("unchecked")
    @Override
    public <T> List<T> search(Class<T> class1, String Columnname) {

        if (class1 != null) {

            String jpql;
            if (Columnname != null) {
                jpql = "SELECT p." + Columnname + " FROM " + class1.getSimpleName() + " p ";
            } else {
                jpql = "SELECT p FROM " + class1.getSimpleName() + " p ";
            }

            LOGGER.debug("JQPL query:{}", jpql);
            Query query = this.entityManager.createQuery(jpql);
            query.setLockMode(LockModeType.NONE);

            return query.getResultList();
        } else {

            LOGGER.error("null class");
        }
        return null;
    }

    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    @Override
    public <T> List<T> search(Class<T> class1, List<String> columRestriction, List<String> restriction, List<Object> in)
            throws DaoException {

        return search(class1, null, columRestriction, restriction, in, -1);

    }

    protected static String genCondition(String columname, String cond, Object in, int pos, boolean hasNext)
            throws DaoException {
        String out;
        if (columname != null && cond != null && in == null
                && (cond.equalsIgnoreCase("IS NULL") || (cond.equalsIgnoreCase("IS NOT NULL")))) {
            out = "p." + columname + " " + Dao.cond(cond) + "  ";
            if (hasNext) {
                out = out + " AND ";
            }
            return out;
        } else if (columname != null && cond != null && in != null) {
            out = "p." + columname + " " + Dao.cond(cond) + "  ?" + pos;
            if (hasNext) {
                out = out + " AND ";
            }
            return out;
        } else {
            throw new DaoException("inserting null condition");

        }

    }

    private static String cond(String cond) throws DaoException {
        if (cond != null && !cond.isEmpty()) {

            if (cond.equalsIgnoreCase("eq"))
                return "=";
            else if (cond.equalsIgnoreCase("le"))
                return "<=";
            else if (cond.equalsIgnoreCase("ge"))
                return ">=";
            else if (cond.equalsIgnoreCase("gt"))
                return ">";
            else if (cond.equalsIgnoreCase("lt"))
                return "<";
            else if (cond.equalsIgnoreCase("ne"))
                return "!=";
            else if (cond.equalsIgnoreCase("like"))
                return "!=";
            else if (cond.equalsIgnoreCase("ne"))
                return "!=";
            else if (cond.equalsIgnoreCase("ne"))
                return "!=";
            else if (cond.equalsIgnoreCase("in"))
                return "IN";
            else if (cond.equalsIgnoreCase("ni"))
                return "NOT IN";

            else if (cond.equalsIgnoreCase(">") || cond.equalsIgnoreCase("<") || cond.equalsIgnoreCase("=")
                    || cond.equalsIgnoreCase("!=") || cond.equalsIgnoreCase(">=") || cond.equalsIgnoreCase("<=")
                    || cond.equalsIgnoreCase("IS NULL") || cond.equalsIgnoreCase("IS NOT NULL"))

                return cond;

        }

        throw new DaoException("try to insert null condition");
    }

    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    @Override
    public Integer getMaxID(Class<?> entity) {
        assert entity != null && entity.isAnnotationPresent(Entity.class);

        LOGGER.debug(" try to obtain max {} ", entity.getSimpleName());
        Query query = entityManager.createNamedQuery(entity.getSimpleName() + ".getMaxID");
        query.setLockMode(LockModeType.NONE);
        Integer maxId = (Integer) query.getSingleResult();

        return (maxId != null) ? maxId + 1 : 0;

    }

    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    @Override
    public <T> List<T> search(Class<T> class1, String columname, List<String> columRestric, List<String> restriction,
                              List<Object> in, List<String> order) throws DaoException {
        return search(class1, columname, columRestric, restriction, in, order, -1);
    }

    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    @SuppressWarnings("unchecked")
    @Override
    public <T> List<T> search(Class<T> class1, String columname, List<String> column, List<String> cond,
                              List<Object> values, List<String> order, Integer max) throws DaoException {
        if (class1 != null) {
            CriteriaBuilder criteriaBuilder = this.entityManager.getCriteriaBuilder();
            CriteriaQuery<T> criteriaQuery = criteriaBuilder.createQuery(class1);

            Root<T> rmenu = criteriaQuery.from(class1);

            Predicate pr2 = null;
            if (column != null && cond != null && values != null && !column.isEmpty() && column.size() == cond.size()) {

                pr2 = getwhere(criteriaBuilder, rmenu, column, cond, values);

            } else {
                LOGGER.warn("search with empty values");

            }

            if (columname != null) {
                criteriaQuery.select(rmenu.get("columname")).distinct(true);

            } else {
                criteriaQuery.select(rmenu);
            }

            if (pr2 != null) {
                criteriaQuery.where(pr2);
            }
            if (order != null && !order.isEmpty()) {
                criteriaQuery = order2(criteriaBuilder, criteriaQuery, rmenu, order);
            }
            // criteriaQuery.orderBy(criteriaBuilder.asc(rmenu.get("genDate")));

            Query qu = entityManager.createQuery(criteriaQuery);

            // LOGGER.info("query->{}",qu.toString());
            if (max != null && max > 1) {
                LOGGER.debug("setting max:{}", max);
                qu.setMaxResults(max);
            }
            return qu.getResultList();

        }

        LOGGER.error("Null params");
        return null;

    }

    @Override
    public <T> BigDecimal sum(Class<T> class1, String columname, List<String> column, List<String> cond, List<Object> values) throws DaoException {

        if (class1 != null && columname != null && !columname.isEmpty()) {
            CriteriaBuilder criteriaBuilder = this.entityManager.getCriteriaBuilder();
            //CriteriaQuery<T> criteriaQuery = criteriaBuilder.createQuery(class1);
            final CriteriaQuery<BigDecimal> criteriaQuery = criteriaBuilder.createQuery(BigDecimal.class);
            Root<T> rmenu = criteriaQuery.from(class1);
            criteriaQuery.select(criteriaBuilder.sum(rmenu.<BigDecimal>get(columname)));
            Predicate pr2 = null;
            if (column != null && cond != null && values != null && !column.isEmpty() && column.size() == cond.size()) {

                pr2 = getwhere(criteriaBuilder, rmenu, column, cond, values);

            } else {
                LOGGER.warn("search with empty values");

            }

            if (pr2 != null) {
                criteriaQuery.where(pr2);
            }
            TypedQuery<BigDecimal> qu = entityManager.createQuery(criteriaQuery);
            return qu.getSingleResult();
        } else {
            LOGGER.error("Null class to search {} {}", class1, columname);
        }
        return null;
    }

    ;

    @SuppressWarnings("unchecked")
    @Override
    public <T> List<T> search(Class<T> class1, List<String> column, List<String> cond, List<Object> values,
                              List<String> order, Integer max) throws DaoException {
        if (class1 != null) {
            CriteriaBuilder criteriaBuilder = this.entityManager.getCriteriaBuilder();
            CriteriaQuery<T> criteriaQuery = criteriaBuilder.createQuery(class1);

            Root<T> rmenu = criteriaQuery.from(class1);

            Predicate pr2 = null;
            if (column != null && cond != null && values != null && !column.isEmpty() && column.size() == cond.size()) {

                pr2 = getwhere(criteriaBuilder, rmenu, column, cond, values);

            } else {
                LOGGER.warn("search with empty values");

            }

            if (pr2 != null) {
                criteriaQuery.where(pr2);
            }
            if (order != null && !order.isEmpty()) {
                criteriaQuery = order2(criteriaBuilder, criteriaQuery, rmenu, order);
            }
            // criteriaQuery.orderBy(criteriaBuilder.asc(rmenu.get("genDate")));

            Query qu = entityManager.createQuery(criteriaQuery);

            // LOGGER.info("query->{}",qu.toString());
            if (max != null && max > 0) {
                LOGGER.debug("setting max:{}", max);
                qu.setMaxResults(max);
            }
            return qu.getResultList();

        }

        LOGGER.error("Null params");
        return null;

    }

    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    @Override
    public <T> List<T> listLimit(Class<T> class1, int maxrows) {
        if (class1 != null) {
            try {
                String namequery = class1.getSimpleName() + ".findAll";
                Query query;
                if (maxrows > 0) {
                    query = this.entityManager.createNamedQuery(namequery).setMaxResults(maxrows);
                } else {
                    query = this.entityManager.createNamedQuery(namequery);
                }
                @SuppressWarnings("unchecked")
                List<T> result = query.getResultList();
                return result;
            } catch (IllegalArgumentException | IndexOutOfBoundsException | PersistenceException e) {
                LOGGER.error("Not possible find:->{}", e.toString());

            }
        } else {
            LOGGER.error("Try to list null class");
        }
        return null;

    }

    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    @Override
    public <T> List<T> search(Class<T> class1, String columname, List<Object> in) {
        List<T> out = new ArrayList<T>();
        if (class1 != null) {

            CriteriaBuilder criteriaBuilder = this.entityManager.getCriteriaBuilder();

            CriteriaQuery<T> criteriaQuery = criteriaBuilder.createQuery(class1);

            Root<T> table = criteriaQuery.from(class1);
            if (columname != null && in != null && !in.isEmpty()) {

                Expression<String> exp = table.get(columname);
                Predicate predicate = exp.in(in);
                criteriaQuery = criteriaQuery.where(predicate);

            }
            TypedQuery<T> query = this.entityManager.createQuery(criteriaQuery);
            out = query.getResultList();

        }

        return out;
    }

    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    @Override
    public <T, E> List<T> searchbyTAG(Class<T> class1, Class<E> class2, String id1, String id2, String tag,
                                      List<String> column, List<String> cond, List<Object> values, List<String> order, Integer maxrows)
            throws DaoException {

        return searchbyTAG3(class1, class2, id1, id2, tag, "pan", column, cond, values, order, maxrows, true);
    }

    @SuppressWarnings({"rawtypes", "unchecked"})
    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    @Override
    public <T, E> List<T> searchbyTAG3(Class<T> class1, Class<E> class2, String id1, String id2, String tag,
                                       String columntag, List<String> column, List<String> cond, List<Object> values, List<String> order,
                                       Integer maxrows, boolean distinct) throws DaoException {
        if (class1 != null && class2 != null && tag != null && !tag.isEmpty() && id1 != null && id2 != null) {
            CriteriaBuilder criteriaBuilder = this.entityManager.getCriteriaBuilder();
            CriteriaQuery criteriaQuery = criteriaBuilder.createQuery();

            Root<E> rmenusxrole = criteriaQuery.from(class2);
            Root<T> rmenu = criteriaQuery.from(class1);

            Expression<String> pathRol = rmenusxrole.get(columntag);
            Predicate pr = criteriaBuilder.equal(pathRol, tag);
            Predicate pr4 = null;
            if (column != null && cond != null && values != null && !column.isEmpty() && column.size() == cond.size()) {

                Predicate pr3 = getwhere(criteriaBuilder, rmenu, column, cond, values);
                pr4 = criteriaBuilder.and(pr, pr3);

            } else {
                pr4 = pr;

            }
            criteriaQuery.multiselect(rmenu).distinct(distinct);
            criteriaQuery.where(criteriaBuilder.and(criteriaBuilder.equal(rmenusxrole.get(id2), rmenu.get(id1)), pr4

            ));
            criteriaQuery = order2(criteriaBuilder, criteriaQuery, rmenu, order);

            Query qu = entityManager.createQuery(criteriaQuery);
            // LOGGER.info("query->{}",qu.toString());
            if (maxrows != null && maxrows > 1) {
                LOGGER.debug("setting max:{}", maxrows);
                qu.setMaxResults(maxrows);
            }
            return qu.getResultList();

        }

        LOGGER.error("Null params");
        return null;
    }

    @SuppressWarnings({"rawtypes", "unchecked"})
    private <T> CriteriaQuery order2(CriteriaBuilder cb, CriteriaQuery criteriaQuery, Root<T> rmenu,
                                     List<String> order) {
        if (order != null && !order.isEmpty()) {

            String aux;
            Iterator<String> it = order.iterator();
            List<Order> or = new ArrayList<Order>();
            while (it.hasNext()) {
                aux = it.next();
                if (aux != null && !aux.isEmpty() && aux.length() > 1) {
                    if (aux.startsWith("_A") || aux.startsWith("_a")) {
                        or.add(cb.asc(rmenu.get(aux.substring(2))));
                        // criteriaQuery.orderBy();

                    } else if (aux.startsWith("_D") || aux.startsWith("_d")) {
                        or.add(cb.desc(rmenu.get(aux.substring(2))));
                        // criteriaQuery.orderBy(cb.desc(rmenu.get(aux.substring(2))));
                    } else {
                        or.add(cb.asc(rmenu.get(aux.substring(2))));
                        // criteriaQuery.orderBy(cb.asc(rmenu.get(aux)));
                    }

                }
            }

            if (!or.isEmpty()) {
                criteriaQuery.orderBy(or);

            } else {
                LOGGER.error("null order by");
            }
        }
        return criteriaQuery;
    }

    @SuppressWarnings({"unchecked", "rawtypes"})
    private <T> Predicate getwhere(CriteriaBuilder cb, Root<T> rmenu, List<String> column, List<String> res,
                                   List<Object> values) throws DaoException {
        Iterator<String> it1 = column.iterator();
        Iterator<String> it2 = res.iterator();
        Iterator<Object> it3 = values.iterator();
        Predicate prant = null;
        Predicate pr;
        String cond;
        Object obj;
        String col;
        // Expression<Object> pathRol ;
        // Expression<? extends Number> pathnum ;

        while (it1.hasNext() && it2.hasNext() && it3.hasNext()) {

            col = it1.next();

            cond = it2.next();
            // Predicate pr = cb.equal(pathRol, tag);
            obj = it3.next();
            if (col != null && cond != null && !cond.isEmpty()) {
                pr = null;
                if ((cond.equalsIgnoreCase("eq") || cond.equalsIgnoreCase("=="))) {
                    pr = cb.equal(rmenu.get(col), obj);
                } else if ((cond.equalsIgnoreCase("le") || cond.equalsIgnoreCase("<=")) && obj instanceof Comparable) {

                    pr = cb.lessThanOrEqualTo(rmenu.get(col), (Comparable) obj);

                } else if ((cond.equalsIgnoreCase("ge") || cond.equalsIgnoreCase(">=")) && obj instanceof Comparable) {

                    pr = cb.greaterThanOrEqualTo(rmenu.get(col), (Comparable) obj);

                } else if ((cond.equalsIgnoreCase("gt") || cond.equalsIgnoreCase(">")) && obj instanceof Comparable) {

                    pr = cb.greaterThan(rmenu.get(col), (Comparable) obj);

                } else if ((cond.equalsIgnoreCase("lt") || cond.equalsIgnoreCase("<")) && obj instanceof Comparable) {

                    pr = cb.lessThan(rmenu.get(col), (Comparable) obj);

                } else if ((cond.equalsIgnoreCase("ne") || cond.equalsIgnoreCase("!=")) && obj instanceof Comparable) {
                    pr = cb.notEqual(rmenu.get(col), obj);
//OJO
                } else if (cond.equalsIgnoreCase("in") && obj instanceof Comparable) {
                    Expression<String> exp = rmenu.get(col);
                    // List<String> ListValues = Arrays.asList(obj.toString().split("\\s*,\\s*"));
                    List<String> listValues = Arrays.asList(obj.toString().split(","));
                    List<String> listValues2 = new ArrayList<String>();
                    if (listValues != null && !listValues.isEmpty()) {
                        Iterator<String> it = listValues.iterator();
                        String aux;
                        while (it.hasNext()) {
                            aux = it.next().trim();
                            if (aux != null && !aux.isEmpty()) {
                                listValues2.add(aux);
                            }
                        }
                    }
                    pr = exp.in(listValues2);

                } else if (cond.equalsIgnoreCase("ni") && obj instanceof Comparable) {
                    Expression<String> exp = rmenu.get(col);
                    List<String> listValues = Arrays.asList(obj.toString().split(","));
                    List<String> listValues2 = new ArrayList<String>();
                    if (listValues != null && !listValues.isEmpty()) {
                        Iterator<String> it = listValues.iterator();
                        String aux;
                        while (it.hasNext()) {
                            aux = it.next().trim();
                            if (aux != null && !aux.isEmpty()) {
                                listValues2.add(aux);
                            }
                        }
                    }
                    pr = cb.not(exp.in(listValues2));

                } else if (cond.equalsIgnoreCase("IS NOT NULL") || cond.equalsIgnoreCase("isnotnull")) {
                    pr = cb.isNotNull(rmenu.get(col));
                } else if (cond.equalsIgnoreCase("IS NULL") || cond.equalsIgnoreCase("isnull")) {
                    pr = cb.isNull(rmenu.get(col));

                } else if (cond.equalsIgnoreCase("like") && obj != null) {
                    pr = cb.like(rmenu.get(col), "%" + obj.toString() + "%");

                } else if (cond.equalsIgnoreCase("nlike") && obj != null) {
                    pr = cb.notLike(rmenu.get(col), "%" + obj.toString() + "%");

                } else if (cond.equalsIgnoreCase("ilike") && obj != null) {
                    pr = cb.like(cb.lower(rmenu.get(col)), "%" + obj.toString().toLowerCase() + "%");

                } else if (cond.equalsIgnoreCase("nilike") && obj != null) {
                    pr = cb.notLike(cb.lower(rmenu.get(col)), "%" + obj.toString().toLowerCase() + "%");

                }
                if (pr == null) {
                    LOGGER.error("try to insert null condition-> {} {}", cond, obj);
                    throw new DaoException("try to insert null condition");
                }
                if (prant == null) {
                    prant = pr;
                } else {
                    prant = cb.and(prant, pr);

                }
            } else {
                throw new DaoException("try to insert null condition");
            }
        }
        return prant;

    }

    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    @Override
    public <T, E> List<T> searchbyTAG(Class<T> class1, Class<E> class2, String id1, String id2, String tag,
                                      List<String> column, List<String> cond, List<Object> values, List<String> order) throws DaoException {

        return searchbyTAG(class1, class2, id1, id2, tag, column, cond, values, order, null);
    }

    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    @Override
    public <T, E> List<Object[]> searchbyTAG2(Class<T> class1, Class<E> class2, String id1, String id2, String tag,
                                              List<String> column, List<String> cond, List<Object> values, List<String> order) throws DaoException {

        return searchbyTAG2(class1, class2, id1, id2, tag, column, cond, values, order, null);
    }

    @SuppressWarnings({"rawtypes", "unchecked"})
    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    @Override
    public <T, E> List<Object[]> searchbyTAG2(Class<T> class1, Class<E> class2, String id1, String id2, String tag,
                                              List<String> column, List<String> cond, List<Object> values, List<String> order, Integer maxrows)
            throws DaoException {
        if (class1 != null && class2 != null && tag != null && !tag.isEmpty() && id1 != null && id2 != null) {
            CriteriaBuilder criteriaBuilder = this.entityManager.getCriteriaBuilder();
            CriteriaQuery criteriaQuery = criteriaBuilder.createQuery();

            Root<E> rmenusxrole = criteriaQuery.from(class2);
            Root<T> rmenu = criteriaQuery.from(class1);

            Expression<String> pathRol = rmenusxrole.get("pan");
            Predicate pr = criteriaBuilder.equal(pathRol, tag);
            Predicate pr4 = null;
            if (column != null && cond != null && values != null && !column.isEmpty() && column.size() == cond.size()) {

                // Expression<Timestamp> pathRol1 = rmenu.get("genDate");
                // Predicate pr1 = criteriaBuilder.between(pathRol1, outfInit, outfEnd);
                // Expression<Timestamp> pathRol2 = rmenu.get("endDate");
                // Predicate pr2 = criteriaBuilder.between(pathRol2, outfInit, outfEnd);
                // Predicate pr3 =criteriaBuilder.or(pr1,pr2);
                Predicate pr3 = getwhere(criteriaBuilder, rmenu, column, cond, values);
                pr4 = criteriaBuilder.and(pr, pr3);
                // criteriaQuery.multiselect(rmenu,rmenusxrole);

            } else {

                // Expression<Integer> pathRol1 = rmenu.get("status");
                // Predicate pr1 = criteriaBuilder.equal(pathRol1,1);
                pr4 = pr;
                // criteriaQuery.multiselect(rmenu,rmenusxrole);

            }
            criteriaQuery.multiselect(rmenu, rmenusxrole).distinct(true);
            // criteriaQuery.multiselect(rmenu).distinct(true);
            criteriaQuery.where(criteriaBuilder.and(criteriaBuilder.equal(rmenusxrole.get(id2), rmenu.get(id1)), pr4

            ));
            criteriaQuery = order2(criteriaBuilder, criteriaQuery, rmenu, order);
            // criteriaQuery.orderBy(criteriaBuilder.asc(rmenu.get("genDate")));

            Query qu = entityManager.createQuery(criteriaQuery);
            // LOGGER.info("query->{}",qu.toString());
            if (maxrows != null && maxrows > 1) {
                LOGGER.debug("setting max:{}", maxrows);
                qu.setMaxResults(maxrows);
            }
            return qu.getResultList();

        }

        LOGGER.error("Null params");
        return null;
    }

    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    @Override
    public Long count(Class<?> class1, List<String> columns, List<String> restriction, List<Object> values)
            throws DaoException {

        return count(class1, null, null, null, null, columns, restriction, values);
    }

    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    @Override
    public Long count(Class<?> class1, Class<?> class2, String id1, String id2, String tag, List<String> column,
                      List<String> cond, List<Object> values) throws DaoException {
        if (class1 != null) {
            CriteriaBuilder criteriaBuilder = this.entityManager.getCriteriaBuilder();

            CriteriaQuery<Long> criteriaQuery = criteriaBuilder.createQuery(Long.class);

            Root<?> rmenusxrole = null;
            Predicate pr4 = null;
            Predicate pr = null;
            if (class2 != null) {
                rmenusxrole = criteriaQuery.from(class2);
                Expression<String> pathRol = rmenusxrole.get("pan");
                pr = criteriaBuilder.equal(pathRol, tag);
                pr4 = pr;
            } else {

            }
            Root<?> rmenu = criteriaQuery.from(class1);

            if (column != null && cond != null && values != null && !column.isEmpty() && column.size() == cond.size()) {

                Predicate pr3 = getwhere(criteriaBuilder, rmenu, column, cond, values);
                if (pr4 != null) {
                    pr4 = criteriaBuilder.and(pr, pr3);
                } else {
                    pr4 = pr3;
                }

            }
            if (rmenusxrole != null && id1 != null && id2 != null) {
                criteriaQuery.select(criteriaBuilder.countDistinct(rmenusxrole));

                criteriaQuery.where(criteriaBuilder.and(criteriaBuilder.equal(rmenusxrole.get(id2), rmenu.get(id1)), pr4

                ));
            } else {
                criteriaQuery.select(criteriaBuilder.count(rmenu)

                );
                criteriaQuery.where(pr4);// criteriaBuilder.countDistinct(rmenu)
            }

            // criteriaQuery.multiselect(rmenu).distinct(true);

            // criteriaQuery=order2(criteriaBuilder,criteriaQuery,rmenu, order);
            // criteriaQuery.orderBy(criteriaBuilder.asc(rmenu.get("genDate")));

            Query qu = entityManager.createQuery(criteriaQuery);
            // LOGGER.info("query->{}",qu.toString());
            Object out = qu.getSingleResult();
            if (out != null) {
                return (Long) out;
            }

        }

        return Long.valueOf(-1);
    }

    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    @SuppressWarnings({"rawtypes", "unchecked"})
    @Override
    public List<Object[]> searchgroup(Class<?> class1, Class<?> class2, String mach1, String mach2, String column1,
                                      String column2, List<String> column, List<String> cond, List<Object> values, List<String> order,
                                      boolean having) throws DaoException {

        if (class1 != null) {
            CriteriaBuilder criteriaBuilder = this.entityManager.getCriteriaBuilder();

            CriteriaQuery criteriaQuery = criteriaBuilder.createQuery();
            Root<?> rmenu = criteriaQuery.from(class1);
            Root<?> rmenusxrole = null;
            Predicate pr4 = null;
            Predicate pr = null;
            if (class2 != null && mach1 != null && mach2 != null) {
                rmenusxrole = criteriaQuery.from(class2);
                Expression<String> pathRol = rmenusxrole.get(mach2);
                pr = criteriaBuilder.equal(pathRol, rmenu.get(mach1));
                pr4 = pr;
            } else {

            }

            if (column != null && cond != null && values != null && !column.isEmpty() && column.size() == cond.size()) {

                Predicate pr3 = getwhere(criteriaBuilder, rmenu, column, cond, values);
                if (pr4 != null) {
                    pr4 = criteriaBuilder.and(pr, pr3);
                } else {
                    pr4 = pr3;
                }

            }
            if (rmenusxrole != null && mach1 != null && mach2 != null) {
                criteriaQuery.select(criteriaBuilder.countDistinct(rmenusxrole));

                criteriaQuery
                        .where(criteriaBuilder.and(criteriaBuilder.equal(rmenusxrole.get(mach2), rmenu.get(mach1)), pr4

                        ));
            } else {
                criteriaQuery.select(criteriaBuilder.countDistinct(rmenu));
                if (pr4 != null) {
                    criteriaQuery.where(pr4);
                }
            }
            if (column1 != null) {
                if (order != null && order.size() == 1 && order.get(0).startsWith("_")) {
                    criteriaQuery.multiselect(rmenu.get(column1), criteriaBuilder.count(rmenu.get(column1)),
                            rmenu.get(order.get(0).substring(2)));
                    criteriaQuery.groupBy(rmenu.get(column1));
                    criteriaQuery.groupBy(rmenu.get(column1), rmenu.get(order.get(0).substring(2)));
                } else if (order != null && order.size() == 1) {
                    criteriaQuery.multiselect(rmenu.get(column1), criteriaBuilder.count(rmenu.get(column1)),
                            rmenu.get(order.get(0)));
                    criteriaQuery.groupBy(rmenu.get(column1), rmenu.get(order.get(0)));
                } else {
                    criteriaQuery.multiselect(rmenu.get(column1), criteriaBuilder.count(rmenu.get(column1)));
                    criteriaQuery.groupBy(rmenu.get(column1));
                }

                if (having) {
                    criteriaQuery.having(criteriaBuilder.gt(criteriaBuilder.count(rmenu.get(column1)), 0));
                }
            } else if (column2 != null) {

                if (order != null && order.size() == 1 && order.get(0).startsWith("_")) {
                    criteriaQuery.multiselect(rmenusxrole.get(column2), criteriaBuilder.count(rmenusxrole.get(column2)),
                            rmenusxrole.get(order.get(0).substring(2)));
                    criteriaQuery.groupBy(rmenusxrole.get(column2), rmenusxrole.get(order.get(0).substring(2)));
                } else if (order != null && order.size() == 1) {
                    criteriaQuery.multiselect(rmenusxrole.get(column2), criteriaBuilder.count(rmenusxrole.get(column2)),
                            rmenusxrole.get(order.get(0)));
                    criteriaQuery.groupBy(rmenusxrole.get(column2), rmenusxrole.get(order.get(0)));
                } else {
                    criteriaQuery.multiselect(rmenusxrole.get(column2),
                            criteriaBuilder.count(rmenusxrole.get(column2)));
                    criteriaQuery.groupBy(rmenusxrole.get(column2));
                }

                if (having) {
                    criteriaQuery.having(criteriaBuilder.gt(criteriaBuilder.count(rmenusxrole.get(column2)), 0));
                }
            } else {
                throw new DaoException("null columns to group");
            }
            if (order != null && order.size() == 1 && column1 != null) {
                criteriaQuery = order2(criteriaBuilder, criteriaQuery, rmenu, order);
            } else if (order != null && order.size() == 1 && column2 != null) {
                criteriaQuery = order2(criteriaBuilder, criteriaQuery, rmenusxrole, order);
            }
            Query qu = this.entityManager.createQuery(criteriaQuery);
            return qu.getResultList();

        } else {

        }
        throw new DaoException("null class to group");
    }

    @SuppressWarnings("unchecked")
    @Override
    public <T> List<T> search(String presql, String postsql, List<String> colRest, List<String> rest, List<Object> in) {
        if (presql != null && postsql != null) {
            LOGGER.debug(" try to sql {}", presql);
//eduardo
            Iterator<String> it1 = colRest.iterator();
            Iterator<String> it2 = rest.iterator();
            Iterator<Object> it3 = in.iterator();

            String jpql = presql;
            try {
                // condition
                int i = 0;
                while (it1.hasNext() && it2.hasNext() && it3.hasNext()) {
                    i++;
                    jpql = jpql + genCondition(it1.next(), it2.next(), it3.next(), i,
                            it1.hasNext() && it2.hasNext() && it3.hasNext());
                }
                jpql = jpql + postsql;

                Query query = this.entityManager.createQuery(jpql);
                query.setLockMode(LockModeType.NONE);

                List<T> result = query.getResultList();

                T out = (result != null) ? (result.size() > 0) ? result.get(0) : null : null;
                if (out != null) {
                    this.entityManager.detach(out);
                }
                return (List<T>) out;
            } catch (DaoException e) {
                LOGGER.error("Can not use the condition:{}", e.toString());
                return null;
            }

        } else {

            LOGGER.error("null class");
        }
        return null;
    }

    @SuppressWarnings({"unchecked"})
    @Override
    public <T> List<Object[]> searchgroup(Class<T> class1, String columname, List<String> colRest, List<String> rest,
                                          List<Object> in, List<String> grp, List<String> fnc) {

        if (class1 != null || columname != null || colRest != null || rest != null || in != null || grp != null
                || fnc != null) {
            Iterator<String> it1 = colRest.iterator();
            Iterator<String> it2 = rest.iterator();
            Iterator<Object> it3 = in.iterator();

            String jpql = "SELECT p." + columname;
            try {
                // Create function

                if (grp.size() == fnc.size()) {
                    for (int i = 0; i < fnc.size(); i++) {
                        jpql = jpql + "," + func(fnc.get(i)) + "p." + grp.get(i) + ")";
                    }
                } else {
                    LOGGER.warn("Group and Functions don't have the same number of parameters ");
                }
                // from
                jpql = jpql + " FROM " + class1.getSimpleName() + " p WHERE ";
                // condition
                int i = 0;
                while (it1.hasNext() && it2.hasNext() && it3.hasNext()) {
                    i++;
                    jpql = jpql + genCondition(it1.next(), it2.next(), it3.next(), i,
                            it1.hasNext() && it2.hasNext() && it3.hasNext());
                }
                // group
                jpql = jpql + " GROUP BY p." + columname;

                LOGGER.debug("JQPL query:{}", jpql);
                Query query = this.entityManager.createQuery(jpql);

                query.setLockMode(LockModeType.NONE);

                it3 = in.iterator();
                it1 = colRest.iterator();
                Object aux, aux2;
                i = 0;
                while (it3.hasNext() && it1.hasNext()) {
                    i++;
                    aux = it3.next();
                    aux2 = it1.next();
                    if (aux != null) {
                        try {
                            if (aux.getClass().isAnnotationPresent(Entity.class) && !this.entityManager.contains(aux)) {
                                this.entityManager.refresh(aux);
                            }
                            ;
                        } catch (NullPointerException e) {
                            LOGGER.error("Class entity not found:{}", e.toString());
                        }
                        LOGGER.debug("set param:{}", aux.toString());
                        query.setParameter(i, aux);
                    } else {
                        LOGGER.warn("null parameter at position:{} with cond:{}", i, aux2);
                    }
                }
                return query.getResultList();

            } catch (DaoException e) {
                LOGGER.error("Can not use the condition:{}", e.toString());
                return null;
            }
        } else {
            LOGGER.warn("NULL/wrong condition");
            return null;
        }
    }

    @SuppressWarnings({"unchecked"})
    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    @Override
    public <T> List<Object[]> storeprocedure(String SPname, Date InitDate, Date EndDate) {

        if (SPname != null && InitDate != null && EndDate != null) {

            Timestamp tspIni = new Timestamp(InitDate.getTime());
            Timestamp tspEnd = new Timestamp(EndDate.getTime());

            StoredProcedureQuery querysp = this.entityManager.createStoredProcedureQuery(SPname)
                    .registerStoredProcedureParameter(1, Class.class, ParameterMode.REF_CURSOR)
                    .registerStoredProcedureParameter(2, Timestamp.class, ParameterMode.IN)
                    .registerStoredProcedureParameter(3, Timestamp.class, ParameterMode.IN).setParameter(2, tspIni)
                    .setParameter(3, tspEnd);
            if (querysp.execute()) {
                LOGGER.info("Se ejecuto SP con resultado de:", +querysp.getResultList().size());
                return querysp.getResultList();
            } else {
                LOGGER.error("Can not execute Store Procedure: " + SPname);
                return null;
            }

        } else {
            LOGGER.warn("NULL/wrong condition");
            return null;
        }
    }

    @Override
    public Long storeprocedure(Long id) {

        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("count_comments")
                .registerStoredProcedureParameter(1, Long.class, ParameterMode.IN)
                .registerStoredProcedureParameter(2, Long.class, ParameterMode.OUT).setParameter(1, 1L);

        query.execute();

        Long commentCount = (Long) query.getOutputParameterValue(2);

        return commentCount;

    }

    @SuppressWarnings({"unchecked"})
    @Override
    public List<Object[]> searchgroup(String tbls, List<String> columname, List<String> colRest, List<String> rest,
                                      List<Object> in, List<String> grp, List<String> fnc, String rela) {

        if (tbls != null || colRest != null || rest != null || in != null || grp != null || fnc != null) {
            Iterator<String> it1 = colRest.iterator();
            Iterator<String> it2 = rest.iterator();
            Iterator<Object> it3 = in.iterator();
            String jpql = "SELECT ";

            try {
                // Create colum
                if (columname != null) {
                    jpql = jpql + strc(columname) + ",";
                }
                // Create function
                if (grp.size() == fnc.size()) {
                    for (int i = 0; i < fnc.size(); i++) {
                        jpql = jpql + func(fnc.get(i)) + grp.get(i) + ")";
                        if (i < fnc.size() - 1) {
                            jpql = jpql + ",";
                        }
                    }
                } else {
                    LOGGER.warn("Group and Functions don't have the same number of parameters ");
                }
                // create from
                jpql = jpql + " FROM " + tbls + " WHERE ";
                // condition
                int i = 0;
                while (it1.hasNext() && it2.hasNext() && it3.hasNext()) {
                    i++;
                    jpql = jpql + genCond2(it1.next(), it2.next(), it3.next(), i,
                            it1.hasNext() && it2.hasNext() && it3.hasNext());
                }
                // group
                if (rela != null) {
                    jpql = jpql + " AND " + rela + " GROUP BY " + strc(columname);
                }

                LOGGER.warn("JQPL query:{}", jpql);
                Query query = this.entityManager.createQuery(jpql);
                query.setLockMode(LockModeType.NONE);

                it3 = in.iterator();
                it1 = colRest.iterator();
                Object aux, aux2;
                i = 0;
                while (it3.hasNext() && it1.hasNext()) {
                    i++;
                    aux = it3.next();
                    aux2 = it1.next();
                    if (aux != null) {
                        try {
                            if (aux.getClass().isAnnotationPresent(Entity.class) && !this.entityManager.contains(aux)) {
                                this.entityManager.refresh(aux);
                            }
                            ;
                        } catch (NullPointerException e) {
                            LOGGER.error("Class entity not found:{}", e.toString());
                        }
                        LOGGER.debug("set param:{}", aux.toString());
                        query.setParameter(i, aux);
                    } else {
                        LOGGER.warn("null parameter at position:{} with cond:{}", i, aux2);
                    }
                }
                return query.getResultList();

            } catch (DaoException e) {
                LOGGER.error("Can not use the condition:{}", e.toString());
                return null;
            }
        } else {
            LOGGER.warn("NULL/wrong condition");
            return null;
        }
    }

    protected static String genCond2(String columname, String cond, Object in, int pos, boolean hasNext)
            throws DaoException {
        String out;
        if (columname != null && cond != null && in == null
                && (cond.equalsIgnoreCase("IS NULL") || (cond.equalsIgnoreCase("IS NOT NULL")))) {
            out = columname + " " + Dao.cond(cond) + "  ";
            if (hasNext) {
                out = out + " AND ";
            }
            return out;
        } else if (columname != null && cond != null && in != null) {
            out = columname + " " + Dao.cond(cond) + "  ?" + pos;
            if (hasNext) {
                out = out + " AND ";
            }
            return out;
        } else {
            throw new DaoException("inserting null condition");
        }
    }

    private static String func(String func) throws DaoException {
        if (func != null && !func.isEmpty()) {
            if (func.equalsIgnoreCase("su"))
                return "SUM(";
            else if (func.equalsIgnoreCase("co"))
                return "COUNT(";
            else if (func.equalsIgnoreCase("ma"))
                return "MAX(";
            else if (func.equalsIgnoreCase("mi"))
                return "MIN(";
            else if (func.equalsIgnoreCase("av"))
                return "AVG(";
        }
        throw new DaoException("try to insert null function");
    }

    private static String strc(List<String> slst) throws DaoException {
        String str = "";
        for (int i = 0; i < slst.size(); i++) {
            if (i > 0) {
                str = "," + str + " ";
            } else {
                str = str + slst.get(i);
            }
        }
        return str;
    }

}
