package com.test.util;

import java.io.Serializable;
import java.util.Arrays;
import java.util.List;

public class Constant implements Serializable {

	private static final long serialVersionUID = -3236425389472722618L;

	public static final String FORMAT_DATE_ENTITY = "yyyy-MM-dd'T'HH:mm:ss.SSS";
	public static final List<String> CREATE_LIST = Arrays.asList("class_Named", "method", "position", "description", "param", "idParking");
	public static final List<String> CREATE_PARKING_LIST = Arrays.asList("id", "createdDate", "description", "idCountry", "latitude", "longitude", "name");
	public static final List<String> CREATE_COUNTRY_LIST = Arrays.asList("id", "description", "name");

}
