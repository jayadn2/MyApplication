package com.actv.simpfo.myapplication;

import android.app.AlertDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.content.DialogInterface;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.actv.simpfo.myapplication.Model.AppSetting;

import java.util.List;

public class AppSettingsActivity extends DialogFragment {

    private AppSettingsDbHelper appSettingsDbHelper;
    private EditText keyEditText;
    private EditText machineInfoEditText;
    private AppSetting appSetting;
    private View view;
    private Button connectButton;


    public void setAppSetting(AppSetting _appSetting)
    {
        appSetting = _appSetting;
    }

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        // Get the layout inflater
        LayoutInflater inflater = getActivity().getLayoutInflater();
        view = inflater.inflate(R.layout.activity_app_settings, null);

        // Inflate and set the layout for the dialog
        // Pass null as the parent view because its going in the dialog layout
        builder.setView(view)
                // Add action buttons
                .setPositiveButton(R.string.ok, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int id) {
                        String settingTextValue = keyEditText.getText().toString();
                        //Parse the key text from the text box. If the key text is in correct format, then you proceed.
                        //Encrypted string ex = QlRQLUIwMDk1NSIiaHR0cDovL3d3dy5zaW1wZm8uaW4vc2l0aS8=
                        settingTextValue = EncryptionHelper.DecryptFromBase64(settingTextValue).trim();
                        String[] paramsArray = settingTextValue.split("\"");
                        if(paramsArray.length == 3) //ex = BTP-B00955""http://www.simpfo.in/siti/
                        {
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

                            AppSetting setting = new AppSetting(paramsArray[2], paramsArray[0], paramsArray[1]);
                            appSettingsDbHelper.createAppSetting(setting);
                        }
                    }
                });
        FindAllViewsById();
        appSettingsDbHelper = new AppSettingsDbHelper(getActivity());//getApplicationContext());
        return builder.create();
    }

    private void FindAllViewsById() {
        keyEditText = (EditText) view.findViewById(R.id.keyEditText);
        machineInfoEditText = (EditText)view.findViewById(R.id.machineInfoEditText);
        machineInfoEditText.setText(AppGlobals.MacId);

        if(appSetting != null)
        {
            String encryptedKey = EncryptionHelper.EncryptToBase64(appSetting.getPname() +":"+appSetting.getPmac() +":"+ appSetting.getServer()); //ex = BTP-B00955::http://www.simpfo.in/siti/
            keyEditText.setText(encryptedKey);
        }
    }

}
