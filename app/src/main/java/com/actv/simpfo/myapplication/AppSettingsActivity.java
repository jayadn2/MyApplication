package com.actv.simpfo.myapplication;

import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import com.actv.simpfo.myapplication.Model.AppSetting;

import java.util.List;

public class AppSettingsActivity extends ActionBarActivity {

    AppSettingsDbHelper appSettingsDbHelper;
    EditText keyEditText;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_app_settings);
        FindAllViewsById();
        appSettingsDbHelper = new AppSettingsDbHelper(getApplicationContext());
    }

    private void FindAllViewsById() {
        keyEditText = (EditText) findViewById(R.id.keyEditText);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_app_settings, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    public void okButtonClick(View view)
    {
        String settingTextValue = keyEditText.getText().toString();
        //Parse the key text from the text box. If the key text is in correct format, then you proceed.
        settingTextValue = EncryptionHelper.DecryptFromBase64(settingTextValue).trim();

        // Getting all Todos
        Log.d("Get AppSetting", "Getting All AppSettings");

        List<AppSetting> allToDos = appSettingsDbHelper.getAllAppSettings();
        //There should be only one setting for the application at any time.
        if(allToDos.size() > 0)
        {
            //Delete all the existing entries before inserting new one.
            for(int i = 0 ;i <allToDos.size();i++) {
                AppSetting setting = allToDos.get(i);
                if (setting != null)
                    appSettingsDbHelper.deleteAppSetting(setting.getId());
            }
        }
    }
}
