package com.actv.simpfo.myapplication;

import com.actv.simpfo.myapplication.Model.MobileCollectionRequestModel;
import com.actv.simpfo.myapplication.Model.MobileCollectionResponseListModel;
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
 * Created by JaSh on 25/07/2015.
 */
public class CollectionReportSeeker extends GenericSeeker<MobileCollectionResponseListModel> {
    private static String User_Search_Path = "api/MobileCollectionRequestModels/";

/*
Example of the request:
    http://localhost/ActvAndroidApp/api/MobileCollectionRequestModels
    User-Agent: Fiddler
    Host: localhost
    Content-Length: 150
    Accept: application/json
    Content-Type: application/json
    Authorization: Bearer pzXHScmjAYJ7IVeS_psOj_uePsAA2TCvYo7aDnZjT-vnsHL5YdCfzVYg7RQyqs0UezVKHAKr7vWZoSGiAWegaRJ3_YgGcBJ4z-E9nMK8U6HJayzeWrTyXV72YgGFM1dkSkMgaqhOyRjSOVbiuUGQ6cSGOmJqmFl3NzyVtS2X42THUHOucYigZRCsxvfv3wo0tLTpW-wIvB2VmjlvXb_pGarXxbu1btT2P8ZCYjYybvY

    Post:
    {
        "ID":0,
            "FromDate":"1/7/2015",
            "ToDate":"2/7/2015",
            "EmpId":"12",
            "SearchOnBillNumber":false,
            "StartBillNumber":"12",
            "EndBillNumber":"12"
    }
*/
    @Override
    public ArrayList<MobileCollectionResponseListModel> find(String query) {
        return null;
    }

    @Override
    public ArrayList<MobileCollectionResponseListModel> find(String query, int maxResults) {
        return null;
    }

    @Override
    public ArrayList<MobileCollectionResponseListModel> findPost(Object postObject) {
        HttpResponse responseObj = null;
        MobileCollectionRequestModel mobileCollectionRequestModel = (MobileCollectionRequestModel) postObject;
        Gson gson = new Gson();
        String jsonObj = gson.toJson(mobileCollectionRequestModel);
        ArrayList<MobileCollectionResponseListModel> result = new ArrayList<MobileCollectionResponseListModel>();
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
                MobileCollectionResponseListModel mobileCollectionJson = gson.fromJson(json, MobileCollectionResponseListModel.class);
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
    public String retrieveSearchMethodPath() {
        return User_Search_Path;
    }

    @Override
    public String ValidateUser(String userName, String password) {
        return null;
    }
}
