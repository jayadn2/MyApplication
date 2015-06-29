package com.actv.simpfo.myapplication;

import com.actv.simpfo.myapplication.Model.User;

import org.apache.commons.httpclient.methods.PostMethod;

import java.util.ArrayList;

import Helper.MacHelper;

/**
 * Created by JaSh on 15/05/2015.
 */
public class UserSeeker extends GenericSeeker<User> {

    private static String User_Search_Path = "token";
    private static String macId;
    @Override
    public ArrayList<User> find(String query) {
        User_Search_Path = "api/";
        ArrayList<User> userArrayList = retrieveUserList(query);
        return userArrayList;
    }

    @Override
    public String ValidateUser(String userName, String password)
    {
        String query = "";
        String response = "";
        macId = MacHelper.GetMacId();
        userName = EncryptionHelper.EncryptToBase64(userName).trim();
        password = EncryptionHelper.EncryptToBase64(password).trim();
        macId = EncryptionHelper.EncryptToBase64(macId).trim();
        String url = constructSearchUrl(query);
        String empId = "";

        PostMethod method = new PostMethod(url);
        //http://www.java2s.com/Code/Java/Apache-Common/HttppostmethodExample.htm
        method.addParameter("username", userName);
        method.addParameter("password", password);
        method.addParameter("grant_type", "password");
        method.addParameter("mac", macId); //1234
        method = httpRetriever.PostRequest(method);
        if(method != null)
        {
            response = method.getResponseBodyAsString();
            empId = method.getResponseHeader("ed").getValue().trim();
            empId = EncryptionHelper.DecryptFromBase64(empId);
            if(response != null) {
                String[] responseSplitArray = response.split(":");
                if (responseSplitArray.length > 1) {
                    setToken(responseSplitArray[1]);
                    setToken(getToken().replace("\"", ""));
                    setToken(getToken().replace(",token_type", ""));
                    AppGlobals.Token = getToken();
                }
            }
        }
        return empId;
    }

    private ArrayList<User> retrieveUserList(String query) {
        String url = constructSearchUrl(query);

        PostMethod method = new PostMethod(url);
        //http://www.java2s.com/Code/Java/Apache-Common/HttppostmethodExample.htm
        method.addParameter("username", "YW5hbmQ=");
        method.addParameter("password", "cGFzc3dvcmQ=");
        method.addParameter("grant_type", "password");
        method.addParameter("mac", macId);
        //postReq.addHeader("", "");
        //int response = httpRetriever.RetrievePostRequest(postReq);
        //return XmlParser.parseMoviesResponse(response);

return null;
    }

    @Override
    public ArrayList<User> find(String query, int maxResults) {
        ArrayList<User> userArrayList = retrieveUserList(query);
        return retrieveFirstResults(userArrayList,maxResults);
    }

    @Override
    public String retrieveSearchMethodPath() {
        return User_Search_Path;
    }

    @Override
    public ArrayList<User> findPost(String query) {
        return null;
    }
}
