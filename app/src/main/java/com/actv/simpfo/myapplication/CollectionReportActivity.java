package com.actv.simpfo.myapplication;

import android.app.Activity;
import android.app.DatePickerDialog;
import android.app.DialogFragment;
import android.app.ListActivity;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.AsyncTask;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.CheckBox;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.actv.simpfo.myapplication.Model.MobileCollectionRequestModel;
import com.actv.simpfo.myapplication.Model.MobileCollectionResponseListModel;
import com.actv.simpfo.myapplication.Model.MobileCollectionResponseModel;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

public class CollectionReportActivity extends ListActivity {

    private DatePicker datePicker;
    private Calendar calendar;
    private EditText fromDateView;
    private EditText toDateView;
    private EditText billNumFromEditText;
    private EditText billNumToEditText;
    private EditText collectionFilterEditText;
    private EditText numOfBillsEditText;
    private EditText amountCollectedEditText;
    private TextView searchResultBasedOnTextView;
    private int year, month, day;
    private CheckBox allCustomersCheckBox;
    private CollectionReportAdapter collectionReportAdapter;
    private ProgressDialog progressDialog;
    private GenericSeeker<MobileCollectionResponseListModel> mobileCollectionResponseSeeker = new CollectionReportSeeker();
    private Activity currentActivity;
    private ArrayList<MobileCollectionResponseListModel> mobileCollectionResponseArrayList = new ArrayList<MobileCollectionResponseListModel>();
    private MobileCollectionRequestModel collectionRequest;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_collection_report);
        currentActivity = this;

        GetViewControls();

    }

    private void GetViewControls()
    {
        fromDateView = (EditText) findViewById(R.id.fromDate);
        toDateView = (EditText) findViewById(R.id.toDate);
        billNumFromEditText = (EditText) findViewById(R.id.billNumFromEditText);
        billNumToEditText = (EditText) findViewById(R.id.billNumToEditText);
        collectionFilterEditText = (EditText) findViewById(R.id.collectionFilterEditText);
        numOfBillsEditText = (EditText) findViewById(R.id.numOfBillsEditText);
        amountCollectedEditText = (EditText) findViewById(R.id.amountCollectedEditText);
        searchResultBasedOnTextView = (TextView) findViewById(R.id.searchResultBasedOnTextView);
        collectionRequest = new MobileCollectionRequestModel();

        calendar = Calendar.getInstance();
        year = calendar.get(Calendar.YEAR);
        month = calendar.get(Calendar.MONTH);
        day = calendar.get(Calendar.DAY_OF_MONTH);
        showDate(fromDateView, year, month + 1, day);
        showDate(toDateView, year, month + 1, day);
        //Enabling Search Filter
        collectionFilterEditText.addTextChangedListener(new TextWatcher() {

            @Override
            public void onTextChanged(CharSequence cs, int arg1, int arg2, int arg3) {
                // When user changed the Text
                collectionReportAdapter.getFilter().filter(cs);
            }

            @Override
            public void beforeTextChanged(CharSequence arg0, int arg1, int arg2,
                                          int arg3) {
                // TODO Auto-generated method stub

            }

            @Override
            public void afterTextChanged(Editable arg0) {
                // TODO Auto-generated method stub
            }
        });
    }

    //@SuppressWarnings("deprecation")
    public void setFromDate(View view) {
        DatePickerDialog datePickerDialog = new DatePickerDialog(this, fromDateListener, year, month, day);
        datePickerDialog.show();
        Toast.makeText(getApplicationContext(), "ca", Toast.LENGTH_SHORT)
                .show();
    }

    public void setToDate(View view) {
        DatePickerDialog datePickerDialog = new DatePickerDialog(this, toDateListener, year, month, day);
        datePickerDialog.show();
        Toast.makeText(getApplicationContext(), "ca", Toast.LENGTH_SHORT)
                .show();
    }

    private DatePickerDialog.OnDateSetListener fromDateListener = new DatePickerDialog.OnDateSetListener() {
        @Override
        public void onDateSet(DatePicker arg0, int arg1, int arg2, int arg3) {
            // TODO Auto-generated method stub
            // arg1 = year
            // arg2 = month
            // arg3 = day
            showDate(fromDateView, arg1, arg2 + 1, arg3);
        }
    };

    private DatePickerDialog.OnDateSetListener toDateListener = new DatePickerDialog.OnDateSetListener() {
        @Override
        public void onDateSet(DatePicker arg0, int arg1, int arg2, int arg3) {
            // TODO Auto-generated method stub
            // arg1 = year
            // arg2 = month
            // arg3 = day
            showDate(toDateView, arg1, arg2 + 1, arg3);
        }
    };

    private void showDate(EditText editText, int year, int month, int day) {
        editText.setText(new StringBuilder().append(day).append("/")
                .append(month).append("/").append(year));
    }

    public void searchOnDateButtonClick(View view) {
        if(fromDateView.getText().toString() == null || fromDateView.getText().toString().length() ==0)
        {
            Toast.makeText(getBaseContext(), "Please enter correct from date. ", Toast.LENGTH_LONG).show();
        }
        else {
            collectionRequest.EmpId = AppGlobals.EmpId;
            collectionRequest.SearchOnBillNumber = false;
            collectionRequest.FromDate = fromDateView.getText().toString();
            if (toDateView.getText().toString() == "")
                toDateView.setText(fromDateView.getText());
            collectionRequest.ToDate = toDateView.getText().toString();
            PerformSearch();
            SetSearchReslutBasedOnText("date");
        }
    }

    public void searchOnBillNumButtonClick(View view)
    {
        if(billNumFromEditText.getText().toString() == null || billNumFromEditText.getText().toString().length() ==0)
        {
            Toast.makeText(getBaseContext(), "Please enter correct start bill number. ", Toast.LENGTH_LONG).show();
        }
        else {
            collectionRequest.EmpId = AppGlobals.EmpId;
            collectionRequest.SearchOnBillNumber = true;
            collectionRequest.StartBillNumber = billNumFromEditText.getText().toString();

            if (billNumToEditText.getText().toString() == "")
                billNumToEditText.setText(billNumFromEditText.getText());
            collectionRequest.EndBillNumber = billNumToEditText.getText().toString();
            PerformSearch();
            SetSearchReslutBasedOnText("bill");
        }
    }

    private void PerformSearch()
    {
        progressDialog = ProgressDialog.show(CollectionReportActivity.this,
                "Please wait...", "Retrieving data...", true, true);
        PerformGetCollectionReportTask task = new PerformGetCollectionReportTask();
        task.execute("");
        progressDialog.setOnCancelListener(new CancelTaskOnCancelListener(task));
    }

    private void SetSearchReslutBasedOnText(String basedOn)
    {
        switch (basedOn)
        {
            case "date":
                searchResultBasedOnTextView.setText("Search Result Based On Date");
                break;
            case "bill":
                searchResultBasedOnTextView.setText("Search Result Based Bill Numbers");
                break;
        }
    }

    private class PerformGetCollectionReportTask extends AsyncTask<String, Void,  ArrayList<MobileCollectionResponseListModel>> {
        @Override
        protected  ArrayList<MobileCollectionResponseListModel> doInBackground(String... params) {
            mobileCollectionResponseSeeker.setToken(AppGlobals.Token);
            return mobileCollectionResponseSeeker.findPost(collectionRequest);
        }

        @Override
        protected void onPostExecute(final ArrayList<MobileCollectionResponseListModel> result) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if (progressDialog != null) {
                        progressDialog.dismiss();
                        progressDialog = null;
                    }
                    if (result != null) {


                        //customerListAdapter.clear();
                        //for (int i = 0; i < result.size(); i++) {
                        //customerListAdapter.add(result.get(i));
                        //}
                        //customerListAdapter.notifyDataSetChanged();
                        setListAdapter(null);
                        numOfBillsEditText.setText("");
                        amountCollectedEditText.setText("");
                        if (result != null && result.size() > 0 ) {
                            MobileCollectionResponseListModel responseListModel = result.get(0);
                            ArrayList<MobileCollectionResponseModel> collectionResponseModel = responseListModel.ReslutCollection;

                            if(collectionResponseModel == null) {
                                Toast.makeText(getBaseContext(), "No results to display.", Toast.LENGTH_LONG).show();
                            }
                            else {
                                collectionReportAdapter = new CollectionReportAdapter(currentActivity, R.layout.collection_report_row, collectionResponseModel);
                                setListAdapter(collectionReportAdapter);
                                collectionReportAdapter.notifyDataSetChanged();
                                numOfBillsEditText.setText(String.valueOf(responseListModel.NoOfBills));
                                amountCollectedEditText.setText(String.valueOf(responseListModel.TotalAmountCollection));
                            }

                        }
                        else if(result.size() <= 0)
                        {
                            Toast.makeText(getBaseContext(), "No results to display.", Toast.LENGTH_LONG).show();
                        }
                        else {
                            Toast.makeText(getBaseContext(), "Error while loading bills.", Toast.LENGTH_LONG).show();
                        }

                    }
                }
            });
        }
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

}
