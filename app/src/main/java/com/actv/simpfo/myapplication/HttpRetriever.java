package com.actv.simpfo.myapplication;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.http.Header;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.preference.PreferenceActivity;
import android.support.annotation.NonNull;
import android.util.Log;

/**
 * Created by JaSh on 15/05/2015.
 */
public class HttpRetriever {

    private HttpClient client = new HttpClient();

    //http://www.java2s.com/Code/Java/Apache-Common/HttppostmethodExample.htm
    public PostMethod PostRequest(PostMethod postMethod)
    {
        String response ="";
        try{
            int returnCode = client.executeMethod(postMethod);
            if(returnCode == org.apache.commons.httpclient.HttpStatus.SC_OK)  {
                Log.d(getClass().getSimpleName(), "The Post method is not implemented by this URI");
                //response = postMethod.getResponseBodyAsString();
                //method.getRequestHeader("")
            }
            else {
                return null;
            }
        } catch (Exception e) {
            System.err.println(e);
        } finally {
            //postMethod.releaseConnection();
            //postMethod.releaseConnection();
        }
        return postMethod;
    }

    public GetMethod GetRequest(GetMethod getMethod)
    {
        String response ="";
        try{
            int returnCode = client.executeMethod(getMethod);
            if(returnCode == org.apache.commons.httpclient.HttpStatus.SC_OK)  {
                Log.d(getClass().getSimpleName(), "The Get method is not implemented by this URI");
                //response = postMethod.getResponseBodyAsString();
                //method.getRequestHeader("")
            }
            else {
                return null;
            }
        } catch (Exception e) {
            System.err.println(e);
        } finally {
            //postMethod.releaseConnection();
            //getMethod.releaseConnection();
        }
        return getMethod;
    }
}
