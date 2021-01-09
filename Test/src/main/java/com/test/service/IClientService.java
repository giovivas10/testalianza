package com.test.service;

import com.test.bean.Client;
import com.test.response.Response;

import javax.ejb.Local;
import java.util.List;

@Local
public interface IClientService {

    Response<List<Client>> getAll();

    Response<Client> create(Client request) throws SecurityException;

    Response<Client> update(Client request) throws SecurityException;

    Response<Client> delete(Client request) throws SecurityException;

}
