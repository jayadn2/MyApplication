package com.actv.simpfo.myapplication;

import com.actv.simpfo.myapplication.Model.Customer;
import com.actv.simpfo.myapplication.Model.CustomerJson;
import com.google.gson.Gson;

import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.methods.PostMethod;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Collections;

import Helper.SortBasedOnName;

/**
 * Created by JaSh on 04/06/2015.
 */
public class CustomerSeeker extends GenericSeeker<CustomerJson> {
    private static String User_Search_Path = "api/CustomerDetails/";

    @Override
    public ArrayList<CustomerJson> find(String query) {
        ArrayList<CustomerJson> result = null;
        String response = "";
        String url = constructSearchUrl(query);
        GetMethod method = new GetMethod(url);
        setToken(AppGlobals.Token);
        //http://www.java2s.com/Code/Java/Apache-Common/HttppostmethodExample.htm
        //Sample request - http://localhost:802/api/CustomerDetails/20
        //Header - Authorization: Bearer UnUihp2SZvAKHCyncqDQRWXB1TKk_ALO9AMUpAz7lJV3Igytjhco06ztbr4bQzpGQGqEQf-CJqkB5xU5VX8shSnFcDcjw4cP8SJ-8cByJnJ6sU71-2xRnU0jGA6KXqKKrbONJC4QhAdJDd7IZ37rH45GK2BaYa_hYkjHRIBNLSftZyg3mNu7X6Lz22nRzAsZMaS5QIGO8hv0LEHKJUlnAVgtNa8bl1f2gl7VNB83pi4
        method.addRequestHeader("Authorization","Bearer " + getToken());
        method = httpRetriever.GetRequest(method);
        if(method != null)
        {
            response = method.getResponseBodyAsString();
            Gson gson = new Gson();
            CustomerJson[] customers =  gson.fromJson(response, CustomerJson[].class);
            result = new ArrayList<CustomerJson>();
            if(customers != null)
            {
                for (int i = 0; i < customers.length; i++) {
                    CustomerJson customerJson = new CustomerJson(customers[i].getCustomerName(), customers[i].getID());
                    result.add(customerJson);
                }
                Collections.sort(result, new SortBasedOnName());
            }
        }
        return result;
    }

    @Override
    public ArrayList<CustomerJson> find(String query, int maxResults) {
        return null;
    }

    @Override
    public String retrieveSearchMethodPath() {
        return User_Search_Path;
    }

    @Override
    public String ValidateUser(String userName, String password) {
        return null;
    }

}
