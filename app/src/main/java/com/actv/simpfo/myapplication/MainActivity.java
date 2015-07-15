package com.actv.simpfo.myapplication;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.AsyncTask;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;
import android.content.DialogInterface.OnCancelListener;


import com.actv.simpfo.myapplication.Model.User;
import com.ngx.BluetoothPrinter;


public class MainActivity extends ActionBarActivity {

    private static final String Empty_String = "";
    private EditText userNameEditText;
    private EditText passwordEditText;
    private Button loginButton;
    private GenericSeeker<User> userSeeker = new UserSeeker();
    private ProgressDialog progressDialog;
    private String empId = "";
    private String token ="";
    public static BluetoothPrinter mBtp = BluetoothPrinter.INSTANCE;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        this.FindAllViewsById();
        AppGlobals.setContext(getBaseContext());
        AppGlobals.MainActivity = this;
        loginButton.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                //Alt+240 : ≡
                if(userNameEditText.getText().length() == 0 || passwordEditText.getText().length() == 0)
                {
                    Toast.makeText(getBaseContext(), "Please enter correct username or password", Toast.LENGTH_SHORT).show();
                    return;
                }
                String query = userNameEditText.getText() + "≡" + passwordEditText.getText();//searchEditText.getText().toString();
                performSearch(query);
            }
        });
    }


    private void performSearch(String query) {
        progressDialog = ProgressDialog.show(MainActivity.this,
                "Please wait...", "Retrieving data...", true, true);
        PerformLoginTask task = new PerformLoginTask();
        task.execute(query);
        progressDialog.setOnCancelListener(new CancelTaskOnCancelListener(task));
    }

    public String getEmpId() {
        return empId;
    }

    public void setEmpId(String empId) {
        this.empId = empId;
    }

    public String getToken() {
        return token;
    }

    private class CancelTaskOnCancelListener implements OnCancelListener {
        private AsyncTask<?, ?, ?> task;
        public CancelTaskOnCancelListener(AsyncTask<?, ?, ?> task) {
            this.task = task;
        }
        @Override
        public void onCancel(DialogInterface dialog) {
            if (task!=null) {
                task.cancel(true);
            }
        }
    }

    private void FindAllViewsById() {
        userNameEditText = (EditText) findViewById(R.id.username_edit_text);
        passwordEditText = (EditText)findViewById(R.id.password_edit_text);
        loginButton = (Button) findViewById(R.id.login_button);
    }

    public void longToast(CharSequence message) {
        Toast.makeText(this, message, Toast.LENGTH_LONG).show();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }



    private class PerformLoginTask extends AsyncTask<String, Void, String> {

        @Override
        protected String doInBackground(String... params) {
            String query = params[0];
            String[] arr = query.split("≡");
            if(arr.length == 2) {
                String userName = arr[0];
                String password = arr[1];
                String empId = userSeeker.ValidateUser(userName, password);
                setEmpId(empId);
                AppGlobals.EmpId = empId;
                return getEmpId();
            }
            else
                return "";
        }

        @Override
        protected void onPostExecute(final String result) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if (progressDialog!=null) {
                        progressDialog.dismiss();
                        progressDialog = null;
                    }
                    if (result != "") {
                        //Store the returned empid for future use.
                        //setEmpId(result);
                        String empId = result;
                        setEmpId(empId);
                        AppGlobals.EmpId = empId;
                        Intent i = new Intent(getApplicationContext(),CustomerListActivity.class);
                        startActivity(i);
                        boolean connected = PrintHelper.ConnectToPrinter();
                        if(connected)
                            Toast.makeText(getBaseContext(), "Connected to Printer", Toast.LENGTH_LONG).show();
                        else
                            Toast.makeText(getBaseContext(), "Error connecting to Printer", Toast.LENGTH_LONG).show();
                    }
                    else
                    {
                        Toast.makeText(getBaseContext(), "Wrong username or password", Toast.LENGTH_LONG).show();
                    }
                }
            });
        }




    }
}
