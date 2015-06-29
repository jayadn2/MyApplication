package com.actv.simpfo.myapplication;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;
import android.widget.Toast;

import com.actv.simpfo.myapplication.Model.CustomerBalanceDetail;
import com.actv.simpfo.myapplication.Model.CustomerJson;

import java.util.ArrayList;

/**
 * Created by JaSh on 10/06/2015.
 */
public class CustomerListAdapter extends ArrayAdapter<CustomerJson> {

    private HttpRetriever httpRetriever = new HttpRetriever();
    private ArrayList<CustomerJson> customerDataItems;
    private Activity context;
    private CustomerBalanceDetail customerBalanceDetail;


    public CustomerListAdapter(Activity context, int textViewResourceId, ArrayList<CustomerJson> _customerDataItems) {
        super(context, textViewResourceId, _customerDataItems);
        this.context = context;
        this.customerDataItems = _customerDataItems;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        final ViewHolder mHolder;
        View view = convertView;
        CustomerJson customerJson = customerDataItems.get(position);
        if (view == null) {
            LayoutInflater vi = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            view = vi.inflate(R.layout.customer_data_row, null);
            mHolder = new ViewHolder();

            if (customerJson != null) {
                mHolder.nameTextView = (TextView) view.findViewById(R.id.name_text_view);
                mHolder.custIdTextView = (TextView) view.findViewById(R.id.cusid_text_view);
                view.setTag(mHolder);

            }
        }
        else {
            mHolder = (ViewHolder) view.getTag();

        }

        mHolder.nameTextView.setText(customerJson.getCustomerName());
        mHolder.custIdTextView.setText("Cust ID: " + customerJson.getID());

        return view;
    }


}

class ViewHolder {
    TextView nameTextView;
    TextView custIdTextView;
}
