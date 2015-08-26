package com.actv.simpfo.myapplication;

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.app.DialogFragment;
import android.app.ProgressDialog;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.AsyncTask;
import android.os.Handler;
import android.os.Message;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;
import android.content.DialogInterface.OnCancelListener;


import com.actv.simpfo.myapplication.Model.AppSetting;
import com.actv.simpfo.myapplication.Model.User;
import com.ngx.BluetoothPrinter;
import com.ngx.DebugLog;
import android.app.AlertDialog.Builder;

import java.net.InetAddress;
import java.util.List;

import Helper.MacHelper;


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
    private String mConnectedDeviceName = "";
    public static final String title_connecting = "connecting...";
    public static final String title_connected_to = "connected: ";
    public static final String title_not_connected = "not connected";
    public String bluetoothStatus = "";
    private AppSettingsDbHelper appSettingsDbHelper;


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
                if (userNameEditText.getText().length() == 0 || passwordEditText.getText().length() == 0) {
                    Toast.makeText(getBaseContext(), "Please enter correct username or password", Toast.LENGTH_LONG).show();
                    return;
                }

                String query = userNameEditText.getText() + "≡" + passwordEditText.getText();//searchEditText.getText().toString();
                performSearch(query);
            }
        });
        mBtp.setDebugService(true);
        try {
            mBtp.initService(this, mHandler);
        } catch (Exception e) {
            e.printStackTrace();
        }

        IntentFilter filter1 = new IntentFilter(BluetoothDevice.ACTION_ACL_CONNECTED);
        IntentFilter filter2 = new IntentFilter(BluetoothDevice.ACTION_ACL_DISCONNECT_REQUESTED);
        IntentFilter filter3 = new IntentFilter(BluetoothDevice.ACTION_ACL_DISCONNECTED);
        this.registerReceiver(mReceiver, filter1);
        this.registerReceiver(mReceiver, filter2);
        this.registerReceiver(mReceiver, filter3);
        AppGlobals.MacId = MacHelper.GetMacId();
    }

    //The BroadcastReceiver that listens for bluetooth broadcasts
    private final BroadcastReceiver mReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);

            if (BluetoothDevice.ACTION_FOUND.equals(action)) {
                //... //Device found
            }
            else if (BluetoothDevice.ACTION_ACL_CONNECTED.equals(action)) {
                //Device is now connected
                PrintHelper.SetIsConnected(true);
                AppGlobals.printerTestDialogFragment.SetPrinterStatus();
            }
            else if (BluetoothAdapter.ACTION_DISCOVERY_FINISHED.equals(action)) {
                //Done searching
            }
            else if (BluetoothDevice.ACTION_ACL_DISCONNECT_REQUESTED.equals(action)) {
                //Device is about to disconnect
            }
            else if (BluetoothDevice.ACTION_ACL_DISCONNECTED.equals(action)) {
                //Device has disconnected
                PrintHelper.SetIsConnected(false);
                AppGlobals.printerTestDialogFragment.SetPrinterStatus();
            }
        }
    };

    public boolean isInternetAvailable() {
        try {
            InetAddress ipAddr = InetAddress.getByName("google.com"); //You can replace it with your name

            if (ipAddr.equals("")) {
                return false;
            } else {
                return true;
            }

        } catch (Exception e) {
            return false;
        }

    }

    @SuppressLint("HandlerLeak")
    private final Handler mHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case BluetoothPrinter.MESSAGE_STATE_CHANGE:
                    switch (msg.arg1) {
                        case BluetoothPrinter.STATE_CONNECTED:
                            bluetoothStatus = title_connected_to + " : "+ mConnectedDeviceName;
                            break;
                        case BluetoothPrinter.STATE_CONNECTING:
                            bluetoothStatus = title_connecting;
                            break;
                        case BluetoothPrinter.STATE_LISTEN:
                        case BluetoothPrinter.STATE_NONE:
                            bluetoothStatus = title_not_connected;
                            break;
                    }
                    break;
                case BluetoothPrinter.MESSAGE_DEVICE_NAME:
                    // save the connected device's name
                    mConnectedDeviceName = msg.getData().getString(
                            BluetoothPrinter.DEVICE_NAME);
                    break;
                case BluetoothPrinter.MESSAGE_STATUS:
                    bluetoothStatus = msg.getData().getString(BluetoothPrinter.STATUS_TEXT);
                    break;
                default:
                    break;
            }
        }
    };


    private AppSetting GettAppSetting()
    {
        AppSetting setting = null;
        appSettingsDbHelper = new AppSettingsDbHelper(getApplicationContext());
        // Getting all Todos
        Log.d("Get AppSetting", "Getting All AppSettings");

        List<AppSetting> allToDos = appSettingsDbHelper.getAllAppSettings();
        //There should be only one setting for the application at any time.
        if(allToDos.size() > 0)
        {
           setting = allToDos.get(0);
        }
        return setting;
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

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();
        switch (id) {
            case R.id.print_test:
                //mBtp.printLogo();
                //PrintHelper.TestPrint("Siti");
                //PrintHelper.TestPrint("Name", "Jayachandra");
                //Display the dialog here.
                AppGlobals.printerTestDialogFragment.show(getFragmentManager(), "PrintTestDialog");
                return true;
            case R.id.app_setting:
                AppSetting setting = GettAppSetting();
                AppSettingsActivity appSettingsActivity = new AppSettingsActivity(setting);
                appSettingsActivity.showDialog();
                return true;
            case R.id.action_connect_device:
                // show a dialog to select from the list of available printers
                //mBtp.showDeviceList(this);
                //mBtp.connectToPrinterUsingMacAddress("98:D3:31:70:3B:9C");
                //mBtp.showDeviceList(this);
                PrintHelper.ConnectToPrinter();
                return true;
            case R.id.action_unpair_device:
                Builder u = new AlertDialog.Builder(this);
                u.setTitle("Bluetooth Printer unpair");
                // d.setIcon(R.drawable.ic_launcher);
                u.setMessage("Are you sure you want to unpair all Bluetooth printers ?");
                u.setPositiveButton(android.R.string.yes,
                        new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int which) {
                                if (mBtp.unPairBluetoothPrinters()) {
                                    Toast.makeText(
                                            getApplicationContext(),
                                            "All NGX Bluetooth printer(s) unpaired",
                                            Toast.LENGTH_SHORT).show();
                                }
                            }
                        });
                u.setNegativeButton(android.R.string.no,
                        new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int which) {
                                // do nothing
                            }
                        });
                u.show();
                return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onPause() {
        mBtp.onActivityPause();
        super.onPause();
    }

    @Override
    public void onResume() {
        mBtp.onActivityResume();
        DebugLog.logTrace("onResume");
        super.onResume();
    }

    @Override
    public void onDestroy() {
        mBtp.onActivityDestroy();
        super.onDestroy();
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        mBtp.onActivityResult(requestCode, resultCode, data, this);
    }


    private class PerformLoginTask extends AsyncTask<String, Void, String> {

        @Override
        protected String doInBackground(String... params) {
            if(isInternetAvailable()) {
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
            else
            {
                return "NoInternet";
            }

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
                    if(result == "NoInternet")
                    {
                        Toast.makeText(getBaseContext(), "No Internet connection. Connect to Internet and try again.", Toast.LENGTH_LONG).show();
                    }
                    else if (result != "") {
                        //Store the returned empid for future use.
                        //setEmpId(result);
                        String empId = result;
                        setEmpId(empId);
                        AppGlobals.EmpId = empId;
                        Intent i = new Intent(getApplicationContext(),MainMenu.class);
                        startActivity(i);

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
