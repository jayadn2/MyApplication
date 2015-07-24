package com.actv.simpfo.myapplication;

import android.content.Intent;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.view.View.OnClickListener;

public class MainMenu extends ActionBarActivity {

    Button collectionReportButton = null;
    Button customerListButton = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_menu);
        FindAllViewsById();
        collectionReportButton.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent i = new Intent(getApplicationContext(),CollectionReportActivity.class);
                startActivity(i);
            }
        });

        customerListButton.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent i = new Intent(getApplicationContext(),CustomerListActivity.class);
                startActivity(i);
            }
        });
    }

    private void FindAllViewsById() {
        collectionReportButton = (Button) findViewById(R.id.collection_report);
        customerListButton = (Button)findViewById(R.id.customer_list);
    }

}
