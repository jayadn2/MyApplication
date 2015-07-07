package com.actv.simpfo.myapplication;

import com.actv.simpfo.myapplication.Model.CustomerBalanceDetail;
import com.actv.simpfo.myapplication.Model.MobileCollectionJson;
import com.google.gson.Gson;

import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;

/**
 * Created by JaSh on 07/07/2015.
 */
public class CollectionEntry extends GenericSeeker<MobileCollectionJson> {
    private static String User_Search_Path = "api/CustomerBalanceDetails/";

    //Create a Post request to update the payment details.

    @Override
    public ArrayList<MobileCollectionJson> findPost(Object postObject) {
        HttpResponse responseObj = null;
        CustomerBalanceDetail customerBalanceDetail = (CustomerBalanceDetail) postObject;
        Gson gson = new Gson();
        String jsonObj = gson.toJson(customerBalanceDetail);
        ArrayList<MobileCollectionJson> result = new ArrayList<MobileCollectionJson>();
        String response = "";
        String url = constructSearchUrl("");
        PostMethod method = new PostMethod(url);
        setToken(AppGlobals.Token);
        try {
            HttpPost httpPost = new HttpPost(url);
            httpPost.setEntity(new StringEntity(jsonObj));
            httpPost.setHeader("Accept", "application/json");
            httpPost.setHeader("Content-type", "application/json");
            httpPost.setHeader("Authorization", "Bearer " + getToken());
            responseObj = new DefaultHttpClient().execute(httpPost);
        }
        catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }  catch (IOException e) {
            e.printStackTrace();
        }
        if(responseObj != null)
        {
            BufferedReader reader = null;
            try {
                reader = new BufferedReader(new InputStreamReader(responseObj.getEntity().getContent(), "UTF-8"));
                String json = reader.readLine();
                MobileCollectionJson mobileCollectionJson = gson.fromJson(json, MobileCollectionJson.class);
                if(mobileCollectionJson != null)
                    result.add(mobileCollectionJson);
            } catch (IOException e) {
                e.printStackTrace();
            }

            response = responseObj.toString();
        }
        return result;


    }


    @Override
    public ArrayList<MobileCollectionJson> find(String query) {
        return null;
    }

    @Override
    public ArrayList<MobileCollectionJson> find(String query, int maxResults) {
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
