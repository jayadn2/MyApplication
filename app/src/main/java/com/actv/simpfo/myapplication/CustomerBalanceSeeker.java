package com.actv.simpfo.myapplication;

import com.actv.simpfo.myapplication.Model.CustomerBalanceDetail;
import com.actv.simpfo.myapplication.Model.CustomerJson;
import com.google.gson.Gson;

import org.apache.commons.httpclient.methods.GetMethod;

import java.util.ArrayList;

/**
 * Created by JaSh on 11/06/2015.
 */
public class CustomerBalanceSeeker extends GenericSeeker<CustomerBalanceDetail>  {
    // GET: api/CustomerBalanceDetails/5
    private static String User_Search_Path = "api/CustomerBalanceDetails";

    @Override
    public String retrieveSearchMethodPath() {
        return User_Search_Path;
    }

    @Override
    public ArrayList<CustomerBalanceDetail> find(String query) {
        ArrayList<CustomerBalanceDetail> result = null;
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
            CustomerBalanceDetail[] customers =  gson.fromJson(response, CustomerBalanceDetail[].class);
            result = new ArrayList<CustomerBalanceDetail>();
            if(customers != null)
            {
                for (int i = 0; i < customers.length; i++) {
                    CustomerBalanceDetail customerJson = new CustomerBalanceDetail(customers[i]);
                    result.add(customerJson);
                }
            }
        }
        return result;
    }

    @Override
    public ArrayList<CustomerBalanceDetail> find(String query, int maxResults) {
        return null;
    }

    @Override
    public String ValidateUser(String userName, String password) {
        return null;
    }

}
