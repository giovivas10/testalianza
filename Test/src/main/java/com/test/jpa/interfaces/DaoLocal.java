package com.test.jpa.interfaces;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import javax.ejb.Local;

import com.test.exception.DaoException;

@Local
public interface DaoLocal {
	int count(String tablename);

	<T> T find(Class<T> class1, String ColumnName, Object id);

	<T> T find(Class<T> class1, Object id);

	<T> List<T> search(Class<T> class1, List<String> columname, List<String> restriction, List<Object> in) throws DaoException;

	<T> List<T> search(Class<T> class1, String columname, List<String> columRestric, List<String> restriction, List<Object> in) throws DaoException;

	<T> List<T> search(Class<T> class1, String columname) throws DaoException;

	<T> List<T> list(Class<T> class1);

	<T> List<T> listLimit(Class<T> class1, int maxrows);

	Integer getMaxID(Class<?> entity);

	<T> List<T> search(Class<T> class1, String columname, List<String> columRestric, List<String> restriction, List<Object> in, List<String> order) throws DaoException;

	<T> List<T> search(Class<T> class1, String columname, List<Object> in) throws DaoException;

	<T> List<T> search(Class<T> class1, String Columnname, List<String> columRestriction, List<String> restriction, List<Object> in, Integer max) throws DaoException;;

	<T> List<T> search(Class<T> class1, String columname, List<String> columRestric, List<String> restriction, List<Object> in, List<String> order, Integer max) throws DaoException;;

	<T> List<T> search(Class<T> class1, List<String> column, List<String> cond, List<Object> values, List<String> order, Integer max) throws DaoException;

	<T, E> List<T> searchbyTAG(Class<T> class1, Class<E> class2, String id1, String id2, String tag, List<String> column, List<String> cond, List<Object> values, List<String> order, Integer maxrows) throws DaoException;

	<T, E> List<T> searchbyTAG(Class<T> class1, Class<E> class2, String id1, String id2, String tag, List<String> column, List<String> cond, List<Object> values, List<String> order) throws DaoException;

	<T, E> List<Object[]> searchbyTAG2(Class<T> class1, Class<E> class2, String id1, String id2, String tag, List<String> column, List<String> cond, List<Object> values, List<String> order, Integer maxrows) throws DaoException;

	<T, E> List<Object[]> searchbyTAG2(Class<T> class1, Class<E> class2, String id1, String id2, String tag, List<String> column, List<String> cond, List<Object> values, List<String> order) throws DaoException;

	public Long count(Class<?> class1, List<String> columns, List<String> restriction, List<Object> values) throws DaoException;

	public Long count(Class<?> class1, Class<?> class2, String id1, String id2, String tag, List<String> column, List<String> cond, List<Object> values) throws DaoException;

	List<Object[]> searchgroup(Class<?> class1, Class<?> class2, String mach1, String mach2, String column1, String column2, List<String> column, List<String> res, List<Object> values, List<String> order, boolean b) throws DaoException;

	List<Object[]> searchgroup(String tbls, List<String> columname, List<String> colRest, List<String> rest, List<Object> in, List<String> grp, List<String> fnc, String rela);

	<T> List<T> search(String presql, String postsql, List<String> colRest, List<String> rest, List<Object> in);

	Long storeprocedure(Long id);

	<T> List<Object[]> storeprocedure(String SPname, Date InitDate, Date EndDate);

	<T> List<Object[]> searchgroup(Class<T> class1, String columname, List<String> colRest, List<String> rest, List<Object> in, List<String> grp, List<String> fnc);

	<T, E> List<T> searchbyTAG3(Class<T> class1, Class<E> class2, String id1, String id2, String tag, String columntag, List<String> column, List<String> cond, List<Object> values, List<String> order, Integer maxrows, boolean distinct) throws DaoException;

	<T> BigDecimal sum(Class<T> class1, String string, List<String> columnname, List<String> operator, List<Object> values) throws DaoException;
}
