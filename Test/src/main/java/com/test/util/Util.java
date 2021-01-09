package com.test.util;

import java.io.IOException;
import java.io.Serializable;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.List;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.jboss.security.Base64Encoder;
import org.json.JSONArray;
import org.json.JSONObject;

public class Util implements Serializable {

	private static final long serialVersionUID = 2402477097896349996L;

	public static Boolean valideField(JSONObject jsonObject, List<String> list) {
		boolean resp = true;
		for (String x : list) {
			if (jsonObject.has(x) && jsonObject.get(x).toString().trim().length() > 0) {
				resp = true;
			} else {
				resp = false;
				break;
			}
		}

		return resp;
	}

	public static Boolean valideFieldArray(JSONArray jsonArray, List<String> list) {
		boolean resp = true;
		for (int i = 0; i < jsonArray.length(); i++) {
			JSONObject jsonObject = jsonArray.getJSONObject(i);
			for (String x : list) {
				if (jsonObject.has(x) && jsonObject.get(x).toString().trim().length() > 0) {
					resp = true;
				} else {
					resp = false;
					break;
				}
			}
		}
		return resp;
	}

	public static String crypto(String word, String cryptoDigestInstance) {
		if (word != null && !word.isEmpty()) {
			MessageDigest md;
			try {
				md = MessageDigest.getInstance(cryptoDigestInstance);
				md.update(word.getBytes());
				byte[] bytes = md.digest();
				return Base64Encoder.encode(bytes);
			} catch (NoSuchAlgorithmException | IOException e) {
			}
		}
		return null;
	}

	public static String getStringObject(Object object) {
		try {
			return new ObjectMapper().writeValueAsString(object);
		} catch (JsonProcessingException e) {
			e.printStackTrace();
			return null;
		}
	}
}
