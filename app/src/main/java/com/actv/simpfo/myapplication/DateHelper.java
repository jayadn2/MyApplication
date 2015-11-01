package com.actv.simpfo.myapplication;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by JaSh on 31-Oct-15.
 */
public class DateHelper {
    public static String ConvertToFormat(int year, int month, int day) {
        String dateValue = "";
        dateValue = String.valueOf(day) + "/" + String.valueOf(month) + "/" + String.valueOf(year);
        String convertedDate = "";
        Date convertedDateObj = new Date();
        try {
            convertedDateObj = AppGlobals.AppDateFormat().parse(dateValue);
            convertedDate = AppGlobals.AppDateFormat().format(convertedDateObj);
        } catch (Exception ex) {
            convertedDate = dateValue;
        }
        return convertedDate;
    }
}
