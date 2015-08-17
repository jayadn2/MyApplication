package com.actv.simpfo.myapplication;

import android.content.Context;
import android.database.SQLException;
import android.database.sqlite.SQLiteDatabase;

/**
 * Created by JaSh on 09/08/2015.
 */
public class AppSettingsDataSource {

    // Database fields
    private SQLiteDatabase database;
    private AppSettingsDbHelper dbHelper;

    public AppSettingsDataSource(Context context) {
        dbHelper = new AppSettingsDbHelper(context);
    }

    public void open() throws SQLException {
        database = dbHelper.getWritableDatabase();
    }

    public void close() {
        dbHelper.close();
    }

    public AppSettingsContract.AppSettings
}
