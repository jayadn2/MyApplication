package com.actv.simpfo.myapplication;

/**
 * Created by JaSh on 05/09/2015.
 */
public class HelperClass {

    public static int stringToInt(String value, int _default) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return _default;
        }
    }


}
