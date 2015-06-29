package com.actv.simpfo.myapplication;

import android.content.Context;

/**
 * Created by JaSh on 06/06/2015.
 */
public class AppGlobals {
    public static String EmpId = "";
    public static String Token = "";
    public static int SelectedCustomerId = -1;

    private static Context context;

    public static void setContext(Context ctx){
        context = ctx;
    }

    public static Context getContext()
    {
        return context;
    }

}
