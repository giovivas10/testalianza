package com.test.jpa.interfaces;

import java.util.List;
import java.util.Set;

import javax.ejb.Local;

import com.test.exception.DaoException;

@Local
public interface DaoRWLocal {
	Object insert(Object entity);

	void delete(Class<?> entity);

	boolean update(Object entity);

	boolean updateList(Set<?> list) throws DaoException;

	boolean insertList(Set<?> list) throws DaoException;

	<T> Set<T> insertList2(Set<T> list) throws DaoException;

	int execQuery(String order);

	void delete(Class<?> entity, List<String> columns, List<String> operators, List<Object> in);

	boolean deleteList(Set<?> list) throws DaoException;

	boolean updateRollBack(Object entity) throws Exception;

	void delete(Object entity) throws Exception;

	List<Object> executeList(List<Object> entities, List<String> methods) throws DaoException;
}
