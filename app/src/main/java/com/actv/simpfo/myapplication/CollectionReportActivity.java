package com.actv.simpfo.myapplication;

import android.app.Activity;
import android.app.DatePickerDialog;
import android.app.DialogFragment;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.AsyncTask;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.CheckBox;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.actv.simpfo.myapplication.Model.MobileCollectionResponseListModel;
import com.actv.simpfo.myapplication.Model.MobileCollectionResponseModel;

import java.util.ArrayList;
import java.util.Calendar;

public class CollectionReportActivity extends ActionBarActivity {

    private DatePicker datePicker;
    private Calendar calendar;
    private EditText fromDateView;
    private EditText toDateView;
    private EditText billNumFromEditText;
    private EditText billNumToEditText;
    private EditText collectionFilterEditText;
    private ListView resultListView;
    private int year, month, day;
    private CheckBox allCustomersCheckBox;
    private CollectionReportAdapter collectionReportAdapter;
    private ProgressDialog progressDialog;
    private GenericSeeker<MobileCollectionResponseListModel> mobileCollectionResponseSeeker = new CollectionReportSeeker();
    private Activity currentActivity;
    private ArrayList<MobileCollectionResponseListModel> mobileCollectionResponseArrayList = new ArrayList<MobileCollectionResponseListModel>();

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
        resultListView = (ListView) findViewById(R.id.resultListView);

        calendar = Calendar.getInstance();
        year = calendar.get(Calendar.YEAR);
        month = calendar.get(Calendar.MONTH);
        day = calendar.get(Calendar.DAY_OF_MONTH);
        showDate(fromDateView, year, month + 1, day);
        showDate(toDateView, year, month + 1, day);
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

    }

    public void searchOnBillNumButtonClick(View view)
    {

    }

    private void PerformSearch()
    {
        progressDialog = ProgressDialog.show(CollectionReportActivity.this,
                "Please wait...", "Retrieving data...", true, true);
    }

    private class PerformGetCustomersTask extends AsyncTask<String, Void,  ArrayList<MobileCollectionResponseListModel>> {

    }

    }

}
