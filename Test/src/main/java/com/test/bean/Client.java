package com.test.bean;

import javax.persistence.*;
import java.io.Serializable;
import java.sql.Timestamp;

@Entity
@Table(name = "\"Client\"")
@NamedQuery(name = "Client.findAll", query = "SELECT e FROM Client e")
public class Client implements Serializable {

	/**
		 * 
		 */
	private static final long serialVersionUID = -8336351708423025883L;

	@Id
	@Column(name = "\"Id\"")
	private Integer id;

	@Id
	@Column(name = "\"SharedKey\"")
	private String sharedKey;

	@Column(name = "\"Name\"")
	private String name;

	@Column(name = "\"BussinesId\"")
	private String bussinesId;

	@Column(name = "`Email`")
	private String email;

	@Column(name = "\"Phone\"")
	private String phone;

	@Column(name = "\"DataAdded\"")
	private Timestamp dataAdded;



}