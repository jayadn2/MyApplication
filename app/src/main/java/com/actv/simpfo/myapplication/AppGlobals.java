package com.actv.simpfo.myapplication;

import android.content.Context;

import com.actv.simpfo.myapplication.Model.CustomerBalanceDetail;
import com.actv.simpfo.myapplication.Model.MobileCollectionJson;

import java.text.SimpleDateFormat;

/**
 * Created by JaSh on 06/06/2015.
 */
public class AppGlobals {
    public static String EmpId = "";
    public static String Token = "";
    public static int SelectedCustomerId = -1;
    private static SimpleDateFormat curFormater = new SimpleDateFormat("dd/MM/yyyy");

    private static Context context;

    public static void setContext(Context ctx){
        context = ctx;
    }

    public static Context getContext()
    {
        return context;
    }

    public static SimpleDateFormat AppDateFormat() {
        return curFormater;
    }

    public static MobileCollectionJson SelectedCollectionEntry;

    public static CustomerBalanceDetail SelectedCustomerBalanceDetail;

}
