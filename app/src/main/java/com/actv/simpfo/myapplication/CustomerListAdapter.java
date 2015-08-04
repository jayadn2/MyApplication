package com.actv.simpfo.myapplication;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.TextView;
import android.widget.Toast;

import com.actv.simpfo.myapplication.Model.CustomerBalanceDetail;
import com.actv.simpfo.myapplication.Model.CustomerJson;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by JaSh on 10/06/2015.
 */
public class CustomerListAdapter extends ArrayAdapter<CustomerJson>  implements Filterable {

    private HttpRetriever httpRetriever = new HttpRetriever();
    private ArrayList<CustomerJson> customerDataItems;
    private Activity context;
    private CustomerBalanceDetail customerBalanceDetail;
    //Two data sources, the original data and filtered data
    private ArrayList<CustomerJson> originalData;
    private ArrayList<CustomerJson> filteredData;


    public CustomerListAdapter(Activity context, int textViewResourceId, ArrayList<CustomerJson> _customerDataItems) {
        super(context, textViewResourceId, _customerDataItems);
        this.context = context;
        this.customerDataItems = _customerDataItems;
        //To start, set both data sources to the incoming data
        originalData = _customerDataItems;
        filteredData = _customerDataItems;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        final ViewHolder mHolder;
        View view = convertView;
        CustomerJson customerJson = filteredData.get(position);//customerDataItems.get(position);
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

    //For this helper method, return based on filteredData
    public int getCount()
    {
        return filteredData.size();
    }

    //This should return a data object, not an int
    public CustomerJson getItem(int position)
    {
        return filteredData.get(position);
    }

    public long getItemId(int position)
    {
        return position;
    }

    @Override
    public Filter getFilter() {
        return new Filter()
        {
            @Override
            protected FilterResults performFiltering(CharSequence charSequence)
            {
                FilterResults results = new FilterResults();

                //If there's nothing to filter on, return the original data for your list
                if(charSequence == null || charSequence.length() == 0)
                {
                    results.values = originalData;
                    results.count = originalData.size();
                }
                else
                {
                    ArrayList<CustomerJson> filterResultsData = new ArrayList<CustomerJson>();

                    for(CustomerJson data : originalData)
                    {
                        //In this loop, you'll filter through originalData and compare each item to charSequence.
                        //If you find a match, add it to your new ArrayList
                        //I'm not sure how you're going to do comparison, so you'll need to fill out this conditional
                        String custId = String.valueOf(data.getID());
                        if(data.getCustomerName().toLowerCase().contains(charSequence) || custId.toLowerCase().contains(charSequence))
                        {
                            filterResultsData.add(data);
                        }
                    }

                    results.values = filterResultsData;
                    results.count = filterResultsData.size();
                }

                return results;
            }

            @Override
            protected void publishResults(CharSequence charSequence, FilterResults filterResults)
            {
                filteredData = (ArrayList<CustomerJson>)filterResults.values;
                notifyDataSetChanged();
            }
        };
    }


}

class ViewHolder {
    TextView nameTextView;
    TextView custIdTextView;
}
