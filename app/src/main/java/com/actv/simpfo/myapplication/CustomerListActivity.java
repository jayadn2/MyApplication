package com.actv.simpfo.myapplication;

import android.app.Activity;
import android.app.ListActivity;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.Toast;

import com.actv.simpfo.myapplication.Model.Customer;
import com.actv.simpfo.myapplication.Model.CustomerJson;
import com.actv.simpfo.myapplication.Model.User;

import java.util.ArrayList;

public class CustomerListActivity extends ListActivity {

    private ProgressDialog progressDialog;
    private String empId = "";
    private String token ="";
    private GenericSeeker<CustomerJson> customerSeeker = new CustomerSeeker();
    private CustomerListAdapter customerListAdapter;
    private Activity currentActivity;
    private ArrayList<CustomerJson> customerJsonArrayList = new ArrayList<CustomerJson>();
    Intent customerBillIntent;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        customerBillIntent = new Intent(getApplicationContext(),CustomerBillActivity.class);
        currentActivity = this;
        setContentView(R.layout.activity_customer_list);
        //customerListAdapter = new CustomerListAdapter(currentActivity, R.layout.customer_data_row, customerJsonArrayList);
        //setListAdapter(customerListAdapter);
        //customerListAdapter.notifyDataSetChanged();
        GetCustomers();

    }

    private void GetCustomers() {
        empId = AppGlobals.EmpId;
        token = AppGlobals.Token;
        progressDialog = ProgressDialog.show(CustomerListActivity.this,
                "Please wait...", "Retrieving data for "+ empId +" ...", true, true);
        PerformGetCustomersTask task = new PerformGetCustomersTask();
        task.execute("");
        progressDialog.setOnCancelListener(new CancelTaskOnCancelListener(task));
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_customer_list, menu);
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

    public String getEmpId() {
        return empId;
    }

    public void setEmpId(String empId) {
        this.empId = empId;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    private class CancelTaskOnCancelListener implements DialogInterface.OnCancelListener {
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

    @Override
    protected void onListItemClick(ListView l, View v, int position, long id) {

        super.onListItemClick(l, v, position, id);
        CustomerJson customerJson = customerListAdapter.getItem(position);

        String customerName = customerJson.getCustomerName();
        if (customerName==null || customerName.length()==0) {
            longToast(getString(R.string.no_customer_found));
            return;
        }

        AppGlobals.SelectedCustomerId = customerJson.getID();
        startActivity(customerBillIntent);
        //longToast(customerName);

    }

    public void longToast(CharSequence message) {
        Toast.makeText(this, message, Toast.LENGTH_LONG).show();
    }


    private class PerformGetCustomersTask extends AsyncTask<String, Void,  ArrayList<CustomerJson>> {

        @Override
        protected  ArrayList<CustomerJson> doInBackground(String... params) {
            customerSeeker.setToken(token);
            return customerSeeker.find(empId);
        }

        @Override
        protected void onPostExecute(final ArrayList<CustomerJson> result) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if (progressDialog!=null) {
                        progressDialog.dismiss();
                        progressDialog = null;
                    }
                    if (result != null) {


                        //customerListAdapter.clear();
                        //for (int i = 0; i < result.size(); i++) {
                            //customerListAdapter.add(result.get(i));
                        //}
                        //customerListAdapter.notifyDataSetChanged();

                        customerListAdapter = new CustomerListAdapter(currentActivity, R.layout.customer_data_row, result);
                        setListAdapter(customerListAdapter);
                        customerListAdapter.notifyDataSetChanged();
                    }
                    else
                    {
                        Toast.makeText(getBaseContext(), "Error while loading customers.", Toast.LENGTH_LONG).show();
                    }
                }
            });
        }




    }
}
