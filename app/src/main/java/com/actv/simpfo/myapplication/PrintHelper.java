package com.actv.simpfo.myapplication;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by JaSh on 12/07/2015.
 */
public class PrintHelper {

    public String Header;
    public List<PrintLine> PrintLines;
    private static boolean isConnected = false;
    public static String PrinterName = "BTP-B00955";

    public PrintHelper()
    {
        PrintLines = new ArrayList<PrintLine>();
    }

    public void Print()
    {
        if(isConnected)
        {
            //Print to the printer
        }
    }

    public static boolean ConnectToPrinter()
    {
        return isConnected;
    }

    public static boolean IsConnected()
    {
        return isConnected;
    }

}
