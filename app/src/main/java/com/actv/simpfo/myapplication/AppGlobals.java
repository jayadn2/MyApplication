package com.actv.simpfo.myapplication;

import android.app.Activity;
import android.app.DialogFragment;
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

    public static void setContext(Context ctx) {
        context = ctx;
    }

    public static Context getContext() {
        return context;
    }

    public static SimpleDateFormat AppDateFormat() {
        return curFormater;
    }

    public static MobileCollectionJson SelectedCollectionEntry;

    public static CustomerBalanceDetail SelectedCustomerBalanceDetail;

    public static Activity MainActivity;

    public static String PrinterName = "";//"BTP-B00955";

    public static String PrinterMac = "";

    public static String ServerUrl = "";

    public static String CompanyName = "SITI";

    public static boolean IsBluetoothConnected;

    public static PrinterTestDialogFragment printerTestDialogFragment = new PrinterTestDialogFragment();

    public static String MacId = "";

    //Appsettings ex = BTP-B00955""http://www.simpfo.in/siti/
    //After encryption = QlRQLUIwMDk1NSIiaHR0cDovL3d3dy5zaW1wZm8uaW4vc2l0aS8=

    //BTP-B00955""http://192.168.0.100/ActvAndroidApp/
    //After encryption = QlRQLUIwMDk1NSIiaHR0cDovLzE5Mi4xNjguMC4xMDAvQWN0dkFuZHJvaWRBcHAv

    //BTP-B00955""http://192.168.0.101/ActvAndroidApp/
    //After encryption = QlRQLUIwMDk1NSIiaHR0cDovLzE5Mi4xNjguMC4xMDAvQWN0dkFuZHJvaWRBcHAv

}
