package com.actv.simpfo.myapplication;
import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.database.sqlite.SQLiteTransactionListener;
import android.util.Log;

import com.actv.simpfo.myapplication.Model.AppSetting;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by JaSh on 09/08/2015.
 */
public class AppSettingsDbHelper extends SQLiteOpenHelper {

    // Logcat tag
    private static final String LOG = "DatabaseHelper";
    // If you change the database schema, you must increment the database version.
    public static final int DATABASE_VERSION = 1;
    public static final String DATABASE_NAME = "AppSettings.db";

    // Table Name
    public static final String TABLE_NAME_APPSETTING = "AppSetting";

    public static final String COLUMN_NAME_ID = "id";
    public static final String COLUMN_NAME_SERVER = "server";
    public static final String COLUMN_NAME_PNAME = "pname";
    public static final String COLUMN_NAME_PMAC = "pmac";

    private static final String TEXT_TYPE = " TEXT";
    private static final String COMMA_SEP = ",";

    private static final String SQL_CREATE_APPSETTING =
            "CREATE TABLE " + TABLE_NAME_APPSETTING + " (" +
                    COLUMN_NAME_ID + " INTEGER PRIMARY KEY," +
                    COLUMN_NAME_SERVER + TEXT_TYPE + COMMA_SEP +
                    COLUMN_NAME_PNAME + TEXT_TYPE + COMMA_SEP +
                    COLUMN_NAME_PMAC + TEXT_TYPE +
            " )";

    private static final String SQL_DELETE_APPSETTING =
            "DROP TABLE IF EXISTS " + TABLE_NAME_APPSETTING;



    public AppSettingsDbHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL(SQL_CREATE_APPSETTING);
    }
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        // This database is only a cache for online data, so its upgrade policy is
        // to simply to discard the data and start over
        db.execSQL(SQL_DELETE_APPSETTING);
        // create new tables
        onCreate(db);
    }
    public void onDowngrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        onUpgrade(db, oldVersion, newVersion);
    }

    // Closing database
    public void closeDB() {
        SQLiteDatabase db = this.getReadableDatabase();
        if (db != null && db.isOpen())
            db.close();
    }


    //Creating a appSetting
    public long createAppSetting(AppSetting appSetting) {
        SQLiteDatabase db = this.getWritableDatabase();

        ContentValues values = new ContentValues();
        values.put(COLUMN_NAME_SERVER, appSetting.getServer());
        values.put(COLUMN_NAME_PNAME, appSetting.getPname());
        values.put(COLUMN_NAME_PMAC, appSetting.getPmac());

        // insert row
        long appSetting_id = db.insert(TABLE_NAME_APPSETTING, null, values);
        return appSetting_id;
    }

    //Get a single AppSetting
    public AppSetting getAppSetting(int id)
    {
        SQLiteDatabase db = this.getWritableDatabase();
        String selectQuery = "Select * from " + TABLE_NAME_APPSETTING + " where " + COLUMN_NAME_ID + "= " +id;
        Log.e(LOG, selectQuery);
        Cursor c = db.rawQuery(selectQuery, null);
        if(c!=null)
            c.moveToFirst();
        AppSetting appSetting =new AppSetting();
        appSetting.setId(c.getInt(c.getColumnIndex(COLUMN_NAME_ID)));
        appSetting.setPmac(c.getString(c.getColumnIndex(COLUMN_NAME_PMAC)));
        appSetting.setPname(c.getString(c.getColumnIndex(COLUMN_NAME_PNAME)));
        appSetting.setServer(c.getString(c.getColumnIndex(COLUMN_NAME_SERVER)));
        return appSetting;
    }

    //Fetch all Appsettings
    public List<AppSetting> getAllAppSettings()
    {
        List<AppSetting> appSettingList = new ArrayList<AppSetting>();
        SQLiteDatabase db = this.getWritableDatabase();
        String selectQuery = "Select * from "+TABLE_NAME_APPSETTING;
        Log.e(LOG, selectQuery);
        Cursor c = db.rawQuery(selectQuery, null);
        if(c != null && c.moveToFirst())
        {
            do{
                AppSetting appSetting =new AppSetting();
                appSetting.setId(c.getInt(c.getColumnIndex(COLUMN_NAME_ID)));
                appSetting.setPmac(c.getString(c.getColumnIndex(COLUMN_NAME_PMAC)));
                appSetting.setPname(c.getString(c.getColumnIndex(COLUMN_NAME_PNAME)));
                appSetting.setServer(c.getString(c.getColumnIndex(COLUMN_NAME_SERVER)));
                appSettingList.add(appSetting);
            }while (c.moveToNext());
        }
        return appSettingList;
    }

    //Update AppSetting
    public int updateAppSetting(AppSetting setting)
    {
        SQLiteDatabase db = this.getWritableDatabase();
        ContentValues values = new ContentValues();
        values.put(COLUMN_NAME_SERVER, setting.getServer());
        values.put(COLUMN_NAME_PNAME, setting.getPname());
        values.put(COLUMN_NAME_PMAC, setting.getPmac());

        return db.update(TABLE_NAME_APPSETTING, values, COLUMN_NAME_ID + " = ?", new String[] { String.valueOf(setting.getId()) });
    }

    //Deleting AppSetting
    public void deleteAppSetting(int setting_id)
    {
        SQLiteDatabase db=this.getWritableDatabase();
        db.delete(TABLE_NAME_APPSETTING,COLUMN_NAME_ID + " = ?", new String[] {String.valueOf(setting_id)});
    }

}
