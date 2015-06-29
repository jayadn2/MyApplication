package com.actv.simpfo.myapplication;

import com.actv.simpfo.myapplication.Model.User;
import com.google.gson.Gson;

import java.util.ArrayList;

/**
 * Created by JaSh on 15/05/2015.
 */
public class XmlParser {
    public static ArrayList<User> parseMoviesResponse(String response) {
        ArrayList<User> userArrayList = null;
        Gson gson = new Gson();
        User[] users = gson.fromJson(response, User[].class);
        if(users != null && users.length > 0)
        {
            for(int i = 0; i <users.length ; i++)
            {
                userArrayList.add(users[i]);
            }
        }

        return null;
    }
}
