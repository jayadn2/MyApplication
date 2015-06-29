package com.actv.simpfo.myapplication;

/**
 * Created by JaSh on 15/05/2015.
 */
import org.apache.http.protocol.HTTP;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;

public abstract class GenericSeeker<E> {
    protected static final String BASE_URL = "http://www.simpfo.in/siti/"; // 10.0.2.2:802/ , http://192.168.0.100:802/, http://www.simpfo.in/siti/
    protected static final String SLASH = "/";
    protected HttpRetriever httpRetriever = new HttpRetriever();
    public abstract ArrayList<E> find(String query);
    public abstract ArrayList<E> find(String query, int maxResults);
    public abstract String retrieveSearchMethodPath();
    public abstract String ValidateUser(String userName, String password);
    private String token = "";
    private String empId = "";

    protected String constructSearchUrl(String query) {
        StringBuffer sb = new StringBuffer();
        sb.append(BASE_URL);
        sb.append(retrieveSearchMethodPath());
        //sb.append(SLASH);
        sb.append(URLEncoder.encode(query));
        return sb.toString();
    }

    public ArrayList<E> retrieveFirstResults(ArrayList<E> list, int maxResults) {
        ArrayList<E> newList = new ArrayList<E>();
        int count = Math.min(list.size(), maxResults);
        for (int i=0; i<count; i++) {
            newList.add(list.get(i));
        }
        return newList;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getEmpId() {
        return empId;
    }

    public void setEmpId(String empId) {
        this.empId = empId;
    }
}
