package com.actv.simpfo.myapplication;


import android.util.Base64;

import java.io.UnsupportedEncodingException;

/**
 * Created by JaSh on 30/05/2015.
 */
public class EncryptionHelper {

    public static String EncryptToBase64(String text)
    {
        String encryptedString = "";
        byte[] data = new byte[0];
        try {
            data = text.getBytes("UTF-8");
            encryptedString = Base64.encodeToString(data, Base64.DEFAULT);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

        return encryptedString;
    }

    public static String DecryptFromBase64(String base64)
    {
        String decryptedString = "";
        byte[] data = Base64.decode(base64, Base64.DEFAULT);
        decryptedString = new String(data);
        return decryptedString;
    }
}
