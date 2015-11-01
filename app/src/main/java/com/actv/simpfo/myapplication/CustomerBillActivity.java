package com.actv.simpfo.myapplication;

import android.app.DatePickerDialog;
import android.app.DialogFragment;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.os.AsyncTask;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.actv.simpfo.myapplication.Model.CustomerBalanceDetail;
import com.actv.simpfo.myapplication.Model.CustomerJson;
import com.actv.simpfo.myapplication.CollectionEntry;
import com.actv.simpfo.myapplication.Model.MobileCollectionJson;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;


public class CustomerBillActivity extends ActionBarActivity {

    private String empId = "";
    private String token ="";
    private int custId;
    private GenericSeeker<CustomerBalanceDetail> customerBillSeeker = new CustomerBillSeeker();
    private ProgressDialog progressDialog;
    private TextView customerBillCustIdTextView;
    private TextView custNameTextView;
    private TextView custAddressTextView;
    private TextView lastPaymentTextView;
    private TextView lastPaymentDateTextView;
    private TextView totalBalanceTextView;
    private EditText paymentAmountEditTextView;
    private Button addButton;
    private Button printButton;
    private CustomerBalanceDetail customerBalanceDetail;
    private String enteredAmount;
    private GenericSeeker<MobileCollectionJson> collectionSeeker = new CollectionEntry();
    private MobileCollectionJson collectionEntry;
    private ImageView printerStatusImageView;
    private Button connectToPrinterButton;
    private EditText billDateEditText;
    private int year, month, day;
    private Calendar calendar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_customer_bill);
        FindAllViewsById();
        paymentAmountEditTextView.setEnabled(true);
        //Clear the previously set value.
        AppGlobals.SelectedCollectionEntry = null;
        AppGlobals.SelectedCustomerBalanceDetail = null;
        GetCustomerBalance();
        InputMethodManager inputMethodManager=(InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
        if (inputMethodManager != null){
            inputMethodManager.toggleSoftInput(InputMethodManager.SHOW_FORCED,0);
        }

        printButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ShowPrintDialog();
            }
        });
    }


    private void FindAllViewsById() {
        customerBillCustIdTextView = (TextView) findViewById(R.id.custNumber_text_view);
        custNameTextView = (TextView) findViewById(R.id.custName_text_view);
        custAddressTextView = (TextView) findViewById(R.id.custAddress_text_view);
        lastPaymentTextView = (TextView) findViewById(R.id.lastPayment_text_view);
        lastPaymentDateTextView = (TextView) findViewById(R.id.lastPaymentDate_text_view);
        totalBalanceTextView = (TextView) findViewById(R.id.totalBalance_text_view);
        paymentAmountEditTextView = (EditText) findViewById(R.id.paymentAmount_edit_text_view);
        addButton = (Button) findViewById(R.id.add_Button_view);
        printButton = (Button) findViewById(R.id.print_Button_view);
        printerStatusImageView = (ImageView) findViewById(R.id.printerStatusImageView);
        connectToPrinterButton = (Button) findViewById(R.id.connectToPrinterButton);

        billDateEditText=(EditText) findViewById(R.id.billDateEditText);
        calendar = Calendar.getInstance();
        year = calendar.get(Calendar.YEAR);
        month = calendar.get(Calendar.MONTH);
        day = calendar.get(Calendar.DAY_OF_MONTH);
        showDate(billDateEditText, year, month + 1, day);

        addButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                UpdateBalance();
            }
        });
        connectToPrinterButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ConnectToPrinter();
            }
        });
        UpdatePrintStatus();
    }

    private void showDate(EditText editText, int year, int month, int day) {
        editText.setText(DateHelper.ConvertToFormat(year, month, day));
    }

    public void setDate(View view) {
        DatePickerDialog datePickerDialog = new DatePickerDialog(this, dateListener, year, month, day);
        datePickerDialog.show();
    }

    private DatePickerDialog.OnDateSetListener dateListener = new DatePickerDialog.OnDateSetListener() {
        @Override
        public void onDateSet(DatePicker arg0, int arg1, int arg2, int arg3) {
            // TODO Auto-generated method stub
            // arg1 = year
            // arg2 = month
            // arg3 = day
            showDate(billDateEditText, arg1, arg2 + 1, arg3);
        }
    };

    private void ShowPrintDialog()
    {
        //Display the dialog here.
        DialogFragment newFragment = new CustomerBillPrintDialogFragment();
        newFragment.setCancelable(false);
        newFragment.show(getFragmentManager(), "CustomerBillPrintDialog");

    }

    private void UpdateBalance()
    {
        enteredAmount = paymentAmountEditTextView.getText().toString();
        if(enteredAmount==null || enteredAmount.length() == 0)
        {
            Toast.makeText(getBaseContext(), "Please enter valid amount.", Toast.LENGTH_LONG).show();
        }
        else {
            customerBalanceDetail.setEmpId(AppGlobals.EmpId);
            customerBalanceDetail.setCurrentPaymentDate(billDateEditText.getText().toString());
            progressDialog = ProgressDialog.show(CustomerBillActivity.this,
                    "Please wait...", "Updating entry for " + custNameTextView.getText().toString() + " ...", true, true);
            PerformPostCustomerBalanceTask task = new PerformPostCustomerBalanceTask();
            task.execute(String.valueOf(custId));
            progressDialog.setOnCancelListener(new CancelTaskOnCancelListener(task));
        }
    }

    private void GetCustomerBalance()
    {
        empId = AppGlobals.EmpId;
        token = AppGlobals.Token;
        custId = AppGlobals.SelectedCustomerId;
        progressDialog = ProgressDialog.show(CustomerBillActivity.this,
                "Please wait...", "Retrieving data for "+ custId +" ...", true, true);
        PerformGetCustomerBalanceTask task = new PerformGetCustomerBalanceTask();
        task.execute(String.valueOf(custId));
        progressDialog.setOnCancelListener(new CancelTaskOnCancelListener(task));
    }

    private void ConnectToPrinter()
    {
        PrintHelper.ConnectToPrinter();
        UpdatePrintStatus();
    }

    private void UpdatePrintStatus() {
        if (PrintHelper.IsConnected())
            printerStatusImageView.setImageResource(R.drawable.printer_connected);
        else
            printerStatusImageView.setImageResource(R.drawable.printer_disconnected);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_customer_bill, menu);
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

    private class PerformGetCustomerBalanceTask extends AsyncTask<String, Void, ArrayList<CustomerBalanceDetail>> {

        @Override
        protected  ArrayList<CustomerBalanceDetail> doInBackground(String... params) {
            customerBillSeeker.setToken(token);
            return customerBillSeeker.find(String.valueOf(custId));
        }

        @Override
        protected void onPostExecute(final ArrayList<CustomerBalanceDetail> result) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if (progressDialog!=null) {
                        progressDialog.dismiss();
                        progressDialog = null;
                    }
                    if (result != null && result.size() > 0) {
                        customerBalanceDetail = result.get(0);
                        if(customerBalanceDetail != null) {
                            AppGlobals.SelectedCustomerBalanceDetail = customerBalanceDetail;
                            customerBillCustIdTextView.setText(String.valueOf(customerBalanceDetail.getCustId()));
                            custNameTextView.setText(customerBalanceDetail.getCustName());
                            custAddressTextView.setText(customerBalanceDetail.getAdress());
                            lastPaymentTextView.setText(String.valueOf(customerBalanceDetail.getLastPaidAmt()));
                            lastPaymentDateTextView.setText(customerBalanceDetail.getLastPaidDate());
                            totalBalanceTextView.setText(String.valueOf(customerBalanceDetail.getTotalBalance()));
                            paymentAmountEditTextView.setText("");
                        }


                    }
                    else
                    {
                        Toast.makeText(getBaseContext(), "Error while loading customer balance.", Toast.LENGTH_LONG).show();
                    }
                }
            });
        }




    }

    private class PerformPostCustomerBalanceTask extends AsyncTask<String, Void, ArrayList<MobileCollectionJson>> {

        @Override
        protected  ArrayList<MobileCollectionJson> doInBackground(String... params) {
            if(customerBalanceDetail != null) {
                collectionSeeker.setToken(token);
                customerBalanceDetail.setCurrentPayment(enteredAmount);
            }
            return collectionSeeker.findPost(customerBalanceDetail);
        }

        @Override
        protected void onPostExecute(final ArrayList<MobileCollectionJson> result) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if (progressDialog != null) {
                        progressDialog.dismiss();
                        progressDialog = null;
                    }
                    if (result != null && result.size() > 0) {
                        collectionEntry = result.get(0);
                        if (collectionEntry != null) {
                            //Display the dialog box to print the receipt.
                            AppGlobals.SelectedCollectionEntry = collectionEntry;
                            ShowPrintDialog();
                            addButton.setEnabled(false);
                            //printButton.setEnabled(false);
                            printButton.setVisibility(View.VISIBLE);
                            paymentAmountEditTextView.setEnabled(false);
                            //finish();
                        }


                    } else {
                        Toast.makeText(getBaseContext(), "Error while loading customer balance.", Toast.LENGTH_LONG).show();
                    }
                }
            });
        }







    }
}
