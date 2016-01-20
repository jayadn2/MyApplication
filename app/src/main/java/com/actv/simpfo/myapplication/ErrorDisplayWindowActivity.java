package com.actv.simpfo.myapplication;

import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.widget.TextView;

import Helper.GmailSender;

public class ErrorDisplayWindowActivity extends ActionBarActivity {

    TextView error;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Thread.setDefaultUncaughtExceptionHandler(new ExceptionHandler(this));
        setContentView(R.layout.activity_error_display_window);

        error = (TextView) findViewById(R.id.error);

        error.setText(getIntent().getStringExtra("error"));
        //GmailSender.sendGmail(getParent(),"Crash on Siti app",error.getText().toString());
    }

}
